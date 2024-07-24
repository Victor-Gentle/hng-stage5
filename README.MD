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
- Run script to install dependencies
**Step 2: Create the devopsfetch Script**
- Create the **devopsfetch** script with the required functionalities and move to /usr/local/bin
- Make the script executable:
```bash
sudo chmod +x /usr/local/bin/devopsfetch
```
## Usage
Now you can use the devopsfetch command directly. For example:

- Display all active ports and services: **devopsfetch --port**
- Display Docker information: **devopsfetch --docker**
- Display Nginx domains and ports: **devopsfetch --nginx**
- List all users and their last login times: **devopsfetch --users**
- Display activities within a specified time range: **devopsfetch --time "2024-07-22 00:00:00" "2024-07-23 00:00:00"**
- This setup ensures that the devopsfetch script is easy to run and manage, while still providing all the functionality required.

## Continuous Monitoring
- When no arguments are provided, devopsfetch will run in monitoring mode by default, logging activities to /var/log/devopsfetch.log.

- To start the monitoring service, use:
```bash
sudo systemctl start devopsfetch.service
```
- To check the status of the service:
```bash
sudo systemctl status devopsfetch.service
```
## Logs
- Logs are stored in /var/log/devopsfetch.log. Log rotation and management are handled by the default log management system of the operating system.

