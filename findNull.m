function [null_dir] = findNull(filename, pref_dir, classOrDeg)
% Finds the null direction, farthest available class location from prefered direction
% Null is returned in either class number or degrees depending on the units (class or deg)
% of the prefered direction.
% NOTE: Assumes that preferered direction is specified to be one of the 16 classes, 
% either by class number or corresponding degrees.  Will not work correctly if a 
% degree value that does not correspond to one of the 15 classes is specified.
%
% Inputs:
%		filename - the file for which to find null direction
%		pref_dir - the specified preferred direction, in class number or degrees
%		classOrDeg - specify classes 'Class' or degrees 'Deg' as inputs
%
% Output: 
%		null_dir - null direction in either class number or degrees
%
		% If user entered degrees, convert to class number (for grab)
		if(strcmp(classOrDeg,'Deg'))
			splitfile=regexp(filename,'/','split');
			date=splitfile{5};
			pref_dir=classMap(pref_dir,date);
		end

		% Get the list of available classes in this file
		[status,result]=system(['grab -R2 ' filename]);
		splitresult=regexp(result,'\n','split');
		classline=regexp(splitresult{2},'\s+','split');
		classes=str2num(char(classline{3:end}));
		
		% Find the farthest class from pref_dir and set null_dir to it
		null_dir=pref_dir-8;
		if(null_dir < 1)
			null_dir=null_dir+16;
		end
		[mindiff,oppidx]=min(abs(int32(classes)-null_dir));
		null_dir=classes(oppidx);

		% If user entered degrees, convert null to degrees
		if(strcmp(classOrDeg,'Deg'))
			null_dir=classMap(null_dir,date);
		end

		

end
