%generate a random selection of 300 file numbers from 1 to 7776 to
%calculate the root mean sqaured error for
shuffle = randi([1, 7776], 1, 300);

%load data
load("save_net\data.mat") 
numSensors = 6;

clear meanerror;

%calculate rate of change of temperature
for n = 1:numel(data)
    gradients{n} = data{n}(:, 2:end) - data{n}(:, 1:end-1);
end

%generate training data
for n = 1:numel(data)
    X = gradients{n};
    XTrain{n} = X(:,1:end-1);
    TTrain{n} = X(:,2:end); 
end

%normalise data to prevent neural network training divergence
mu = mean(cat(2, gradients{:}), 2);
sigma = std(cat(2, gradients{:}), 0, 2);

%normalise to prevent divergence
mu = mean(cat(2, gradients{:}), 2);
sigma = std(cat(2, gradients{:}), 0, 2);

for n = 1:numel(data)
    XTrain{n} = (XTrain{n} - mu) ./ sigma;
    TTrain{n} = (TTrain{n} - mu) ./ sigma;
end


%load trained neural network                                   
load("save_net\sensor_LSTM_lite.mat");
net = sensor_LSTM_lite;

%start predicting temperatures after the first 200 time steps and predict
%ahead by 20 time steps
offset = 200;
overlap = 20;
numPredictionTimeSteps = 499 - offset;
net = resetState(net);
meanerror = zeros(300, 1);

%run predictions for a random selection of 300 temperature data files
counter = 1;
for index = shuffle
    disp(counter);
    X = XTrain{index};
    T = TTrain{index};
    numberOverlap = 0;
    Y = zeros(numSensors,numPredictionTimeSteps);
    Xcopy = zeros(numSensors, 498);
    Xcopy(:, 1:offset+1) = X(:, 1:offset+1);
    %run until 500th time step is predicted
    while offset+(numberOverlap+1)*overlap < 500
        %reset neural network states
        net = resetState(net);
        %feed shifting window of 200 time steps into neural network
        [net,Z] = predictAndUpdateState(net,Xcopy(:, (1+numberOverlap*overlap):(offset+numberOverlap*overlap)));        %closed loop (X/Xcopy)
        %forecast
        Xt = Z(:,end);
        %predict ahead by 20 time steps
        for t = (1+numberOverlap*overlap):((numberOverlap+1)*overlap)
            [net,Y(:,t)] = predictAndUpdateState(net,Xt);               %closed loop
            %[net,Y(:,t)] = predictAndUpdateState(net,X(:, offset+t));   %open loop
            Xt = Y(:,t);
            Xcopy(:, offset+1+t) = Xt;       
        end
        numberOverlap = numberOverlap+1;
    end

    %plot predictions
    numTimeSteps = offset + numPredictionTimeSteps;

    %convert gradients back to temperatures
    temps = data{index}(:, 2:end);
    forecast = zeros(6, numPredictionTimeSteps-1);
    forecast(:, 1) = temps(:, offset+2);
    for i = 1:numPredictionTimeSteps-2
        forecast(:, i+1) = forecast(:,i) + Y(:, i).*sigma+mu;
    end

    %calculate RMSE
    error = abs(forecast(:, 1:1+(numberOverlap*overlap)) - temps(:, offset+1:offset+1+(numberOverlap*overlap)));
    meanerror(counter) = mean(error.^2, 'all')^0.5;
    counter = counter + 1;
end

overallMean = mean(meanerror);
disp(overallMean);
histogram(meanerror);
xlabel('RMSE');
ylabel('Frequency')






