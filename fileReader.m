function [numSensors, numTimeSteps, data] = fileReader(path_directory)
    %uploads .csv data to matlab
    name_list = sprintf('%s/*.csv', path_directory);
    original_files=dir(name_list);
    table_number = length(original_files);
    
    
    %combine into data array
    data = {};
    for i = 1:table_number
        name = fullfile(path_directory, sprintf('tmgtempn_%s.csv', string(i)));
        table = table2array(readtable(name));
        data{i} = table(2:end, 2:end)';
    end
    
    %extract array dimensions
    numSensors = size(data{1},1);
    numTimeSteps = size(data{1},2);
    
    %save the data.mat file
    outputDir = "save_net";
    outputFile = fullfile(outputDir, "data.mat");
    save(outputFile);

end


