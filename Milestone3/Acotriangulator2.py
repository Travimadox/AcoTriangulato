import multiprocessing
from time import sleep
import os
import sys

# Define SSH record command for each Raspberry Pi
def pi1():
    os.system("ssh raspberrypi1@192.168.137.39 sudo nice -n -20 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -d 10 -t wav -V stereo -v RecordingPi1.wav")
    os.system("ssh raspberrypi1@192.168.137.39 echo $(date +%s%N) > ntp_status_pi1.csv")

    

    
def pi2():
    os.system("ssh raspberrypi2@192.168.137.190 sudo nice -n -20 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -d 10 -t wav -V stereo -v RecordingPi2.wav")
    os.system("ssh raspberrypi2@192.168.137.190 echo $(date +%s%N) > ntp_status_pi2.csv")

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

    sleep(15)                                         # Wait until recordings finish

    # Collect recordings and NTP status from Raspberry Pis
    os.system(f"scp raspberrypi1@192.168.137.39:RecordingPi1.wav {file_name}/")
    os.system(f"scp raspberrypi2@192.168.137.190:RecordingPi2.wav {file_name}/")
    os.system(f"scp raspberrypi1@192.168.137.39:ntp_status_pi1.csv {file_name}/")
    os.system(f"scp raspberrypi2@192.168.137.190:ntp_status_pi2.csv {file_name}/")
   
