function [filename monkey date unit pref_dir specified_null_dir xcoord ycoord zcoord area] = readCellList(cellList)

% Reads the specified cell List and returns various cell parameters
% 
% Inputs:
% 		cellList - Cell List file name and path
%
% Outputs:	
%		filename - cell-array of neuron file names and paths
%		monkey - cell-array of monkey name
%		date - cell-array of recording date
%		unit - unit number data is recorded in
%		pref_dir - specified preferred direction
%		specified_null_dir - specified null direction
%		xcoord - x-coordinate of recording location
%		ycoord - y-coordinate of recording location
%		zcoord - z-coordinate of recording location
%		area - cell-array of area (F or D)
	filename=cell(1,0);
	monkey=cell(1,0);
	date=cell(1,0);;
	unit=[];
	pref_dir=[];
	specified_null_dir=[];
	xcoord=[];
	ycoord=[];
	zcoord=[];
	area=cell(1,0);
	fid=fopen(cellList);
	while ~feof(fid)
		if(strcmp(strtrim(fgetl(fid)),'Nf'))
			filename{end+1}=fgetl(fid);
			splitfile=regexp(filename{end},'/','split');
			monkey{end+1}=splitfile{4};
			date{end+1}=splitfile{5};
			paramsstr=fgetl(fid);
			params=regexp(paramsstr,' ','split');
			unit=[unit str2num(params{2})];
			pref_dir=[pref_dir str2num(params{3})];
			specified_null_dir=[specified_null_dir str2num(params{4})];

			coordsstr=fgetl(fid);
			if(ischar(coordsstr))
				coords=regexp(coordsstr,' ','split');
				if(strcmp(char(coords{1}),'#coords'))
					xcoord=[xcoord str2num(coords{2})];
					ycoord=[ycoord str2num(coords{3})];
					zcoord=[zcoord str2num(coords{4})+str2num(coords{5})];
					area{end+1}=coords{6};
				end
			end


		end
	end
	fclose(fid);
end
