provider "google" {
  project = "sincere-concept-378021"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_storage_bucket" "gcb1234" {
  name     = "gc-bucket"
  location = "europe-west2"
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.gcb1234.name
  role   = "READER"
  entity = "allUsers"
}


resource "google_compute_instance" "gc-vm" {
  name         = "gc-vm-tf"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["dareit"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"
      }
    }
  }

  network_interface {
    network = "default"
    access_config {

      // Ephemeral public IP

    }
  }
}

resource "google_sql_database_instance" "dareit" {
  name             = "dareit-db"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = "dareit_user"
  instance = google_sql_database_instance.dareit.name
  host     = "dareit_user.com"
  password = "changeme"
}