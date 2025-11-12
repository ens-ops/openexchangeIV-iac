proxmox_api_url = "https://192.168.0.100:8006/api2/json"
proxmox_token_id = "root@pam!OXtoken"
proxmox_token_secret = "53db9d94-6d68-4358-b3ae-4829901062bb"
proxmox_node    = "gsserver"
proxmox_storage_pool = "local"
proxmox_bridge_network_id = "vmbr0"
vm_template_name = "ubuntu-2204-cloud-template"

# Static IP addresses for OpenExchange VMs
openexchange_backend_ip = "192.168.1.10" # Example IP, adjust as needed
openexchange_ui_ip = "192.168.1.11"    # Example IP, adjust as needed
openexchange_services_ip = "192.168.1.12" # Example IP, adjust as needed
proxmox_gateway_ip = "192.168.1.1" # Example Gateway IP, adjust as needed

# SSH Public Key for VM access
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3b... your_public_key_here" # Replace with your actual public SSH key
vm_ssh_user = "ubuntu" # Default cloud-init user for Ubuntu
