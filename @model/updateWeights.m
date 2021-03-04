function thisModel = updateWeights(thisModel, referenceResponse, detectorsActivated)
%UPDATEWEIGHTS Updates the weights of the max reference response neuron depending on the activation of the connected detectors
%
    updateIncrement = thisModel.hyperParameters.updateIncrement;
    updateDecrement = thisModel.hyperParameters.updateDecrement;
    
    % Select the detectors of the reference neuron with the max response
    % and update their weights
    [~, referenceIndex] = max(referenceResponse);
    detectorWeights = thisModel.weightMatrix(referenceIndex, :)';
    isConnected = (detectorWeights > 0);
    isActivated = (detectorsActivated > 0);
    group1 = (isConnected & isActivated);
    group2 = (isConnected & ~isActivated);
    weightBounds = [0 1];
    
    detectorWeights(group1) = interpolate(detectorWeights(group1), ...
                                          weightBounds(2), ...
                                          updateIncrement);
    detectorWeights(group2) = interpolate(detectorWeights(group2), ...
                                          weightBounds(1), ...
                                          updateDecrement);
    thisModel.weightMatrix(referenceIndex, :) = detectorWeights;
end

function P = interpolate(A, B, t)
    P = t * B + (1 - t) * A;
end