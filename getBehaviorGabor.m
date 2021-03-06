function [gaborFit,gofGabor, relativeGaborAngles,residualError] = getBehaviorGabor(filelist,perSessionOrPop,rawOrSmooth,stack_opts_C,stack_opts_P);

%  Returns a gabor fit and the raw data associated with it for a given list of files
%
%
%  Inputs:
%		filelist - list of files to get gabor from
%		perSessionOrPop - do the gabor based on error calculated per file, or 
%				  error calculated from population as a whole ('Session','Population')
%		stack_opts_C - stacks to include in 'Current' trials
%		stack_opts_P - stacks to include in 'Previous' trials
%		
%  Outputs:
%		gaborfit - gabor model
%		gofGabor - goodness of fit parameters for the model
%		relativegabortargangles - (previous - current) target locations
%		residualError - saccade residual error
%		residualError Smoothed - smoothed saccade residual error
%

addpath('/home/cpapadim/m-files/Data_Analysis/generic');

%parameters
degreeSpan=22.5/360; %Span for smoothing
stacksCurr=stack_opts_C;
stacksPrev=stack_opts_P;


%%%%%%%%%%%%%%%%%%%%%%%%%
% Read Cell List        %
%%%%%%%%%%%%%%%%%%%%%%%%%

[filename monkey date unit pref_dir specified_null_dir xcoord ycoord zcoord area]=readCellList(filelist);



        alltrialtarganglesC=[];
        alltrialtarganglesP=[];
        alltrialsaccanglesC=[];
        alltrialsaccanglesP=[];
	alltrialsaccResErrTh=[];
        for j=1:length(filename)

                j
		
		splitfile=regexp(filename{j},'/','split');
	
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			%  Get Target Saccade locations         %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			[targetTh, targetR, targetX, targetY] = getTargets(filename{j},'');
			[saccadeTh, saccadeR, saccadeX, saccadeY] = getSaccades(filename{j},'');

			[trialsprevID trialsP trialstacksprev classprev successprev] = getTrialData(filename{j}, '', stacksPrev);
			[trialscurrID trialsC trialstackscurr classcurr successcurr] = getTrialData(filename{j}, '', stacksCurr);


			% Keep only consecutive trials
			
			[trialscurr, trialsprev, trialsIDcurr, trialsIDprev, keepidxCurr, keepidxPrev] = getConsecutiveTrialIndex(filename{j},trialsprevID,trialscurrID);

			prevtargangles=targetTh(keepidxPrev)';
			currtargangles=targetTh(keepidxCurr)';
			prevsaccangles=saccadeTh(keepidxPrev)';
			currsaccangles=saccadeTh(keepidxCurr)';
			
			tuningangles{j}=currtargangles;
			relativegaborangles{j}=prevtargangles-currtargangles;
			relativegaborangles{j}(relativegaborangles{j} <= -180)=relativegaborangles{j}(relativegaborangles{j} <= -180)+360;
        		relativegaborangles{j}(relativegaborangles{j} > 180)=relativegaborangles{j}(relativegaborangles{j} > 180)-360;
			
			saccadeError=currsaccangles-currtargangles;
			saccadeError(saccadeError > 180)=saccadeError(saccadeError > 180)-360;
			saccadeError(saccadeError <= -180)=saccadeError(saccadeError <= -180)+360;

			tempArray=[saccadeError; saccadeError; saccadeError];
			smoothDim=[currtargangles; currtargangles+360; currtargangles+720];
			if(~isvector(tempArray) | ~isvector(smoothDim))
                                error('Dimensions passed to the smooth funcion must be vector');
                        end
			tempArray=smooth(smoothDim, tempArray,degreeSpan,'rlowess');
			smoothAngles=tempArray(((1/3)*end)+1:(2/3)*end,:);

			saccResErrTh=saccadeError-smoothAngles; %remove systematic error
			saccResErrTh(saccResErrTh <= -180)=saccResErrTh(saccResErrTh <= -180)+360;
			saccResErrTh(saccResErrTh > 180)=saccResErrTh(saccResErrTh > 180)-360;

			alltrialtarganglesP=[alltrialtarganglesP; prevtargangles];
			alltrialtarganglesC=[alltrialtarganglesC; currtargangles];
			alltrialsaccanglesP=[alltrialsaccanglesP; prevsaccangles];
			alltrialsaccanglesC=[alltrialsaccanglesC; currsaccangles];
			
			alltrialsaccResErrTh=[alltrialsaccResErrTh; saccResErrTh];

        end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Define Gabor Model		%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	gaboropts=fitoptions('Method','NonLinearLeastSquares');
	gaboropts.Startpoint=[5,1]; %start point for the height and width coefficients.  Play with these if the data is not being fit by the wavy part of the gabor
	gabormodel=fittype('h*exp(-(w*x*(pi/180))^2)*(sin(w*x*(pi/180)))','independent',{'x'},'coefficients',{'h','w'});



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Get relative angle difference (Previous - Current)		%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        relativeanglediff=alltrialtarganglesP-alltrialtarganglesC;
        relativeanglediff(relativeanglediff <= -180)=relativeanglediff(relativeanglediff <= -180)+360;
        relativeanglediff(relativeanglediff > 180)=relativeanglediff(relativeanglediff > 180)-360;
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Generate Gabor from saccade error calculated on each session         %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(strcmp(perSessionOrPop,'Session') & strcmp(rawOrSmooth,'Raw'))
		[gaborFit gofGabor]=fit(relativeanglediff,alltrialsaccResErrTh,gabormodel,gaboropts);
		relativeGaborAngles=relativeanglediff;
		residualError=alltrialsaccResErrTh;
	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Generate Gabor from saccade error calculated on each session and smoothed         %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
	if(strcmp(perSessionOrPop,'Session') & strcmp(rawOrSmooth,'Smooth'))
		tempArray=[alltrialsaccResErrTh; alltrialsaccResErrTh; alltrialsaccResErrTh];
		smoothDim=[relativeanglediff; relativeanglediff+360; relativeanglediff+720];
		if(~isvector(tempArray) | ~isvector(smoothDim))
			error('Dimensions passed to the smooth funcion must be vector');
		end
		tempArray=smooth(smoothDim, tempArray,11.25/360,'lowess');
		smoothsaccResErrTh=tempArray(((1/3)*end)+1:(2/3)*end,:);
		
		[gaborFit, gofGabor]=fit(relativeanglediff,smoothsaccResErrTh,gabormodel,gaboropts);
		relativeGaborAngles=relativeanglediff;
		residualError=smoothsaccResErrTh;
	end
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Generate Gabor from saccade error calculated from all sessions as a whole		%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(strcmp(perSessionOrPop,'Population') & strcmp(rawOrSmooth,'Raw'))
		saccadeErrorPop=alltrialsaccanglesC-alltrialtarganglesC;
		saccadeErrorPop(saccadeErrorPop > 180)=saccadeErrorPop(saccadeErrorPop> 180)-360;
		saccadeErrorPop(saccadeErrorPop <= -180)=saccadeErrorPop(saccadeErrorPop <= -180)+360;

		tempArray=[saccadeErrorPop; saccadeErrorPop; saccadeErrorPop];
		smoothDim=[alltrialtarganglesC; alltrialtarganglesC+360; alltrialtarganglesC+720];
		if(~isvector(tempArray) | ~isvector(smoothDim))
			error('Dimensions passed to the smooth funcion must be vector');
		end
		tempArray=smooth(smoothDim, tempArray,degreeSpan,'rlowess');
		smoothAnglesPop=tempArray(((1/3)*end)+1:(2/3)*end,:);

		saccResErrThPop=saccadeErrorPop-smoothAnglesPop; %remove systematic error
		saccResErrThPop(saccResErrThPop <= -180)=saccResErrThPop(saccResErrThPop <= -180)+360;
		saccResErrThPop(saccResErrThPop > 180)=saccResErrThPop(saccResErrThPop > 180)-360;
		
		[gaborFit, gofGabor]=fit(relativeanglediff,saccResErrThPop,gabormodel,gaboropts);
		relativeGaborAngles=relativeanglediff;
		residualError=saccResErrThPop;
	end

        
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Generate Gabor from saccade error calculated from all sessions as a whole and smoothed	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
	if(strcmp(perSessionOrPop,'Population') & strcmp(rawOrSmooth,'Smooth'))
		saccadeErrorPop=alltrialsaccanglesC-alltrialtarganglesC;
		saccadeErrorPop(saccadeErrorPop > 180)=saccadeErrorPop(saccadeErrorPop> 180)-360;
		saccadeErrorPop(saccadeErrorPop <= -180)=saccadeErrorPop(saccadeErrorPop <= -180)+360;

		tempArray=[saccadeErrorPop; saccadeErrorPop; saccadeErrorPop];
		smoothDim=[alltrialtarganglesC; alltrialtarganglesC+360; alltrialtarganglesC+720];
		if(~isvector(tempArray) | ~isvector(smoothDim))
			error('Dimensions passed to the smooth funcion must be vector');
		end
		tempArray=smooth(smoothDim, tempArray,degreeSpan,'rlowess');
		smoothAnglesPop=tempArray(((1/3)*end)+1:(2/3)*end,:);

		saccResErrThPop=saccadeErrorPop-smoothAnglesPop; %remove systematic error
		saccResErrThPop(saccResErrThPop <= -180)=saccResErrThPop(saccResErrThPop <= -180)+360;
		saccResErrThPop(saccResErrThPop > 180)=saccResErrThPop(saccResErrThPop > 180)-360;
		
		tempArray=[saccResErrThPop; saccResErrThPop; saccResErrThPop];
		smoothDim=[relativeanglediff; relativeanglediff+360; relativeanglediff+720];
		if(~isvector(tempArray) | ~isvector(smoothDim))
			error('Dimensions passed to the smooth funcion must be vector');
		end
		tempArray=smooth(smoothDim, tempArray,11.25/360,'lowess');
		smoothsaccResErrThPop=tempArray(((1/3)*end)+1:(2/3)*end,:);

		[gaborFit, gofGabor]=fit(relativeanglediff,smoothsaccResErrThPop,gabormodel,gaboropts);
		relativeGaborAngles=relativeanglediff;
		residualError=smoothsaccResErrThPop;
	end

	
end	
