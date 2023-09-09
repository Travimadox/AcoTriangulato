% Define the Environment
a_width = 594;  % Width of the A1 grid in mm
a_height = 841;  % Height of the A1 grid in mm
M1 = [0, 0];
M2 = [a_width, 0];
M3 = [0, a_height];
M4 = [a_width, a_height];
c = 343; % Speed of sound in m/s

% Initialization
num_iterations = 100;
estimated_positions = zeros(num_iterations, 2);  % To store estimated positions
actual_positions = zeros(num_iterations, 2);  % To store actual positions

% Optimization settings
options = optimset('Display', 'off');

for iter = 1:num_iterations
    % Random position for the source within the grid
    source_position = [rand()*a_width, rand()*a_height];
    actual_positions(iter, :) = source_position;
    
    % Compute theoretical distances
    d1 = norm(M1 - source_position);
    d2 = norm(M2 - source_position);
    d3 = norm(M3 - source_position);
    d4 = norm(M4 - source_position);
    
    % Theoretical time delays
    theoretical_delay1 = d1 / c;
    theoretical_delay2 = d2 / c;
    theoretical_delay3 = d3 / c;
    theoretical_delay4 = d4 / c;
    
    % Assuming you have estimated delays tau1, tau2, tau3, tau4
    % Here we're using theoretical delays for demonstration
    tau1 = theoretical_delay1;
    tau2 = theoretical_delay2;
    tau3 = theoretical_delay3;
    tau4 = theoretical_delay4;
    
    % Non-linear least squares estimation to find source position
    initial_guess = [a_width / 2, a_height / 2];
    estimated_position = lsqnonlin(@(x) distance_error(x, M1, M2, M3, M4, tau1, tau2, tau3, tau4, c), initial_guess, [], [], options);
    
    estimated_positions(iter, :) = estimated_position;
end

% Assessing the accuracy of the triangulation
errors = sqrt(sum((estimated_positions - actual_positions).^2, 2));

% Calculate the mean and standard deviation of the errors
mean_error = mean(errors);
std_dev_error = std(errors);

% Display the results
fprintf('Mean Position Estimation Error: %.9f mm\n', mean_error);
fprintf('Standard Deviation of Position Estimation Error: %.9f mm\n', std_dev_error);

figure;
subplot(1,2,1);
histogram(errors(:), 50); % Adjust the number of bins as necessary
title('Histogram of Position Estimation Errors');
xlabel('Position Error (mm)');
ylabel('Frequency');
grid on;

subplot(1,2,2);
plot(actual_positions(:,1), actual_positions(:,2), 'bo', 'MarkerSize', 10, 'DisplayName', 'Source Position');
hold on;
plot(estimated_positions(:,1), estimated_positions(:,2), 'rx', 'MarkerSize', 5, 'DisplayName', 'Estimated Positions');
legend('Location', 'best');
title('Actual vs. Estimated Positions');
xlabel('x (mm)');
ylabel('y (mm)');
axis([0 a_width 0 a_height]);
grid on;
hold off;

% Function to calculate distance error for lsqnonlin
function error = distance_error(x, M1, M2, M3, M4, tau1, tau2, tau3, tau4, c)
    est_d1 = norm(M1 - x);
    est_d2 = norm(M2 - x);
    est_d3 = norm(M3 - x);
    est_d4 = norm(M4 - x);
    
    error = [
        c*tau1 - est_d1;
        c*tau2 - est_d2;
        c*tau3 - est_d3;
        c*tau4 - est_d4;
    ];
end

