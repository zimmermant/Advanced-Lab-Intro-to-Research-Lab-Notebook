%-----------------------compile_data.m------------------------------------
%
% This Matlab script compiles all the important data into a single file.
% 
%-------------------------------------------------------------------------

load vfield_cgs
load vortex_cgs

u=u_cgs(:,1:avg_window:end);
v=v_cgs(:,1:avg_window:end);
omega=omega_cgs(:,:,1:avg_window:end);
deltat=avg_window/fps;

save([tag '.mat'],'X_cm','Y_cm','x_cm','y_cm','omega','u','v','deltat')