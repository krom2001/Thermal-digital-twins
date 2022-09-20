%load data and neural networks into Matlab workspace
load("save_net\data.mat");
load("save_net\pcanet.mat");
load("save_net\pcanet2.mat");
load("save_net\pcanet3.mat");
load("save_net\pcanet4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");

%settings
window = 20;                    %number of time steps to input into combinationFinderPCA()
thresholdProbability = 0.3;     %minimum confidence level for a neural network output to be considered valid

%generates predictions for file numbers 3000-3100 and counts how many radii combinations were predicted correctly
correct = 0;
for i = 3000:3100
    [prediction, ~] = combinationFinderPCA(data{i}(:, 2:window+1), thresholdProbability, uniformcases, absnet, pcanet, pcanet2, pcanet3, pcanet4);
    actual = numtocomb(i);
    prediction(:, 1:5) = prediction(:, 1:5)*10;
    disp('Predictions')
    disp(prediction)
    disp('Actual radii')
    disp(actual*10)     %converting to mm
    if prediction(1, 1:5) == actual*10
        correct = correct + 1;
    end
end
%displays how many combinations were correclty predicted
disp('Correct predictions:')
disp(correct);


