# Enhanced Error Analysis Report on TDOA Data

## Introduction

This comprehensive report aims to offer an in-depth analysis of the errors associated with Time Difference of Arrival (TDOA) measurements. The dataset under consideration includes theoretical TDOA values, measured TDOA values, and source positions (\(Source_X\) and \(Source_Y\)) for various sensor pairs. 

---

## Methodology

The analysis was organized into a four-step process:

1. **Error Computation**: Calculate the absolute difference between the theoretical and measured TDOA values for each sensor pair.
2. **Statistical Analysis**: Examine the mean, standard deviation, and range of the errors.
3. **Visual Insights**: Plot histograms and scatter plots to visualize the distribution and correlation of errors.
4. **Correlation with Source Position**: Investigate whether the errors are dependent on the source's location.

---

## Data Overview

The dataset contains:

- 10 entries representing different instances.
- 14 columns, which include:
  - \(Source_X\): X-coordinate of the source.
  - \(Source_Y\): Y-coordinate of the source.
  - Theoretical TDOA values for sensor pairs: 21, 31, 41, 32, 42, 43.
  - Measured TDOA values for the same sensor pairs.

---

## Step 1: Error Computation

### Formula

The absolute error for each sensor pair was computed using the following formula:

\[
\text{Absolute Error for TDOA pair (i, j)} = \left| \text{Theoretical TDOA}_{ij} - \text{Measured TDOA}_{ij} \right|
\]

---

## Step 2: Statistical Analysis

### Mean Error

The average error for each sensor pair is as follows:

- \(Error_{TDOA_{21}}\): 0.00063
- \(Error_{TDOA_{31}}\): 0.00075
- \(Error_{TDOA_{41}}\): 0.00087
- \(Error_{TDOA_{32}}\): 0.00079
- \(Error_{TDOA_{42}}\): 0.00079
- \(Error_{TDOA_{43}}\): 0.00040

### Standard Deviation

The measure of the dispersion of the error values:

- \(Error_{TDOA_{21}}\): 0.00067
- \(Error_{TDOA_{31}}\): 0.00056
- \(Error_{TDOA_{41}}\): 0.00079
- \(Error_{TDOA_{32}}\): 0.00069
- \(Error_{TDOA_{42}}\): 0.00059
- \(Error_{TDOA_{43}}\): 0.00029

### Range of Error

- Minimum error varies from 0.00004 to 0.00008.
- Maximum error varies from 0.00087 to 0.0021.

---

## Step 3: Visual Insights

### Histograms

The histograms illustrate how the errors are distributed for each sensor pair.

![Histo](https://imgur.com/HbA01lz.jpg)

### Observations:

- The errors appear to be centered around a mean value.
- The spread of errors is relatively narrow, indicating a lower standard deviation.

---

## Step 4: Correlation with Source Position

### Scatter Plots

Scatter plots were generated to investigate if the errors correlate with the source positions (\(Source_X\) and \(Source_Y\)).

![Sactter](https://imgur.com/l77qdn4.jpg)

### Observations:

- There is no strong, consistent correlation between the source positions and the magnitude of the error.

---

## Conclusions 

### Conclusions

- The errors are generally low but can vary depending on the sensor pair involved.
- There's no noticeable pattern or correlation between the errors and the source positions.

