%% Define the Environment
a_width = 800;  % Width of the A1 grid in mm
a_height = 500;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343000; % Speed of sound in mm/s
Fs = 48000; % Sampling frequency in Hz

% Define the source position 
source_position = [650, 150];

% Read in the audio files 
[audio1, Fs] = audioread('RecordingPi1.wav');
[audio2, Fs] = audioread('RecordingPi2.wav');

% Extract the channels
signal2 = audio1(:, 1);  % Left channel of first Pi,M2
signal4 = audio1(:, 2);  % Right channel of first Pi,M4
signal1 = audio2(:, 1);  % Left channel of second Pi,M1
signal3 = audio2(:, 2);  % Right channel of second Pi,M3

% Noise Reduction and Signal Preprocessing
% Define the frequency band of interest
lowFreq = 1400;  % Lower bound of frequency band in Hz
highFreq = 1600; % Upper bound of frequency band in Hz

% Design a band-pass filter
[b, a] = butter(2, [lowFreq highFreq]/(Fs/2));

% Apply the band-pass filter to each signal
signal1 = filter(b, a, signal1);
signal2 = filter(b, a, signal2);
signal3 = filter(b, a, signal3);
signal4 = filter(b, a, signal4);




% Compute time delays using GCC-PHAT
[tau12, ~] = gccphat(signal1, signal2, Fs);
[tau13, ~] = gccphat(signal1, signal3, Fs);
[tau14, ~] = gccphat(signal1, signal4, Fs);
[tau23, ~] = gccphat(signal2, signal3, Fs);
[tau24, ~] = gccphat(signal2, signal4, Fs);
[tau34, ~] = gccphat(signal3, signal4, Fs);

% Convert tau (time delay) into spatial delay (distance)
delta_t12 = tau12 * c;
delta_t13 = tau13 * c;
delta_t14 = tau14 * c;
delta_t23 = tau23 * c;
delta_t24 = tau24 * c;
delta_t34 = tau34 * c;


% Nonlinear Least Squares Estimation
fun = @(p) [
    (sqrt(p(1)^2 + p(2)^2) - sqrt((p(1) - a_width)^2 + p(2)^2)) - delta_t12;
    (sqrt(p(1)^2 + p(2)^2) - sqrt(p(1)^2 + (p(2) - a_height)^2)) - delta_t13;
    (sqrt(p(1)^2 + p(2)^2) - sqrt((p(1) - a_width)^2 + (p(2) - a_height)^2)) - delta_t14;
    (sqrt((p(1) - a_width)^2 + p(2)^2) - sqrt(p(1)^2 + (p(2) - a_height)^2)) - delta_t23;
    (sqrt((p(1) - a_width)^2 + p(2)^2) - sqrt((p(1) - a_width)^2 + (p(2) - a_height)^2)) - delta_t24;
    (sqrt(p(1)^2 + (p(2) - a_height)^2) - sqrt((p(1) - a_width)^2 + (p(2) - a_height)^2)) - delta_t34;
];

options = optimset('Display', 'off');  % Turn off display for lsqnonlin
estimated_position = lsqnonlin(fun, [a_width/2, a_height/2], [0, 0], [a_width, a_height], options);  % initial guess: center of the A1 grid

% Display the estimated position
disp(['Estimated Position (x,y): ', num2str(estimated_position)]);
disp(['Actual Position (x,y): ', num2str(source_position)]);
disp(['Error (mm): ', num2str(sqrt(sum((estimated_position - source_position).^2)))]);

% Plot the estimated position
figure;
plot(source_position(1), source_position(2), 'bo', 'MarkerSize', 10, 'DisplayName', 'Source Position');
hold on;
plot(estimated_position(1), estimated_position(2), 'rx', 'MarkerSize', 10, 'DisplayName', 'Estimated Position');
legend('Location', 'best');
title('Source vs. Estimated Position');
xlabel('x (mm)');
ylabel('y (mm)');
axis([0 a_width 0 a_height]);
grid on;
hold off;