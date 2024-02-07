# Docker and Logging Environment Setup Script

This bash script automates the setup process for a Docker environment on a Linux machine. It installs Docker, adds the current user to the Docker group, installs essential utilities (`curl` and `wget`), sets up Docker Compose, and prepares the system for logging by creating specific directories with appropriate permissions. It also configures the Uncomplicated Firewall (UFW) to allow traffic on port 9000, commonly used by web applications.

## Prerequisites

- A Linux distribution that supports `apt` package management (such as Ubuntu or Debian).
- User with sudo privileges.

## Features

- **Docker Installation**: Installs `docker.io` package.
- **User Group Configuration**: Adds the current user to the `docker` group to allow running Docker commands without `sudo`.
- **Docker Version Check**: Displays the installed Docker version.
- **Utility Tools Installation**: Installs `curl` and `wget` utilities.
- **Docker Compose Setup**: Installs `docker-compose`.
- **Directory Creation**: Creates `/mongo_data`, `/es_data`, and `/graylog_journal` for data storage.
- **Permissions Setting**: Sets full read/write/execute permissions on the created directories.
- **Firewall Configuration**: Allows traffic on port 9000/tcp.

## How to Use

1. **Download the Script**: Download the `setup_docker_and_logs.sh` script to your local machine.

2. **Make the Script Executable**:
    ```bash
    chmod +x setup_docker_and_logs.sh
    ```

3. **Run the Script**:
    - Execute the script using `sudo` to ensure it has the necessary permissions:
    ```bash
    sudo ./setup_docker_and_logs.sh
    ```

4. **Post-Execution Steps**:
    - You may need to log out and log back in or reboot your system to apply the user group changes effectively.

## Security Considerations

- The script sets the permissions of `/mongo_data`, `/es_data`, and `/graylog_journal` directories to `777` (read, write, execute for all users). Review and adjust these permissions as necessary to comply with your security policies.
- Ensure that allowing traffic on port 9000/tcp is compatible with your network security policies.

## Troubleshooting

- **Docker Commands Require `sudo`**: If Docker commands still require `sudo` after script execution, ensure you've logged out and back in to refresh your user group memberships.
- **Firewall Issues**: If applications can't connect on port 9000, ensure UFW is correctly configured and the service/application is configured to listen on this port.

## License

This script is provided "as is", without warranty of any kind, express or implied. Use at your own risk.

