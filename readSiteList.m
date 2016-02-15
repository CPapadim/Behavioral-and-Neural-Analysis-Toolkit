function [filelist datadirectory electrode pref_dir null_dir xcoord ycoord zcoord area same samesig site_status diff diffsig area_diff dataentries] = readSiteList(SiteList)

% Read LFP Site lists and extract various parameters
%
% Inputs:
%		SiteList - File containing a list of LFP Sites
%
% Outputs:
%		filelist - full path to the file containing behavior
%		datadirectory - directory of the behavior data for a given site
%		electrode - electrode number of recording
%		pref_dir - preferred direction
%		null_dir - null_direction
%		xcoord - x coordinate of electrode
%		ycoord - y coordinate of electrode
%		zcoord - z coordinate of electrode
%		area - brain area of electrode
%		same - Cell array of unit numbers in each electrode (-1 means no unit)
%		samesig - same unit significant tuning (S) or not (NS)
%		site_status - the status of the site such as 'electrode moving', 'everything ok', 'no LFP' etc.
%		diff - Cell array of unit numbers in all different electrodes (-1 means no unit)
%		diffsig - diff unit significant tuning (S) or not (NS)
%		area_diff - the area of the opposite electrode
%		dataline - the raw data entries from the file

	fid=fopen(SiteList);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Read Parameters     %%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
	filelist=cell(1,0);
        datadirectory=cell(1,0);
	area=cell(1,0);
	same1sig=cell(1,0);
	same2sig=cell(1,0);
	diff1sig=cell(1,0);
	diff2sig=cell(1,0);
	electrode=[];
	pref_dir=[];
	null_dir=[];
	xcoord=[];
	ycoord=[];
	zcoord=[];
	area=[];
	same=[];
	samesig=[];
	site_status=[];
	diff=[];
	diffsig=[];
	area_diff=[];
	dataentries=cell(1,0);

	while ~feof(fid)
		nextline=fgetl(fid);
		if(~isempty(nextline) & nextline(1)~='#') %if nextline is not a comment or empty	
			splitline=regexp(nextline,' ','split');
			filelist{end+1}=splitline{1};
			datadirectory{end+1}=splitline{1}(1:26);
			electrode=[electrode str2num(splitline{2})];
			pref_dir=[pref_dir str2num(splitline{3})];
			null_dir=[null_dir str2num(splitline{4})];
			xcoord=[xcoord str2num(splitline{5})];
			ycoord=[ycoord str2num(splitline{6})];
			zcoord=[zcoord str2num(splitline{7})+str2num(splitline{8})];
			area{end+1}=splitline{9};
			same{end+1}=[str2num(splitline{10}) str2num(splitline{12})];
			samesig{end+1,1}=splitline{11};
			samesig{end,2}=splitline{13};
			site_status{end+1}=splitline{14};
			dataentries{end+1}=nextline;
			
		end
	end
        fclose(fid);
	
	%diff1=-1*ones(length(same1),1);
	%diff2=-1*ones(length(same1),1);

	for i = 1:length(filelist)
		matching=find(strcmp(filelist{i},filelist));
		matching=matching(find(matching~=i));
		%if(~isempty(matching))
		for match = 1:length(matching)
		%NOTE, NEED TO CHANGE THIS SINCE matching MAY CONTAIN MULTIPLE VALUES FOR MORE THAN 2 ELECTRODES
			if (match == 1)
				diff{i}=same{matching(match)};
			else
				diff{i}=[diff{i} same{matching(match)}];
			end
			diffsig{i,2*match-1}=samesig{matching(match),1};
			diffsig{i,2*match}=samesig{matching(match),2};
			%diff1(i)=same1(matching);
			%diff2(i)=same2(matching);
			%diff1sig{i}=same1sig{matching};
			%diff2sig{i}=same2sig{matching};
			area_diff{i,match}=area{matching(match)};
		end
	end
	
	% Index for unit / LFP area matching
%	LFUFIdx1 = ((strcmp(area, 'F') & cellfun(@strcmp, area, area_diff) & diff1' >= 0 ));
%	LFUFIdx2 = ((strcmp(area, 'F') & cellfun(@strcmp, area, area_diff) & diff2' >= 0 ));
%	
%	LFUDIdx1 = ((strcmp(area, 'F') & ~cellfun(@strcmp, area, area_diff) & diff1' >= 0 ));
%	LFUDIdx2 = ((strcmp(area, 'F') & ~cellfun(@strcmp, area, area_diff) & diff2' >= 0 ));
%	
%	LDUFIdx1 = ((strcmp(area, 'D') & ~cellfun(@strcmp, area, area_diff) & diff1' >= 0 ));
%	LDUFIdx2 = ((strcmp(area, 'D') & ~cellfun(@strcmp, area, area_diff) & diff2' >= 0 ));
%	
%	LDUDIdx1 = ((strcmp(area, 'D') & cellfun(@strcmp, area, area_diff) & diff1' >= 0 ));
%	LDUDIdx2 = ((strcmp(area, 'D') & cellfun(@strcmp, area, area_diff) & diff2' >= 0 ));



end
