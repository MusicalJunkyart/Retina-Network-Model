classdef model
%MODEL An emergent algorithm that learns how to recognize line orientations
% We generate a number of detector neurons randomly located inside a 
% circle of specified radius. We connect each reference neuron with 
% a random group of detectors and set the initial synaptic strength of
% these connections. In the training phase we generate a set of
% lines with random orientations that stimulate nearby detector  
% neurons according to an activation probability and their distance from  
% the line. We calculate the output of the reference neurons and according
% to their responses, we take the strongest and we rewire its connections. 
% Finally we update the weights of the strongest by empowering those 
% that where activaded and depowering those that where not.

    properties
        weightMatrix 
        detectorCoordinates
        hyperParameters = ...
            struct('activationFunction', {}, ...
                   'initialConnectivity', {}, ...
                   'initialWeightBounds', {}, ...
                   'activationProbability', {}, ...
                   'activationDissipation', {}, ...
                   'stimulationDistance', {}, ...
                   'rewireProbability', {}, ...
                   'updateIncrement', {}, ...
                   'updateDecrement', {} ...
                   );
    end
    
    methods
        function thisModel = model(nDetectors, nReferences, hyperParameters)
  
            if nargin == 2
                thisModel.hyperParameters = ...
                    struct( ...
                    'activationFunction', 'ReLU', ...
                    'initialConnectivity', 0.15, ...
                    'initialWeightBounds', [0.3, 0.7], ...
                    'activationProbability', 0.1, ...
                    'activationDissipation', 0.2, ...
                    'stimulationDistance', 0.1, ...
                    'rewireProbability', 0.5, ...    
                    'updateIncrement', 0.9, ...
                    'updateDecrement', 0.1 ...
                    );
                
                thisModel = initialWeightMatrix(thisModel, nDetectors, nReferences);
                thisModel = initialCoordinates(thisModel, nDetectors); 
                    
            elseif nargin == 3
                thisModel.hyperParameters = hyperParameters;
                thisModel = initialWeightMatrix(thisModel, nDetectors, nReferences);
                thisModel = initialCoordinates(thisModel, nDetectors); 
                
            end                
        end
        referenceResponse = computeModel(thisModel, detectorsActivated)
        thisModel = trainModel(thisModel, iterations)
        plotActivation(thisModel, theta)
        plotResponse(thisModel)
        plotOrientation(thisModel)
    end
    
    methods (Access = 'protected')
        thisModel = initialWeightMatrix(thisModel, nDetectors, nReferences)
        thisModel = initialCoordinates(thisModel, nDetectors)
        thisModel = rewireNeurons(thisModel, referenceResponse, detectorsActivated)
        thisModel = updateWeights(thisModel, referenceResponse, detectorsActivated)
        detectorsActivated = activateNeurons(thisModel, theta)  
        detectorsInRange = stimulateNeurons(thisModel, theta)
    end
end

