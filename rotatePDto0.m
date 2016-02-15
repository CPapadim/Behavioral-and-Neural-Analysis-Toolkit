function [rotatedLocations] = rotatePDto0(locations, pref_dir, classOrDeg)
% Rotate locations (classes or degrees) so that the preferred direction is at 0
%
% Inputs:
%		locations - classes or degrees of locations to rotate
%		pref_dir - preferred direction around which to rotate
%		classOrDeg - whether inputs are classes ('Class') or degrees ('Deg')
%
% Outputs:
%		rotatedLocations - classes or degrees after they've been rotated
	

	if(strcmp(classOrDeg,'Class')) % If user entered class numbers...
		locations=locations-pref_dir;
		locations(locations<=-8)=locations(locations<=-8)+16;
		locations(locations>8)=locations(locations>8)-16;

	elseif(strcmp(classOrDeg,'Deg')) % If user entered degrees...
		locations=locations-pref_dir;
		locations(locations<=-180)=locations(locations<=-180)+360;
		locations(locations>180)=locations(locations>180)-360;
	end
	
	rotatedLocations=locations;

end
