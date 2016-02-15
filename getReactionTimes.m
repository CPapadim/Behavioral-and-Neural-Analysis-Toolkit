function [reactionTimes] = getReactionTimes(filename,stack_opts)
% Get saccade angles, radii, and x/y coordinates for each trial
%
% Inputs:
%		filename - file name from which to extract saccades
%		stack_opts - stack options
%
% Outputs:
%		reactionTimes - reaction times

	splitfile=regexp(filename,'/','split');

	% Get Fixation location
	system(['rm -f Movements*']);
	grabRT=['grab ' stack_opts ' -ab2 -a#208r -a#207b1 -a#206b1 -a#83b1 -a#78b1 -o63 ' filename];
        [status,result]=system(grabRT)
	system(['mv -f Movements* Movements' splitfile{6}(2:end)]);
        file_RT=['Movements' splitfile{6}(2:end)];
        RT=importdata(file_RT,' ',0);
        system(['rm -f ' file_RT]);
        reactionTimes=RT(:,9);


end
