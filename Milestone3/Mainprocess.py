# Pyhton code to TDOA triangualtion

import numpy as np
import matplotlib.pyplot as plt
import math
import time
import scipy.io.wavfile as wav
from scipy import signal
import os
import sys
import matlab.engine

# Define constants
c = 343  # Speed of sound in m/s
fs = 48000  # Sampling frequency in Hz

# Define microphone positions
mic1 = np.array([0, 0])
mic2 = np.array([0, 0.5])
mic3 = np.array([0.8, 0.5])
mic4 = np.array([0.8, 0])

# Define function to calculate TDOA
def TDOA(mic1, mic2, mic3, mic4, fs, x):
    # Calculate distance between microphones and source
    d1 = math.sqrt((mic1[0] - x[0]) ** 2 + (mic1[1] - x[1]) ** 2)
    d2 = math.sqrt((mic2[0] - x[0]) ** 2 + (mic2[1] - x[1]) ** 2)
    d3 = math.sqrt((mic3[0] - x[0]) ** 2 + (mic3[1] - x[1]) ** 2)
    d4 = math.sqrt((mic4[0] - x[0]) ** 2 + (mic4[1] - x[1]) ** 2)

    # Calculate TDOA
    tdoa1 = d1 / c
    tdoa2 = d2 / c
    tdoa3 = d3 / c
    tdoa4 = d4 / c

    # Calculate sample delay
    delay1 = round(tdoa1 * fs)
    delay2 = round(tdoa2 * fs)
    delay3 = round(tdoa3 * fs)
    delay4 = round(tdoa4 * fs)

    return delay1, delay2, delay3, delay4
