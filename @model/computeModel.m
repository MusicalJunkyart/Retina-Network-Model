function referenceResponse = computeModel(thisModel, detectorsActivated)
%COMPUTEMODEL 
%-------------------------------Description-------------------------------%
% Computes the reference neuron responses from the weighted sum of the
% connected and activated detector neuron signals
%
%--------------------------------Arguments--------------------------------%
% thisModel:           emergence model object we want to modify and take
%                      its hyperparameters weightMatrix and
%                       activationFunction (class model)
% weightMatrix:        the synaptic weight matrix of the model 
%                      (matrix of size nReferences x nDetectors)
% activationFunction:  the activation function that is used in order to
%                      calculate the reference responses (string)
% detectorsActivated:  an array containing 1s at indexes of detector 
%                      neurons that are activated and 0s otherwise 
%                      (column array)
% referenceResponse:   an array containing the intesity of each neuron
%                      response to a given ditector neuron activation
%                      (column array)
%
%--------------------------------Function---------------------------------%

    X = detectorsActivated;
    f = activationFunction(thisModel);
    W = thisModel.weightMatrix;
    Y = f(W * X);
    referenceResponse = Y;
end

%------------------------------Subfunctions-------------------------------%
function functionHandle = activationFunction(thisModel)
%ACTIVATIONFUNCTION Contains different activation function handles

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
