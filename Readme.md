# Connector Test Framework for REH Trainee (Mentorship)

## Features
This project is a test framework for the Digitech connector, designed for REH trainees as part of a mentorship program. It uses Codeception for acceptance testing and Docker for managing test environments.

# How to start the project locally
1. Clone the repository:
   ```bash
   git clone https://github.com/NoellaMarie501/Codeception-UAT-Connector.git
   cd Codeception-UAT-Connector
   ```
2. Ensure that Docker and Docker Compose are installed on your machine.
3. Install and configure aws
```bash
   sudo apt update && sudo apt install unzip -y
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   complete -C '/usr/local/bin/aws_completer' aws
   aws configure  //for add your aws key, aws secret, region and format
```

4. Authenticate with your aws credentials:
   ```bash
    make auth2
   ```

5. Download the image of digitech connector
   ```bash
   make digitech-pull
   ```

6. Build the Docker containers:
   ```bash
   make build
   ```

7. Start the services:
   ```bash
   make up
   ```

## Framework
The project uses the following frameworks:
- **Codeception**: A PHP testing framework for acceptance, functional, and unit testing.
## Development
### Development Commands
- **build**: Build the Docker containers.
  ```bash
  make build
  ```
- **up**: Start the services in the background.
  ```bash
  make up
  ```
- **stop**: Stop the services.
  ```bash
  make stop
  ```
- **reset**: Reset the services (stop, clean, rebuild, and start).
  ```bash
  make reset
  ```
- **clean**: Clean up Docker containers and orphans.
  ```bash
  make clean
  ```
- **app-logs**: Show application logs.
  ```bash
  make app-logs
  ```
- **test-logs**: Show test logs.
  ```bash
  make test-logs
  ```
- **app-root**: Open a bash shell as root in the application container.
  ```bash
  make app-root
  ```
- **test-root**: Open a bash shell as root in the test container.
  ```bash
  make test-root
  ```
- **execute-test**: Run tests in the test container.
  ```bash
  make execute-test
  ```

## Run tests

To run the tests:
1. Open a bash shell as root in the test container: 
```bash
   make test-root
```
2. use the following command:
```bash
   vendor/bin/codecept run Acceptance 
```

# Configuration Parameters
Configuration parameters are defined in the `variables.env` file. Make sure to properly configure the necessary environment variables before starting the services.

For example content of the `variables.env` file:
```env
DIGITECH=<digitech_connector-image>
APPLICATION_ENV=testing
MYSQL_HOST=mysql
```

