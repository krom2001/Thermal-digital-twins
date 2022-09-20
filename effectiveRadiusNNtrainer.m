%load data files
load("save_net\data.mat")
load("save_net\uniformcases.mat");
clear B;
clear A;


%format data
A = zeros(6, numel(data));
B = zeros(6, numel(data));
truerad = zeros(1, numel(data));
for i = 1:numel(data)
    %finf element radii and calculate element scores
    comb = numtocomb(i);
    [perc, ~, ~] = percent(data, comb);
    score = perc./uniformcases(3, 2:end);
    %save scores and temperature difference across beam for neural network
    %training input
    A(:, i) = [score(1), score(2), score(3), score(4), score(5), data{i}(6, 2) - data{i}(2,2)];
    Btemp = zeros(6, 1);
    %save true minimum radii for neural network training data
    Btemp(min(numtocomb(i))) = 1;
    B(:, i) = Btemp;
    %save minimum element radius
    truerad(i) = min(numtocomb(i));
end

absnet = patternnet(300);               %train neural networks
absnet = configure(absnet,A);
[absnet,~] = train(absnet,A,B);

%save neural networks    
outputDir = "save_net";
outputFile = fullfile(outputDir, "absnet.mat");
save(outputFile);


abserror = zeros(numel(data), 1);
yabs = absnet(A);                 %generate error histogram to show results of training
for i = 1:numel(data)
    [~, I] = max(yabs(:, i));
    abserror(i) = (I) - truerad(i);
end
figure(1)
histogram(abserror)

