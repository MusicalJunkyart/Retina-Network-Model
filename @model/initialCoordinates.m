function thisModel = initialCoordinates(thisModel, nDetectors)
%INITIALCOORDINATES 
%-------------------------------Description-------------------------------%
% Computes the initial positions of the detector neurons with the following
% algorithm. 
% Generate N iid random vectors following standard normal gaussian 
% distribution of D dimentions. Normalize the random vectors to get a 
% uniform distribution on the surface of the ball. Generate N iid 
% random radiuses R < Rs with probability equal to the volume of a ball
% of radius R to the total volume of radius Rs. Scale the normalized random
% vectors to get the uniform distribution of vectors inside the ball
% 
%--------------------------------Arguments--------------------------------%
% thisModel:           emergence model object we want to modify its parameters 
%                      detectorCoordinates (class model)
% nDetectors:          the number of detector neurons (numeric)
% detectorCoordinates: a matrix containing in column form the coordinates
%                      of the detector neurons 
%                      (matrix of size 2 x nDetectors)                   
%
%--------------------------------Function---------------------------------%

    % default values
    radius = 1;
    dimention = 2;
    
    % generate uniform random vectors on the surface of the ball
    randomVectorGaussian = randn(dimention, nDetectors);
    randomVectorNorm = sqrt(sum(randomVectorGaussian.^2));
    randomVectorNormalized = randomVectorGaussian./randomVectorNorm;

    % generate appropriate random radiuses to scale the normalized vectors
    uniformVariable = rand(1, nDetectors);
    randomScaleUniform = radius * uniformVariable.^(1/dimention);
    randomVectorUniform = randomScaleUniform .* randomVectorNormalized;
    thisModel.detectorCoordinates = randomVectorUniform;

end

