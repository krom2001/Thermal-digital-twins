%read file
%[numSensors, numTimeSteps, data] = fileReader();         %comment out for speed once data uploaded
clear Y;
clear correctlist;
clear errorlist;
clear X;
disp('Data loaded')

%format data      
X1 = zeros(6, numel(data));       
X2 = zeros(6, numel(data));
X3 = zeros(6, numel(data));
X4 = zeros(6, numel(data));
Y1 = zeros(11, numel(data));
Y2 = zeros(11, numel(data));
Y3 = zeros(11, numel(data));
Y4 = zeros(11, numel(data));
load("save_net\uniformcases.mat");

%split cases 1
truediff1 = zeros(1, numel(data));
for ind = 1:numel(data)
   comb = numtocomb(ind);
   truediff1(ind) = comb(5) - comb(4);
   [perc, ~, ~] = percent(data, comb);
   %score = -log(perc./uniformcases(3, 2:end));
   score = perc./uniformcases(3, 2:end);
   X1(:, ind) = [score(1), score(2), score(3), score(4), score(5), min(numtocomb(ind))];
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
   X2(:, ind) = [score(1), score(2), score(3), score(4), score(5), min(numtocomb(ind))];
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
   X3(:, ind) = [score(1), score(2), score(3), score(4), score(5), min(numtocomb(ind))];
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
   X4(:, ind) = [score(1), score(2), score(3), score(4), score(5), min(numtocomb(ind))];
   Y4temp = zeros(11, 1);
   Y4temp(floor(comb(5)-comb(1))+6, 1) = 1;
   Y4(:, ind) = Y4temp;
end

disp('Training data generated')
disp('Training net')

X1 = X2;
net = patternnet(300);               %train net 1
net = configure(net,X1);
[net,~] = train(net,X1,Y1);

net2 = patternnet(300);               %train net 2
net2 = configure(net2,X2);
[net2,~] = train(net2,X2,Y2);

net3 = patternnet(300);               %train net 3
net3 = configure(net3,X3);
[net3,~] = train(net3,X3,Y3);

net4 = patternnet(300);               %train net 4
net4 = configure(net4,X4);
[net4,~] = train(net4,X4,Y4);

%save net                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "net.mat");
%save(outputFile);

%save net                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "net2.mat");
%save(outputFile);

%save net                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "net3.mat");
%save(outputFile);

%save net                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "net4.mat");
%save(outputFile);

%save net                                           %save net on/off
%outputDir = "save_net";
%outputFile = fullfile(outputDir, "bignet.mat");
%save(outputFile);

disp('Training complete')

%load nets                                 %load net on/off
%load("save_net\net.mat");
%load("save_net\net2.mat");
%load("save_net\net3.mat");
%load("save_net\net4.mat");


error1 = zeros(numel(data), 1);
y1 = net(X3);                 %validate 1
for idx = 1:numel(data)
    [~, I] = max(y1(:, idx));
    error1(idx) = (I-6) - truediff1(idx);
end
figure(1)
histogram(error1)

error2 = zeros(numel(data), 1);
y2 = net2(X2);                 %validate 2
for idx = 1:numel(data)
    [~, I] = max(y2(:, idx));
    error2(idx) = (I-6) - truediff2(idx);
end
figure(2)
histogram(error2)

error3 = zeros(numel(data), 1);
y3 = net3(X3);                 %validate 3
for idx = 1:numel(data)
    [~, I] = max(y3(:, idx));
    error3(idx) = (I-6) - truediff3(idx);
end
figure(3)
histogram(error3)

error4 = zeros(numel(data), 1);
y4 = net4(X4);                 %validate 4
for idx = 1:numel(data)
    [~, I] = max(y4(:, idx));
    error4(idx) = (I-6) - truediff4(idx);
    if error4(idx) ==2
        disp(numtocomb(idx))
    end
end
figure(4)
histogram(error4)





