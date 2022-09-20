%load files
load("save_net\data.mat")

uniformcases = zeros(6, 6);

%generates reference cases
for j = 1:6
    [perc, stdev, range] = percent(data, [j j j j j]);
    uniformcases(j, 2:6) = perc;
    uniformcases(j, 1) = range;
end

%save uniformcases                         %save on/off
outputDir = "save_net\";
name = "uniformcases.mat";
outputFile = fullfile(outputDir, name);
save(outputFile);

disp(uniformcases)