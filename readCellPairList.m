function [filename monkey date unit1 unit2 pref_dir1 pref_dir2 specified_null_dir1 specified_null_dir2 xcoord1 xcoord2 ycoord1 ycoord2 zcoord1 zcoord2 area1 area2] = readCellPairList(cellList)

% Reads the specified cell List with cell pairs and returns various cell parameters
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
	unit1=[];
	unit2=[];
	pref_dir1=[];
	pref_dir2=[];
	specified_null_dir1=[];
	specified_null_dir2=[];
	xcoord1=[];
	xcoord2=[];
	ycoord1=[];
	ycoord2=[];
	zcoord1=[];
	zcoord2=[];
	area1=cell(1,0);
	area2=cell(1,0);
	fid=fopen(cellList);
	while ~feof(fid)
		if(strcmp(strtrim(fgetl(fid)),'Nf'))
			filename{end+1}=fgetl(fid);
			splitfile=regexp(filename{end},'/','split');
			monkey{end+1}=splitfile{4};
			date{end+1}=splitfile{5};
			
			paramsstr=fgetl(fid);
			params=regexp(paramsstr,' ','split');
			unit1=[unit1 str2num(params{2})];
			pref_dir1=[pref_dir1 str2num(params{3})];
			specified_null_dir1=[specified_null_dir1 str2num(params{4})];

			coordsstr=fgetl(fid);
			if(ischar(coordsstr))
				coords=regexp(coordsstr,' ','split');
				if(strcmp(char(coords{1}),'#coords'))
					xcoord1=[xcoord1 str2num(coords{2})];
					ycoord1=[ycoord1 str2num(coords{3})];
					zcoord1=[zcoord1 str2num(coords{4})+str2num(coords{5})];
					area1{end+1}=coords{6};
				end
			end

			paramsstr=fgetl(fid);
			params=regexp(paramsstr,' ','split');
			unit2=[unit2 str2num(params{2})];
			pref_dir2=[pref_dir2 str2num(params{3})];
			specified_null_dir2=[specified_null_dir2 str2num(params{4})];

			coordsstr=fgetl(fid);
			if(ischar(coordsstr))
				coords=regexp(coordsstr,' ','split');
				if(strcmp(char(coords{1}),'#coords'))
					xcoord2=[xcoord2 str2num(coords{2})];
					ycoord2=[ycoord2 str2num(coords{3})];
					zcoord2=[zcoord2 str2num(coords{4})+str2num(coords{5})];
					area2{end+1}=coords{6};
				end
			end




		end
	end
	fclose(fid);
end
