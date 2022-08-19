%read files
%[numSensors, numTimeSteps, data] = fileReader();         %comment out for speed once data uploaded

%settings
window = 20;
thresholdProbability = 0.3;

%generate brownian noise
clear true;
noise = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);

%load nets                                 %load net on/off
load("save_net\net.mat");
load("save_net\net2.mat");
load("save_net\net3.mat");
load("save_net\net4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");

%measure algorithm accuracy
%validity = 0;
%for i = 1:numel(data)
%    [combprediction, ~, ~] = combinationFinder(data{i}(:, 2:window+1), thresholdProbability, uniformcases, absnet, net, net2, net3, net4);
%    comb = numtocomb(i);
%    if round(combprediction(1:5))==comb
%        validity = validity+1;
%    else
%        disp(round(combprediction(1:6)))
%        disp(comb)
%    end
%    if rem(i,100) == 100
%        disp(i)
%    end
%end

%effect of brownian noise on accuracy
%for noiseAmplitude = 1:10
%    validity = 0;
%    for i = 1:numel(data)
%        [combprediction, ~, ~] = combinationFinder(data{i}(:, 2:window+1)+(noiseAmplitude/10)*noise()', thresholdProbability, uniformcases, absnet, net, net2, net3, net4);
%        comb = numtocomb(i);
%        if round(combprediction(1:5))==comb
%            validity = validity+1;
%        end
%    end
%    disp(validity)
%end



%checks accuracy of each relative radius prediction
for noiseAmplitude = 1:10
    error1 = [];
    error2 = [];
    error3 = [];
    error4 = [];
    error5 = [];
    for i = 1:numel(data)
        [~, test, testabs] = combinationFinder(data{i}(:, 2:window+1)+(noiseAmplitude/10)*noise()', thresholdProbability, uniformcases, absnet, net, net2, net3, net4);
        comb = numtocomb(i);
        %error1(i) = comb(5) - comb(1) - test(1);
        %error2(i) = comb(5) - comb(2) - test(2);
        %error3(i) = comb(5) - comb(3) - test(3);
        %error4(i) = comb(5) - comb(4) - test(4);
        error5(i) = min(comb) - testabs;
        if rem(i,100) == 100
            disp(i)
        end
    end

    %figure(5*noiseAmplitude-4)
    %histogram(error1)

    %figure(5*noiseAmplitude-3)
    %histogram(error2)

    %figure(5*noiseAmplitude-2)
    %histogram(error3)

    %figure(5*noiseAmplitude-1)
    %histogram(error4)

    figure(5*noiseAmplitude)
    histogram(error5)
end


