function thisModel = rewireNeurons(thisModel, referenceResponse, detectorsActivated)
%REWIRENEURONS Rewires the minimnum strenght connection of the strogest response reference neuron
%
    rewireProbability = thisModel.hyperParameters.rewireProbability;
    initialWeightBounds = thisModel.hyperParameters.initialWeightBounds;
    weightMatrix = thisModel.weightMatrix;

    % Find the index of the reference neuron with the maximum signal response
    [~, referenceIndex] = max(referenceResponse);
    detectorWeights = weightMatrix(referenceIndex, :);
    isConnected = (detectorWeights > 0)';
    detectorWeights(~isConnected) = nan;
    [minWeight, detectorIndex] = min(detectorWeights);
    
    if minWeight < initialWeightBounds(1)
        isRewirable = (detectorsActivated & ~isConnected);
        isRewirable = isRewirable & (rand(size(isRewirable)) < rewireProbability);
        rewireWeight = mean(initialWeightBounds);
        
        if any(isRewirable) 
            indexes = 1 : length(detectorWeights);
            indexes = indexes(isRewirable);
            rewireIndex = indexes(randi(end));
            weightMatrix(referenceIndex, detectorIndex) = 0;
            weightMatrix(referenceIndex, rewireIndex) = rewireWeight;
            thisModel.weightMatrix = weightMatrix;
        end 
    end
end