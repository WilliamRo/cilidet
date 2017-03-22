function img = quickFilter(img, varargin)
%MORPHFILTER::QUICKFILTER ...
%   ...

%% Find class name
% get name of the file which caller is in
node = dbstack(1);
filename = node.file;
linenum = node.line;
% get the line which calls quickFilter
fid = fopen(filename);
for i = 1 : linenum, line = fgetl(fid); end
fclose(fid);
% get class name
strs = strsplit(line, '.');
index = find(strcmp(strs, 'mf'), 1);
assert(index >= 0, '!! Failed to find source, can not quickFilter')
clsname = strs{index+1};

%% Quick filter
ft = cid.mf.(clsname)(varargin{:});
img = ft.filter(img);

end

