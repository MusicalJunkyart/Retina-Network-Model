function functionHandle = activationFunction(functionLabel)
%ACTIVATIONFUNCTION
%   
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
