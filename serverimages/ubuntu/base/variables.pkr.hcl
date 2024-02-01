variable "zone" {
  description = "Gcp Zone where Image will be created"
  type        = string
  default     = "us-east1-b"
}

variable "project_id" {
  description = "Gcp Project Id where Image will be created"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Network tags"
  type        = list(string)
  default     = [""]
}

variable "subnetwork" {
  description = "Subnetwork"
  type        = string
  default     = ""
}

variable "network" {
  description = "Network"
  type        = string
  default     = ""
}

variable "disk_size" {
  description = "Size of the image disk"
  type        = number
  default     = 10
}

variable "ssh_user" {
  description = "The SSH user used when connecting to the image for provisioning"
  type        = string
  default     = "ubuntu"
}

variable "machine_type" {
  description = "Machine type that will be use"
  type        = string
  default     = "e2-micro"
}

variable "image_name_prefix" {
  description = "The prefix to use when creating the image name."
  type        = string
  default     = "ubuntu-cis-hardened"
}

variable "source_image_family" {
  description = "Source image family."
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "source_image_project_id" {
  description = "Source image project id."
  type        = list(string)
  default     = ["ubuntu-os-cloud"]
}

variable "image_licenses" {
  description = "Image licenses"
  type        = list(string)
  default     = ["projects/vm-options/global/licenses/enable-vmx"]
}
