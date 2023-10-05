%% Define the Environment
a_width = 800;  % Width of the A1 grid in mm
a_height = 500;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343; % Speed of sound in m/s
Fs = 48000; % Sampling frequency in Hz



%% Define the paths to the audio files
audio_file1 = fullfile(audio_dir, 'RecordingPi1.wav');
audio_file2 = fullfile(audio_dir, 'RecordingPi2.wav');

% Read in the audio files
[audio1, Fs] = audioread(audio_file1);
[audio2, Fs] = audioread(audio_file2);





% Extract the channels
signal1 = audio1(:, 1);  % Left channel of first Pi,M1
signal3 = audio1(:, 2);  % Right channel of first Pi,M3
signal2 = audio2(:, 1);  % Left channel of second Pi,M2
signal4 = audio2(:, 2);  % Right channel of second Pi,M4

%% Noise Reduction and Signal Preprocessing
% Define the frequency band of interest
lowFreq = 1450;  % Lower bound of frequency band in Hz
highFreq = 1550; % Upper bound of frequency band in Hz

% Design a band-pass filter
[b, a] = butter(2, [lowFreq highFreq]/(Fs/2));

% Apply the band-pass filter to each signal
signal1 = filter(b, a, signal1);
signal2 = filter(b, a, signal2);
signal3 = filter(b, a, signal3);
signal4 = filter(b, a, signal4);

% Get the maximum length among all signals
maxLength = max([length(signal1), length(signal2), length(signal3), length(signal4)]);

% Zero-pad all signals to the maximum length
signal1 = [signal1; zeros(maxLength - length(signal1), 1)];
signal2 = [signal2; zeros(maxLength - length(signal2), 1)];
signal3 = [signal3; zeros(maxLength - length(signal3), 1)];
signal4 = [signal4; zeros(maxLength - length(signal4), 1)];

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

options = optimset('Display', 'off');

% Simple centroid-based initial guess
avgX = mean([M1(1), M2(1), M3(1), M4(1)]);
avgY = mean([M1(2), M2(2), M3(2), M4(2)]);

try
    % Run the nonlinear least squares estimation
    estimated_position = lsqnonlin(fun, [avgX, avgY], [0, 0], [a_width, a_height], options);
catch ME
    % Display the error message if lsqnonlin fails
    disp('Error in optimization:');
    disp(ME.message);
    return;
end

% Validate the estimated position
if estimated_position(1) < 0 || estimated_position(1) > a_width || ...
   estimated_position(2) < 0 || estimated_position(2) > a_height
    disp('Estimated position is outside the defined grid.');
    return;
end

% Error Calculation
%error_distance = sqrt((estimated_position(1) - source_position(1))^2 + (estimated_position(2) - source_position(2))^2);

% After calculating the estimated_position

% Full path to the CSV file
filePath = 'C:\Users\User\OneDrive - University of Cape Town\Desktop\EEE3097S\AcoTriangulator\Milestone3\estimated_position.csv';

writematrix(estimated_position,filePath);

