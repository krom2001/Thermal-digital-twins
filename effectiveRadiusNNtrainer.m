%read file
%[numSensors, numTimeSteps, data] = fileReader();     %comment out for speed once data uploaded
clear B;
clear A;


%format data
load("save_net\uniformcases.mat");
A = zeros(6, numel(data));
B = zeros(6, numel(data));
truerad = zeros(1, numel(data));
for i = 1:numel(data)
    comb = numtocomb(i);
    [perc, ~, ~] = percent(data, comb);
    score = perc./uniformcases(3, 2:end);
    A(:, i) = [score(1), score(2), score(3), score(4), score(5), data{i}(6, 2) - data{i}(2,2)];
    Btemp = zeros(6, 1);
    Btemp(min(numtocomb(i))) = 1;
    B(:, i) = Btemp;
    truerad(i) = min(numtocomb(i));
end

absnet = patternnet(300);               %train nets
absnet = configure(absnet,A);
[absnet,~] = train(absnet,A,B);

%save nets                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "absnet.mat");
%save(outputFile);


abserror = zeros(numel(data), 1);
yabs = absnet(A);                 %generate error histogram
for i = 1:numel(data)
    [~, I] = max(yabs(:, i));
    abserror(i) = (I) - truerad(i);
end
figure(1)
histogram(abserror)

