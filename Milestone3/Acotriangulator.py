import tkinter as tk
from tkinter import ttk
import paramiko
import threading
from scp import SCPClient
import subprocess
import csv

# Global flag to indicate if the process should stop
stop_flag = False

# Read estimated postion from file
def read_estimated_position_from_file():
    with open('estimated_position.csv', 'r') as f:
        reader = csv.reader(f)
        estimated_position = next(reader)  # Assumes only one line in the CSV
    return float(estimated_position[0]), float(estimated_position[1])




# Function to record audio on Raspberry Pi
def record_audio_on_pi(device):
    global stop_flag

    hostname = device['hostname']
    username = device['username']
    password = device['password']
    command = device['command']

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        ssh.connect(hostname, username=username, password=password)
        if stop_flag:
            return
        stdin, stdout, stderr = ssh.exec_command(command)
        stdout.channel.recv_exit_status()

        if stop_flag:
            return

        with SCPClient(ssh.get_transport()) as scp:
            remote_path = command.split()[-1]
            local_path = f"C:\\Users\\User\\Downloads\\TestAudio\\{remote_path}"
            scp.get(remote_path, local_path)
    finally:
        ssh.close()

# Function to update GUI with estimated position
def update_position(x, y):
    position_label.config(text=f"X: {x}, Y: {y}")
    canvas.create_oval(x-5, y-5, x+5, y+5, fill="red")

# Function to start the recording and TDOA process
def start_process():
    global stop_flag
    stop_flag = False
    
    # Reset progress bar
    progress_bar["value"] = 0

    # Define your devices and threads here
    
    devices = [
    {"hostname": "192.168.137.39", "username": "raspberrypi1", "password": "your_password_here", "command": "arecord -D plughw:0 -c2 -r 48000 -f S32_LE -d 10 -t wav -V stereo -v Acotest1.wav"},
    {"hostname": "192.168.137.190", "username": "raspberrypi2", "password": "your_password_here", "command": "arecord -D plughw:0 -c2 -r 48000 -f S32_LE -d 10 -t wav -V stereo -v Acotest2.wav"}
    ]
    threads = []

    for device in devices:
        thread = threading.Thread(target=record_audio_on_pi, args=(device,))
        threads.append(thread)

    for thread in threads:
        thread.start()
        if stop_flag:
            return

    for thread in threads:
        thread.join()
        if stop_flag:
            return

    # Update progress bar after recording
    progress_bar["value"] = 50

    # Run MATLAB Script and get estimated_position
    matlab_script_path = "C:\\Users\\User\\Downloads\\TestAudio\\TDOA.m"

    try:
        subprocess.run(['matlab', '-r', f"run('{matlab_script_path}')"], check=True)
    except subprocess.CalledProcessError:
        print("Failed to run MATLAB script.")

    # Update progress bar after MATLAB Script
    progress_bar["value"] = 100

    # Update the GUI
    # For demonstration, using (200, 200) as the estimated position
    x, y = read_estimated_position_from_file()
    update_position(x, y)
    update_position(200, 200)

# Function to stop the process
def stop_process():
    global stop_flag
    stop_flag = True

# Function to clear previous results and GUI elements
def clear_previous_results():
    position_label.config(text="")
    canvas.delete("all")
    progress_bar["value"] = 0

# Function to resume the process
def resume_process():
    global stop_flag
    stop_flag = False
    clear_previous_results()
    start_process()


def draw_grid():
    for i in range(0, 801, 100):  # Vertical lines
        canvas.create_line(i, 0, i, 500, fill='gray', dash=(2, 2))
    for i in range(0, 501, 100):  # Horizontal lines
        canvas.create_line(0, i, 800, i, fill='gray', dash=(2, 2))










# Initialize the GUI window
root = tk.Tk()
root.title("Acotriangulator")

# Add buttons
start_button = ttk.Button(root, text="Start", command=start_process)
start_button.grid(row=0, column=0, padx=10, pady=10)

stop_button = ttk.Button(root, text="Stop", command=stop_process)
stop_button.grid(row=0, column=1, padx=10, pady=10)

resume_button = ttk.Button(root, text="Resume", command=resume_process)
resume_button.grid(row=0, column=2, padx=10, pady=10)

# Add labels to display the estimated position
result_label = ttk.Label(root, text="Estimated Position:")
result_label.grid(row=1, column=0, padx=10, pady=10)

position_label = ttk.Label(root, text="")
position_label.grid(row=1, column=1, padx=10, pady=10)

# Add a progress bar
progress_bar = ttk.Progressbar(root, orient="horizontal", length=300, mode="determinate")
progress_bar.grid(row=2, columnspan=3, padx=10, pady=10)

# Add a canvas to display the grid and estimated position
canvas = tk.Canvas(root, bg="white", height=500, width=800)
canvas.grid(row=3, columnspan=3)

# Draw the grid on the canvas
draw_grid()


# Run the GUI event loop
root.mainloop()
