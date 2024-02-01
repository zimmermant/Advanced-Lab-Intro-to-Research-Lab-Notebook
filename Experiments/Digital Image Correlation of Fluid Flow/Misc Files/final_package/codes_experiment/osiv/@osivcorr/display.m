function display(obj)
%DISPLAY Display an OSIVCORR object.
%   DISPLAY(OBJ) prints all assigned property values to the 
%   console for the provided OSIVCORR object.

% Copyright (c) 2007-2009 James A. Strother

% Check that is OSIVCORR object
if ~isa(obj, 'osivcorr')
   error('display() requires OSIVCORR as first argument');
end

% Print out header
disp('osivcorr object:');

% Open osivcorr object as struct
obj_guts = struct(obj);

% Print out the properties list
obj_props = orderfields(obj_guts.props);
obj_prop_names = fieldnames(obj_props);
for ii=1:length(obj_prop_names)
   p_name = sprintf('  %-18s', [obj_prop_names{ii} ' : ']);
   p_value = evalc('disp(obj_props.(obj_prop_names{ii}))');

   % Trim trailing newlines
   last_n = length(p_value)+1;
   for jj=length(p_value):-1:1
      if double(p_value(jj)) == 10
         last_n = jj;
      else
         break;
      end
   end

   if last_n == 1
      disp([p_name '[]']);
   else
      disp([p_name p_value(1:last_n-1)]);
   end
end

if isempty(obj_prop_names)
   disp('  No properties defined');
end

% Print a linefeed
fprintf('%c', 10);

