function thisModel = rewireNeurons(thisModel, referenceResponse, detectorsActivated)
%REWIRENEURONS 
%-------------------------------Description-------------------------------%
% Computes the reference neuron responses from the weighted sum of the
% connected and activated detector neuron signals
%
%--------------------------------Arguments--------------------------------%
% thisModel:           emergence model object we want to modify and take
%                      its hyperparameters weightMatrix rewireProbability
%                      and initialWeightBounds (class model)
% weightMatrix:        the synaptic weight matrix of the model 
%                      (matrix of size nReferences x nDetectors)
% rewireProbability:   the probability that each activated detector neuron  
%                      has to rewire the least weight connection
%                      (numeric between 0 and 1)
% initialWeightBounds: the initial synaptic weight bounds from which we
%                      choose randomly the values (array of length 2)
% detectorsActivated:  an array containing 1s at indexes of detector 
%                      neurons that are activated and 0s otherwise 
%                      (column array)
% referenceResponse:   an array containing the intesity of each neuron
%                      response to a given ditector neuron activation
%                      (column array)
%
%--------------------------------Function---------------------------------%

    rewireProbability = thisModel.hyperParameters.rewireProbability;
    initialWeightBounds = thisModel.hyperParameters.initialWeightBounds;
    weightMatrix = thisModel.weightMatrix;

    % Find the index of the reference neuron with the maximum signal response
    [~, referenceIndex] = max(referenceResponse);
    detectorWeights = weightMatrix(referenceIndex, :);
    isConnected = (detectorWeights > 0)';
    detectorWeights(~isConnected) = nan;
    [minimumWeight, detectorIndex] = min(detectorWeights);
    
    if minimumWeight < initialWeightBounds(1)
        isRewirable = (detectorsActivated & ~isConnected);
        isRewirable = isRewirable & (rand(size(isRewirable)) < rewireProbability);
        rewireWeight = mean(initialWeightBounds);
        
        if any(isRewirable) 
            rewireIndex = 1 : length(detectorWeights);
            rewireIndex = rewireIndex(isRewirable);
            rewireIndex = rewireIndex(randi(end));
            weightMatrix(referenceIndex, detectorIndex) = 0;
            weightMatrix(referenceIndex, rewireIndex) = rewireWeight;
            thisModel.weightMatrix = weightMatrix;
        end 
    end
end