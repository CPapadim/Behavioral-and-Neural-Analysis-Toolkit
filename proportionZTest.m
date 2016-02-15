function [pValue,zstat] = proportionZTest(P1,P2,N1,N2)

%  Calculate p value for the difference between two proportions
%
%  Inputs:
%		P1 - proportion 1
%		P2 - proportion 2
%		N1 - The total number of trials for P1
%		N2 - The total number of trials for P2
%		E.g. P1 = 10/200;  In this case N = 200 and P = 10/200.  The count (10) can be deduced so is not an input

	count1 = P1.*N1;
	count2 = P2.*N2;

	totalproportion = (count1 + count2)./(N1+N2);
	
	denom = sqrt(totalproportion.*(1-totalproportion).*((1/N1)+(1/N2)));

	zstat = abs((P1-P2)/denom);
	pValue=2*(1-normcdf(zstat));
end
