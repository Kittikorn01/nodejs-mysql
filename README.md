# NodeJs app with MySQL Database

A simple nodejs app connected with mySQL database.

## Getting Started

1. Clone the repo
```bash
git clone https://github.com/verma-kunal/nodejs-mysql.git
cd nodejs-mysql
```
2. Create a `.env` file in root directory and add the environment variables:
```bash
DB_HOST="localhost"
DB_USER="root" # default mysql user
DB_PASS=""
DB_NAME=""
TABLE_NAME=""
PORT=3000
```
> Make sure to create the database and the corresponding table in your mySQL database.
3. Initialize and start the development server:
```bash
npm install
npm run dev
```
![running app](https://github.com/user-attachments/assets/d882c2ec-2539-49eb-990a-3b0669af26b6)

---------------------------------------------------------------------------------------------------
# Infrastructure Provisioning for Node.js MySQL App

## Prerequisites (สิ่งที่ต้องเตรียมก่อน)
1. ติดตั้ง Terraform CLI และ AWS CLI
2. รัน `aws configure` เพื่อเข้าสู่ระบบด้วย AWS Account ของผู้ตรวจ
3. ไปที่ AWS Console (Region ap-southeast-7) เข้าไปที่ EC2 > Key Pairs แล้วสร้าง Key Pair ชื่อ `my-terraform-key` (.pem)

## How to Deploy (วิธีการรัน)
1. เปิด Terminal ในโฟลเดอร์นี้
2. รันคำสั่ง `terraform init` เพื่อเตรียม Environment
3. รันคำสั่ง `terraform apply` 
4. พิมพ์ `yes` เพื่อยืนยันการสร้าง Infrastructure
5. รอประมาณ 3-5 นาที เมื่อเสร็จสิ้นระบบจะแสดง `app_public_url` ออกมาทางหน้าจอ 
6. นำ URL นั้นไปเปิดใน Web Browser เพื่อใช้งานแอปพลิเคชัน

## Configuration Modifications (การปรับแก้ค่า)
หากต้องการเปลี่ยนรหัสผ่าน Database หรือ Region สามารถเข้าไปแก้ไข Default value ได้ที่ไฟล์ `variables.tf`

## Clean Up (การลบทรัพยากรเพื่อป้องกันค่าใช้จ่าย)
เมื่อทำการทดสอบระบบเสร็จสิ้นแล้ว สามารถลบทรัพยากรทั้งหมดที่สร้างขึ้นบน AWS ได้ทันทีเพื่อป้องกันค่าใช้จ่ายย้อนหลัง โดยทำตามขั้นตอนนี้:
1. เปิด Terminal ในโฟลเดอร์เดิม
2. รันคำสั่ง `terraform destroy`
3. พิมพ์ `yes` เพื่อยืนยันการทำลายทรัพยากรทั้งหมดที่ Terraform สร้างขึ้น
