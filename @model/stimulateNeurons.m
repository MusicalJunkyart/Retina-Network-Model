function detectorsInRange = stimulateNeurons(thisModel, theta)
%STIMULATENEURONS
%
    activationDistance = thisModel.hyperParameters.activationDistance;
    detectorCoordinates = thisModel.detectorCoordinates;
    
    endPointA = [cos(theta) sin(theta)]';
    endPointB = - endPointA;
    distance = lineSegmentSDF(endPointA, endPointB, detectorCoordinates)';
    detectorsInRange = (distance < activationDistance);

    function distance = lineSegmentSDF(A, B, P)
    %LINESEGMENTSDF Caluclates the least distance of a point to a line segment
    %
        h = min(1, ...
            max(0, ...
           ((P - A)' * (B - A)) ./ ...
           ((B - A)' * (B - A))));
        distance = vecnorm(P - A - h' .* (B - A));
    end
end

