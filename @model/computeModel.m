function referenceResponse = computeModel(thisModel, detectorsActivated)
%COMPUTEMODEL Computes the weighted sum of the activated detectors signal 
%   
    X = detectorsActivated;
    f = activationFunction(thisModel);
    W = thisModel.weightMatrix;
    Y = f(W * X);
    referenceResponse = Y;
end

function functionHandle = activationFunction(thisModel)
%ACTIVATIONFUNCTION
%   
    functionLabel = thisModel.hyperParameters.activationFunction;
    switch functionLabel
        case 'sigmoid'
            functionHandle = @(x) 1/(1 + exp(-x));
        case 'ReLU'
            functionHandle = @(x) max(0, x);
        case 'Linear'
            functionHandle = @(x) x;
        case 'Heaviside'
            functionHandle = @(x) heaviside(x);
        case 'GeLU'
            functionHandle = @(x) x * (1 - qfunc(x));
        case 'SiLU'
            functionHandle = @(x) x/(1 + exp(-x));
        case 'Softplus'
            functionHandle = @(x) log(1 + exp(x));
        otherwise
            functionHandle = @(x) 1/(1 + exp(-x));
            messageText = 'activation function label was not found, sigmoid was used instead';
            warning(messageText);
    end
end
