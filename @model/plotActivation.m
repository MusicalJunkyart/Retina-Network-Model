function plotActivation(thisModel, thetaDegrees)
%PLOTACTIVATION 
%
    if nargin == 1
        thetaDegrees = 360 * rand; 
        fprintf('Angle theta is choosen %.1f degrees\n', thetaDegrees);
    end
    thetaRadians = 2*pi/360 * thetaDegrees;
    detectorCoordinates = thisModel.detectorCoordinates;
    detectorsActivated = activateNeurons(thisModel, thetaRadians);
    detectorsInRange = stimulateNeurons(thisModel, thetaRadians);
    referenceValues = computeModel(thisModel, detectorsActivated);  
    
    x1 = detectorCoordinates(1, ~detectorsActivated);
    y1 = detectorCoordinates(2, ~detectorsActivated);
    x2 = detectorCoordinates(1, detectorsInRange & ~detectorsActivated);
    y2 = detectorCoordinates(2, detectorsInRange & ~detectorsActivated);
    x3 = detectorCoordinates(1, detectorsActivated);
    y3 = detectorCoordinates(2, detectorsActivated);
    
    hold on
    markerSize = 80;
    markerType1 = '.';
    markerType2 = '.';
    markerType3 = 'x';
    markerColor1 = [192, 39, 57] / 255;
    markerColor2 = [41, 199, 172] / 255;
    markerColor3 = [238, 238, 238] / 255;
    lineColor = [210, 240, 210] / 255;
    backgroundColor = [35, 41, 49] / 255;
    
    scatter(x1, y1, markerSize, markerColor1, markerType1);
    scatter(x2, y2, markerSize, markerColor2, markerType2);
    scatter(x3, y3, markerSize, markerColor3, markerType3, 'LineWidth',1.5);
    
    endPointsX = [cos(thetaRadians), -cos(thetaRadians)]';
    endPointsY = [sin(thetaRadians), -sin(thetaRadians)]';
    plot(endPointsX, endPointsY, '-', 'Color', lineColor, 'LineWidth', 0.9);
    
    N = length(referenceValues);
    pointsX = (1 + 1/8) * ones(1, N);
    pointsY = (2 * (1 : N) - 1) / N - 1;
    AlphaData = rescale(referenceValues);
    for n = 1 : N
        s = scatter(pointsX(n), pointsY(n), 300, [255, 249, 176] / 255, 'square', 'filled');
        if ~isnan(sum(AlphaData(:)))
            s.MarkerFaceAlpha = AlphaData(n);
        end
    end
    
    set(gca,'Color', backgroundColor);
    xmin = -1;
    xmax = 1 + 1/4;
    ymin = -1;
    ymax = 1;
    axis([xmin xmax ymin ymax])
    axis manual
    hold off

end

