function thisModel = trainModel(thisModel, iterations)
%TRAINMODEL
%-------------------------------Description-------------------------------%
% Computes the training of the model by generating random lines as inputs 
% and altering the connections and weights of the model
%
%--------------------------------Arguments--------------------------------%
% thisModel:     emergence model object we want to train and modify
%                (class model)
% iterations:    the number of the training steps (numeric)
%
%--------------------------------Function---------------------------------%

    for i = 1 : iterations
        theta = pi * rand;
        detectorsActivated = activateNeurons(thisModel, theta);
        
        if any(detectorsActivated)
            referenceResponse = computeModel(thisModel, detectorsActivated);
            thisModel = rewireNeurons(thisModel, referenceResponse, detectorsActivated);    
            thisModel = updateWeights(thisModel, referenceResponse, detectorsActivated);
        end
    end
    
end

