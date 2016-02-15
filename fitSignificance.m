function [Fstat, p, modelFit, gofM] = fitSignificance(model,fitOpts, xdata,ydata,robust)
% Compare the significance of a fit (Compare if the fit is different from a fit of a straight line with slope 0)
% Uses an F-test
%
% Inputs:
%		model - the model is a fittype
%		fitOpts - fit options
%		xdata - x variable
%		ydata - y variable
%		robust - 0 = normal fit, 1 = fit with low weight on outliers
%
% Outputs:
%		Fstat - F statistic
%		p - p-value
%		modelFit - the fit of the model passed to the function (for plotting)
%		gofM - goodness of fit parameters such as R-squared and others
%
        ZeroSlopeLineModel=fittype(@(intercept,x) (0*x)+intercept,'independent','x');
	if(robust==0)
		[ZeroSlopeLineFit,gofZ]=fit(xdata,ydata, ZeroSlopeLineModel,'StartPoint',[0]);
		[modelFit,gofM]=fit(xdata,ydata, model, fitOpts);
	else
		[ZeroSlopeLineFit,gofZ]=fit(xdata,ydata, ZeroSlopeLineModel,'StartPoint',[0],'Robust','on');
		[modelFit,gofM]=fit(xdata,ydata, model,'Robust','on');
	end	
	sseZ=gofZ.sse;
        sseM=gofM.sse;
        npZ=numcoeffs(ZeroSlopeLineModel);  %Number of parameters in the reduced model (the zero slope line model)
        npM=numcoeffs(model);  %Number of parameters in complete model
        nd=length(ydata); %Number of points in the data
        Fstat=((sseZ-sseM)/(npM-npZ))/(sseM/(nd-npM));
        p=1-fcdf(Fstat,npM-npZ,nd-npM);


end
