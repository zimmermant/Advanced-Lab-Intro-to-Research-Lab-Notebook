function r_obj = execute(obj, varargin)
%EXECUTE Execute the prepared OSIVCORR object.
%   OBJ = EXECUTE(OBJ, MOVIE_ONE) executes the provided OSIVCORR 
%   object taking both the first and second image of the 
%   cross-correlation pair from the same movie.  MOVIE_ONE
%   should be a string specifying the filename of the movie,
%   or the filename pattern if the movie is stored in an
%   image stack.
%
%   OBJ = EXECUTE(OBJ, MOVIE_ONE, MOVIE_TWO) executes the provided
%   OSIVCORR object taking first image of cross-correlation from
%   MOVIE_ONE and taking the second image from MOVIE_TWO.  Both
%   MOVIE_ONE and MOVIE_TWO should be strings specifying the
%   filenames of the movies, or the filename patterns if the
%   movie is stored in an image stack.   More information on
%   how to define filename patterns can be found in the user
%   manual.
%
%   The result of executing an OSIVCORR object is a structure
%   that contains two fields.  The first field, the 'args' field,
%   is a structure that stores the parameter values that were
%   used to execute the job.  Every parameter has a field in the
%   'args' structure, including parameters that were given default
%   values rather than explicitly defined in the OSIVCORR object.
%   The second field, the 'frames' field, is a structure array
%   that contains one element for every pair of frames that were
%   analyzed.  The 'frames' structure array contains the following 
%   information: the frame number (in the 'frm' field), the X
%   position for each vector (in the 'x' field), the Y position
%   for each vector (in the 'y' field), the X velocity for each
%   vector (in the 'u' field), the Y velocity for each vector (in
%   the 'v' field), and the signal-to-noise ratio (in the 'r'
%   field).  To summarize, the output data has the following
%   organization:
%
%      args [1x1 struct]
%         xcorr_alg [1x1 double]
%         pproc_alg [1x1 double]
%         ...
%      frames [NUMFRAMESx1 struct]
%         frm [1x1 double]
%         x [NUMVECTORSx1 double]
%         y [NUMVECTORSx1 double]
%         u [NUMVECTORSx1 double]
%         v [NUMVECTORSx1 double]
%         r [NUMVECTORSx1 double]
%

% Copyright (c) 2007-2009 James A. Strother

% Check that is OSIVCORR object
if ~isa(obj, 'osivcorr')
   error('execute() requires OSIVCORR as first argument');
end

% Extract osivcorr contents
obj_guts = struct(obj);

% Respond to each of the cases
if nargin == 1
   error('at least one argument expected');
elseif nargin == 2
   movie_one = varargin{1};
   
   if ~isa(movie_one,'char') || ndims(movie_one) ~= 2 || ...
         size(movie_one,1) ~= 1
      error('expected filename for second argument');
   end
   
   obj_guts.movie_one = movie_one;
elseif nargin == 3
   movie_one = varargin{1};
   movie_two = varargin{2};
   
   if ~isa(movie_one,'char') || ndims(movie_one) ~= 2 || ...
         size(movie_one,1) ~= 1
      error('expected filename for second argument');
   end

   if ~isa(movie_two,'char') || ndims(movie_two) ~= 2 || ...
         size(movie_two,1) ~= 1
      error('expected filename for third argument');
   end
   
   obj_guts.movie_one = movie_one;
   obj_guts.movie_two = movie_two;
else
   error('invalid number of arguments');
end

% Invoke OSIV to do some real work
r_obj = osiv_intr('corr_execute', obj_guts);

