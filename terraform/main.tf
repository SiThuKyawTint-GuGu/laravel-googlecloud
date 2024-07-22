provider "google" {
  project = "testing-429803"
  region  = "asia-southeast1"
}

resource "google_sql_database_instance" "mysql_instance" {
  name             = "mysql"
  database_version = "MYSQL_8_0"
  region           = "asia-southeast1"

 settings {
    tier = "db-f1-micro"

    ip_configuration {
      authorized_networks {
        name  = "allow-all"
        value = "0.0.0.0/0"  # Not recommended for production; use specific IP ranges
      }
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "my_database" {
  name     = "gcp"
  instance = google_sql_database_instance.mysql_instance.name
}

resource "google_sql_user" "my_user" {
  name     = "gugu"
  instance = google_sql_database_instance.mysql_instance.name
  password = "guguadmin"
}

output "database_host" {
  value = google_sql_database_instance.mysql_instance.ip_address[0].ip_address
}