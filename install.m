%% add libs to path

% call scanDictionary.
path = mfilename('fullpath');
path = fileparts(path);
scanDictionary(@installPath, path);
 
savepath;