function [targetAngles, targetRadii, targetX, targetY, targetAnglesNewLoc, targetRadiiNewLoc, targetNewLocX, targetNewLocY] = getTargets(filename,stack_opts)
% Get target angles, radii, and x/y coordinates for each trial
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
	grabtargs=['grab ' stack_opts ' -aD -o8 -i400:500 ' filename]
	[status,result]=system(grabtargs);
	system(['mv -f Targets_* Targets_' splitfile{6}(2:end)]);
	file_targets=['Targets_' splitfile{6}(2:end)];
	target=importdata(file_targets,' ',1);
	system(['rm -f Targets_*']);
	fixationX=target.data(:,6)/10;
	fixationY=target.data(:,7)/10;
	targetX=((target.data(:,12)/10)-fixationX);
	targetY=((target.data(:,13)/10)-fixationY);
	targetNewLocX=((target.data(:,18)/10)-fixationX);
	targetNewLocY=((target.data(:,19)/10)-fixationY);

	for i = 1:length(targetX)
		targetRadii(i)=sqrt((targetX(i)^2)+(targetY(i)^2));
		targetAngles(i)=atan2(targetY(i),targetX(i))*(180/pi);

		targetRadiiNewLoc(i)=sqrt((targetNewLocX(i)^2)+(targetNewLocY(i)^2));
		targetAnglesNewLoc(i)=atan2(targetNewLocY(i),targetNewLocX(i))*(180/pi);
	end


end
