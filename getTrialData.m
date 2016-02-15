function [sequencenumbers trialnumbers stacks classes success] = getTrialData(filename, class_opts, stack_opts)
% Get Trial data from file
%
% Inputs:
%		filename - file to get data from
%		class_opts - class options for grab
%		stack_opts - stack options for grab
%
% Outputs:
%		sequencenumbers - consecutive numbers for each trial, can be used as an index
%		trialnumbers - trial numbers
%		stacks - stack for each trial
%		classes - class for each trial
%		success - whether trial succeeded or failed

	[status, result]=system(['grab -R1 ' class_opts ' ' stack_opts ' ' filename]);
	[junk sequencenumstr stacks classes trialnumstr success]=strread(result, '%s %s %d %d %s %s','delimiter', ' ');
	% octave - [junk sequencenumstr stacks classes trialnumstr success]=strread(result, '%s %s %d %d %s %s','delimiter', ' ','multipledelimsasone',1);
	% Convert trial number and sequence number strings to numbers
	for i = 1:size(junk,1)
		trialnumbers(i)=str2num(trialnumstr{i}(2:end-1)); %Trial Numbers
		sequencenumbers(i)=str2num(sequencenumstr{i}(1:end-1)); %Sequence Numbers
	end
	trialnumbers=trialnumbers';
	sequencenumbers=sequencenumbers';	

end
