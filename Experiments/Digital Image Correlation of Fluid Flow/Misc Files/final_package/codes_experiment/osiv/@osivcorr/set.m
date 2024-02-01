function obj = set(obj, varargin)
%SET Set properties of OSIVCORR object.
%   OBJ = SET(OBJ, 'PropertyName', VALUE) sets the property
%   'PropertyName' of the OSIVCORR object to the value VALUE.
%
%   OBJ = SET(OBJ, 'PropertyName', VALUE, 'PropertyName',VALUE,...)
%   sets multiple property values of the OSIVCORR object.
%
%       NOTE: This function is intended to be used by other
%       OSIVCORR functions and NOT users.  Users should generally
%       access properties through structure notation.  For example,
%
%       obj.xcorr_alg = 1;

% Copyright (c) 2007-2009 James A. Strother

% Check that is OSIVCORR object
if ~isa(obj, 'osivcorr')
   error('set() requires OSIVCORR as first argument');
end

% Extract struct array from osivcorr
obj_guts = struct(obj);

% Check that all names have values
if mod(length(varargin), 2) ~= 0
   error('argument %d is missing value', nargin);
end

% Make assignments to properties list
for ii=1:2:length(varargin)
   p_name = varargin{ii};
   p_value = varargin{ii+1};

   % Check that property name is string
   if ~isa(p_name,'char') || ndims(p_name) ~= 2 || size(p_name,1) ~= 1
      error('expected property name for argument %d', i);
   end

   % Find the property type
   [e_type,e_dims] = osiv_intr('corr_prop_type', p_name);
   if strcmp(e_type, 'unknown')
      error('unknown property `%s''', p_name);
   end

   % Check callbacks separately since they are not arrays
   if strcmp(e_type, 'callback')
      if isa(p_value, 'char')
         if ndims(p_value) ~= 2 || size(p_value,1) ~= 1
            error('property `%s'' assigned invalid callback', p_name);
         end
      elseif isa(p_value, 'cell')
         if length(p_value) < 1
            error('property `%s'' assigned invalid callback', p_name);
         end
         if isa(p_value{1}, 'char')
            if ndims(p_value{1}) ~= 2 || size(p_value{1},1) ~= 1
               error('property `%s'' assigned invalid callback', p_name);
            end
         elseif ~isa(p_value{1}, 'function_handle') 
            error('property `%s'' assigned invalid callback', p_name);
         end
      elseif ~isa(p_value, 'function_handle')
         error('property `%s'' assigned invalid callback', p_name);
      end

      % Everything looks good, do assignment
      % NOTE: we need to add subscript b/c
      % MATLAB has ridiculous behavior with
      % empty structure arrays.
      obj_guts.props(1).(p_name) = p_value;
      continue;
   end


   % Check dimensions of property value
   if length(e_dims) == 1
      if ndims(p_value) ~= 2
         error('property %s expects %d-dimensional value',...
            p_name, 1);
      end

      % Put input into a standard column vector form
      if size(p_value,2) == 1 && size(p_value,1) ~= 1
         p_value = p_value';
      elseif size(p_value,1) ~= 1
         error('property %s expects %d-dimensional value',...
            p_name, 1);
      end

      if e_dims(1) ~= -1 && e_dims(1) ~= size(p_value,2)
         error('property %s expects %d-element vector',...
            p_name, e_dims(1));
      end
   else
      if ndims(p_value) ~= length(e_dims)
         error('property %s expects %d-dimensional value',...
            p_name, length(e_dims));
      end

      for jj=1:length(e_dims)
         if e_dims(jj) ~= -1 && e_dims(jj) ~= size(p_value,jj)
            error('property %s expects size(value,%d) == %d',...
               p_name, jj, e_dims(jj));
         end
      end
   end

   % Check type of property value
   if strcmp(e_type, 'char')
      if ~isa(p_value,'char')
         error('property %s expects character value',...
            p_name);
      end
   elseif strcmp(e_type, 'double')
      if ~isa(p_value,'double')
         error('property %s expects numeric value',...
            p_name);
      end
   elseif strcmp(e_type, 'integer')
      if ~isa(p_value,'double') || ...
         ~isempty(find(p_value - round(p_value),1))

         error('property %s expects integer value',...
            p_name);
      end
   elseif strcmp(e_type, 'boolean')
      if ~(isa(p_value,'double') || isa(p_value,'logical')) || ...
         ~isempty(find(p_value ~= 0 & p_value ~= 1,1))

         error('property %s expects boolean value',...
            p_name);
      end
   else
      assert(0, 'unknown type %s', e_type);
   end

   % Everything looks good, do assignment
   % NOTE: we need to add subscript b/c
   % MATLAB has ridiculous behavior with
   % empty structure arrays.
   obj_guts.props(1).(p_name) = p_value;
end

% Push constructed object to output
obj = class(obj_guts, 'osivcorr');


