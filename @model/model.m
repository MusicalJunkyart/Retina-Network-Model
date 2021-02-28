classdef model
    %MODEL An emergent algorithm that learns how to recognize line orientations
    % We generate a number of detector neurons randomly located inside a 
    % circle of specified radius. We connect each reference neuron with 
    % a random group of detectors and set the initial synaptic strength of
    % these connections. In the training phase we generate a set of
    % lines with random orientations that stimulate nearby detector  
    % neurons according to an activation probability and their distance from  
    % the line. We calculate the output of the reference neurons and according
    % to their response we rewire the connections of the strongest. Finally 
    % we update the connection weights by empowering those that where
    % activaded and depowering those that where not.
   
    properties
        weightMatrix 
        detectorCoordinates
        hyperParameters = ...
            struct('activationFunction', {}, ...
                   'initialConnectivity', {}, ...
                   'initialWeight', {}, ...
                   'activationProbability', {}, ...
                   'activationDistance', {}, ...
                   'rewireProbability', {}, ...
                   'updateIncrement', {}, ...
                   'updateDecrement', {} ...
                   );
    end
    
    methods
        function thisModel = model(nDetectors, nReferences, hyperParameters)
            %EMERGENCEMODEL Construct an instance of this class
            %
            if nargin == 2
                thisModel.hyperParameters = ...
                    struct( ...
                    'activationFunction', 'ReLU', ...
                    'initialConnectivity', 0.15, ...
                    'initialWeight', 0.5, ...
                    'activationProbability', 0.3, ...
                    'activationDistance', 0.3, ...
                    'rewireProbability', 0.5, ...    
                    'updateIncrement', 0.1, ...
                    'updateDecrement', 0.1 ...
                    );
                
                thisModel = initWeightMatrix(thisModel, nDetectors, nReferences);
                thisModel = initCoordinates(thisModel, nDetectors); 
                    
            elseif nargin == 3
                
                thisModel.hyperParameters = hyperParameters;
                thisModel = initWeightMatrix(thisModel, nDetectors, nReferences);
                thisModel = initCoordinates(thisModel, nDetectors); 
            end                
        end
        thisModel = trainModel(thisModel, iterations)
        referenceResponse = computeModel(thisModel, detectorSignal)
        plotActivation(thisModel, theta)
        plotConnections(thisModel);
    end
    
    methods (Access = 'protected')
        thisModel = initWeightMatrix(thisModel, nDetectors, nReferences)
        thisModel = initCoordinates(thisModel, nDetectors)
        thisModel = rewireNeurons(thisModel, referenceResponse, detectorSignal)
        thisModel = updateWeights(thisModel, referenceResponse, detectorSignal)
        detectorsActivated = activateNeurons(thisModel, theta)  
        detectorsInRange = stimulateNeurons(thisModel, theta)
    end
end

