%Code for the subsytem for TDOA
% Define the Environment
a_width = 594;  % Width of the A1 grid in mm
a_height = 841;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343; % Speed of sound in m/s
Fs = 48000; % Sampling frequency in Hz
t = 0:1/Fs:10; % Time vector, for a signal of 0.1s

% Signal Type
signal_type = 'tone';

switch signal_type
    case 'tone'
        source_signal = cos(2*pi*1000*t);
    case 'white_noise'
        source_signal = randn(size(t));
    case 'speech'
        % For speech, you need to load a speech file
end

% Initialization
num_iterations = 100;
gccphat_errors = zeros(num_iterations, 6); % For storing time delay estimation errors

for iter = 1:num_iterations
    % Random position for the source within the grid
    source_position = [rand()*a_width, rand()*a_height];
    
    % Compute distances
    d1 = norm(M1 - source_position);
    d2 = norm(M2 - source_position);
    d3 = norm(M3 - source_position);
    d4 = norm(M4 - source_position);

    % Theoretical time delays
    theoretical_delay1 = d1 / c;
    theoretical_delay2 = d2 / c;
    theoretical_delay3 = d3 / c;
    theoretical_delay4 = d4 / c;
    
    % Theoretical delay differences
    theoretical_tau12 = theoretical_delay1 - theoretical_delay2;
    theoretical_tau13 = theoretical_delay1 - theoretical_delay3;
    theoretical_tau14 = theoretical_delay1 - theoretical_delay4;
    theoretical_tau23 = theoretical_delay2 - theoretical_delay3;
    theoretical_tau24 = theoretical_delay2 - theoretical_delay4;
    theoretical_tau34 = theoretical_delay3 - theoretical_delay4;

    % Simulate received signals (You can add noise and other effects if needed)
    signal1 = [zeros(1, round(theoretical_delay1*Fs)), source_signal];
    signal2 = [zeros(1, round(theoretical_delay2*Fs)), source_signal];
    signal3 = [zeros(1, round(theoretical_delay3*Fs)), source_signal];
    signal4 = [zeros(1, round(theoretical_delay4*Fs)), source_signal];

    % Make all signals the same length
    maxLength = max([length(signal1), length(signal2), length(signal3), length(signal4)]);
    signal1 = [signal1, zeros(1, maxLength - length(signal1))];
    signal2 = [signal2, zeros(1, maxLength - length(signal2))];
    signal3 = [signal3, zeros(1, maxLength - length(signal3))];
    signal4 = [signal4, zeros(1, maxLength - length(signal4))];

    sig = [signal1', signal2', signal3', signal4'];

    % Estimate time delays using gccphat
    [tau12, ~] = gccphat(sig(:,1), sig(:,2), Fs);
    [tau13, ~] = gccphat(sig(:,1), sig(:,3), Fs);
    [tau14, ~] = gccphat(sig(:,1), sig(:,4), Fs);
    [tau23, ~] = gccphat(sig(:,2), sig(:,3), Fs);
    [tau24, ~] = gccphat(sig(:,2), sig(:,4), Fs);
    [tau34, ~] = gccphat(sig(:,3), sig(:,4), Fs);

    % Calculate the errors in estimated time delays
    gccphat_errors(iter, 1) = abs(theoretical_tau12 - tau12);
    gccphat_errors(iter, 2) = abs(theoretical_tau13 - tau13);
    gccphat_errors(iter, 3) = abs(theoretical_tau14 - tau14);
    gccphat_errors(iter, 4) = abs(theoretical_tau23 - tau23);
    gccphat_errors(iter, 5) = abs(theoretical_tau24 - tau24);
    gccphat_errors(iter, 6) = abs(theoretical_tau34 - tau34);
end

% Calculate the mean and standard deviation of the time delay estimation errors
mean_gccphat_error = mean(gccphat_errors(:));
std_gccphat_error = std(gccphat_errors(:));

% Display the results
fprintf('Mean Time Delay Estimation Error: %.9f s\n', mean_gccphat_error);
fprintf('Standard Deviation of Time Delay Estimation Error: %.9f s\n', std_gccphat_error);

figure;
histogram(gccphat_errors(:), 50); % Adjust the number of bins as necessary
title('Histogram of Time Delay Estimation Errors');
xlabel('Time Delay Error (s)');
ylabel('Frequency');
grid on;

