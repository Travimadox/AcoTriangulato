
% Define the Environment
a_width = 594;  % Width of the A1 grid in mm
a_height = 841;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343; % Speed of sound in m/s
Fs = 48000; % Sampling frequency in Hz
t = 0:1/Fs:5; % Time vector, for a signal of 0.1s

% 1. Multiple Signal Types
signal_type = 'tone'; % Options: 'tone', 'white_noise', 'speech'

switch signal_type
    case 'tone'
        source_signal = cos(2*pi*1000*t);
    case 'white_noise'
        source_signal = randn(size(t));
    case 'speech'
        % Load a speech signal from a file or use predefined ones in MATLAB
        [speech, Fs_speech] = audioread('path_to_speech.wav');
        source_signal = resample(speech, Fs, Fs_speech);
end

% 6. Calibration
mic_response_variation = 0.05; % +/- 5% variation
mic_responses = 1 + mic_response_variation * (2*rand(4,1) - 1);

% 3. Iterative Testing
num_iterations = 100;
errors = zeros(num_iterations, 1);
estimated_positions = zeros(num_iterations, 2);
source_positions = zeros(num_iterations, 2);

for iter = 1:num_iterations
    % Define a random position for the source within the grid
    source_position = [rand()*a_width, rand()*a_height];
    source_positions(iter,:) = source_position;

    % Compute distances and delays
    d1 = norm(M1 - source_position);
    d2 = norm(M2 - source_position);
    d3 = norm(M3 - source_position);
    d4 = norm(M4 - source_position);
    delay1 = d1 / c;
    delay2 = d2 / c;
    delay3 = d3 / c;
    delay4 = d4 / c;
    max_delay = max([delay1, delay2, delay3, delay4]);
    sig_length = length(source_signal) + round(max_delay*Fs);

    % Generate signals with equal lengths
    signal1 = [zeros(1, round(delay1*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay1*Fs))];
    signal2 = [zeros(1, round(delay2*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay2*Fs))];
    signal3 = [zeros(1, round(delay3*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay3*Fs))];
    signal4 = [zeros(1, round(delay4*Fs)), source_signal, zeros(1, sig_length - length(source_signal) - round(delay4*Fs))];

    % Add noise to the signals
    SNR = 30; % Signal-to-Noise Ratio in dB

    signal1 = awgn(signal1, SNR);
    signal2 = awgn(signal2, SNR);
    signal3 = awgn(signal3, SNR);
    signal4 = awgn(signal4, SNR);
    
    % 7. Room Impulse Response applied to signals (placeholder for future impementation)
    % Note: You should define or load a room impulse response (RIR) for this to work
    % signal1 = conv(signal1, RIR, 'same');
    % signal2 = conv(signal2, RIR, 'same');
    % signal3 = conv(signal3, RIR, 'same');
    % signal4 = conv(signal4, RIR, 'same');

    % 6. Calibration
    signal1 = signal1 / mic_responses(1);
    signal2 = signal2 / mic_responses(2);
    signal3 = signal3 / mic_responses(3);
    signal4 = signal4 / mic_responses(4);

    sig = [signal1', signal2', signal3', signal4'];

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

    options = optimset('Display', 'off');
    estimated_position = lsqnonlin(fun, [a_width/2, a_height/2], [0, 0], [a_width, a_height], options);

    errors(iter) = norm(estimated_position - source_position);
    estimated_positions(iter,:) = estimated_position;
end

% 14. Error Analysis
mean_error = mean(errors);
std_error = std(errors);
error_x = estimated_positions(:,1) - source_positions(:,1);
error_y = estimated_positions(:,2) - source_positions(:,2);
mean_bias_x = mean(error_x);
mean_bias_y = mean(error_y);

figure;
subplot(1,2,1);
histogram(errors, 20);
title('Histogram of Errors SNR- Value',num2str(SNR));
xlabel('Error Distance (mm)');
ylabel('Number of Occurrences');

% 13. Visual Enhancements
subplot(1,2,2);
plot(source_positions(:,1), source_positions(:,2), 'bo', 'MarkerSize', 10, 'DisplayName', 'Source Position');
hold on;
plot(estimated_positions(:,1), estimated_positions(:,2), 'rx', 'MarkerSize', 5, 'DisplayName', 'Estimated Positions');
legend('Location', 'best');
title('Source vs. Estimated Positions SNR- Value',num2str(SNR));
xlabel('x (mm)');
ylabel('y (mm)');
axis([0 a_width 0 a_height]);
grid on;
hold off;


% 15. Accuracy and Precision Calculation
mean_accuracy = mean_error; % Mean accuracy in mm
precision = std_error;  % Precision in mm

% Displaying the results
fprintf('Mean Accuracy: %.9f mm\n', mean_accuracy);
fprintf('Precision: %.9f mm\n', precision);


subplot(1,2,1); % Go back to the first subplot
text(max(errors)*0.5, 1, sprintf('Mean Accuracy: %.9f mm', mean_accuracy), 'FontSize', 12);
text(max(errors)*0.5, 2, sprintf('Precision: %.9f mm', precision), 'FontSize', 12);
