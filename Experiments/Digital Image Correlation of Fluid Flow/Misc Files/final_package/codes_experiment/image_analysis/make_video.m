function make_video(jump,video_fps)
%----------------------make_video(jump,video_fps)-------------------------
% This function makes an avi video of the data. The inputs are:
%   jump - number of time steps to jump over for each successive frame
%          plotted in the video; choosing a value that corresponds to
%          about 1-10 seconds is usually good, depending on the flow
%   video_fps - the speed at which to encode the video, in frames per
%	   second
%
% We recommend the following:
%       make_video(16,15);
%-------------------------------------------------------------------------

%Load cgs velocity and vorticity data
load vfield_cgs.mat
load vortex_cgs.mat

% Save variables for the range of data to look at (all of it)
start_t = 1;
end_t = size(u_cgs,2);

% Generate a name for the video based on the 'tag' for the current data
name=['video_' tag,'.avi'];

% Set number of vorticity contour levels
steps = 10;

% Set the factor to scale 'quiver' velocity vectors by
scale = 1;

% Open a video file with this file name
aviobj=avifile(name,'fps',video_fps);
hf=figure('visible','off');

% Calculate the max and min vorticity values, and use these to set the
% vorticity contour levels
maxlev = max(max(max(omega_cgs,[],1)));
minlev = min(min(min(omega_cgs,[],1)));
stepsize = (maxlev-minlev)/steps;
levels = minlev:stepsize:maxlev;

% Calculate the dimensions to set for x and y limits on the window
x_max=max(x_cm);
x_min=min(x_cm);
y_max=max(y_cm);
y_min=min(y_cm);
limits = [x_min,x_max,y_min,y_max];

% Loop over each time step
for i = start_t:jump:end_t
    
    % Clear current figure window then 'hold on'
    clf;
    hold on;

    % Draw the vorticity contour
    contourf(X_cm,Y_cm,omega_cgs(:,:,i),levels,'LineStyle','None');

    % Fix the levels for the colorbar and turn it on
    colorbar;
    set(gca,'clim',[minlev maxlev]);
    
    % Draw the velocity vectors
    quiver(x_cm,y_cm,u_cgs(:,i),v_cgs(:,i),scale,'k');
    
    % Set the axis limits
    axis(limits)

    % Label the axes
    xlabel('X (cm)','FontWeight','bold','FontSize',16,'FontName',...
        'Bitstream Charter');
    ylabel('Y (cm)','FontWeight','bold','FontSize',16,'FontName',...
        'Bitstream Charter');
    
    % Label the colorbar
    cbl = colorbar('peer',gca);
    set(get(cbl,'ylabel'),'String','Vorticity \it(s^{-1})','FontWeight',...
        'bold','FontSize',16,'FontName','Bitstream Charter');
    
    % Put a title and timer at the top
    title(['Time: ',num2str(fix((i-1)/(fps*60))),' min ',...
        num2str(mod(int32((i-1)/fps),60)),' sec'],'FontWeight','bold',...
        'FontSize',16,'FontName','Bitstream Charter')
    
    % Set the aspect ratio to 1:1
    set(gca,'DataAspectRatio',[1 1 1])

    % Add this frame to the video
    aviobj=addframe(aviobj,hf);
end

%Close the video file
aviobj=close(aviobj);
close(hf);