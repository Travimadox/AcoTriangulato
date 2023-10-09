% Define the Environment
a_width = 594;  % Width of the A1 grid in mm
a_height = 841;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343000; % Speed of sound in m/s

% Generate synthetic source signal
Fs = 48000; % Sampling frequency in Hz
t = 0:1/Fs:0.1; % Time vector, for a signal of 0.1s
source_signal = cos(2*pi*1000*t); % A 1kHz tone

% Define a random position for the source within the grid
source_position = [rand()*a_width, rand()*a_height];

% Compute distances to microphones
d1 = norm(M1 - source_position);
d2 = norm(M2 - source_position);
d3 = norm(M3 - source_position);
d4 = norm(M4 - source_position);

% Compute time delays for each microphone
delay1 = d1 / c;
delay2 = d2 / c;
delay3 = d3 / c;
delay4 = d4 / c;

% Compute the maximum delay to set the length of all signals
max_delay = max([delay1, delay2, delay3, delay4]);
sig_length = length(source_signal) + round(max_delay*Fs);

% Generate signals received by each microphone with equal lengths
signal1 = [zeros(1, round(delay1*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay1*Fs))];
signal2 = [zeros(1, round(delay2*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay2*Fs))];
signal3 = [zeros(1, round(delay3*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay3*Fs))];
signal4 = [zeros(1, round(delay4*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay4*Fs))];

% Desired Signal-to-Noise Ratio in dB
snr_dB = 60;

% Add noise to each microphone signal using the awgn function
signal1 = awgn(signal1, snr_dB, 'measured');
signal2 = awgn(signal2, snr_dB, 'measured');
signal3 = awgn(signal3, snr_dB, 'measured');
signal4 = awgn(signal4, snr_dB, 'measured');


% Create matrix sig
sig = [signal1', signal2', signal3', signal4'];



% Compute time delays using gccphat
[tau12, ~, ~] = gccphat(sig(:, 1), sig(:, 2), Fs);
[tau13, ~, ~] = gccphat(sig(:, 1), sig(:, 3), Fs);
[tau14, ~, ~] = gccphat(sig(:, 1), sig(:, 4), Fs);
[tau23, ~, ~] = gccphat(sig(:, 2), sig(:, 3), Fs);
[tau24, ~, ~] = gccphat(sig(:, 2), sig(:, 4), Fs);
[tau34, ~, ~] = gccphat(sig(:, 3), sig(:, 4), Fs);

% Print out the time delays
fprintf('Time delay tau12: %.9f seconds\n', tau12);
fprintf('Time delay tau13: %.9f seconds\n', tau13);
fprintf('Time delay tau14: %.9f seconds\n', tau14);
fprintf('Time delay tau23: %.9f seconds\n', tau23);
fprintf('Time delay tau24: %.9f seconds\n', tau24);
fprintf('Time delay tau34: %.9f seconds\n', tau34);

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

error_distance = norm(estimated_position - source_position);
disp(['Error Distance: ', num2str(error_distance), ' mm']);


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


