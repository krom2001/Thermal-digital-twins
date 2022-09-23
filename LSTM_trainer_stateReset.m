%load files
load("save_net\data.mat")        
numSensors = 6;
%threshold temperature at which to raise flags
thresholdtemp = 21;

%calculate rate of change of temperature
for n = 1:numel(data)
    gradients{n} = data{n}(:, 2:end) - data{n}(:, 1:end-1);
end

for n = 1:numel(data)
    X = gradients{n};
    XTrain{n} = X(:,1:end-1);
    TTrain{n} = X(:,2:end); 
end

%normalise data to prevent divergence during neural network training
mu = mean(cat(2, gradients{:}), 2);
sigma = std(cat(2, gradients{:}), 0, 2);

for n = 1:numel(data)
    XTrain{n} = (XTrain{n} - mu) ./ sigma;
    TTrain{n} = (TTrain{n} - mu) ./ sigma;
end

%define LSTM network
layers = [
    sequenceInputLayer(numSensors)
    lstmLayer(170,'OutputMode','sequence')
    %dropoutLayer(0.1)
    %lstmLayer(100,'OutputMode','sequence')
    %dropoutLayer(0.1)
    fullyConnectedLayer(numSensors)
    regressionLayer];

options = trainingOptions("adam", ...
    MaxEpochs=2, ...
    SequencePaddingDirection="left", ...
    Shuffle="every-epoch", ...
    Plots="training-progress", ...
    Verbose=0);

%train network
%net = trainNetwork(XTrain,TTrain,layers,options);       %train net on/off

%save net                                           %save net on/off
%sensor_LSTM_lite = net;
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "sensor_LSTM_lite.mat");
%save(outputFile);

%load network                                   %load net on/off
load("save_net\sensor_LSTM_lite.mat");
net = sensor_LSTM_lite;

%Select data file number to run by setting idx:
idx = 7333;
X = XTrain{idx};
T = TTrain{idx};

%start predicting temperatures after the first 200 time steps and predict
%the following 20 time steps using a sliding window of 200 time steps
offset = 200;
overlap = 20;
numberOverlap = 0;
numPredictionTimeSteps = 499 - offset;
net = resetState(net);
Y = zeros(numSensors,numPredictionTimeSteps);
Xcopy = zeros(numSensors, 498);
Xcopy(:, 1:offset+1) = X(:, 1:offset+1);

%keep predicting until the 500th time step has been predicted
while offset+(numberOverlap+1)*overlap < 500
    %reset networ state
    net = resetState(net);
    %run a 200 time step window through the neural network
    [net,Z] = predictAndUpdateState(net,Xcopy(:, (1+numberOverlap*overlap):(offset+numberOverlap*overlap)));    %closed loop (X/Xcopy)
    %forecast the next 20 time steps
    Xt = Z(:,end);
    for t = (1+numberOverlap*overlap):((numberOverlap+1)*overlap)       
        [net,Y(:,t)] = predictAndUpdateState(net,Xt);               %closed loop
        %[net,Y(:,t)] = predictAndUpdateState(net,X(:, offset+t));   %open loop
        Xt = Y(:,t);
        Xcopy(:, offset+1+t) = Xt;       
    end
    numberOverlap = numberOverlap+1;
end
numTimeSteps = offset + numPredictionTimeSteps;

%convert predicted rate of change of temperatures back to temperatures
temps = data{idx}(:, 2:end);
forecast = zeros(6, numPredictionTimeSteps-1);
forecast(:, 1) = temps(:, offset+2);
for i = 1:numPredictionTimeSteps-2
    forecast(:, i+1) = forecast(:,i) + Y(:, i).*sigma+mu;
end

%warning flags initialised and raised when temperature exceeds threshold
exceedTime = 1000;
lvl1 = 0;
lvl2 = 0;
lvl3 = 0;
for i = 1:size(forecast,2)
    if abs(forecast(1,i))>thresholdtemp || abs(forecast(2,i))>thresholdtemp || abs(forecast(3,i))>thresholdtemp || abs(forecast(4,i))>thresholdtemp || abs(forecast(5,i))>thresholdtemp || abs(forecast(6,i))>thresholdtemp
        exceedTime = i;
        break
    end
end
%Description of conditions for warning levels 1-3:
if exceedTime<100
    lvl3 = 1;
    disp("Level 3 warning: Temperature threshold will be crossed in less than 100 time steps")
    disp(["Time steps until threshold crossed: " exceedTime])
elseif exceedTime<200
    lvl2 = 1;
    disp("Level 2 warning: Temperature threshold will be crossed in less than 200 time steps")
    disp(["Time steps until threshold crossed: " exceedTime])
elseif exceedTime<300
    lvl3 = 1;
    disp("Level 1 warning: Temperature threshold will be crossed in less than 300 time steps")
    disp(["Time steps until threshold crossed: " exceedTime])
end

%calculate RMSE of the predctions
error = abs(forecast(:, 1:1+(numberOverlap*overlap)) - temps(:, offset+1:offset+1+(numberOverlap*overlap))).^2;
rmse = mean(error, 'all')^0.5;
disp(["Prediction RMSE: " rmse])
    

figure(3)
hold on;
title("Temperature Forecasting")

%plot the temperature predictions
for i = 1:6
    %plot(T(i,1:offset))
    plot(temps(i,1:offset+2+(numberOverlap*overlap)), 'black')                      
    plot(offset+1:offset+1+(numberOverlap*overlap),forecast(i,1:1+(numberOverlap*overlap)),'--')
    ylabel("Temperatures")
end
%if a warning has been raised, mark on the plot in red, the time step where
%the temperature threshold is predicted to be exceeded
if lvl1==1 || lvl2==1 || lvl3==1
    plot([exceedTime+offset, exceedTime+offset], [min(temps, [], 'all'), max(temps, [], 'all')], 'red')
end

xlabel("Time Step")
legend(["Measured" "Forecasted"])
hold off;

figure(4)
hold on;
title("Gradient Forecasting")

%plot a graph of the real and predicted rates of change of temperature
for i = 1:6
    %plot(T(i,1:offset))
    plot(T(i,1:(offset+(numberOverlap*overlap))), 'black')                      
    plot(offset:(offset+(numberOverlap*overlap)),[T(i,offset) Y(i,1:(numberOverlap*overlap))],'--')
    ylabel("Gradients")
end

xlabel("Time Step")
legend(["Measured" "Forecasted"])
hold off;


