function [classConv] = classMap(class, date)

% Maps a class specified in degrees to a class number
% Maps a class specified as a class number to degrees
% 
% Inputs:
%		class - class to convert from class to deg, or deg to class
%		date - date data was collected (because maps differ by date)
%
% Output:
%		classConv - converted class

	% Set Default Class Map
	classMap=floor(360:-22.5:22);
	classMap(1)=0;
	classMap(12)=113;

	% Set Different mapping for files prior to 12-06-01
	splitdate=regexp(date,'-','split');
	year=str2num(splitdate{1});
	month=str2num(splitdate{2});
	if (((year == 12) & (month <=5)) | (year < 12))
		classMap=floor(0:22.5:337.5);
	end


	% Convert class format
	if(~ismember(class,(1:16))) % If user entered degrees ...
		classConv=find(classMap==class);
	else  % Else, if he entered a class number ...
		classConv=classMap(class);
	end

end
