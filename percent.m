function [percentage, standdev, minmax] = percent(data, combination)
   %generates scores from the temperature data
   idx = (combination(1, 1)-1)*6^4 + (combination(1, 2)-1)*6^3 + (combination(1, 3)-1)*6^2 + (combination(1, 4)-1)*6 + (combination(1, 5)-1) +1;
   range = abs(data{idx}(2, 2:100) - data{idx}(6, 2:100));
   minmax = mean(range);
   diff1 = abs(data{idx}(2, 2:100) - data{idx}(1, 2:100));
   diff2 = abs(data{idx}(1, 2:100) - data{idx}(3, 2:100));
   diff3 = abs(data{idx}(3, 2:100) - data{idx}(4, 2:100));
   diff4 = abs(data{idx}(4, 2:100) - data{idx}(5, 2:100));
   diff5 = abs(data{idx}(5, 2:100) - data{idx}(6, 2:100));
   std1 = std(diff1./range);
   std2 = std(diff2./range);
   std3 = std(diff3./range);
   std4 = std(diff4./range);
   std5 = std(diff5./range);
   percentage = [mean(diff1./range), mean(diff2./range), mean(diff3./range), mean(diff4./range), mean(diff5./range)];
   standdev = [std1, std2, std3, std4, std5];
end

