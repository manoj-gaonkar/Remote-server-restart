# Remote Server Management Script

This Bash script automates the process of stopping and starting two servers on multiple remote servers via SSH. It includes functionality for checking the status of processes to ensure proper execution. The script is designed to handle errors gracefully and prompts the user for their SSH username before execution.

## Features

1. **Automated Stop and Start**:

   - Executes shutdown and startup commands for two servers sequentially.
   - Ensures each server stops and starts successfully before proceeding.

2. **Background Execution**:

   - Startup scripts are executed in the background using `nohup` to allow them to run independently of the script's lifecycle.

3. **Error Handling**:

   - Verifies the success of each command and exits the script if a command fails.
   - Provides clear error messages in case of issues.

4. **Process Validation**:

   - Uses `ps` commands to check the status of processes.
   - Displays the PID of running processes for better monitoring.

5. **Pause Between Operations**:
   - Introduces a configurable delay between starting the two servers to reduce CPU load.

## Requirements

- Bash shell
- SSH access to remote servers
- User permissions to execute shutdown and startup scripts on the remote servers

## Usage

1. Clone or copy the script to your local system.

2. Ensure the shutdown and startup scripts for the servers are available on the remote server paths:

   - `/home/<username>/bin/shutdown_1.sh`
   - `/home/<username>/bin/startup_1.sh`
   - `/home/<username>/bin/shutdown_2.sh`
   - `/home/<username>/bin/startup_2.sh`

3. Execute the script:

   ```bash
   ./script_name.sh
   ```

4. Enter your SSH username when prompted.

## Script Workflow

1. **Prompt for Username**:
   The script asks for the username required to SSH into the servers.

2. **Iterate Over Servers**:
   The script processes each server in the `servers` array (currently set to `localhost`).

3. **Stop Servers**:

   - Executes the stop script for each server.
   - Verifies that the servers have successfully stopped by checking the process list.

4. **Start Servers**:

   - Executes the start script for each server in the background using `nohup`.
   - Verifies that the servers have successfully started by checking the process list and retrieving the PID.
   - Introduces a pause before starting the second server.

5. **Error Handling**:
   - If any command fails, the script exits and displays an error message.

## Example Output

```
Enter your username: username
Processing localhost...
Executing on localhost: /home/username/bin/shutdown_1.sh
 1 stopped on localhost
Executing on localhost: /home/username/bin/shutdown_2.sh
 2 stopped on localhost
Executing on localhost: nohup /home/username/bin/startup_1.sh > /dev/null 2>&1 &
 1 started on localhost with PID: 12345
Pausing for 3 seconds before starting  2 on localhost...
Executing on localhost: nohup /home/username/bin/startup_2.sh > /dev/null 2>&1 &
 2 started on localhost with PID: 67890
All servers processed successfully.
```

## Notes

- **Configurable SSH Port**: The script uses port `2228` for SSH. Update the `ssh` command in the script if a different port is required.
- **Servers Array**: Modify the `servers` array to include all the servers you want to manage.
- **Startup Script Background Execution**: `nohup` ensures that startup scripts continue running even if the SSH session closes.

## Troubleshooting

1. **Permission Denied Errors**:
   Ensure the user has the correct permissions to execute the scripts on the remote server.

2. **Process Not Stopping/Starting**:
   Verify the paths to the stop and start scripts and ensure they are executable.

3. **SSH Issues**:

   - Check the SSH port and server connectivity.
   - Ensure the SSH key or password for the user is correctly configured.

4. **Script Hanging**:
   If the startup script includes long-running commands (e.g., `sleep`), ensure it runs properly in the background using `nohup` and `&`.

## License

This script is provided "as is" without warranty of any kind. Modify and use it as needed for your own environment.
