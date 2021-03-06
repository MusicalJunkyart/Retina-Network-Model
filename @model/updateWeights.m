function thisModel = updateWeights(thisModel, referenceResponse, detectorsActivated)
%UPDATEWEIGHTS 
%-------------------------------Description-------------------------------%
% Updates the synaptic weights of the connections of the reference neuron 
% with the strongst response from a given input 
%
%--------------------------------Arguments--------------------------------%
% thisModel:           emergence model object we want to modify and take
%                      its hyperparameters weightMatrix updateIncrement and
%                      updateDecrement(class model)
% updateIncrement:     a number that determines the speed of the increment
%                      of the activated synaptic weights 
%                      (numeric between 0 and 1)
% updateDecrement:     a number that determines the speed of the decrement
%                      of the deactivated synaptic weights 
%                      (numeric between 0 and 1)   
% weightMatrix:        the synaptic weight matrix of the model 
%                      (matrix of size nReferences x nDetectors)
% detectorsActivated:  an array containing 1s at indexes of detector 
%                      neurons that are activated and 0s otherwise 
%                      (column array)
% referenceResponse:   an array containing the intesity of each neuron
%                      response to a given detector neuron activation
%                      (column array)
%
%--------------------------------Function---------------------------------%

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

%------------------------------Subfunctions-------------------------------%
function P = interpolate(A, B, t)
    P = t * B + (1 - t) * A;
end