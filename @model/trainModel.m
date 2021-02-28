function thisModel = trainModel(thisModel, iterations)
%TRAINMODEL
%
    for i = 1 : iterations
        theta = pi * rand;
        detectorSignal = activateNeurons(thisModel, theta);
        
        if any(detectorSignal)
            referenceResponse = computeModel(thisModel, detectorSignal);
            thisModel = rewireNeurons(thisModel, referenceResponse, detectorSignal);    
            thisModel = updateWeights(thisModel, referenceResponse, detectorSignal);
        end
    end
    
end

