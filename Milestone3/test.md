$G(s) = \frac{A}{\tau s+1}$

$\tau = \frac{1}{b}$


$G(s) = \frac{A}{\frac{1}{b} s+1}$

## Scenario 1: 0.9b(-10%)
$G(s) = \frac{A}{\frac{1}{0.9\frac{1}{\tau}} s+1}$



## Scenario 1: 0.9b(-10%)
$G(s) = \frac{A}{\frac{1}{1.1\frac{1}{\tau}} s+1}$


## Analysis(Steady state tracking)

$G(s) = \frac{KA}{s^2 + 0.9bs + KHA}$

Final value theorem:
The limit of the transfer as s -> 0
$lim_{s->0} \frac{KA}{s^2 + 0.9bs + KHA} \times s \times \frac{1}{s}$


$lim_{s->0} \frac{KA}{s^2 + 0.9bs + KHA}$

substitute s = 0

$\frac{1}{H}$


%OS = ALOT MATH



Simulink is easier


## Summing Amplifier
$V_{out} = -\frac{R3}{R1} (V1 + V2) =  -\frac{R3}{R1} (-SETPOINT + DAC) = \frac{R3}{R1} (SETPOINT - DAC) =  K_P(SETPOINT -DAC)$

$K_P$ IS CONTROLLER GAIN

THE POT CONNECTED TO NON INVERTING TERMINAL IS USED TO ADD 2.5 OFFSET TO $V_{OUT}$



The code you provided is employing a method of solving a nonlinear system of equations to estimate the position of a sound source on a grid. The grid is defined by the positions of four microphones, and the code computes the time delay of arrival (TDOA) of a signal at each microphone pair using the Generalized Cross-Correlation Phase Transform (GCC-PHAT) algorithm. These TDOAs are then converted into spatial distance differences, which are used in a nonlinear least squares estimation to find the estimated position of the sound source. Below are the mathematical formulations extracted from the provided code:

1. **Time Delay Calculation (using GCC-PHAT):**
   \[ \tau_{ij} = \text{gccphat}(\text{signal}_i, \text{signal}_j, Fs) \]
   where \( i \) and \( j \) are indices of the microphone pairs, and \( Fs \) is the sampling frequency.

2. **Conversion of Time Delay to Spatial Distance Difference:**
   \[ \delta t_{ij} = \tau_{ij} \cdot c \]
   where \( c \) is the speed of sound.

3. **Nonlinear System of Equations:**
   \[
   \begin{aligned}
   f_1(p) & = \sqrt{p(1)^2 + p(2)^2} - \sqrt{(p(1) - a_{\text{width}})^2 + p(2)^2} - \delta t_{12}, \\
   f_2(p) & = \sqrt{p(1)^2 + p(2)^2} - \sqrt{p(1)^2 + (p(2) - a_{\text{height}})^2} - \delta t_{13}, \\
   f_3(p) & = \sqrt{p(1)^2 + p(2)^2} - \sqrt{(p(1) - a_{\text{width}})^2 + (p(2) - a_{\text{height}})^2} - \delta t_{14}, \\
   f_4(p) & = \sqrt{(p(1) - a_{\text{width}})^2 + p(2)^2} - \sqrt{p(1)^2 + (p(2) - a_{\text{height}})^2} - \delta t_{23}, \\
   f_5(p) & = \sqrt{(p(1) - a_{\text{width}})^2 + p(2)^2} - \sqrt{(p(1) - a_{\text{width}})^2 + (p(2) - a_{\text{height}})^2} - \delta t_{24}, \\
   f_6(p) & = \sqrt{p(1)^2 + (p(2) - a_{\text{height}})^2} - \sqrt{(p(1) - a_{\text{width}})^2 + (p(2) - a_{\text{height}})^2} - \delta t_{34},
   \end{aligned}
   \]

   where \( p \) is a vector of the unknown coordinates \( (x, y) \) of the sound source, \( a_{\text{width}} \) and \( a_{\text{height}} \) are the dimensions of the grid, and \( \delta t_{ij} \) are the spatial distance differences computed from the TDOAs.

4. **Nonlinear Least Squares Estimation:**
   \[ \text{estimated\_position} = \text{lsqnonlin}(fun, [a_{\text{width}}/2, a_{\text{height}}/2], [0, 0], [a_{\text{width}}, a_{\text{height}}], \text{options}) \]
   where \( fun \) is a function handle to the system of equations, the second argument is the initial guess for the position, and the third and fourth arguments are the lower and upper bounds for the position, respectively.

5. **Error Calculation:**
   \[ \text{error\_distance} = \sqrt{(\text{estimated\_position}(1) - \text{source\_position}(1))^2 + (\text{estimated\_position}(2) - \text{source\_position}(2))^2} \]
   which computes the Euclidean distance between the estimated position and the actual source position.

These equations encapsulate the mathematical computations and optimization process carried out in the provided MATLAB code to estimate the position of the sound source based on the TDOA data.