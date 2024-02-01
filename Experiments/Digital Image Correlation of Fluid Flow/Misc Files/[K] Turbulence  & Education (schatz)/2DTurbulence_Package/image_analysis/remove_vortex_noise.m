%-------------------remove_vortex_noise-----------------------------------
% This function removes the stray vorticity values to make the overall
% vorticity contour look more uniform in a video of the flow.
%-------------------------------------------------------------------------

% Load the cgs vorticity data
load vortex_cgs.mat;

% Set the parameters for reducing the noise
N = 100;
threshold = 1/500;

% Get the number of time steps
bins = size(omega_cgs,3);

% Recast the vorticity from a 2D array into a vector
temp = reshape(omega_cgs,rows*columns*bins,1);

% Calculate some statistics on the vorticity
largest = max(temp);
smallest = min(temp);
range = largest - smallest;
delta_vor = range/N;
vorticity = smallest+delta_vor/2:delta_vor:largest-delta_vor/2.0;
dist = hist(temp,vorticity);
dist = dist./sum(dist);

% Set the limits on the vorticity
indices = find(dist<threshold);
upper_cutoff = vorticity(indices(min(find(vorticity(indices)>0))));
lower_cutoff = vorticity(indices(max(find(vorticity(indices)<0))));

% Cut out data that is noise (i.e. above the threshold vorticity)
indices = find(temp>upper_cutoff);
temp(indices) = upper_cutoff + delta_vor/2;
indices = find(temp<lower_cutoff);
temp(indices) = lower_cutoff - delta_vor/2;

% Reshape the data and replace the original variable
omega_cgs = reshape(temp,rows,columns,bins);

% Clear unneeded variables
clear temp indices dist vorticity

% Resave the vorticity data file with the new, de-noised vorticity 
save('vortex_cgs.mat','X_cm','Y_cm','omega_cgs','fps','tag','t_steps',...
    'rows','columns','avg_window','h_cm','h_pix','today_date','U_cgs',...
    'V_cgs');