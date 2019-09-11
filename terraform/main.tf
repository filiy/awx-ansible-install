provider "google" {
  credentials = "${var.gcp_json}"
  project     = "${var.gcp_project_id}"
  region      = "${var.gcp_region}"
  zone        = "${var.gcp_region}-${var.gcp_zone}"
}

// Create a new instance
resource "google_compute_instance" "awx01" {
  count        = 1
  machine_type = "n1-standard-1"
  zone         = "${var.gcp_region}-${var.gcp_zone}"
  name         = "${var.gcp_instance_name}"


  boot_disk {
    initialize_params {
      image = "${var.gcp_instance_os}"
    }
  }

 network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
   }
}
  // Add http/https network tags for use in firewall rule creation
  tags=["http","https"]
  
  // Add the public key defined in main.tf as a meta tag 
  metadata {
     ssh-keys = "${var.ssh_user}:${var.ssh_key_pub}"
  }

  // Remote Exec provisioner is used to bootstrap the instance with GIT/Ansible and run 
  // the playbook to install AWX. It connects via SSH using the SSH Keys provisioned previously 
  // as defined in main.tf 

  provisioner "remote-exec" {
    connection { 
      type    = "ssh"
      user    = "${var.ssh_user}"
      timeout = "500s"
      private_key = "${var.ssh_key_priv}"
    }
    inline = [

      "sudo yum -y apache",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo firewall-cmd --add-port=tcp/80"
    ]

  }

}
// Create a firewall Rule to allow instances tagged with http/https 
resource "google_compute_firewall" "default" {
 name    = "web-firewall"
 network = "default"

 allow {
   protocol = "icmp"
 }

 allow {
   protocol = "tcp"
   ports    = ["80","443"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags = ["http","https"]
}
variable "gcp_json" {}
variable "gcp_project_id" {}
variable "gcp_region" {}
variable "gcp_zone" {}
variable "gcp_instance_name" {}
variable "gcp_instance_os" {}
variable "ssh_key_path" {}
variable "ssh_key_pub" {}
variable "ssh_key_priv" {}
variable "ssh_user" {}
variable "github_repo" {}
variable "ansible_playbook" {} 
