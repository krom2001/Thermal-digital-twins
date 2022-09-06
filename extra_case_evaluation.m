%load data
load("save_net\extradata.mat");
load("save_net\extradataAnswers.mat");
load("save_net\net.mat");
load("save_net\net2.mat");
load("save_net\net3.mat");
load("save_net\net4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");

%settings
window = 20;
thresholdProbability = 0.3;

%generate and output results
for i = 1:numel(extradata)
    %predict radii combination using temperature data
    disp("Predicted Combinations:")
    combination = combinationFinder(extradata{i}(:,2:window+1),thresholdProbability, uniformcases, absnet, net, net2, net3, net4);
    combination(:, 1:5) = combination(:, 1:5)*10;   %convert to mm
    disp(combination);
    clear combination;
    %display the correct radii combination
    disp("Actual Combination:");
    disp(extradataAnswers(i, :));
end