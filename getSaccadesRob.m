function [saccadeAngles, saccadeRadii, saccadeX, saccadeY] = getSaccadesRob(filename,stack_opts)
% Get saccade angles, radii, and x/y coordinates for each trial - Rob's data
%
% Inputs:
%		filename - file name from which to extract saccades
%		stack_opts - stack options
%
% Outputs:
%		saccadeAngles - saccade angle
%		saccadeRadii - saccade radii
%		saccadeX - saccade x-coordinate
%		saccadeY - saccade y-coordinate

	splitfile=regexp(filename,'/','split');

	% Get Fixation location

        system(['rm -f Targets_*']);
	grabtargs=['grab ' stack_opts ' -aB1 -o8 -i-50:50 ' filename];
        [status,result]=system(grabtargs);
        system(['mv -f Targets_* Targets_' splitfile{7}(2:end)]);
        file_targets=['Targets_' splitfile{7}(2:end)];
        target=importdata(file_targets,' ',1);
        system(['rm -f ' file_targets]);
        fixationX=target.data(:,4)/10;
        fixationY=target.data(:,5)/10;

	% Get Saccade location
	system(['rm -f BehavIndi*']);
	grabsaccades=['grab ' stack_opts ' -aB1 -o9 -i-50:50 ' filename];
	[status,result]=system(grabsaccades);
	system(['mv -f BehavIndi* BehavIndi' splitfile{7}(2:end)]);
	file_saccades=['BehavIndi' splitfile{7}(2:end)];
        saccade=importdata(file_saccades,' ',1);
	system(['rm -f ' file_saccades]);
        saccadeX=(saccade.data(:,2)-fixationX);
       	saccadeY=(saccade.data(:,3)-fixationY);

	for i = 1:length(saccadeX)
		saccadeRadii(i)=sqrt((saccadeX(i)^2)+(saccadeY(i)^2));
		saccadeAngles(i)=atan2(saccadeY(i),saccadeX(i))*(180/pi);
	end


end
