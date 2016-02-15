function [pValue] = coeffSignificance(estimate, upper, lower, CIPercent)

% Calculate coefficient significance from confidence intervals - useful for fits since matlab returns CI
% NOTE:  Calculates p if effect is GREATER than 0.  If there is a negative effect p-value will be nonsensical
% 	 For a negative effect, change the order of upper and lower!!
%
%  Inputs:
%		estimate - coefficient estimate from fit
%		upper - upper Confidence Interval
%		lower - lower CI
%		CIPercent - e.g. 0.95 if 95% confidence interval, 0.9 if 90% confidence intreval, etc
%
%  Outputs:
%		pValue - p value
	numSE=norminv(1-((1-CIPercent)/2));
	SE=(upper - lower)/(2*numSE);
	Z=estimate/SE;
	pValue=2*(1-normcdf(Z));


end
