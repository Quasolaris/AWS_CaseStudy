resource "aws_db_instance" "movierental_db" {

  allocated_storage = 20
  identifier = "rds-movierental"
  storage_type = "gp2"
  engine = "mysql"
  instance_class = "db.t3.micro"
  name = "eaf"
  username = "root"
  password = "movieRental$123"
  publicly_accessible    = true
  skip_final_snapshot    = true


  tags = {
    Name = "movierental-db"
    Modul = "pcls"
  }
}

//https://linuxhint.com/create-aws-rds-db-instance-using-terraform/
