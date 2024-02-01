%---------------------------vortex_cgs------------------------------------
% This script calculates the vorticity of the velocity field in cgs units.
% It also reshapes the x and y coordinate vectors into 2D arrays.
%-------------------------------------------------------------------------

% Load the velocity field data
load vfield_cgs.mat

% Allocate space for all the vorticity and velocity matrices
omega_cgs = zeros(rows,columns,t_steps,'single');
U_cgs = zeros(rows,columns);
V_cgs = zeros(rows,columns);

% Reshape the x and y coordinate vectors into 2D arrays 
X_cm = reshape(x_cm,rows,columns)';
Y_cm = reshape(y_cm,rows,columns)';

% Reshape the vectors containing v_x and v_y into 2D arrays and
% calculate vorticity
for n = 1:t_steps 
    U_cgs(:,:) = reshape(u_cgs(:,n),rows,columns)';
    V_cgs(:,:) = reshape(v_cgs(:,n),rows,columns)';
    [omega_cgs(:,:,n) temp] = curl(X_cm,Y_cm,U_cgs,V_cgs);
end

% Save the vorticity data
save('vortex_cgs.mat','X_cm','Y_cm','omega_cgs','fps','tag','t_steps',...
    'rows','columns','avg_window','h_cm','h_pix','today_date','U_cgs',...
    'V_cgs');