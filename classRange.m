function [classList, merge_str] = classRange(class, range, merge_to)
% Create a range of classes around the specified class, and generate
% the merge string for grab (e.g. -mc100,1,2,3)
%
% Inputs:
%		class - the class around which to get a range
%		range - the desired range around class
%		merge_to - class number to merge classes to
%
% Outputs:
%		classList - the list of classes within the specified range
	
	classList=[];
	for r = 0:range
		classList=[classList class+r class-r];
	end
	classList=unique(classList); % Sort the results and remove duplicates
	
	% Wrap classes to the range  1 to 16
	classList(classList < 1)=classList(classList < 1)+16;
	classList(classList > 16)=classList(classList > 16)-16;

	% Generate grab merge string
	merge_str=['-mc' num2str(merge_to)];
        for cc=1:length(classList)
                merge_str=[merge_str ',' num2str(classList(cc))];
        end

end
