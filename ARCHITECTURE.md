# OpenExchange Infrastructure Architecture Document

## 1. Introduction

This document outlines the architecture for deploying and managing the OpenExchange suite using Infrastructure as Code (IaC) principles. The primary goal is to provision virtual machines (VMs) on a Proxmox hypervisor and configure them with Ansible to host the OpenExchange backend, UI, and services, along with essential security measures.

## 2. Architecture Overview

The OpenExchange infrastructure is designed as a multi-VM setup, with distinct roles for the backend, user interface, and services. This separation enhances modularity, security, and scalability. Terraform is used for provisioning the VMs on Proxmox, while Ansible handles the operating system configuration, software installation, and application deployment.

**Key Components:**
*   **Proxmox VE:** The virtualization platform hosting the VMs.
*   **Terraform:** Used for defining and provisioning the VM infrastructure.
*   **Ansible:** Used for configuration management and application deployment on the VMs.
*   **OpenExchange Backend VM:** Hosts the core OpenExchange application logic and database.
*   **OpenExchange UI VM:** Hosts the Nginx web server serving the OpenExchange user interface.
*   **OpenExchange Services VM:** Hosts additional OpenExchange services.
*   **Template Builder VM:** A temporary VM used for creating or updating the base VM template.

## 3. Infrastructure Components (Terraform)

The `iac/main.tf` file defines the following virtual machines:

### 3.1. `openexchange_backend` VM
*   **Purpose:** Dedicated to running the OpenExchange backend application and its dependencies, including MariaDB.
*   **Configuration:**
    *   Cloned from a base VM template.
    *   Configured with specific CPU cores, memory, and disk size.
    *   Assigned a static IP address (`var.openexchange_backend_ip`).
    *   Cloud-init enabled for initial user and SSH key setup.

### 3.2. `openexchange_ui` VM
*   **Purpose:** Dedicated to serving the OpenExchange user interface via Nginx.
*   **Configuration:**
    *   Cloned from a base VM template.
    *   Configured with specific CPU cores, memory, and disk size.
    *   Assigned a static IP address (`var.openexchange_ui_ip`).
    *   Cloud-init enabled for initial user and SSH key setup.

### 3.3. `openexchange_services` VM
*   **Purpose:** Dedicated to running auxiliary OpenExchange services.
*   **Configuration:**
    *   Cloned from a base VM template.
    *   Configured with specific CPU cores, memory, and disk size.
    *   Assigned a static IP address (`var.openexchange_services_ip`).
    *   Cloud-init enabled for initial user and SSH key setup.

### 3.4. `template_builder` VM
*   **Purpose:** A temporary VM used for building and updating the golden VM template. This VM is typically provisioned, configured, and then converted into a template.
*   **Configuration:**
    *   Cloned from a base VM template.
    *   Configured with specific CPU cores, memory, and disk size.
    *   Uses DHCP for IP assignment, as it's a temporary, non-production VM.
    *   Cloud-init enabled for initial user and SSH key setup.

## 4. Configuration Management and Deployment (Ansible)

The `ansible/playbook.yml` orchestrates the configuration of the provisioned VMs using various roles:

### 4.1. `common_dependencies` Role
*   **Purpose:** Installs common packages and system-wide dependencies required by all OpenExchange VMs.
*   **Tasks:** Includes general system updates, essential utilities, and any prerequisites for other roles.

### 4.2. `openexchange_backend` Role
*   **Purpose:** Configures the OpenExchange backend server.
*   **Tasks:**
    *   Installs and configures MariaDB, including initial setup and security hardening.
    *   Deploys OpenExchange specific packages.
    *   Configures OpenExchange application settings using Jinja2 templates (e.g., `ox-config/*.j2`) for various components like CalDAV, CardDAV, IMAP, mail, notification, and server properties.

### 4.3. `openexchange_ui` Role
*   **Purpose:** Configures the OpenExchange user interface server.
*   **Tasks:**
    *   Installs Nginx web server.
    *   Configures Nginx to serve the OpenExchange UI, including virtual host configurations (`default.conf.j2`, `openexchange_ui.conf.j2`) and general Nginx settings (`nginx.conf.j2`).

### 4.4. `openexchange_services` Role
*   **Purpose:** Configures any additional OpenExchange services that are not part of the core backend or UI.
*   **Tasks:** Specific tasks for these services would be defined within this role.

### 4.5. `secure_vms` Role
*   **Purpose:** Applies baseline security configurations to all VMs.
*   **Tasks:**
    *   Hardens SSH configurations.
    *   Installs and configures Fail2Ban for intrusion prevention.
    *   Removes cloud-init artifacts post-provisioning to enhance security and reduce attack surface.

## 5. Technologies Used

*   **Proxmox VE:** Virtualization platform.
*   **Terraform:** Infrastructure as Code tool for provisioning.
*   **Ansible:** Configuration management and automation tool.
*   **MariaDB:** Database for the OpenExchange backend.
*   **Nginx:** Web server for the OpenExchange UI.
*   **Cloud-init:** For initial VM setup and configuration.
*   **Jinja2:** Templating engine used by Ansible for dynamic configuration files.

## 6. Security Considerations

*   **SSH Hardening:** Implemented via the `secure_vms` role.
*   **Fail2Ban:** Configured to protect against brute-force attacks.
*   **Secrets Management:** `ansible/group_vars/all/vault.yml` is used for storing sensitive data, which should be encrypted.
*   **TLS/SSL:** Nginx configurations should be updated to enforce HTTPS for secure communication.
*   **Firewall:** Further firewall rules should be implemented at the VM and/or Proxmox level to restrict access to necessary ports only.

## 7. Scalability and High Availability (Future Considerations)

The current architecture provisions single instances of each OpenExchange component. For production environments, the following should be considered:

*   **Load Balancing:** Implement a load balancer (e.g., HAProxy, Nginx) in front of multiple UI and Services VMs.
*   **Database Clustering:** Configure MariaDB in a cluster (e.g., Galera Cluster) for high availability and read scalability.
*   **Multiple Instances:** Deploy multiple instances of `openexchange_backend`, `openexchange_ui`, and `openexchange_services` VMs behind load balancers.
*   **Shared Storage:** For certain OpenExchange components, shared storage solutions might be necessary.

## 8. Future Enhancements

*   **CI/CD Pipeline:** Integrate Terraform and Ansible into a CI/CD pipeline for automated deployments and updates.
*   **Monitoring and Alerting:** Implement comprehensive monitoring (e.g., Prometheus, Grafana) and alerting for infrastructure and application health.
*   **Backup and Disaster Recovery:** Establish automated backup procedures and a disaster recovery plan.
*   **Automated Testing:** Introduce automated tests for IaC (Terraform, Ansible) to ensure correctness and idempotency.
*   **Advanced Secrets Management:** Explore dedicated secrets management solutions (e.g., HashiCorp Vault) for enhanced security.
*   **Documentation:** Maintain up-to-date documentation for all aspects of the infrastructure.
