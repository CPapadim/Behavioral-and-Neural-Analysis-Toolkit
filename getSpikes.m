function [spike_data] = getSpikes(filename, unit, alignment, interval, class_opts, stack_opts)
% Get spike counts in interval
%
% Inputs:
%		filename - path and name of file to get spikes from
%		unit - unit channel to get spikes from
%		alignment - how to align trials when getting spikes
%		interval - time interval to get spikes from
%		class_opts - class options (inclues, merges, etc)
%		stack_opts - stack options
%
% Output:
%		spike_data - Array with stacks, classes, and spike_counts
%		spike_data(:,1) is stacks
%		spike_data(:,2) is classes
%		spike_data(:,3) is spike count
%		spike_data(:,4) is firing rate
        grabcall=['grab -o140 ' alignment ' -u' num2str(unit) ' ' interval ' ' class_opts ' ' stack_opts ' ' filename];
	[status,result]=system(grabcall);
	if(~isempty(result))
		result
	end
        [stack class spike_count]=textread('Spikes.out','%d %d %d','delimiter',' ');
	
	% Calculate firing rate
	intv1=str2num(interval(strfind(interval,'i')+1:strfind(interval,':')-1));
	intv2=str2num(interval(strfind(interval,':')+1:end));
	interval_length=abs(intv1-intv2);
	firing_rate=spike_count./(interval_length/1000);

	
	spike_data=[stack class spike_count firing_rate];
	%system(['rm -f Spikes.out']);
	system(['rm -f ps']);


end
