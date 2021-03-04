function thisModel = trainModel(thisModel, iterations)
%TRAINMODEL
%
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

