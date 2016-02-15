function [targetAngles, targetRadii, targetX, targetY] = getTargetsRob(filename,stack_opts)
% Get target angles, radii, and x/y coordinates for each trial - Rob's Data
%
% Inputs:
%		filename - file name from which to extract targets
%		stack_opts - stack options
%
% Outputs:
%		targetAngles - target angle
%		targetRadii - target radii
%		targetX - target x-coordinate
%		targetY - target y-coordinate

	splitfile=regexp(filename,'/','split');

	system(['rm -f Targets_*']);
	grabtargs=['grab ' stack_opts ' -aB1 -o8 -i-50:50 ' filename]
	[status,result]=system(grabtargs)
	system(['mv -f Targets_* Targets_' splitfile{7}(2:end)]);
	file_targets=['Targets_' splitfile{7}(2:end)]
	target=importdata(file_targets,' ',1);
	system(['rm -f Targets_*']);
	fixationX=target.data(:,4)/10;
	fixationY=target.data(:,5)/10;
	targetX=((target.data(:,8)/10)-fixationX);
	targetY=((target.data(:,9)/10)-fixationY);

	for i = 1:length(targetX)
		targetRadii(i)=sqrt((targetX(i)^2)+(targetY(i)^2));
		targetAngles(i)=atan2(targetY(i),targetX(i))*(180/pi);
	end


end
