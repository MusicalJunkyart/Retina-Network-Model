function thisModel = rewireNeurons(thisModel, referenceResponse, detectorSignal)
%REWIRENEYRONS
%
    rewireProbability = thisModel.hyperParameters.rewireProbability;
    initialWeight = thisModel.hyperParameters.initialWeight;
    weightMatrix = thisModel.weightMatrix;

    % Find the index of the reference neuron with the maximum signal response
    [~, referenceIndex] = max(referenceResponse);
    detectorWeights = weightMatrix(referenceIndex, :);
    
    % Find the index of the detector neuron with the minimum synaptic  
    % weight that is connected to the maximum reference neuron
    isConnected = (detectorWeights > 0)';
    detectorWeights(~isConnected) = inf;
    [~, detectorIndex] = min(detectorWeights);
    
    % Generate the indexes from the detector neurons that that we can   
    % rewire to from the minimum synaptic weight neuron
    isRewired = (rewireProbability > rand);
    isActivated = detectorSignal;
    rewireIndexArray = 1 : length(detectorWeights);
    rewireIndexArray = rewireIndexArray(isActivated & ~isConnected);
   
    % With some probability given that there are neurons to rewire to 
    % apply the rewiring 
    if isRewired && ~isempty(rewireIndexArray)
        
        randomIndex = randi(length(rewireIndexArray));
        rewireIndex = rewireIndexArray(randomIndex);
        weightMatrix(referenceIndex, detectorIndex) = 0;
        weightMatrix(referenceIndex, rewireIndex) = initialWeight;
        thisModel.weightMatrix = weightMatrix;
    end 
    
end