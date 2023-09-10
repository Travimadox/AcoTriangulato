% Define the Environment
a_width = 594;  % Width of the A1 grid in mm
a_height = 841;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343; % Speed of sound in m/s
Fs = 48000; % Sampling frequency in Hz
t = 0:1/Fs:1.0; % Time vector, for a signal of 1.0s

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

% Simulate received signals
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

% Pairs of signals for GCC-PHAT
pairs = [1, 2; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4];

% Initialize figure
figure;
% Initialize array to store GCC-PHAT peak times
gcc_peak_times = zeros(size(pairs, 1), 1);

% Loop through each pair
for i = 1:size(pairs, 1)
    % Perform GCC-PHAT
    [tau, R, lags] = gccphat(sig(:, pairs(i, 1)), sig(:, pairs(i, 2)), Fs);


    % Get the time of the peak in seconds
    [max_val, max_idx] = max(real(R));
    peak_time = lags(max_idx) / Fs;
    gcc_peak_times(i) = peak_time;  % Store for later

    
    
    % Plot the cross-correlation
    subplot(3, 2, i);
    plot(1000 * lags / Fs, real(R))
    xlabel('Lag Times (ms)')
    ylabel('Cross-correlation')
    axis tight
    title(sprintf('GCC-PHAT between M%d and M%d', pairs(i, 1), pairs(i, 2)))
end

% Display the peak times
for i = 1:length(gcc_peak_times)
    fprintf('GCC-PHAT peak time for pair M%d-M%d: %.6f s\n', pairs(i, 1), pairs(i, 2), gcc_peak_times(i));
end
