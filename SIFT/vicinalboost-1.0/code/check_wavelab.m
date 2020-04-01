function check_wavelab(defpath)
% CHECK_WAVELAB

[vicinalboost_root,drop] = fileparts(which('vicinalboost')) ;

vicinalboost_root ;
if nargin < 1
	defpath = fullfile(vicinalboost_root, 'toolbox', 'Wavelab850') ;
end

% test for Wavelab850
s = which('MakeOnFilter') ;

if isempty(s)
	fprintf('** Cannot find Wavelab850 in the current path\n') ;
	fprintf('** Attempting to load Wavelab from the default path ''%s''\n',...
					defpath) ;
	
	d=pwd ;
	try
		matlabroot = vicinalboost_root ;
		cd(defpath) ;
		WavePath ;
	catch
		cd(d) ;
		error(lasterr) ;
	end
	cd(d) ;
end
