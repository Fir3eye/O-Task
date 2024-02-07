# 🕹️Docker and Logging Environment Setup Script

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



## 🥏Configuring `docker-compose.yml`

To configure your Docker services, you'll need to create a `docker-compose.yml` file with your server's IP address and a secure password. 

### Steps to Configure

1. **Create `docker-compose.yml`**: Create a `docker-compose.yml` file in your preferred directory.

2. **Generate a Secure Password**:
    - Run the following command to generate a secure SHA-256 hashed password:
    ```bash
    echo -n "Enter pass:" && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d " " -f1
    ```
    - When prompted, enter your desired password and press Enter. The script will output a SHA-256 hash of your password.

3. **Edit `docker-compose.yml`**:
    - Insert the server IP and the generated SHA-256 hashed password into the `docker-compose.yml` file. Replace `your_server_ip` with your actual server IP and `your_generated_password` with the SHA-256 hash you generated.
    ```yaml
        .......
      - GRAYLOG_ROOT_PASSWORD_SHA2=your_generated_password
      - GRAYLOG_HTTP_EXTERNAL_URI=http://your_server_ip:9000/
    ...........
    ```
    - Customize the service and image according to your setup requirements.

4. **Start Services with Docker Compose**:
    - In the directory with your `docker-compose.yml`, run:
    ```bash
    docker-compose up
    ```
    - This will start the services defined in your Docker Compose file.

5. **Accessing the Application**:
    - Once the services are running, you can access the application by navigating to `http://your_server_ip:9000` in your web browser.

## 🚀Configuring Apache Logs with `rsyslog`

To forward Apache logs to a centralized log server using `rsyslog`, follow the steps below to configure your Apache server. This will allow you to manage and analyze logs from a single location.

### Prerequisites

- Apache web server installed on your node server.
- `rsyslog` installed on both the Apache server (client) and the centralized log server.

### Configuration Steps

1. **Configure `rsyslog` on the Apache Server**:
    - Open the `rsyslog` configuration file for editing, which is typically `/etc/rsyslog.conf` or a custom file in `/etc/rsyslog.d/apache-log.conf`.
    - Add the following lines to forward Apache logs to your centralized log server. Replace `central_log_server_ip` with the IP address of your log server:

    ```
    # Load the imfile module
    module(load="imfile" PollingInterval="10")

    # Monitor Apache Access Log
    input(type="imfile"
      File="/var/log/apache2/access.log"
      Tag="apache-access"
      StateFile="stat-apache-access-log"
      Severity="info")

    # Monitor Apache Error Log
    input(type="imfile"
          File="/var/log/apache2/error.log"
          Tag="apache-error"
          StateFile="stat-apache-error-log"
          Severity="error")

    # Forward All Logs to Remote Server
    *.* @your_server_IP:1514
    ```

3. **Restart Apache and `rsyslog`**:
    - After updating the configurations, restart Apache and `rsyslog` to apply the changes:

    ```bash
    sudo systemctl restart apache2
    sudo systemctl restart rsyslog
    ```

