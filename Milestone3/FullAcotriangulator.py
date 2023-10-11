import multiprocessing
from time import sleep
import os
import sys
import paramiko
import matlab.engine
import sounddevice as sd
import soundfile as sf

# Define SSH record command for each Raspberry Pi
def pi1():
    #os.system("ssh raspberrypi1@192.168.137.39 python3 wait_and_record.py")

    #os.system("ssh raspberrypi1@192.168.137.39 echo $(date +%s%N) > timestamp1.csv")

    os.system("ssh raspberrypi1@192.168.137.47 sudo nice -n -20 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -d 20 -t wav -V stereo -v RecordingPi1.wav")
   

def pi2():
    #os.system("ssh raspberrypi2@192.168.137.190 python3 wait_and_record.py")

   #os.system("ssh raspberrypi1@192.168.137.190 echo $(date +%s%N) > timestamp2.csv")

    os.system("ssh raspberrypi2@192.168.137.105 sudo nice -n -20 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -d 20 -t wav -V stereo -v RecordingPi2.wav")
   
def transfer_files(host, user, file_path, dest_dir):
    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(paramiko.WarningPolicy)
    client.connect(host, username=user)
    sftp = client.open_sftp()
    sftp.get(file_path, f'{dest_dir}/{file_path.split("/")[-1]}')
    sftp.close()
    client.close()
    
def matlab_processing(audio_dir):
    eng = matlab.engine.start_matlab()
    script_path = os.path.join(os.getcwd(), 'Acotriangulator.m')  # Get the path to the MATLAB script
    eng.workspace['audio_dir'] = audio_dir  # Pass the directory path to MATLAB
    eng.eval(f"run('{script_path}')", nargout=0)  # Execute the MATLAB script
    eng.quit()

if __name__ == '__main__':
    argumentList = sys.argv[1:]                       # Read in File name
    file_name = argumentList[0]
    os.system(f"mkdir {file_name}")                   # Create directory
    
    # Define parallel processes and target the ssh command
    process1 = multiprocessing.Process(target=pi1)
    process2 = multiprocessing.Process(target=pi2)

    # Execute parallel processes to begin recording
    process1.start()
    process2.start()


    sleep(5)                                           #Wait 5 seconds
    
    #Read in calibration signal
    filename = 'chirp_0_15000_5s.wav' 

    data, fs = sf.read(filename, dtype='float32')      # Extract data and sampling rate from file
    sd.play(data, fs)                                  #Play calibration signal
    status = sd.wait()                                 # Wait until file is done playing



    sleep(25)                                         # Wait until recordings finish

    # Collect recordings and NTP status from Raspberry Pis
    transfer_files('192.168.137.47', 'raspberrypi1', 'RecordingPi1.wav', file_name)
    transfer_files('192.168.137.105', 'raspberrypi2', 'RecordingPi2.wav', file_name)

    #transfer_files('192.168.137.39', 'raspberrypi1', 'timestamp1.csv', file_name)
    #transfer_files('192.168.137.190', 'raspberrypi2', 'timestamp2.csv', file_name)
    

    # Call MATLAB processing function
    #audio_dir = 'C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\EEE3097S\\AcoTriangulator\\Milestone3\\Audio'
    #matlab_processing(file_name)

    print("Done")


    exit
exit
