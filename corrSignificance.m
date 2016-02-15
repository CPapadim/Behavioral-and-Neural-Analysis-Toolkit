function [p] = corrSignificance(r1, r2, n1, n2, sides)

% Calculate if two correlation coefficients are different
% 
%
% Inputs:
%		r1 & r2 - correlation coefficients
%		n1 & n2 - degrees of freedom / num observations
%		sides to t-test (1 or 2)
%
% Outputs:
%		p - p value

	c1=max([r1 r2]);
	c2=min([r1 r2]);
	z1=atanh(c1); % Fisher Z transform
	z2=atanh(c2);

	tstat=-(z1-z2)/sqrt((1/(n1-3))+(1/(n2-3))); % Negative sign makes it so we don't have to do 1-tcdf

	if(sides==2)
		tstat=-abs(tstat);
	end
	p=sides*tcdf(tstat,1000000); % Infinite degrees of freedom

end
