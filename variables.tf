variable "aws_region" {
  description = "Region ของ AWS ที่ต้องการสร้าง Resource"
  type        = string
  default     = "ap-southeast-7"
}

variable "key_name" {
  description = "ชื่อของ Key Pair ใน AWS ที่ใช้สำหรับ SSH เข้าเครื่อง EC2"
  type        = string
  default     = "my-terraform-key"
}

variable "instance_type" {
  description = "ขนาดของ EC2 Instance"
  type        = string
  default     = "t3.micro"
}

variable "db_password" {
  description = "รหัสผ่านสำหรับ MySQL Database"
  type        = string
  default     = "my5ecre7pa55w0rd"
  sensitive   = true 
}

variable "db_name" {
  description = "ชื่อ Schema ของฐานข้อมูล"
  type        = string
  default     = "tf_demo"
}

variable "table_name" {
  description = "ชื่อของตารางในฐานข้อมูล"
  type        = string
  default     = "users"
}