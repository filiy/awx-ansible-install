module "gcp" {
   source                 = "./modules/gcp"
   awx_admin              = "admin"
   awx_admin_pass         = ""
   gcp_json               = ""
   gcp_project_id         = ""
   gcp_region             = ""
   gcp_zone               = ""
   gcp_instance_name      = ""
   gcp_instance_os        = ""
   ssh_key_path           = ""
   ssh_key_pub            = ""
   ssh_key_priv           = ""
   ssh_user               = ""
}

# source             = module path. Do not Change
# gcp_json           = GCP Service Account Key (path + filename) 
# gcp_project_id     = GCP Project ID
# gcp_region         = GCP Region for instances ie northamerica-northeast
# gcp_zone           = GCP Zone within the region ie a,b,c
# gcp_instance_name  = The instance name as it will appear in GCP https://cloud.google.com/compute/docs/regions-zones/
# gcp_instance_os    = The OS Image to use - public images https://cloud.google.com/compute/docs/images#os-compute-support
# ssh_key_path       = Path to SSH key pair to use
# ssh_key_pub        = Public Key filename to be provisioned to the instance
# ssh_key_priv       = Private Key filename 
# ssh_user           = Username for ssh
