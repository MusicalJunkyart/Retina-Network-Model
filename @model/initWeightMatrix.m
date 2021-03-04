function thisModel = initWeightMatrix(thisModel, nDetectors, nReferences)
%INITWEIGHTMATRIX Initializes the Synaptic Weights of the Neuron Connections
%
    initialWeightBounds = thisModel.hyperParameters.initialWeightBounds;
    initialConnectivity = thisModel.hyperParameters.initialConnectivity;
    
    % Calculate the number of connections for each reference
    % neuron  and randomly assign them to the detectors
    nConnections = max(1, floor(nDetectors * initialConnectivity));
    weightMatrix = zeros(nReferences, nDetectors);
    
    for referenceIndex = 1 : nReferences
        detectorIndexes = randi(nDetectors, nConnections, 1);
        weightMatrix(referenceIndex, detectorIndexes) = initialWeightBounds(1) ...
                                                      + rand ...
                                                      * diff(initialWeightBounds);
    end
    thisModel.weightMatrix = weightMatrix;
end