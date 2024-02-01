function b = subsref(a,s)
%SUBSREF Overloaded subscript reference

% Copyright (c) 2007-2009 James A. Strother

% Check that is OSIVCORR object
if ~isa(a, 'osivcorr')
   error('subsref() requires OSIVCORR as first argument');
end

% Check the length of subscripts
if length(s) < 1 || length(s) > 1
   error('invalid subscript into OSIVCORR object');
end

switch s.type
case '()'
   error('array access into OSIVCORR object undefined');
case '{}'
   error('cell array access into OSIVCORR object undefined');
case '.'
   b = get(a,s.subs);
end
