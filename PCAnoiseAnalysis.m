%load files
load("save_net\uniformcases.mat");
load("save_net\data.mat")
load("save_net\pcanet.mat");
load("save_net\pcanet2.mat");
load("save_net\pcanet3.mat");
load("save_net\pcanet4.mat");

%noise settings
window = 499;
cn = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);
errors = zeros(numel(data), 44);
overallnoise = zeros(11,1);

%run for all 11 noise levels
for k = 0:10
    X1noisy = zeros(7, numel(data));
    truediff1 = zeros(1, numel(data));
    truediff2 = zeros(1, numel(data));
    truediff3 = zeros(1, numel(data));
    truediff4 = zeros(1, numel(data));
    avnoise = zeros(1, numel(data));
    %run for all 7776 cases
    for ind = 1:numel(data)
       comb = numtocomb(ind);
       %save true element radii differences
       truediff1(ind) = comb(5) - comb(4);
       truediff2(ind) = comb(5) - comb(3);
       truediff3(ind) = comb(5) - comb(2);
       truediff4(ind) = comb(5) - comb(1);
       %generate noise
       noise = (k/10)*cn();
       %find average noise magnitude
       avnoise(ind) = mean(abs(mean(noise, 1)));
       %find PCA principal component of noisy temperature data
       coeffnoisy = pca(data{ind}(:, 1:window)'+ noise);
       %save principal component and minimum element radius
       X1noisy(:,ind) = [coeffnoisy(1, 1), coeffnoisy(2, 1), coeffnoisy(3, 1), coeffnoisy(4, 1), coeffnoisy(5, 1), coeffnoisy(6, 1), min(numtocomb(ind))];
    end
    
    %run data through neural networks and evaluate prediction errors
    %compared to the true differences in radii. Save errors for each nerual network in the 'errors' matrix
    
    %with noise
    y1 = pcanet(X1noisy);                 %validate 1
    for idx = 1:numel(data)
        [~, I] = max(y1(:, idx));
        errors(idx, 1+4*k) = (I-6) - truediff1(idx);
    end
    
    %with noise
    y2 = pcanet2(X1noisy);                 %validate 2
    for idx = 1:numel(data)
        [~, I] = max(y2(:, idx));
        errors(idx, 2+4*k) = (I-6) - truediff2(idx);
    end
    
    %with noise
    y3 = pcanet3(X1noisy);                 %validate 3
    for idx = 1:numel(data)
        [~, I] = max(y3(:, idx));
        errors(idx, 3+4*k) = (I-6) - truediff3(idx);
    end
    
    %with noise
    y4 = pcanet4(X1noisy);                 %validate 4
    for idx = 1:numel(data)
        [~, I] = max(y4(:, idx));
        errors(idx, 4+4*k) = (I-6) - truediff4(idx);
    end
    
    %calculate average noise amplitude for this noise level
    overallnoise(k+1) = mean(avnoise);
    disp(k);
end

%calculate the number of correctly predicted radii differences for each
%noise level for each neural network
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




