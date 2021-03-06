function detectorsActivated = activateNeurons(thisModel, theta)
%ACTIVATENEURONS
%-------------------------------Description-------------------------------%
% Computes the activation of detector neurons depending on the input line
% of orientation theta 
%
%--------------------------------Arguments--------------------------------%
% thisModel:             emergence model object we want to modify and take
%                        its hyperparameters activationProbability and 
%                        activationDissipation(class model)
% activationProbability: the probability of a detector neuron to become
%                        activated given that it is stimulated first
%                        (numeric between 0 and 1)
% activationDissipation: a percentage that determines how much dissipation
%                        the activation of neurons will have. Given a group
%                        of properly activated detector neurons we assign 
%                        a number of random activations ouside the group
%                        with the number being a percentage form the total
%                        number of the properly activated neurons 
%                        (numeric between 0 and 1)
% theta:                 the orientation angle of the input line (numeric)
% detectorsActivated:    an array containing 1s at indexes of detector 
%                        neurons that are activated and 0s otherwise 
%                        (column array)
%                     
%--------------------------------Function---------------------------------%

    activationProbability = thisModel.hyperParameters.activationProbability;
    activationDissipation = thisModel.hyperParameters.activationDissipation;
    
    isInRange = stimulateNeurons(thisModel, theta);
    isActivated = isInRange & (rand(size(isInRange)) < activationProbability);
    nDissipations = floor(activationDissipation * sum(isActivated));
    
    if nDissipations >= 2 
        dissipationIndexes = find(isActivated == 0);
        dissipationIndexes = dissipationIndexes(randperm(end, nDissipations));
        isActivated(dissipationIndexes) = 1;
    end
    detectorsActivated = isActivated;
end