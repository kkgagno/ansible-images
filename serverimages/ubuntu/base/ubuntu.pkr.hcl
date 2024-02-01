locals {
  timestamp  = regex_replace(timestamp(), "[- TZ:]", "")
  image_name = "${var.image_name_prefix}-${local.timestamp}"
}

source "googlecompute" "this" {

  project_id = var.project_id
  zone       = var.zone

  image_name              = local.image_name
  image_licenses          = var.image_licenses
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  
  subnetwork = var.subnetwork
  
  tags = ["packer-ssh"]

  machine_type = var.machine_type

  ssh_username      = var.ssh_user
  ssh_timeout       = "10m"
  skip_create_image = false

  metadata = {
    enable-oslogin         = "false"
    enable-oslogin-2fa     = "false"
    block-project-ssh-keys = "true"
  }
}

build {
  sources = [
    "source.googlecompute.this"
  ]

  provisioner "file" {
    destination = "/tmp"
    source      = "../../software/"
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | {{ .Vars }} sudo -S -E bash -eux '{{ .Path }}'"
    script          = "scripts/install-nessus.sh"
    environment_vars = [
      #"VAR1=${var.VAR1}"
    ]
  }

  provisioner "ansible" {

    ansible_env_vars       = ["ANSIBLE_ROLES_PATH=ansible-roles"]
    extra_arguments        = ["-e", "ansible_python_interpreter=/usr/bin/python3"]
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
    user                   = var.ssh_user
    playbook_file          = "./playbook_packer.yml"
  }


}
