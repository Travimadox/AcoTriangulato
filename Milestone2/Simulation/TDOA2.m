% Define the Environment
L = 0.841; % Length of the grid in meters
W = 0.594; % Width of the grid in meters
Fs = 48000; % Sampling frequency in Hz
c = 343; % Speed of sound in m/s

% Define microphone array
mic_positions = [0, L, L, 0; 0, 0, W, W; 0, 0, 0, 0];
microphone_array = phased.ConformalArray('Element', phased.OmnidirectionalMicrophoneElement, ...
    'ElementPosition', mic_positions);

% Generate synthetic source signal
t = 0:1/Fs:0.1; % Time vector, for a signal of 0.1s
source_signal = cos(2*pi*1000*t); % A 1kHz tone

% Add noise to the source signal
snr_dB = 40;
noisy_signal = awgn(source_signal, snr_dB, 'measured');

% Define a random position for the source within the grid
source_position = [rand()*L, rand()*W, 0];

% Compute distances to microphones
d = sum((mic_positions - source_position').^2).^0.5;

% Compute time delays for each microphone
delays = d / c;

% Compute the maximum delay to set the length of all signals
max_delay = max(delays);
sig_length = length(noisy_signal) + round(max_delay*Fs);

% Generate signals received by each microphone with equal lengths
signals = zeros(sig_length, 4);
for i = 1:4
    signals(:, i) = [zeros(1, round(delays(i)*Fs)), noisy_signal, ...
        zeros(1, sig_length - length(noisy_signal) - round(delays(i)*Fs))];
end



% Continue with Cross-correlation to compute time delays using gccphat
[tau12, ~] = gccphat(signals(:,1), signals(:,2), Fs);
[tau13, ~] = gccphat(signals(:,1), signals(:,3), Fs);
[tau14, ~] = gccphat(signals(:,1), signals(:,4), Fs);
[tau23, ~] = gccphat(signals(:,2), signals(:,3), Fs);
[tau24, ~] = gccphat(signals(:,2), signals(:,4), Fs);
[tau34, ~] = gccphat(signals(:,3), signals(:,4), Fs);

% Convert tau (time delay) into spatial delay (distance)
delta_t12 = tau12 * c;
delta_t13 = tau13 * c;
delta_t14 = tau14 * c;
delta_t23 = tau23 * c;
delta_t24 = tau24 * c;
delta_t34 = tau34 * c;

% Nonlinear Least Squares Estimation
fun = @(p) [
    (sqrt(p(1)^2 + p(2)^2) - sqrt((p(1) - L)^2 + p(2)^2)) - delta_t12;
    (sqrt(p(1)^2 + p(2)^2) - sqrt(p(1)^2 + (p(2) - W)^2)) - delta_t13;
    (sqrt(p(1)^2 + p(2)^2) - sqrt((p(1) - L)^2 + (p(2) - W)^2)) - delta_t14;
    (sqrt((p(1) - L)^2 + p(2)^2) - sqrt(p(1)^2 + (p(2) - W)^2)) - delta_t23;
    (sqrt((p(1) - L)^2 + p(2)^2) - sqrt((p(1) - L)^2 + (p(2) - W)^2)) - delta_t24;
    (sqrt(p(1)^2 + (p(2) - W)^2) - sqrt((p(1) - L)^2 + (p(2) - W)^2)) - delta_t34;
];

options = optimset('Display', 'off');  % Turn off display for lsqnonlin
estimated_position = lsqnonlin(fun, [L/2, W/2], [0, 0], [L, W], options);  % initial guess: center of the grid

% Display the estimated position
disp(['Estimated Position (x,y): ', num2str(estimated_position)]);
disp(['Actual Position (x,y): ', num2str(source_position(1:2))]);

error_distance = norm(estimated_position - source_position(1:2));
disp(['Error Distance: ', num2str(error_distance), ' meters']);

% Plotting
figure;
plot(source_position(1), source_position(2), 'bo', 'MarkerSize', 10, 'DisplayName', 'Source Position');
hold on;
plot(estimated_position(1), estimated_position(2), 'rx', 'MarkerSize', 10, 'DisplayName', 'Estimated Position');
legend('Location', 'best');
title('Source vs. Estimated Position');
xlabel('x (m)');
ylabel('y (m)');
axis([0 L 0 W]);
grid on;
hold off;

