% Define the Environment
a_width = 594;  % Width of the A1 grid in mm
a_height = 841;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343; % Speed of sound in m/s

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

% Vector of noise levels to test
noise_levels = 0:0.01:0.5; % You can adjust this range as needed

error_distances = zeros(size(noise_levels));

% Array to store SNR values
snr_values = zeros(size(noise_levels));

for i = 1:length(noise_levels)
    noise_level = noise_levels(i);

    % Generate noise for the current noise level
    noise = noise_level*randn(size(signal1));

    % Add noise to the signals for the current noise level
    signal1_noisy = signal1 + noise_level*randn(size(signal1));
    signal2_noisy = signal2 + noise_level*randn(size(signal2));
    signal3_noisy = signal3 + noise_level*randn(size(signal3));
    signal4_noisy = signal4 + noise_level*randn(size(signal4));

    % Compute the SNR for the current noise level in dB
    signal_power = mean(signal1.^2);
    noise_power = mean(noise.^2);
    snr_values(i) = 10 * log10(signal_power / noise_power);

    sig = [signal1_noisy', signal2_noisy', signal3_noisy', signal4_noisy'];



    % Compute time delays using gccphat
[tau12, ~, ~] = gccphat(sig(:, 1), sig(:, 2), Fs);
[tau13, ~, ~] = gccphat(sig(:, 1), sig(:, 3), Fs);
[tau14, ~, ~] = gccphat(sig(:, 1), sig(:, 4), Fs);
[tau23, ~, ~] = gccphat(sig(:, 2), sig(:, 3), Fs);
[tau24, ~, ~] = gccphat(sig(:, 2), sig(:, 4), Fs);
[tau34, ~, ~] = gccphat(sig(:, 3), sig(:, 4), Fs);

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






    estimated_position = lsqnonlin(fun, [a_width/2, a_height/2], [0, 0], [a_width, a_height], options);

    error_distances(i) = norm(estimated_position - source_position);



end


% Plot the results
figure;
subplot(2,1,1);
plot(noise_levels, error_distances, '-o');
title('Impact of Noise on TDOA-based Localization');
xlabel('Noise Level');
ylabel('Position Estimation Error (mm)');
grid on;

subplot(2,1,2);
plot(noise_levels, snr_values, '-x');
title('Signal-to-Noise Ratio (SNR) vs Noise Level');
xlabel('Noise Level');
ylabel('SNR (dB)');
grid on;


