%--------------------------recurrence-------------------------------------
% This script generates a recurrence plot of the time series of the
% velocity field.
%-------------------------------------------------------------------------

% Load the cgs velocity data
load vfield_cgs.mat

% Get the number of time-averaged frames
frames = size(u_cgs,2);

% Get the number of data points in each time step
grid = size(u_cgs,1);

% Get the number of distinct non-overlapping instants
mat_size = fix(frames/avg_window);

% Allocate memory for variables used for making recurrence
recast_u =  zeros(grid,mat_size,'single');
recast_v =  zeros(grid,mat_size,'single');
rec=zeros(mat_size,mat_size,'single');

% Set the 'recast_u' and 'recast_v' variables as non-overlapping time-
% steps of the velocity data
for i = 1:mat_size
    recast_u(:,i)= u_cgs(:,((i-1)*avg_window)+1);
    recast_v(:,i)= v_cgs(:,((i-1)*avg_window)+1);
end

% Calculate the norm of the differences in vector fields
for i = 1:mat_size-1
    for j = 1:(mat_size-i)
        rec(i,j)= sqrt(((norm(recast_u(:,i)- recast_u(:,i+j)))^2+(norm(...
            recast_v(:,i)- recast_v(:,i+j)))^2));
    end
end

% Save the recurrence data
save('recurrence.mat','rec','mat_size','recast_u','recast_v','tag',...
    'fps','n_points');

% Turn the figure off
hf = figure('visible', 'off'); 

% Set the x and y coordinates for the recurrence plot, by converting the
% time steps to real time
x=[1:1/fps:fix(t_steps/fps)];
y=x;

% Draw the recurrence plot
imagesc(x,y,rec');

% Turn the colorbar on and label it
colorbar;
cbl = colorbar('peer',gca);
set(get(cbl,'ylabel'),'String','Energy Norm','FontWeight',...
    'bold','FontSize',16,'FontName','Bitstream Charter');

% Label the axes
xlabel('Time, t (s)','FontWeight','bold','FontSize',19,'FontName',...
    'Bitstream Charter');
ylabel('{\tau} (s)','FontWeight','bold','FontSize',19,'FontName',...
    'Bitstream Charter');
set(gca,'YDir','normal');
set(gca,'Layer','top','FontSize',16,'FontName','Bitstream Charter',...
    'DataAspectRatio',[1 1 1]);

% Save the figure
saveas(gcf,['recurrence_' tag],'tif'); 