function scanDictionary(operateFun, path)
    % get the list files under path   
    list = dir(path);
    
    % call operateFun
    operateFun(path);
    
    % the first is '.', and the second is '..'
    for i = 3 : length(list);
        % if the ith element is a dictionary
        if ( list(i).isdir)
            name = list(i).name;
            if( strcmp(name, '.git') == 1)
                continue;
            end
            
            newPath = [path, '\', name];
           
            % recursive the function of scanDictionary
            scanDictionary(operateFun, newPath);
        end
    end
end