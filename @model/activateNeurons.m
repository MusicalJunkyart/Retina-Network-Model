function detectorsActivated = activateNeurons(thisModel, theta)
%ACTIVATENEURONS Generate the detectors activation signal given a line segment as input
%
    activationProbability = thisModel.hyperParameters.activationProbability;
    activationDissipation = thisModel.hyperParameters.activationDissipation;
    
    isInRange = stimulateNeurons(thisModel, theta);
    isActivated = isInRange & (rand(size(isInRange)) < activationProbability);
    nDissipations = floor(activationDissipation * sum(isActivated));
    
    if nDissipations >= 2 
        temp = isActivated(isActivated == 0);
        temp(randperm(end, nDissipations)) = 1;
        isActivated(isActivated == 0) = temp;
    end
    detectorsActivated = isActivated;
end