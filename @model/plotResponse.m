function plotResponse(thisModel)
%PLOTRESPONSE Summary of this function goes here
%   Detailed explanation goes here

    activationProbability = thisModel.hyperParameters.activationProbability;
    weightMatrix = thisModel.weightMatrix;
    nReferences = size(weightMatrix, 1);
    nRows = ceil(sqrt(nReferences));
    nColumns = ceil(sqrt(nReferences));
    thetaRadians = 0 : 0.05 : pi;
    meanResponse = zeros(nReferences, length(thetaRadians));
    
    % Calculate the mean response of each reference neuron  
    % given the activation line angle theta
    for referenceIndex = 1 : nReferences
        for i = 1 : length(thetaRadians)
            
            detectorWeights = weightMatrix(referenceIndex, :)';
            isConnected = (detectorWeights > 0);
            isInRange = stimulateNeurons(thisModel, thetaRadians(i));
            detectorSignal = (isConnected & isInRange);
            
            meanResponse(referenceIndex, i) = dot(detectorWeights, detectorSignal) ...
                                            * activationProbability ...
                                            ./ sum(isInRange);  
        end
    end
    
    % Plot the results of the responses
    fig = figure('Name', 'Reference Neuron Ensemble');
    
    % Normalize the Responses 
    thetaDegrees = 180/pi * thetaRadians;
    meanResponse = rescale(meanResponse(:));
    meanResponse = reshape(meanResponse, nReferences, []);
    
    for referenceIndex = 1 : nReferences
        subplot(nColumns, nRows, referenceIndex);
        
        % Plot parameters
        filterSpan = 4;
        responseLineWidth = 1;
        responseColor = [41, 199, 172] / 255;
        backgroundColor = [35, 41, 49] / 255;
        extremaPointSize = 20;
        extremaPointColor = [255, 111, 126] / 255; 
        extremaPointMarker = '^';
        
        hold on
        % Plot the mean responses
        smoothResponse = smooth(meanResponse(referenceIndex, :), filterSpan);
        plot(thetaDegrees, smoothResponse, ...
                           'Color', responseColor, ...
                           'LineWidth', responseLineWidth);
        
        % Plot the max response point and the anrgle that achives it
        [maxResponse, argmaxIndex] = max(smoothResponse);
        thetaArgmax = thetaDegrees(argmaxIndex);
        textLabel = sprintf('%.1f°', thetaArgmax);
        textOffset = [5.5, 0.06];
        text(thetaArgmax + textOffset(1), ...
             maxResponse + textOffset(2), ...
             textLabel, ...
             'Color', extremaPointColor);
        scatter(thetaArgmax, ...
                maxResponse, ...
                extremaPointSize, ...
                extremaPointColor, ...
                extremaPointMarker);
        set(gca,'Color', backgroundColor);

        % Specify axis limits and ticks
        xlim([0 180])
        ylim([0 1])
        xticks([0, 90, 180])
        xticklabels({'0°', '90°', '180°'})
        yticks([0, 0.5, 1])
        
        % Specify common title, X and Y labels
        ax = axes(fig, 'visible', 'off'); 
        ax.Title.Visible = 'on';
        ax.XLabel.Visible = 'on';
        ax.YLabel.Visible = 'on';
        ylabel(ax, 'Normalized Mean Response');
        xlabel(ax, 'Activation Line Angle');
        title(ax, 'Reference Neurons Responses');
        hold off
    end
end

