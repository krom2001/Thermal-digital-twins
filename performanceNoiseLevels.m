%settings
window = 20;    %number of time steps input into function
thresholdProbability = 0.3;

%generate brownian noise
clear true;
noise = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);

%load nets                          
load("save_net\data.mat")
load("save_net\net.mat");
load("save_net\net2.mat");
load("save_net\net3.mat");
load("save_net\net4.mat");
load("save_net\absnet.mat")
load("save_net\uniformcases.mat");


%generates graph of effect of brownian noise on beam identification accuracy
resy = zeros(11,1);
resx = zeros(11,1);
%run for 11 levels of noise
for noiseAmplitude = 0:10
    %set counter of number of correct cases
    validity = 0;
    casenoise = zeros(1, numel(data));
    %run all 7776 cases
    for i = 1:numel(data)
        %generate noise
        component = (noiseAmplitude/10)*noise()';
        %predict combination
        [combprediction, ~] = combinationFinder(data{i}(:, 2:window+1)+component, thresholdProbability, uniformcases, absnet, net, net2, net3, net4);
        comb = numtocomb(i);
        %calculate average noise amplitude
        casenoise(i) = mean(abs(mean(component,2)));
        %check if prediction is correct
        if round(combprediction(1:5))==comb
            validity = validity+1;
        end
    end
    %find average noise amplitude over 7776 cases for given level of noise
    resx(noiseAmplitude+1) = mean(casenoise);
    %save number of correctly identified cases
    resy(noiseAmplitude+1) = validity;
    disp(noiseAmplitude)
end
%plot performance graph
plot(resx, resy)
xlabel(['Average noise amplitude/ ' char(176) 'C'])
ylabel('Number of correctly predicted radii combinations')
title('Performance of algorithm with different levels of noise')



