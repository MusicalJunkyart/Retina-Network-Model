function detectorsInRange = stimulateNeurons(thisModel, theta)
%STIMULATENEURONS
%-------------------------------Description-------------------------------%
% Stimulates the detector neurons that lie nearby the input line of
% oriantations theta. Stimulated neurons are able to get activated 
%
%--------------------------------Arguments--------------------------------%
% thisModel:            emergence model object we want to modify and take
%                       its hyperparameters stimulationDistance and
%                       detectorCoordinates (class model)
% stimulationDistance:  the distance from the input line inside which 
%                       detector neurons become stimulated therfore they 
%                       can become activated (numeric)
% detectorCoordinates:  a matrix containing in column form the coordinates
%                       of the detector neurons 
%                       (matrix of size 2 x nDetectors)  
% detectorsInRange:     an array containing 1s at indexes of detector 
%                       neurons that are stimulated and 0s otherwise 
%                       (column array)
%--------------------------------Function---------------------------------%

    stimulationDistance = thisModel.hyperParameters.stimulationDistance;
    detectorCoordinates = thisModel.detectorCoordinates;
    
    endPointA = [cos(theta) sin(theta)]';
    endPointB = - endPointA;
    distance = lineSegmentSDF(endPointA, endPointB, detectorCoordinates)';
    detectorsInRange = (distance < stimulationDistance);

end

%------------------------------Subfunctions-------------------------------%
function distance = lineSegmentSDF(A, B, P)
%LINESEGMENTSDF Caluclates the least distance of a point to a line segment
    h = min(1, ...
        max(0, ...
       ((P - A)' * (B - A)) ./ ...
       ((B - A)' * (B - A))));
    distance = vecnorm(P - A - h' .* (B - A));
end
