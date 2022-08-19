%load data and neural networks into Matlab workspace
load("save_net\data.mat");
load("save_net\net.mat");
load("save_net\net2.mat");
load("save_net\net3.mat");
load("save_net\net4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");

%settings
window = 20;                    %number of time steps to input into combinationFinder()
thresholdProbability = 0.3;     %minimum confidence level for a neural network output to be considered valid
fileNumber = 4932;              %the number of the temperature data file from "5_seg_beam_csv" to take temperature data from

%radius prediction
%combinationFinder() takes the required number of data points from the required file and predicts its radii combination
[prediction, ~, ~] = combinationFinder(data{fileNumber}(:, 2:window+1), thresholdProbability, uniformcases, absnet, net, net2, net3, net4);

%numtocomb() converts the file number into the actual radii used in the file
actual = numtocomb(fileNumber);

%displays the predicted likely radii combinations (mm) and their confidence levels (from 0-1)
prediction(:, 1:5) = prediction(:, 1:5)*10;
disp('Predictions')
disp(prediction)

%displays the actual radii
disp('Actual radii')
disp(actual*10)
