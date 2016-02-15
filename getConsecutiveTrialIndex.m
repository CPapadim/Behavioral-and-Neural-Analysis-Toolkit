function [trialscurr, trialsprev, trialsIDcurr, trialsIDprev, keepidxCurr, keepidxPrev] = getConsecutiveTrialIndex(filename, previoustrialsID, currenttrialsID)
% Generate indices for current and previous trials to keep that are consecutive
%
% Inputs:
%		filename - name of file to operate on
%		previoustrialsID - previous trial IDs
%		currenttrialsID - current trial IDs
%
% Output:
%		keepidxCurr - index of current trials to keep
%		keepidxPrev - index of previous trials to keep
%
% NOTE:  Indices can be used like this:  previoustrials=previoustrials(keepidxPrev), etc

	[trialsID trialNums stacks classes success] = getTrialData(filename, '', '');
	trialNumsPadded=[trialNums; -99999]; % Pad to make diff vector the same size as the rest

	trialNumsConsecutive=trialNums(diff(trialNumsPadded)==1 & ismember(trialsID, previoustrialsID) & ismember(trialsID+1,currenttrialsID));
	trialNumsConsecutiveID=trialsID(diff(trialNumsPadded)==1 & ismember(trialsID, previoustrialsID) & ismember(trialsID+1,currenttrialsID));
	
	keepidxCurr=ismember(trialsID,trialNumsConsecutiveID+1);
	keepidxPrev=ismember(trialsID+1,trialsID(keepidxCurr));

	trialsprev=trialNums(keepidxPrev);
	trialscurr=trialNums(keepidxCurr);
	trialsIDprev=trialsID(keepidxPrev);
	trialsIDcurr=trialsID(keepidxCurr);


	%previoustrials=previoustrials(1:end-1);
	
	%trialsconsecutive=previoustrials(diff(previoustrials)==1);
	%trialsconsecutiveID=previoustrialsID(diff(previoustrials)==1);

	%keepidxCurr=ismember(currenttrialsID,trialsconsecutiveID+1);
	%keepidxPrev=ismember(previoustrialsID+1,currenttrialsID(keepidxCurr));


end
