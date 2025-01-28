#!/bin/bash

# Array of servers
servers=(localhost)

# Stop and start commands for the two  servers
1_stop="/home/manoj/bin/shutdown_1.sh"
1_start="nohup /home/manoj/bin/startup_1.sh > /dev/null 2>&1 &"
2_stop="/home/manoj/bin/shutdown_2.sh"
2_start="nohup /home/manoj/bin/startup_2.sh > /dev/null 2>&1 &"

# Prompt for username
read -p "Enter your username: " username

# Function to execute a command on a remote server and handle errors
execute_remote_command() {
    local server=$1
    local command=$2
    echo "Executing on $server: $command"
    ssh -p 2228 "$username@$server" "$command"
    echo "lol"
    if [ $? -ne 0 ]; then
        echo "Error: Command failed on $server: $command"
        exit 1
    fi
}

# Function to check if a process is running and display PID
check_process() {
    local server=$1
    local process_name=$2
    local action=$3

    echo "Checking if $process_name has $action on $server..."
    if [ "$action" == "stopped" ]; then
        ssh -p 2228 "$username@$server" "ps -ef | grep -v grep | grep $process_name" 
        if [ $? -eq 0 ]; then
            echo "Error: $process_name is still running on $server"
            exit 1
        else
            echo "$process_name has successfully stopped on $server"
        fi
    elif [ "$action" == "started" ]; then
        pid=$(ssh -p 2228 "$username@$server" "ps -ef | grep -v grep | grep $process_name | awk '{print \$2}'")
        if [ -z "$pid" ]; then
            echo "Error: $process_name has not started on $server"
            exit 1
        else
            echo "$process_name has successfully started on $server with PID: $pid"
        fi
    fi
}

# Iterate over servers
for server in "${servers[@]}"; do
    echo "Processing $server..."

    # Stop  1
    execute_remote_command "$server" "$1_stop"
    check_process "$server" "shutdown_1\.sh" "stopped"
    echo " 1 stopped on $server"

    # Stop  2
    execute_remote_command "$server" "$2_stop"
    check_process "$server" "shutdown_2\.sh" "stopped"
    echo " 2 stopped on $server"

    # Start  1
    execute_remote_command "$server" "$1_start"
    check_process "$server" "startup_1\.sh" "started"
    echo " 1 started on $server"

    # Pause to avoid CPU overload
    echo "Pausing for 3 seconds before starting  2 on $server..."
    sleep 3

    # Start  2
    execute_remote_command "$server" "$2_start"
    check_process "$server" "startup_2\.sh" "started"
    echo " 2 started on $server"

done

echo "All servers processed successfully."
