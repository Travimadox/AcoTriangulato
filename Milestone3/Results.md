
# TDOA System Analysis Report

## Table of Contents

- [TDOA System Analysis Report](#tdoa-system-analysis-report)
  - [Table of Contents](#table-of-contents)
  - [1. Introduction](#1-introduction)
  - [2. Data Overview](#2-data-overview)
  - [3. Descriptive Statistics](#3-descriptive-statistics)
  - [4. Accuracy and Precision Analysis](#4-accuracy-and-precision-analysis)
    - [Overall Analysis](#overall-analysis)
    - [Visual Representation](#visual-representation)
      - [Error Histograms](#error-histograms)
      - [Histogram Analysis:](#histogram-analysis)
      - [Grid Plot](#grid-plot)
  - [5. Discussion](#5-discussion)
    - [Performance in Different Scenarios](#performance-in-different-scenarios)
    - [Accuracy and Precision Assessment](#accuracy-and-precision-assessment)
  - [6. Frequency Analysis](#6-frequency-analysis)
    - [Introduction](#introduction)
    - [Summary Statistics by Frequency](#summary-statistics-by-frequency)
      - [Key Observations:](#key-observations)
    - [Visual Representation](#visual-representation-1)
      - [1. Mean Error Across Different Frequencies](#1-mean-error-across-different-frequencies)
      - [2. Error in X and Y Coordinates Across Different Frequencies](#2-error-in-x-and-y-coordinates-across-different-frequencies)
    - [Discussion](#discussion)
  - [7. Conclusion](#7-conclusion)

---

## 1. Introduction

This report provides a thorough analysis of a Time Difference of Arrival (TDOA) system designed for locating acoustic signals within a given grid. The primary objective is to evaluate the system's accuracy and precision in estimating the position of acoustic sources.

---

## 2. Data Overview

The dataset includes various tests for locating an acoustic source within a grid. For each test, the dataset provides:

- Actual position of the source in X and Y coordinates.
- Estimated position of the source in X and Y coordinates.
- Errors in the estimated X and Y coordinates.
- Mean error, calculated as the Euclidean distance between the actual and estimated positions.

**Snapshot of Data:**
(Include Table Here)

---

## 3. Descriptive Statistics

- **Mean Error**: \(0.219\) meters.
- **Standard Deviation of Error in X**: \(0.123\) meters.
- **Standard Deviation of Error in Y**: \(0.058\) meters.

---

## 4. Accuracy and Precision Analysis

### Overall Analysis

1. **Overall Accuracy**: The average "Mean_Error" value is \(0.219\) meters, suggesting moderate accuracy in the system's performance.
  
2. **Overall Precision**: 
    - For the X coordinate, the standard deviation of the error is \(0.123\) meters, indicating some variability.
    - For the Y coordinate, the standard deviation is \(0.058\) meters, suggesting relatively consistent estimations.

---

### Visual Representation

#### Error Histograms

![Histogram](https://imgur.com/kICuFpe.jpg)

#### Histogram Analysis:

1. **Histogram of Errors in X-coordinate**: 
   - Most of the errors in the X-coordinate seem to be around 0.1 to 0.3 meters.
  
2. **Histogram of Errors in Y-coordinate**: 
   - Most of the errors in the Y-coordinate are concentrated around 0.05 to 0.15 meters.
  
3. **Histogram of Total Mean Errors**: 
   - The total mean errors appear to be primarily within the range of 0.1 to 0.35 meters.


#### Grid Plot

![Grid](https://imgur.com/28t2iis.jpg)

The grid plot visualizes the actual and estimated positions. Dashed circles centered at the source positions have a radius equal to the mean error for each test. This representation provides a spatial understanding of the system's accuracy and precision.

---

## 5. Discussion

### Performance in Different Scenarios

The system's performance might be influenced by several factors:

1. **Signal Strength**: Stronger signals usually allow for more accurate position estimations.
2. **Noise Level**: Elevated levels of noise can negatively affect the accuracy of position estimations.
3. **Sensor Configuration**: The geometry and arrangement of sensors can also significantly impact performance.

### Accuracy and Precision Assessment

- **Accuracy**: The mean error of \(0.219\) meters indicates moderate accuracy.
  
- **Precision**: The standard deviations of errors in X and Y coordinates suggest decent precision.

---


---

## 6. Frequency Analysis

### Introduction

This section delves into the impact of different frequencies—classified as Low (500 Hz), Medium (4017 Hz), and High (18k Hz)—on the accuracy and precision of the TDOA system.

### Summary Statistics by Frequency

The table below succinctly captures the mean errors for each frequency category:

| Frequency Category | Mean Error (m) | Mean Error in X (m) | Mean Error in Y (m) |
|--------------------|----------------|---------------------|---------------------|
| High               | 0.0802         | 0.005               | 0.0800              |
| Low                | 0.1333         | 0.015               | 0.1325              |
| Medium             | 0.1076         | 0.005               | 0.1075              |

#### Key Observations:

1. **High Frequency (18k Hz)**: Exhibits the lowest mean error, indicating the highest accuracy among the three categories.
2. **Medium Frequency (4017 Hz)**: Displays moderate accuracy with mean error values falling between the High and Low categories.
3. **Low Frequency (500 Hz)**: Shows the highest mean error, suggesting it's the least accurate for this system.

### Visual Representation

#### 1. Mean Error Across Different Frequencies

![Mean Error Bar Plot](https://imgur.com/hYKVNLk.jpg)

This bar plot reinforces the data from the table, visually emphasizing that the system performs best at high frequencies in terms of accuracy.

#### 2. Error in X and Y Coordinates Across Different Frequencies

(Insert Bar Plot for Error in X and Y Coordinates Here)

This bar plot complements the previous one, focusing on the errors in X and Y coordinates across different frequencies. It further substantiates the frequency-dependent nature of the system's accuracy and precision.

### Discussion

The frequency of the acoustic signal has a profound impact on the performance metrics of the TDOA system:

1. **High Frequency (18k Hz)**: Generally allows for more accurate distance measurements but may be susceptible to environmental factors such as absorption and reflection.
  
2. **Medium Frequency (4017 Hz)**: Offers a balanced performance, but like the other frequencies, it can be influenced by noise and environmental conditions.
  
3. **Low Frequency (500 Hz)**: These signals may be more susceptible to noise, thereby affecting the system's accuracy.

---


---



## 7. Conclusion

The TDOA system demonstrates a reasonable level of accuracy and precision in estimating acoustic source positions within the grid. The visual representations, including histograms and grid plots, enhance our understanding of the system's capabilities and limitations. For a more comprehensive evaluation, additional data points and features would be beneficial.

---

