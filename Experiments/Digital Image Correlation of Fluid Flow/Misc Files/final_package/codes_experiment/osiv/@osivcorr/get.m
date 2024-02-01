function value = get(obj, varargin)
%GET Get properties of OSIVCORR object.
%   VALUE = GET(OBJ, 'PropertyName') retrieves the value of 
%   specified property for the given OSIVCORR object.
%
%       NOTE: This function is intended to be used by other
%       OSIVCORR functions and NOT users.  Users should generally
%       access properties through structure notation.  For example,
%
%       value = obj.xcorr_alg;

% Copyright (c) 2007-2009 James A. Strother

% Check that is OSIVCORR object
if ~isa(obj, 'osivcorr')
   error('get() requires OSIVCORR as first argument');
end

% Check format of arguments
if length(varargin) == 0
   display(obj);
   return;
elseif length(varargin) ~= 1
   error('extra arguments passed to get() function');
end

% Extract struct array from osivcorr 
obj_guts = struct(obj);

if ~isfield(obj_guts.props, p_name)
   % Not assigned, verify that it exists
   % NOTE: this isn't necessary but could help
   % the user to identify problems more quickly

   % Check that property name is string   
   if ~isa(p_name,'char') || ndims(p_name) ~= 2 || size(p_name,1) ~= 1
      error('expected property name for second argument');
   end

   % Find the property type
   [e_type,e_dims] = osiv_intr('corr_prop_type', p_name);
   if strcmp(e_type, 'unknown')
      error('unknown property %s', p_name);
   end
   
   value = [];
else
   value = obj_guts.props.(p_name);
end

