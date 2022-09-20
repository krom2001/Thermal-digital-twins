function [combinations, testrel] = combinationFinderPCA(tempwindow, threshold, uniformcases, absnet, pcanet, pcanet2, pcanet3, pcanet4)
    %identifies combination and confidence level
    %tempwindow must contain first timestep since this is required for absnet to work
    clear possibleMinRadius;
    clear confidenceMinRadius;
    clear relativeRadii;
    clear possible1Radius;
    clear confidence1Radius;
    clear possible2Radius;
    clear confidence2Radius;
    clear possible3Radius;
    clear confidence3Radius;
    clear possible4Radius;
    clear confidence4Radius;
    clear combinations; 
    
    %generate scores
    range = abs(tempwindow(6, :) - tempwindow(2, :));
    score1 = mean(abs(tempwindow(2, :) - tempwindow(1, :))./range)/uniformcases(3, 2);
    score2 = mean(abs(tempwindow(1, :) - tempwindow(3, :))./range)/uniformcases(3, 3);
    score3 = mean(abs(tempwindow(3, :) - tempwindow(4, :))./range)/uniformcases(3, 4);
    score4 = mean(abs(tempwindow(4, :) - tempwindow(5, :))./range)/uniformcases(3, 5);
    score5 = mean(abs(tempwindow(5, :) - tempwindow(6, :))./range)/uniformcases(3, 6);
    %generate pca principle components
    coefficients = pca(tempwindow');

    %find possible effective radii
    effectiveradius = absnet([score1, score2, score3, score4, score5, range(1)]');
    numMinRadius = 0;
    for cell = 1:numel(effectiveradius)
        if effectiveradius(cell)>threshold
            numMinRadius = numMinRadius + 1;
            possibleMinRadius(numMinRadius) = cell;
            confidenceMinRadius(numMinRadius) = effectiveradius(cell);
            inp = [coefficients(1, 1), coefficients(2, 1), coefficients(3, 1), coefficients(4, 1), coefficients(5, 1), coefficients(6, 1), cell]';
            %predict relative radii
            relativeRadii(1:11, 4*numMinRadius-3) = pcanet4(inp);
            [~, I1] = max(relativeRadii(1:11, 4*numMinRadius-3));
            relativeRadii(1:11, 4*numMinRadius-2) = pcanet3(inp);
            [~, I2] = max(relativeRadii(1:11, 4*numMinRadius-2));
            relativeRadii(1:11, 4*numMinRadius-1) = pcanet2(inp);
            [~, I3] = max(relativeRadii(1:11, 4*numMinRadius-1));
            relativeRadii(1:11, 4*numMinRadius) = pcanet(inp);
            [~, I4] = max(relativeRadii(1:11, 4*numMinRadius));
            if effectiveradius(cell) == max(effectiveradius)
                testrel = [I1-6, I2-6, I3-6, I4-6];
            end
        end
    end

    %find all likely combinations
    numCombinations = 1;
    for cell1 = 1:numel(numMinRadius)
        num1Radius = 0;
        num2Radius = 0;
        num3Radius = 0;
        num4Radius = 0;
        for cell3 = 1:11
            if relativeRadii(cell3, 4*cell1-3)>threshold
                num1Radius = num1Radius + 1;
                possible1Radius(num1Radius) = cell3 - 6;
                confidence1Radius(num1Radius) = relativeRadii(cell3, 4*cell1-3);
            end
            if relativeRadii(cell3, 4*cell1-2)>threshold
                num2Radius = num2Radius + 1;
                possible2Radius(num2Radius) = cell3 - 6;
                confidence2Radius(num2Radius) = relativeRadii(cell3, 4*cell1-2);
            end
            if relativeRadii(cell3, 4*cell1-1)>threshold
                num3Radius = num3Radius + 1;
                possible3Radius(num3Radius) = cell3 - 6;
                confidence3Radius(num3Radius) = relativeRadii(cell3, 4*cell1-1);
            end
            if relativeRadii(cell3, 4*cell1)>threshold
                num4Radius = num4Radius + 1;
                possible4Radius(num4Radius) = cell3 - 6;
                confidence4Radius(num4Radius) = relativeRadii(cell3, 4*cell1);
            end
        end
        for cell3 = 1:num1Radius
            for cell4 = 1:num2Radius
                for cell5 = 1:num3Radius
                    for cell6 = 1:num4Radius
                        combinations(numCombinations, 1:5) = [-possible1Radius(cell3), -possible2Radius(cell4), -possible3Radius(cell5), -possible4Radius(cell6), 0];
                        difference = possibleMinRadius(cell1) - min(combinations(numCombinations, 1:5));
                        combinations(numCombinations, 1:5) = combinations(numCombinations, 1:5) + ones(1, 5)*difference;
                        combinations(numCombinations, 6) = confidenceMinRadius(cell1)*confidence1Radius(cell3)*confidence2Radius(cell4)*confidence3Radius(cell5)*confidence4Radius(cell6);
                        for cell7 = 1:5
                            if combinations(numCombinations, cell7)>6
                                combinations(numCombinations, cell7) = 6;
                                %disp('Error: Predicted radius out of bounds')
                            end
                            if combinations(numCombinations, cell7)<1
                                combinations(numCombinations, cell7) = 1;
                                %disp('Error: Predicted radius out of bounds')
                            end
                        end
                        numCombinations = numCombinations + 1;
                    end
                end
            end
        end
    end
    %sort combinations by confidence before outputting
    combinations = sortrows(combinations, 6, 'descend');
end