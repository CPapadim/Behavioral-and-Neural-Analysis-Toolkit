function [delay, ITI] = getDelayAndITI(filename,stack_opts)
% Get delay and ITI for each trial
%
% Inputs:
%               filename - file name from which to extract targets
%               stack_opts - stack options
%
% Outputs:
%               delay - memory delay time
%               iti - time between go-cue of previous trial and target onset of current trial
% 




        splitfile=regexp(filename,'/','split');

        system(['rm -f MemoryTiming.out*']);
        grabmemdata=['grab ' stack_opts ' -o40 ' filename];
        [status,result]=system(grabmemdata)
        memorydata=importdata('MemoryTiming.out',' ');
        system(['rm -f MemoryTiming.out']);
	delay=memorydata(:,5);
	ITI=memorydata(:,6);


end  
