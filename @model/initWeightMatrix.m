function thisModel = initWeightMatrix(thisModel, nDetectors, nReferences)
%INITWEIGHTMATRIX Initializes the Synaptic Weights of the Neuron Connections
%
    initialWeight = thisModel.hyperParameters.initialWeight;
    initialConnectivity = thisModel.hyperParameters.initialConnectivity;
    
    % Calculate the number of connections each reference neuron 
    % will have and randomly assign them to the detectors
    nConnections = floor(max(1, nDetectors * initialConnectivity));
    weightMatrix = zeros(nReferences, nDetectors);
    
    for i = 1 : nReferences
        detectorIndexes = randi(nDetectors, nConnections, 1);
        weightMatrix(i, detectorIndexes) = initialWeight;
    end
    thisModel.weightMatrix = weightMatrix;
end