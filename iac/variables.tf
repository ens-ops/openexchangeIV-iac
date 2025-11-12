variable "proxmox_api_url" {
  description = "The URL of the Proxmox API."
  type        = string
  sensitive   = true
}

variable "proxmox_token_id" {
  description = "The Proxmox API token ID (e.g., root@pam!OXtoken)."
  type        = string
}

variable "proxmox_token_secret" {
  description = "The Proxmox API token secret."
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "The Proxmox node name where VMs will be created."
  type        = string
}

variable "proxmox_storage_pool" {
  description = "The Proxmox storage pool name for VM disks."
  type        = string
}

variable "proxmox_bridge_network_id" {
  description = "The Proxmox bridge network ID for VM connectivity."
  type        = string
}

variable "openexchange_backend_ip" {
  description = "Static IP address for the OpenExchange Backend VM."
  type        = string
}

variable "openexchange_ui_ip" {
  description = "Static IP address for the OpenExchange UI VM."
  type        = string
}

variable "openexchange_services_ip" {
  description = "Static IP address for the OpenExchange Services VM."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to be injected into the VMs for access."
  type        = string
  sensitive   = true
}

variable "vm_ssh_user" {
  description = "The user for SSH access to the VMs (e.g., ubuntu)."
  type        = string
  default     = "ubuntu"
}

variable "vm_template_name" {
  description = "The name of the cloud-init template to use for VMs."
  type        = string
}

variable "vm_cpu_cores" {
  description = "Number of CPU cores for each VM."
  type        = number
  default     = 2
}

variable "vm_memory_mb" {
  description = "Amount of RAM in MB for each VM."
  type        = number
  default     = 2048
}

variable "vm_disk_size_gb" {
  description = "Size of the primary disk in GB for each VM."
  type        = number
  default     = 30
}

variable "proxmox_gateway_ip" {
  description = "The gateway IP address for the Proxmox network bridge."
  type        = string
}

variable "custom_vm_template_name" {
  description = "The name of the custom OpenExchange VM template to create."
  type        = string
  default     = "openexchange-custom-template"
}
