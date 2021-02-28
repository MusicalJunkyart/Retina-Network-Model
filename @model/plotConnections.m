function plotConnections(thisModel)
%PLOTCONNECTIONS Summary of this function goes here
%   Detailed explanation goes here

    activationProbability = thisModel.hyperParameters.activationProbability;
    weightMatrix = thisModel.weightMatrix;
   
    nReferences = size(weightMatrix, 1);
    nRows = ceil(sqrt(nReferences));
    nColumns = ceil(sqrt(nReferences));
    thetaValues = 0 : 0.05 : 2 * pi;
    
    for n = 1 : nReferences
        subplot(nColumns, nRows, n);
        
        %
        detectorCoordinates = thisModel.detectorCoordinates;
        detectorsConnected = (weightMatrix(n, :) > 0)';

        x1 = detectorCoordinates(1, ~detectorsConnected);
        y1 = detectorCoordinates(2, ~detectorsConnected);
        x2 = detectorCoordinates(1, detectorsConnected);
        y2 = detectorCoordinates(2, detectorsConnected);

        hold on
        markerSize1 = 20;
        markerSize2 = 50;
        markerType1 = '.';
        markerType2 = '.';
        markerColor1 = [192, 39, 57] / 255;
        markerColor2 = [41, 199, 172] / 255;
        backgroundColor = [35, 41, 49] / 255;

        scatter(x1, y1, markerSize1, markerColor1, markerType1);
        scatter(x2, y2, markerSize2, markerColor2, markerType2);

        set(gca,'Color', backgroundColor);
        xmin = -1;
        xmax = 1;
        ymin = -1;
        ymax = 1;
        axis([xmin xmax ymin ymax])
        %axis square
        hold off
        %}
        
        %{
        expectedReferenceResponse = zeros(size(thetaValues));
        for m = 1 : length(thetaValues)
            detectorWeights = weightMatrix(n, :)';
            isConnected = (detectorWeights > 0);
            isInRange = stimulateNeurons(thisModel, thetaValues(m));
            detectorSignal = (isConnected & isInRange);
            expectedReferenceResponse(m) = dot(detectorWeights, detectorSignal) ...
                                         * activationProbability ...
                                         ./ sum(isInRange);                                     
        end
        
        expectedReferenceResponse = smooth(expectedReferenceResponse);
        expectedReferenceResponse = expectedReferenceResponse/max(expectedReferenceResponse);
        polarplot(thetaValues, expectedReferenceResponse);
        %}
    end
end

