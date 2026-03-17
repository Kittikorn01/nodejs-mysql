provider "aws" {
  region = var.aws_region
}

# สร้าง Security Group เปิดพอร์ต 22, 80, 3000, 3306
resource "aws_security_group" "app_sg" {
  name_prefix = "app_sg"
  description = "Security Group for App and DB"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# สร้าง Database (RDS) MySQL
resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = "root"
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  skip_final_snapshot    = true
}

locals {
  db_host = aws_db_instance.mysql_db.address
}

# สร้าง EC2 Instance และรัน Script ติดตั้งแอปพลิเคชัน
resource "aws_instance" "nodejs_server" {
  ami                    = "ami-0e5b9e1afa5e50e27"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    export DEBIAN_FRONTEND=noninteractive
    
    sudo -E apt-get update -y
    sudo -E apt-get install -y curl mysql-client git
    
    sudo curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash
    sudo -E apt-get install -y nodejs
    
    cd /home/ubuntu
    # Clone โค้ดโปรเจกต์จากบัญชีของคุณ
    git clone https://github.com/Kittikorn01/nodejs-mysql.git
    cd nodejs-mysql
    
    # สร้างไฟล์ .env สำหรับรันแอปพลิเคชัน
    echo "DB_HOST=${local.db_host}" > .env
    echo "DB_USER=${aws_db_instance.mysql_db.username}" >> .env
    echo "DB_PASS=${var.db_password}" >> .env
    echo "DB_NAME=${var.db_name}" >> .env
    echo "TABLE_NAME=${var.table_name}" >> .env
    echo "PORT=3000" >> .env
    
    source .env; set +a
    
    # รอจนกว่า Database จะพร้อมใช้งาน
    until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "status" &> /dev/null; do
      sleep 5
    done
    
    # นำเข้าโครงสร้างฐานข้อมูล
    if [ -f db_commands.txt ]; then
      grep -vE "CREATE DATABASE|USE" db_commands.txt > init_schema.sql
      mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" < init_schema.sql
    fi
    
    npm install
    nohup npm run dev > app.log 2>&1 &
  EOF

  user_data_replace_on_change = true
}