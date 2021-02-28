function thisModel = updateWeights(thisModel, referenceResponse, detectorSignal)
%UPDATEWEIGHTS
%
    updateIncrement = thisModel.hyperParameters.updateIncrement;
    updateDecrement = thisModel.hyperParameters.updateDecrement;
    [~, referenceIndex] = max(referenceResponse);
    detectorWeights = thisModel.weightMatrix(referenceIndex, :)';
    isConnected = (detectorWeights > 0);
    isActivated = (detectorSignal > 0);
    detectorWeights(isActivated & isConnected) = detectorWeights(isActivated & isConnected) ...
                                                * (1 - updateIncrement) ... 
                                                + updateIncrement;
    detectorWeights(~isActivated & isConnected) = detectorWeights(~isActivated & isConnected) ...
                                                 * (1 - updateDecrement);
    thisModel.weightMatrix(referenceIndex, :) = detectorWeights;
end