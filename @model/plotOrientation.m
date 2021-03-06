function plotOrientation(thisModel)
%PLOTORIENTATION
%-------------------------------Description-------------------------------%
% Plots the orientation preference of each reference neuron and the
% distribution of the connected detector neurons in the retina. Also the
% colors follow a gradient to account for the difference in the synaptic
% weights
%
%--------------------------------Function---------------------------------%

    weightMatrix = thisModel.weightMatrix;
    nReferences = size(weightMatrix, 1);
    nRows = ceil(sqrt(nReferences));
    nColumns = ceil(sqrt(nReferences));
    
    fig = figure('Name', 'Reference Neuron Ensemble');
    for referenceIndex = 1 : nReferences
        subplot(nColumns, nRows, referenceIndex);
       
        detectorCoordinates = thisModel.detectorCoordinates;
        isConnected = (weightMatrix(referenceIndex, :) > 0)';

        x1 = detectorCoordinates(1, ~isConnected);
        y1 = detectorCoordinates(2, ~isConnected);
        x2 = detectorCoordinates(1, isConnected);
        y2 = detectorCoordinates(2, isConnected);
        w2 = weightMatrix(referenceIndex, isConnected)';

        hold on
        markerSize1 = 20;
        markerSize2 = 50;
        markerType1 = '.';
        markerType2 = '.';
        markerColor1 = [192, 39, 57] / 255;
        markerColor2 = [41, 199, 172] / 255;
        gradientColor2 = markerColor2 .* interpolate(0.5, 1, w2);
        lineColor = [210, 240, 210] / 255;
        backgroundColor = [35, 41, 49] / 255;

        scatter(x1, y1, markerSize1, markerColor1, markerType1);
        scatter(x2, y2, markerSize2, gradientColor2, markerType2);

        % Plot the input line 
        [thetaRadians, R2] = regressionTLS(x2, y2, w2);
        endPointsX = [cos(thetaRadians), -cos(thetaRadians)]';
        endPointsY = [sin(thetaRadians), -sin(thetaRadians)]';
        plot(endPointsX, endPointsY, '-', ...
                                     'Color', lineColor, ...
                                     'LineWidth', 1.2);
        set(0,'DefaultAxesTitleFontWeight', 'normal');
        labelX = sprintf('è = %.1f°', 180/pi * thetaRadians);
        labelY = sprintf('R² = %.3f', R2);
        %labelTitle = sprintf('index %u', referenceIndex);
        %title(labelTitle)
        xlabel(labelX) 
        ylabel(labelY)
                
        % Specify common title, X and Y labels
        set(gca,'Color', backgroundColor);
        set(gca,'XTick',[], 'YTick', []);
        ax = axes(fig, 'visible', 'off'); 
        ax.Title.Visible = 'on';
        ax.XLabel.Visible = 'on';
        ax.YLabel.Visible = 'on';
        ylabel(ax, 'Coefficient of Determination');
        xlabel(ax, 'Angle Estimation WTLS');
        title(ax, 'Reference Neurons Orientation Preference');
        hold off
    end
    
end

%------------------------------Subfunctions-------------------------------%
function [theta, R2] = regressionTLS(X, Y, W)
%REGRESSIONMSE 
% Computes the weighted total linear regression using gradient decent in
% order to caclulate the line that best fits the data

    P = (W(:) .* [X(:), Y(:)])';
    u = @(theta) [cos(theta), sin(theta)]';
    v = @(theta) [-sin(theta), cos(theta)]';
    grad = @(theta) -u(theta)' * (P * P') * v(theta);

    % iteration parameters
    nIterations = 40;
    thetaThreshold = 1e-4;
    theta = zeros(nIterations, 1);
    theta(2) = pi / nIterations;

    % apply the gradient decent to find the best theta with least error
    for n = 2 : nIterations - 1
        step = abs((theta(n) - theta(n-1)) / (grad(theta(n)) - grad(theta(n-1))));
        theta(n+1) = mod(theta(n) - step * grad(theta(n)), pi);            
        if abs(theta(n+1) - theta(n)) < thetaThreshold
            break
        end
    end
    theta = theta(n+1);

    % modified coefficient of determination
    distanceSquared = vecnorm(P).^2 - (u(theta)' * P).^2;
    SSresidual = sum(distanceSquared);
    SStotal = sum(vecnorm(P - mean(P, 2)).^2);
    R2 = 1 - SSresidual/SStotal;
end

function P = interpolate(A, B, t)
    P = t * B + (1 - t) * A;
end




