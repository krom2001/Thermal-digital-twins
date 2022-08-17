function [numSensors, numTimeSteps, data] = fileReader()
    %uploads .csv data to matlab
    path_directory= "5_seg_beam_csv/"; 
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
end


