function [saccadeAngles, saccadeRadii, saccadeX, saccadeY, targetAngles, targetRadii, targetX, targetY] = getSaccadeVectorsRob(filename,stack_opts)
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



	% Get Saccade location
	system(['rm -f BehavIndi*']);
	grabsaccades=['grab ' stack_opts ' -aB1 -o9 -i-800:-600 ' filename];
	%grabsaccades=['grab ' stack_opts ' -aB1 -o9 -i-1500:-1400 ' filename];
	[status,result]=system(grabsaccades);
	system(['mv -f BehavIndi* BehavIndi' splitfile{7}(2:end)]);
	file_saccades=['BehavIndi' splitfile{7}(2:end)];
        saccade=importdata(file_saccades,' ',1);
	system(['rm -f ' file_saccades]);
        %saccinitialX=(saccade.data(:,2)-fixationX);
       	%saccinitialY=(saccade.data(:,3)-fixationY);
        saccinitialX=(saccade.data(:,2));
       	saccinitialY=(saccade.data(:,3));
	
	system(['rm -f BehavIndi*']);
	grabsaccades=['grab ' stack_opts ' -aB1 -o9 -i-50:50 ' filename];
	[status,result]=system(grabsaccades);
	system(['mv -f BehavIndi* BehavIndi' splitfile{7}(2:end)]);
	file_saccades=['BehavIndi' splitfile{7}(2:end)];
        saccade=importdata(file_saccades,' ',1);
	system(['rm -f ' file_saccades]);
        %saccadeX=(saccade.data(:,2)-fixationX-saccinitialX);
       	%saccadeY=(saccade.data(:,3)-fixationY-saccinitialY);
        saccadeX=(saccade.data(:,2)-saccinitialX);
       	saccadeY=(saccade.data(:,3)-saccinitialY);

	for i = 1:length(saccadeX)
		saccadeRadii(i)=sqrt((saccadeX(i)^2)+(saccadeY(i)^2));
		saccadeAngles(i)=atan2(saccadeY(i),saccadeX(i))*(180/pi);
	end


	% Get Targ & Fixation location

        system(['rm -f Targets_*']);
	grabtargs=['grab ' stack_opts ' -aB1 -o8 -i-50:50 ' filename];
        [status,result]=system(grabtargs);
        system(['mv -f Targets_* Targets_' splitfile{7}(2:end)]);
        file_targets=['Targets_' splitfile{7}(2:end)];
        target=importdata(file_targets,' ',1);
        system(['rm -f ' file_targets]);
        fixationX=target.data(:,4)/10;
        fixationY=target.data(:,5)/10;
	%targetX=((target.data(:,8)/10)-fixationX);
	%targetY=((target.data(:,9)/10)-fixationY);
	targetX=((target.data(:,8)/10)-saccinitialX);
	targetY=((target.data(:,9)/10)-saccinitialY);
	
	for i = 1:length(targetX)
		targetRadii(i)=sqrt((targetX(i)^2)+(targetY(i)^2));
		targetAngles(i)=atan2(targetY(i),targetX(i))*(180/pi);
	end
end
