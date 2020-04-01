function [ex,rs]=joinexp(pattern)
% JOINEXP Join partial results from parallel computations

% AUTORIGHTS
% Copyright 2007 (c) Andrea Vedaldi and Paolo Favaro
% 
% This file is part of VicinalBoost, available in the terms of the GNU
% General Public License version 2.

[path,name] = fileparts(pattern) ;
files = dir(pattern) ;
names = {files.name} ;
rs = {} ;
for t=1:length(names)
  data = load(fullfile(path,names{t})) ;
  rs = {rs{:}, data.rs{:}} ;  
	fprintf('%.2f done\r',t/length(names)*100) ;
end
ex = data.ex ;
fprintf('\n') ;

% cleanup: remove empty cells
is_empty = boolean(zeros(1,length(rs))); 
for i=1:length(rs)
  is_empty(i) = isempty(rs{i}) ;
end

rs(is_empty) = [] ;
