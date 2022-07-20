terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("C:/Users/hp/Desktop/majestic-nimbus-328507-cce470665f77.json")

  project = "majestic-nimbus-328507"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vpc_network" {
  name         = "terraform"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}