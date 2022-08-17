function [comb] = numtocomb(idx)
    %converts the index of the file into its radius combination
    %eg: file 311 => [1 2 3 4 5] => 10mm, 20mm, 30mm, 40mm, 50mm
    comb = [1 1 1 1 1] + mod(floor((idx-1) ./ 6 .^ (4:-1:0)), 6);
end