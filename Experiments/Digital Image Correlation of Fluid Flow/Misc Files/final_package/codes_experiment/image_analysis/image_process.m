function image_process(first,last,h_cm,fps)
%------------------image_process(first,last,h_cm)-------------------------
% This function takes the first and last image numbers and calculates
% velocities using consecutive frames.  The time series of velocities
% is saved in 'correlation.mat'.
% The function then calls several other scripts to process and analyze
% the data.  The input 'h_cm' is used to scale the data from pixel units
% to cgs units.
%
% Example: Suppose you want to process all the data for images named
%          'Frame_0002.tif' through 'Frame_2250.tif'.  Also, suppose you
%          measured that the real height that an image corresponds to
%          is 4.8cm.  Then, you would type:
%               image_process('0002','2250',4.8);
%-------------------------------------------------------------------------


% Set the window to average data over
avg_window = round(fps);

% Create a tag to name files and add the date to data sets
address = pwd;
tag = [];
for i = length(address):-1:1
    if(address(i)=='\')
        break;
    else
        tag = [address(i) tag];
    end
end
today_date = date;

% Display the current folder name and the 'first' & 'last' file being
% processed
fprintf(['\n working in folder ' tag '\n'])
first
last

% Call pivCorrelate_fi to make the correlation of the data from 'first' to
% 'last'.  Save any warnings or output in report.txt
diary report.txt
diary on
pivCorrelate_fi(first,last)
diary off

% Convert 'first' to a number
first_frame = str2num(first);

% Append other parameters to the correlation.mat file
save('correlation.mat','fps','avg_window','tag','h_cm','today_date',...
    'first_frame','-append')

end

