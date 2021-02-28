function referenceResponse = computeModel(thisModel, detectorSignal)
%COMPUTEMODEL Computes the weighted sum of the activated neuron signals 
%   
    X = detectorSignal;
    f = activationFunction(thisModel.hyperParameters.activationFunction);
    W = thisModel.weightMatrix;
    Y = f(W * X);
    referenceResponse = Y;
end

