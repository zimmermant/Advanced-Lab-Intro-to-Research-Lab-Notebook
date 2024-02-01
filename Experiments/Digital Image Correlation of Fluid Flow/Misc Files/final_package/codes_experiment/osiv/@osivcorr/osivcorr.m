function obj = osivcorr(varargin)
%OSIVCORR Create a new OSIV Cross-Correlation job.
%   OBJ = OSIVCORR() creates an OSIVCORR object with all property
%   values left unassigned.
%
%   OBJ = OSIVCORR('PropertyName', VALUE, 'PropertyName', VALUE,...)
%   creates an OSIVCORR object with the specified property values.
%
%   After the object is created properties can be modified using
%   structure notation prior to execution.  For example,
%
%       q = osivcorr();
%       q.xcorr_alg = 2;
%       q.wind_size = 16;
%       d = execute(q, 'im0.tif', 'im1.tif');
%
%
%   OSIVCORR Methods
%
%     DISPLAY - Display the current parameter settings.
%     EXECUTE - Execute job using supplied parametsrs.
%
%
%   OSIVCORR Properties
%
%     xcorr_alg - The  algorithm used to perform the correlation
%     is selected by specifying one of the following integers:
%         1 - Direct Least Squares
%         2 - Fast Direct Least Squares
%         3 - Direct Correlation
%         4 - Fast Direct Correlation
%         5 - Fourier Correlation
%         6 - Fourier Least Squares
%         7 - Iterative Fourier Correlation
%         8 - Direct Normalized Correlation
%         9 - Fast Direct Normalized Correlation
%        10 - Fourier Normalized Correlation
%
%     pproc_alg - The algorithm used to perform pre-processing of the
%     images is selected by specifying one of the following integers:
%         0 - None
%         1 - Subtract to minima
%         2 - Add to maxima
%         3 - Stretch to limits
%         4 - Stretch to variance
%         5 - Stretch to average
%
%     interp_alg - The algorithm used to perfom peak interpolation
%     is selected by specifying one of the following integers:
%         0 - None
%         1 - Gaussian
%         2 - Parabolic
%         3 - Paraboloidal
%         4 - Centroid
%
%     image_xsize - The width of the images must be the same for  every
%     frame.  As OSIVCORR can almost always determine image sizes from
%     the input image files, this option is very rarely required.  Upper
%     bounds on the image size are specified during the compilation.
%
%     image_ysize - The height of the image must be the same for every
%     frame.  As OSIVCORR can almost always determine image sizes from
%     the input image files, this option is very rarely required.  Upper
%     bounds on the image size are specified during the compilation.
%
%     grid_xstart - The horizontal position of the first correlation
%     window on the image frame. A value of zero abuts the left edge
%     of the first window against the left edge of the frame. You should
%     note that certain algorithms must be able to access the pixels
%     surrounding the window, so the first window may need to be offset.
%     Please see the manual for more information.
%
%     grid_ystart - The vertical position of the first correlation
%     window on  the  image frame. A value of zero abuts the top edge
%     of the first window against the top edge of the frame. You 
%     should note that certain algorithms must be able to access the
%     pixels surrounding the window, so the first window may need to
%     be offset. Please see the manual for more information.
%
%     grid_xspace - The horizontal spacing between correlation windows
%     on the image frame. A value of one places overlapping windows
%     on every pixel.
%
%     grid_yspace - The vertical spacing between correlation windows on 
%     the image frame.  A value of one places overlapping windows on
%     every pixel.
%
%     grid_xsize - The number of windows placed in each row of the grid
%     of correlations windows used for each frame. The grid size must
%     not extend the grid beyond the image bounds, see the manual for
%     more information.
%
%     grid_ysize -  The number of windows placed in each column of the
%     grid of correlations windows used for each frame. The grid size
%     must not extend the grid beyond the image bounds, see the manual
%     for more information.
%
%     disp_xoffset -  A horizontal displacment around which all
%     correlations are calculated.  Adding a fixed displacement 
%     improves the accuracy of the correlation in flow fields that
%     are primarily uniform.  The displacement is added back to the
%     vector before values are output, so no post-processing is
%     required.
%
%     disp_yoffset -  A vertical displacment around which all
%     correlations are calculated. Adding a fixed displacement
%     improves the accuracy of the correlation in flow fields that
%     are primarily uniform.  The displacement is added back to
%     the vector before values are output, so no post-processing
%     is required.
%
%     disp_xmax - The maximum horizontal displacement to be examined.
%     For direct methods, the  correlation is only evaluated up to
%     this limit. For FFT-based methods, the search is limited to this
%     maximum.
%
%     disp_ymax - The maximum vertical displacement to be examined.
%     For direct methods, the correlation is only evaluated up to
%     this limit. For FFT-based methods, the search is limited to this
%     maximum.
%
%     disp_xiter - The maximum horizontal displacement to which the
%     Iterative Fourier Correlation algorithm may displace a window.
%     It is ignored by all other algorithms.  Note that the correlation
%     window will then be limited to a maxmimum displacement of
%     disp_xmax + disp_xiter.
%
%     disp_yiter -  The maximum vertical displacement to which the
%     Iterative Fourier Correlation algorithm may displace a window.
%     It is ignored by all other algorithms.  Note that the correlation
%     window will then be limited to a maxmimum displacement of
%     disp_ymax + disp_yiter.
%
%     snr_xexcl - The number of pixels in the x direction around the
%     signal peak to be excluded when searching for the noise peak.  
%
%     snr_yexcl - The number of pixels in the y direction around the
%     signal peak to be excluded when searching for the noise peak.  
%
%     snr_excl - The number of pixels around the signal peak to be
%     excluded when searching for the noise peak. This is identical
%     to setting both snr_xexcl and snr_yexcl with the same value. 
%
%     wind_xsize - Horizontal size of the window used to perform the
%     correlation.  Larger windows are generally less prone to error,
%     while smaller windows yield finer spatial resolution. For FFT-
%     based methods, powers of two allow efficient algorithms.
%
%     wind_ysize - Vertical size of the window used to perform the
%     correlation.  Larger windows are generally less prone to error,
%     while smaller windows yield finer spatial resolution. For FFT-
%     based methods, powers of two allow efficient algorithms.
%
%     wind_size - Set the horizontal and vertical sizes of the window
%     to the same value, simultaneously. This is identical to setting
%     both wind_xsize and wind_ysize to the same value.
%
%     wind_xsuper - Horizontal size of the larger underlying correlation
%     window used in the Fourier Correlation and Fourier Least Squares
%     algorithms. This parameter is ignored by all other algorithms.
%     See the manual for more information.
%
%     wind_ysuper -  Vertical size of the larger underlying correlation
%     window used in the Fourier Correlation and Fourier Least Squares
%     algorithms. This parameter is ignored by all other algorithms.
%     See the manual for more information.
%
%     wind_super -  Set the horizontal and vertical size of the super
%     window to the same value, simultaneously. This is identical to
%     setting both wind_xsuper and wind_ysuper to the same value.
%
%     movie_start -  The first frame of the movie on which cross
%     correlation is performed. This number is used to calculate the
%     filename to use with some movie types, the tiff directory to read
%     with tiff movies, and byte offsets for raw movies. See the manual
%     for more information.
%
%     movie_finish -  The last frame of the movie on which cross
%     correlation is performed. This number is used to calculate the
%     filename to use with some movie types, the tiff directory to
%     read with tiff movies, and byte offsets for raw movies.
%     See the manual for more information.
%
%     movie_skip - The number of frames to skip between sets of frames
%     that are cross correlated.  See the manual for more information
%     and some helpful examples.
%
%     movie_set -  The number of frames that separate a pair of images
%     to be cross correlated. See the manual for more information and
%     some helpful examples.
%
%     num_iter -  The number of iterations to perform when using the
%     iterative cross correlation algorithm. All other algorithms ignore
%     this parameter.
%
%     fft_wisdom - The FFT-based algorithms make use of the self-
%     tuning FFTW library. This parameter is the name of a wisdom file
%     generated by the program osiv_tune.
%
%     write_map - This option is currently ignored.  It the future it
%     will cause correlation maps to be written to the output data.
%     This substantially increases the size of the output structure,
%     and so this output should normally be omitted.
%     
%     callback - This is a callback that can be called to perform
%     immediate processing of calculated vectors or to interrupt the
%     current job prematurely.  It has the standard form for callbacks
%     as implemented in MATLAB: it can be the name of a routine, a
%     function handle, or a cell array whose first element is a function
%     name or function handle followed additional elements that contain
%     additional arguments passed to the callback routine.  Please see
%     MATLAB documentation for additional information on using callbacks.
%     The callback is invoked after each frame is processed.  The first
%     argument passed to the routine is a structure with the fields
%     frm, x, y, u, v (identical to the structure returned by the 
%     execute() routine).  If additional arguments were specified by
%     using a cell array as the callback object, those arguments are
%     passed following this argument.  The returned value should be zero
%     if processing is to be continued or -1 if processing is to stop
%     immediately.  If a negative value other than -1 is returned than
%     that error code is displayed when the interrupt error message is
%     generated.  If a positive number is returned, then the sign is
%     flipped before handling according to the above rules.

% Copyright (c) 2007-2009 James A. Strother


% Handle no arguments case
if nargin == 0
   % Create empty struct
   obj.props = struct([]);
    
   obj = class(obj, 'osivcorr');

% Handles properties list case
else  
   % This is really just a shorthand for the following
   obj = osivcorr();
   obj = set(obj, varargin{:});
end

