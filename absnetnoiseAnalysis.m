%load all data and the absnet neural network
load("save_net\absnet.mat")
load("save_net\data.mat")
load("save_net\uniformcases.mat")
clear true;

%settings
window = 20;
cn = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);   %generate noise            
errors = zeros(numel(data), 11);
overallnoise = zeros(11,1);

%apply 11 different magnitudes of brownian noise to the data
for k = 0:10
    X1noisy = zeros(6, numel(data));
    trueabs = zeros(1, numel(data));
    avnoise = zeros(1, numel(data));
    %loop through all 7776 data files
    for ind = 1:numel(data)
       %find the element radii and save the true minimum radius
       comb = numtocomb(ind);
       trueabs(ind) = min(comb);
       %generate noise of required magnitude and find average noise magnitude
       noise = (k/10)*cn();
       avnoise(ind) = mean(abs(mean(noise, 1)));
       %add noise to data
       tempwindow = data{ind}(:, 2:window+1) + noise';
       %calculate temperature across the whole beam and the element scores
       range = abs(tempwindow(6, :) - tempwindow(2, :));
       score1 = mean(abs(tempwindow(2, :) - tempwindow(1, :))./range)/uniformcases(3, 2);
       score2 = mean(abs(tempwindow(1, :) - tempwindow(3, :))./range)/uniformcases(3, 3);
       score3 = mean(abs(tempwindow(3, :) - tempwindow(4, :))./range)/uniformcases(3, 4);
       score4 = mean(abs(tempwindow(4, :) - tempwindow(5, :))./range)/uniformcases(3, 5);
       score5 = mean(abs(tempwindow(5, :) - tempwindow(6, :))./range)/uniformcases(3, 6);
       %save input to neural netowrk
       X1noisy(:,ind) = [score1, score2, score3, score4, score5, data{ind}(6, 2) - data{ind}(2,2)];
    end
    
    %calculate results from neural network
    y1 = absnet(X1noisy);                 
    for idx = 1:numel(data)
        [~, I] = max(y1(:, idx));
        %compare to the neural network prediction to the true minimum and save the error
        errors(idx, k+1) = I - trueabs(idx);
    end
    
    %save the average noise over all of the data samples for each noise
    %magnitude to 'overallnoise'.
    overallnoise(k+1) = mean(avnoise);
    disp(k);
end


%count up the number of correctly identified minimum radii out of 7776
%cases for 11 magnitudes of noise. Saves the number of correctly identified 
%cases to the 'results' vector, such that 'results' can be plotted against 'overallnoise'  
results = zeros(11, 1);
for j = 1:11
    counter = 0;
    for i = 1:7776
        if errors(i,j)==0
            counter = counter + 1;
        end
    end
    disp(j)
    results(j) = counter;
end

%plot a histogram of the errors for the 1st noise level
%0th level - no noise, 10th level - highest noise
%select noise level with 'noiseLevel'
noiseLevel = 1;
histogram(errors(:, noiseLevel+1)*10)
title(sprintf('Histogram of prediction errors for noise level %s', num2str(netnumber)));
xlabel('Error')
ylabel('Frequency')




