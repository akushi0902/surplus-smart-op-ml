terraform {
  cloud {
    # Replaced automatically during deployment with the selected TFC organization
    organization = "TF01"
    workspaces {
      # Replaced automatically during deployment with the selected TFC workspace name
      name = "ec2-instance-dev"
    }
  }
}
