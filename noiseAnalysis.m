%load files
load("save_net\uniformcases.mat");
load("save_net\data.mat")
load("save_net\net.mat");
load("save_net\net2.mat");
load("save_net\net3.mat");
load("save_net\net4.mat");

%noise settings
window = 20;
cn = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);
errors = zeros(numel(data), 44);
overallnoise = zeros(11,1);

%run for all 11 noise levels
for k = 0:10
    X1noisy = zeros(6, numel(data));
    truediff1 = zeros(1, numel(data));
    truediff2 = zeros(1, numel(data));
    truediff3 = zeros(1, numel(data));
    truediff4 = zeros(1, numel(data));
    avnoise = zeros(1, numel(data));
    %run for all 7776 cases
    for ind = 1:numel(data)
        %save true radii differences between elements
       comb = numtocomb(ind);
       truediff1(ind) = comb(5) - comb(4);
       truediff2(ind) = comb(5) - comb(3);
       truediff3(ind) = comb(5) - comb(2);
       truediff4(ind) = comb(5) - comb(1);
       %generate noise
       noise = (k/10)*cn();
       %calculate average noise amplitude
       avnoise(ind) = mean(abs(mean(noise, 1)));
       tempwindow = data{ind}(:, 2:window+1) + noise';
       %calculate scores and temperature difference across beam
       range = abs(tempwindow(6, :) - tempwindow(2, :));
       score1 = mean(abs(tempwindow(2, :) - tempwindow(1, :))./range)/uniformcases(3, 2);
       score2 = mean(abs(tempwindow(1, :) - tempwindow(3, :))./range)/uniformcases(3, 3);
       score3 = mean(abs(tempwindow(3, :) - tempwindow(4, :))./range)/uniformcases(3, 4);
       score4 = mean(abs(tempwindow(4, :) - tempwindow(5, :))./range)/uniformcases(3, 5);
       score5 = mean(abs(tempwindow(5, :) - tempwindow(6, :))./range)/uniformcases(3, 6);
       %save data in matrix
       X1noisy(:,ind) = [score1, score2, score3, score4, score5, min(numtocomb(ind))];
    end
    
    %run data through neural networks for identifying differences in radii
    %between elements. Compare results to true values and save errors for
    %each noise level for each neural network

    %with noise
    y1 = net(X1noisy);                 %validate 1
    for idx = 1:numel(data)
        [~, I] = max(y1(:, idx));
        errors(idx, 4+4*k) = (I-6) - truediff1(idx);
    end
    
    %with noise
    y2 = net2(X1noisy);                 %validate 2
    for idx = 1:numel(data)
        [~, I] = max(y2(:, idx));
        errors(idx, 3+4*k) = (I-6) - truediff2(idx);
    end
    
    %with noise
    y3 = net3(X1noisy);                 %validate 3
    for idx = 1:numel(data)
        [~, I] = max(y3(:, idx));
        errors(idx, 2+4*k) = (I-6) - truediff3(idx);
    end
    
    %with noise
    y4 = net4(X1noisy);                 %validate 4
    for idx = 1:numel(data)
        [~, I] = max(y4(:, idx));
        errors(idx, 1+4*k) = (I-6) - truediff4(idx);
    end
    
    %calculate average noise magnitude for noise level
    overallnoise(k+1) = mean(avnoise);
    disp(k);
end

%calculate number of radii differences identified correctly
results = zeros(44, 1);
for j = 1:44
    counter = 0;
    for i = 1:7776
        if errors(i,j)==0
            counter = counter + 1;
        end
    end
    disp(j)
    results(j) = counter;
end

disp(overallnoise);
disp(results);



