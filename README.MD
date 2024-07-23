# DevOpsFetch: Server Information Retrieval and Monitoring Tool
## Objective
DevOpsFetch is a tool designed for DevOps engineers to collect and display system information, including active ports, user logins, Nginx configurations, Docker images, and container statuses. It also includes a systemd service for continuous monitoring and logging of these activities.

## Features
- Ports: Display all active ports and services, or detailed information about a specific port.
- Docker: List all Docker images and containers, or detailed information about a specific container.
- Nginx: Display all Nginx domains and their ports, or detailed configuration information for a specific domain.
- Users: List all users and their last login times, or detailed information about a specific user.
- Time Range: Display activities within a specified time range.
- Continuous Monitoring: Continuous monitoring and logging of system activities using a systemd service.

## Installation Guide
**Step 1: Prepare the Installation Script**
- Create an installation script **install.sh** that will install necessary dependencies, set up the systemd service, and start the service.
- Make sure the installation script is executable:
```bash
sudo chmod +x install.sh
```
**Step 2: Create the devopsfetch Script**
- Create the **devopsfetch** script with the required functionalities and move to /usr/local/bin
- Make the script executable:
```bash
sudo chmod +x /usr/local/bin/devopsfetch
```
