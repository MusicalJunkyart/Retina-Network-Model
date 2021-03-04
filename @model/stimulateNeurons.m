function detectorsInRange = stimulateNeurons(thisModel, theta)
%STIMULATENEURONS Stimulated the detector neurons that are near the input line
% Stimulation of neurons makes them capable of being activated 

    stimulationDistance = thisModel.hyperParameters.stimulationDistance;
    detectorCoordinates = thisModel.detectorCoordinates;
    
    endPointA = [cos(theta) sin(theta)]';
    endPointB = - endPointA;
    distance = lineSegmentSDF(endPointA, endPointB, detectorCoordinates)';
    detectorsInRange = (distance < stimulationDistance);

end

function distance = lineSegmentSDF(A, B, P)
%LINESEGMENTSDF Caluclates the least distance of a point to a line segment
%
    h = min(1, ...
        max(0, ...
       ((P - A)' * (B - A)) ./ ...
       ((B - A)' * (B - A))));
    distance = vecnorm(P - A - h' .* (B - A));
end
