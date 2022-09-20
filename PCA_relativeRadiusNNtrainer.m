%load files
clear Y;
clear correctlist;
clear errorlist;
clear X;
load("save_net\uniformcases.mat");
load("save_net\data.mat")
disp('Data loaded')

%noise generation settings
window = 499;
cn = dsp.ColoredNoise('brown', window, 6, 'BoundedOutput', true);
amplitude = 0.1;

%format data      
X1 = zeros(7, numel(data));
X1noisy = zeros(7, numel(data));
X2 = zeros(7, numel(data));
X2noisy = zeros(7, numel(data));
X3 = zeros(7, numel(data));
X3noisy = zeros(7, numel(data));
X4 = zeros(7, numel(data));
X4noisy = zeros(7, numel(data));
Y1 = zeros(11, numel(data));
Y2 = zeros(11, numel(data));
Y3 = zeros(11, numel(data));
Y4 = zeros(11, numel(data));

%save main PCA principal components and minimal element radii as training
%data. Save true differences in element radii as training data
%split cases 1
truediff1 = zeros(1, numel(data));
for ind = 1:numel(data)
   comb = numtocomb(ind);
   truediff1(ind) = comb(5) - comb(4);
   [perc, ~, ~] = percent(data, comb);
   %score = -log(perc./uniformcases(3, 2:end));
   score = perc./uniformcases(3, 2:end);
   coeff = pca(data{ind}(:, 1:window)');
   coeffnoisy = pca(data{ind}(:, 1:window)'+amplitude*cn());
   X1(:, ind) = [coeff(1, 1), coeff(2, 1), coeff(3, 1), coeff(4, 1), coeff(5, 1), coeff(6, 1), min(numtocomb(ind))];
   X1noisy(:,ind) = [coeffnoisy(1, 1), coeffnoisy(2, 1), coeffnoisy(3, 1), coeffnoisy(4, 1), coeffnoisy(5, 1), coeffnoisy(6, 1), min(numtocomb(ind))];
   Y1temp = zeros(11, 1);
   Y1temp(floor(comb(5)-comb(4))+6, 1) = 1;
   Y1(:, ind) = Y1temp;
end

%split cases 2
truediff2 = zeros(1, numel(data));
for ind = 1:numel(data)
   comb = numtocomb(ind);
   truediff2(ind) = comb(5) - comb(3);
   [perc, ~, ~] = percent(data, comb);
   %score = -log(perc./uniformcases(3, 2:end));
   score = perc./uniformcases(3, 2:end);
   coeff = pca(data{ind}(:, 1:window)');
   coeffnoisy = pca(data{ind}(:, 1:window)'+amplitude*cn());
   X2(:, ind) = [coeff(1, 1), coeff(2, 1), coeff(3, 1), coeff(4, 1), coeff(5, 1), coeff(6, 1), min(numtocomb(ind))];
   X2noisy(:,ind) = [coeffnoisy(1, 1), coeffnoisy(2, 1), coeffnoisy(3, 1), coeffnoisy(4, 1), coeffnoisy(5, 1), coeffnoisy(6, 1), min(numtocomb(ind))];
   Y2temp = zeros(11, 1);
   Y2temp(floor(comb(5)-comb(3))+6, 1) = 1;
   Y2(:, ind) = Y2temp;
end

%split cases 3
truediff3 = zeros(1, numel(data));
for ind = 1:numel(data)
   comb = numtocomb(ind);
   truediff3(ind) = comb(5) - comb(2);
   [perc, ~, ~] = percent(data, comb);
   %score = -log(perc./uniformcases(3, 2:end));
   score = perc./uniformcases(3, 2:end);
   coeff = pca(data{ind}(:, 1:window)');
   coeffnoisy = pca(data{ind}(:, 1:window)'+amplitude*cn());
   X3(:, ind) = [coeff(1, 1), coeff(2, 1), coeff(3, 1), coeff(4, 1), coeff(5, 1), coeff(6, 1), min(numtocomb(ind))];
   X3noisy(:,ind) = [coeffnoisy(1, 1), coeffnoisy(2, 1), coeffnoisy(3, 1), coeffnoisy(4, 1), coeffnoisy(5, 1), coeffnoisy(6, 1), min(numtocomb(ind))];
   Y3temp = zeros(11, 1);
   Y3temp(floor(comb(5)-comb(2))+6, 1) = 1;
   Y3(:, ind) = Y3temp;
end

%split cases 4
truediff4 = zeros(1, numel(data));
for ind = 1:numel(data)
   comb = numtocomb(ind);
   truediff4(ind) = comb(5) - comb(1);
   [perc, ~, ~] = percent(data, comb);
   %score = -log(perc./uniformcases(3, 2:end));
   score = perc./uniformcases(3, 2:end);
   coeff = pca(data{ind}(:, 1:window)');
   coeffnoisy = pca(data{ind}(:, 1:window)'+amplitude*cn());
   X4(:, ind) = [coeff(1, 1), coeff(2, 1), coeff(3, 1), coeff(4, 1), coeff(5, 1), coeff(6, 1), min(numtocomb(ind))];
   X4noisy(:,ind) = [coeffnoisy(1, 1), coeffnoisy(2, 1), coeffnoisy(3, 1), coeffnoisy(4, 1), coeffnoisy(5, 1), coeffnoisy(6, 1), min(numtocomb(ind))];
   Y4temp = zeros(11, 1);
   Y4temp(floor(comb(5)-comb(1))+6, 1) = 1;
   Y4(:, ind) = Y4temp;
end

disp('Training data generated')
disp('Training net')

X1 = X2;
pcanet = patternnet(500);               %train net 1
pcanet = configure(pcanet,X1);
[pcanet,~] = train(pcanet,X1,Y1);

pcanet2 = patternnet(500);               %train net 2
pcanet2 = configure(pcanet2,X2);
[pcanet2,~] = train(pcanet2,X2,Y2);

pcanet3 = patternnet(500);               %train net 3
pcanet3 = configure(pcanet3,X3);
[pcanet3,~] = train(pcanet3,X3,Y3);

pcanet4 = patternnet(500);               %train net 4
pcanet4 = configure(pcanet4,X4);
[pcanet4,~] = train(pcanet4,X4,Y4);

%save net                                           %save net on/off
outputDir = "save_net";
outputFile = fullfile(outputDir, "pcanet.mat");
save(outputFile);

%save net                                           %save net on/off
outputDir = "save_net";
outputFile = fullfile(outputDir, "pcanet2.mat");
save(outputFile);

%save net                                           %save net on/off
outputDir = "save_net";
outputFile = fullfile(outputDir, "pcanet3.mat");
save(outputFile);

%save net                                           %save net on/off
outputDir = "save_net";
outputFile = fullfile(outputDir, "pcanet4.mat");
save(outputFile);

%save net                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "bignet.mat");
%save(outputFile);

disp('Training complete')

%load nets                                 %load net on/off
%load("save_net\pcanet.mat");
%load("save_net\pcanet2.mat");
%load("save_net\pcanet3.mat");
%load("save_net\pcanet4.mat");


%print error histograms of resulting neural networks for data with and
%without noise
error1 = zeros(numel(data), 1);
y1 = pcanet(X1);                 %validate 1
for idx = 1:numel(data)
    [~, I] = max(y1(:, idx));
    error1(idx) = (I-6) - truediff1(idx);
end
figure(1)
histogram(error1)

error2 = zeros(numel(data), 1);
y2 = pcanet2(X2);                 %validate 2
for idx = 1:numel(data)
    [~, I] = max(y2(:, idx));
    error2(idx) = (I-6) - truediff2(idx);
end
figure(2)
histogram(error2)

error3 = zeros(numel(data), 1);
y3 = pcanet3(X3);                 %validate 3
for idx = 1:numel(data)
    [~, I] = max(y3(:, idx));
    error3(idx) = (I-6) - truediff3(idx);
end
figure(3)
histogram(error3)

error4 = zeros(numel(data), 1);
y4 = pcanet4(X4);                 %validate 4
for idx = 1:numel(data)
    [~, I] = max(y4(:, idx));
    error4(idx) = (I-6) - truediff4(idx);
    if error4(idx) ==2
        disp(numtocomb(idx))
    end
end
figure(4)
histogram(error4)

%with noise
error5 = zeros(numel(data), 1);
y5 = pcanet(X1noisy);                 %validate 1
for idx = 1:numel(data)
    [~, I] = max(y5(:, idx));
    error5(idx) = (I-6) - truediff1(idx);
end
figure(5)
histogram(error5)

error6 = zeros(numel(data), 1);
y6 = pcanet2(X2noisy);                 %validate 2
for idx = 1:numel(data)
    [~, I] = max(y6(:, idx));
    error6(idx) = (I-6) - truediff2(idx);
end
figure(6)
histogram(error6)

error7 = zeros(numel(data), 1);
y7 = pcanet3(X3noisy);                 %validate 3
for idx = 1:numel(data)
    [~, I] = max(y7(:, idx));
    error7(idx) = (I-6) - truediff3(idx);
end
figure(7)
histogram(error7)

error8 = zeros(numel(data), 1);
y8 = pcanet4(X4noisy);                 %validate 4
for idx = 1:numel(data)
    [~, I] = max(y8(:, idx));
    error8(idx) = (I-6) - truediff4(idx);
    if error8(idx) ==2
        disp(numtocomb(idx))
    end
end
figure(8)
histogram(error8)





