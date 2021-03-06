function thisModel = initialWeightMatrix(thisModel, nDetectors, nReferences)
%INITIALWEIGHTMATRIX 
%-------------------------------Description-------------------------------%
% Computes the initial synaptic weight matrix of the connections. The
% number of the connections is determined by the initial connectivity and
% the synaptic weight values are choosen randomly within the initial weight 
% bounds
%
%--------------------------------Arguments--------------------------------%
% thisModel:            emergence model object we want to modify and take
%                       its hyperparameters initialWeightBounds and 
%                       initialConnectivity (class model)
% initialWeightBounds:  the initial synaptic weight bounds from which we
%                       choose randomly the values (array of length 2)
% initialConnectivity:  the initial percentage of connections that each
%                       reference neuron will have from all the detector
%                       neurons population (numeric between 0 and 1)
% nDetectors:           the number of detector neurons (numeric)
% nReferences:          the number of reference neurons (numeric)
% 
%--------------------------------Function---------------------------------%

    initialWeightBounds = thisModel.hyperParameters.initialWeightBounds;
    initialConnectivity = thisModel.hyperParameters.initialConnectivity;
    
    % calculate the number of connections for each reference
    % neuron  and randomly assign them to the detectors
    nConnections = max(1, floor(nDetectors * initialConnectivity));
    weightMatrix = zeros(nReferences, nDetectors);
    
    for referenceIndex = 1 : nReferences     
        detectorIndexes = randi(nDetectors, nConnections, 1);
        initialWeight = interpolate(initialWeightBounds(1), ...
                                    initialWeightBounds(2), ...
                                    rand);
        weightMatrix(referenceIndex, detectorIndexes) = initialWeight;
                                                             
    end
    thisModel.weightMatrix = weightMatrix;
end

%------------------------------Subfunctions-------------------------------%
function P = interpolate(A, B, t)
    P = t * B + (1 - t) * A;
end
