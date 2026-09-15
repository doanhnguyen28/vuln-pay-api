provider "aws" {
  region = "ap-southeast-1"
}

# ❌ S3 bucket public (REL-006 / SEC-7)
resource "aws_s3_bucket" "payments_data" {
  bucket = "vuln-pay-payments-data-lab"
}

resource "aws_s3_bucket_public_access_block" "payments_data" {
  bucket                  = aws_s3_bucket.payments_data.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ❌ Security group mở toàn bộ Internet vào SSH (REL-006 / SEC-7)
resource "aws_security_group" "app" {
  name = "vuln-pay-app-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ❌ RDS không mã hóa, không backup (REL-006)
resource "aws_db_instance" "payments" {
  identifier          = "vuln-pay-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "admin"
  password            = "Password123!"   # ❌ secret trong IaC (SEC-6)
  storage_encrypted   = false
  publicly_accessible = true
  skip_final_snapshot = true
}
