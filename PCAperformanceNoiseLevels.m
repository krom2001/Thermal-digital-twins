%noise settings
window = 499;
thresholdProbability = 0.3;

%generate brownian noise
clear true;
noise = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);

%load files
load("save_net\data.mat")
load("save_net\pcanet.mat");
load("save_net\pcanet2.mat");
load("save_net\pcanet3.mat");
load("save_net\pcanet4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");

%generated graph of effect of brownian noise on prediction accuracy
resy = zeros(11,1);
resx = zeros(11,1);
%try all noise levels
for noiseAmplitude = 0:10
    %counter for number of correct cases
    validity = 0;
    casenoise = zeros(1, numel(data));
    %loop through all cases
    for i = 1:numel(data)
        %generate noise
        component = (noiseAmplitude/10)*noise()';
        %predict element radii
        [combprediction, ~] = combinationFinderPCA(data{i}(:, 2:window+1)+component, thresholdProbability, uniformcases, absnet, pcanet, pcanet2, pcanet3, pcanet4);
        comb = numtocomb(i);
        %calculate mean noise amplitude
        casenoise(i) = mean(abs(mean(component,2)));
        %count case of prediction is correct
        if round(combprediction(1:5))==comb
            validity = validity+1;
        end
    end
    %find mean noise amplitude over 7776 cases
    resx(noiseAmplitude+1) = mean(casenoise);
    resy(noiseAmplitude+1) = validity;
    disp(noiseAmplitude)
end
%plot preformance graph
plot(resx, resy)
xlabel(['Average noise amplitude/ ' char(176) 'C'])
ylabel('Number of correctly predicted radii combinations')
title('Performance of algorithm with different levels of noise')






