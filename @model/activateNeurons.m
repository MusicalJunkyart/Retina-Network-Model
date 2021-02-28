function detectorSignal = activateNeurons(thisModel, theta)
%STIMULATENEURONS
%
    activationProbability = thisModel.hyperParameters.activationProbability;
    isInRange = stimulateNeurons(thisModel, theta);
    isActivated = (rand(size(isInRange)) < activationProbability);
    detectorSignal = (isInRange & isActivated);
end