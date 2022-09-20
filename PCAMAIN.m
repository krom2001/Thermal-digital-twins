%load data and neural networks into Matlab workspace
load("save_net\data.mat");
load("save_net\pcanet.mat");
load("save_net\pcanet2.mat");
load("save_net\pcanet3.mat");
load("save_net\pcanet4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");

%settings
window = 20;                    %number of time steps to input into combinationFinder()
thresholdProbability = 0.3;     %minimum confidence level for a neural network output to be considered valid
fileNumber = 4932;              %the number of the temperature data file from "5_seg_beam_csv" to take temperature data from

%radius prediction
%combinationFinderPCA() takes the required number of data points from the
%required file and predicts its radii combination using the PCA
%pre-processing method
%first time step contains invalid temperatures so this is not input into
%the function
[prediction, ~] = combinationFinderPCA(data{fileNumber}(:, 2:window+1), thresholdProbability, uniformcases, absnet, pcanet, pcanet2, pcanet3, pcanet4);

%numtocomb() converts the file number into the actual radii used in the file
actual = numtocomb(fileNumber);

%displays the predicted likely radii combinations (mm) and their softmax score
prediction(:, 1:5) = prediction(:, 1:5)*10;
disp('Predictions')
disp(prediction)

%displays the actual radii
disp('Actual radii')
disp(actual*10)
