function backup(name)
% BACKUP Backup file
%   BACKUP(NAME) copyes NAME to NAME.BAK if NAME is an existing file.

if exist(name,'file')
  copyfile(name, [name '.bak']) ;
end
