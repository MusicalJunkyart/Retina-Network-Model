function plotActivation(thisModel, thetaDegrees)
%PLOTACTIVATION Plot the stimulated and activated detector neurons given an input line and the reference responses 
%-------------------------------Description-------------------------------%
% Plot the stimulated and activated distribution of detector neurons 
% given an input line and a colorbar of the reference responses 
%
%--------------------------------Function---------------------------------%

    if nargin == 1
        thetaDegrees = 180 * rand; 
        fprintf('Angle theta is choosen %.1f degrees\n', thetaDegrees);
    end
    thetaRadians = pi/180 * thetaDegrees;
    detectorCoordinates = thisModel.detectorCoordinates;
    isActivated = activateNeurons(thisModel, thetaRadians);
    isInRange = stimulateNeurons(thisModel, thetaRadians);
    referenceResponse = computeModel(thisModel, isActivated);  
    
    % Take the coordinates of the 3 groups of detector neurons
    x1 = detectorCoordinates(1, ~isActivated);
    y1 = detectorCoordinates(2, ~isActivated);
    x2 = detectorCoordinates(1, isInRange & ~isActivated);
    y2 = detectorCoordinates(2, isInRange & ~isActivated);
    x3 = detectorCoordinates(1, isActivated);
    y3 = detectorCoordinates(2, isActivated);
    
    figure('Name', 'Detector Layer Activation');
    hold on
    % Set the figure parameters
    detectorSize = 80;
    referenceSize = 300;
    detectorMarker1 = '.';
    detectorMarker2 = '.';
    detectorMarker3 = 'x';
    referenceMarker = 'square';
    detectorColor1 = [192, 39, 57] / 255;
    detectorColor2 = [41, 199, 172] / 255;
    detectorColor3 = [238, 238, 238] / 255;
    lineColor = [210, 240, 210] / 255;
    backgroundColor = [35, 41, 49] / 255;
    
    % Plot the 3 sets of detector neurons
    scatter(x1, y1, detectorSize, detectorColor1, detectorMarker1);
    scatter(x2, y2, detectorSize, detectorColor2, detectorMarker2);
    scatter(x3, y3, detectorSize, detectorColor3, detectorMarker3, 'LineWidth',1.5);
    
    % Plot the input line 
    endPointsX = [cos(thetaRadians), -cos(thetaRadians)]';
    endPointsY = [sin(thetaRadians), -sin(thetaRadians)]';
    plot(endPointsX, endPointsY, '-', 'Color', lineColor, 'LineWidth', 0.9);
    
    % Plot the reference neurons responses
    nReferences = length(referenceResponse);
    pointsX = 1.125 * ones(1, nReferences);
    pointsY = (2 * (1:nReferences) - 1)/nReferences - 1;
    normalizedResponse = rescale(referenceResponse);
    
    for i = 1 : nReferences
        if ~isnan(sum(normalizedResponse))
            t = normalizedResponse(i);
            referenceColorRGB = interpolate(detectorColor1, detectorColor2, t);
            referenceColorRGB = interpolate(backgroundColor, referenceColorRGB, t);
        end
        scatter(pointsX(i), pointsY(i), referenceSize, referenceColorRGB, referenceMarker, 'filled');
    end
    
    % Set the limits of the figure window
    set(gca,'Color', backgroundColor);
    xmin = -1;
    xmax = 1 + 1/4;
    ymin = -1;
    ymax = 1;
    axis([xmin xmax ymin ymax])
    axis manual
    hold off
end

%------------------------------Subfunctions-------------------------------%
function P = interpolate(A, B, t)
    P = t * B + (1 - t) * A;
end


