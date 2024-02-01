%---------------------------vfield_cgs------------------------------------
% This script converts the velocities and coordinates from pixel units 
% into cgs units.
%-------------------------------------------------------------------------

% Load the time-averaged data
load taverage.mat

% The number of pixels along the height of the image
h_pix = 480;

% The number of cm per pixel, used to convert the velocities and
% displacements to cgs units
cm_per_pix = h_cm/h_pix;

% Convert the coordinates to cgs units
x_cm = x*(cm_per_pix);
y_cm = y*(cm_per_pix);

% Time elapsed between frames is 1/fps
deltat = 1/fps;

% Convert the velocities to cgs units
u_cgs = u_tavg*(cm_per_pix)/deltat; 
v_cgs = v_tavg*(cm_per_pix)/deltat;

% Save the vfield_cgs data 
save('vfield_cgs.mat','x_cm','y_cm','u_cgs','v_cgs','cm_per_pix','h_cm',...
    'h_pix','fps','tag','rows','columns','n_points','t_steps',...
    'avg_window','today_date');