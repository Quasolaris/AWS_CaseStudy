resource "aws_db_instance" "limesurvey_db" {

  allocated_storage = 20
  identifier = "rds-limesurvey"
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.t3.micro"
  name = "limesurvey"
  username = "limesurvey"
  password = "limesurvey$123"
  publicly_accessible    = true
  skip_final_snapshot    = true


  tags = {
    Name = "limesurvey-db"
    Modul = "pcls"
  }
}

//https://linuxhint.com/create-aws-rds-db-instance-using-terraform/
