function path = createDir(path)
    if(~ exist(path, 'dir') )
        mkdir(path);
    end
end