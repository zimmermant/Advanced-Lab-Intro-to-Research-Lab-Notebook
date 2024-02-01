%--------------------pivCorrelate_fi--------------------------------------
% Written By: Jon Paprocki 1/22/2009
%-------------------------------------------------------------------------
% This function opens up the data files in the current directory and saves
% the correlation data into a structure array named correlation.mat.
% 
% This function will take 15+ minutes to run if a large time-series is
% input.
%-------------------------------------------------------------------------

function correlation = pivCorrelate_fi(startFile, stopFile)
corr = osivcorr(); % Initializes PIV correlation object
corr.xcorr_alg = 2; % Sets the correlation algorithm
corr.wind_size = 16;
corr.grid_xspace = 20;
corr.grid_yspace = 15;
corr.grid_xsize = 30;
corr.grid_ysize = 30;

l = length(startFile);      % Determine number of zeros to pad
s = sprintf('%%0%d.0f',l);  % Specify number format for OSIV input string
initial_file = str2num(startFile);  % Read starting index from input
final_file = str2num(stopFile);     % Read final index from input

% Loop over every pair of images and do the correlation
for k = initial_file:(final_file - 1)
    % Use 'try' and 'catch' in case there is a frame skip
    try 
        frame1 = ['Frame_', num2str(k,s), '.tif'];
        g = ls(frame1);
        if isempty(g) == 1
            disp(['WARNING: ',frame1,' does not exist'])
        end
        frame2 = ['Frame_', num2str(k + 1,s), '.tif'];
        % Run the image correlation algorithm on two sequential images
        alg = execute(corr, frame1, frame2);
        % Put each correlation structure into a structure array
        correlation(k-initial_file+1) = alg;
    % If there is a frame skip, use the most recent correlation values
    catch
        g = [];
        correlation(k-initial_file+1) = correlation(k-initial_file);
    end
end

% Save the correlation data
save('correlation.mat', 'correlation');

end