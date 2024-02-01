%----------------------------taverage-------------------------------------
% This script time-averages the velocities from 'correlation.mat' to
% reduce experimental noise.  It also extracts the x and y coordinates
% and the number of rows and columns from the 'correlation' structure.
%-------------------------------------------------------------------------

% Load the correlation input
load correlation.mat

% Total number of time steps
t_steps = size(correlation,2);

% Recast x and y into single precision
x = single(correlation(1,1).frames.x);
y = single(correlation(1,1).frames.y);

% Number of sampled points
n_points = length(x);

% Calculate the number of rows and columns
for i = 1:n_points
    if y(i+1) - y(i) ~=0
        columns = i;
        rows = n_points/columns;
        break;
    end
end

% Allocate memory for the velocity fields. Note that u corresponds to the
% x-component of velocity and v corresponds to the y-component of velocity
u_tavg = zeros(rows*columns,t_steps-avg_window+1,'single'); 
v_tavg = zeros(rows*columns,t_steps-avg_window+1,'single');

% Time average the vector field over 'roll_ave_window'
% [1,8] -> 1, [2,9] -> 2 and so on.
for i = 1:(t_steps-avg_window+1)
    for j = 0:(avg_window-1)
        u_tavg(:,i) = u_tavg(:,i) + correlation(1,i+j).frames.u;
        v_tavg(:,i) = v_tavg(:,i) + correlation(1,i+j).frames.v;
    end
    u_tavg(:,i) = u_tavg(:,i)/avg_window;
    v_tavg(:,i) = v_tavg(:,i)/avg_window;
    
end
clear correlation

% Reset the number of time steps since averaging has removed at least 1
t_steps = t_steps-avg_window+1;
bins = fix(t_steps/avg_window);

% Save taverage data
save('taverage.mat', 'u_tavg','v_tavg','x','y','rows','columns',...
    'avg_window','n_points','fps','tag','t_steps','bins','h_cm',...
    'today_date');