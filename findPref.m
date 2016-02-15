function [pref_dir] = findPref(xdata,ydata)
% Finds the preferred direction in a given interval in degrees, using a fit
% 
%
% Inputs:
%		xdata - x axis data
%		ydata - y axis data
%
% Output: 
%		preferred_dir - preferred direction in degrees
%

                % Fit cosine to cell
                CosModel=fittype(@(base,A,peakloc,angleloc) (base + A * cosd(peakloc-angleloc)),'independent','angleloc');
                CosOpts=fitoptions('Method','NonLinearLeastSquares','Upper',[Inf,Inf,180],'Lower',[0 0 -180]);
                [Fc, pc, modelfitc, gofC] = fitSignificance(CosModel,CosOpts,xdata,ydata,0);
		pref_dir = modelfitc.peakloc;

		

end
