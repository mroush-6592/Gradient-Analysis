    %% NOTES
% This code works as a trial for the computer to find the center of the
% circle, the coordinates the computer finds are put into the command
% window and a circle is drawn around it, if the coordinates look
% incorrect, adjust them in the Manual Graph Display. The code may not give a circle
% if it cannot find one, thus the data must be put in entirely in the
% Manual Graph Display; further instruction is given there. 
%% Maintenance Commands 
clear all
close all
clc

%% Read excel file
file = uigetfile(".csv");
[numData, textData, rawData] = xlsread(file); % We only care about numData

%% Determine the size of the number matrix
numData(1,:) = []; % crop out the top row of non useful numbers from the excel file
numRows = size(numData, 1); % determine the number of rows
numCols = size(numData, 2); % determine the number of columns


%% Main Code
% Step 1: Edge Detection using gradient
[gradientX, gradientY] = gradient(double(numData));
magnitude = sqrt(gradientX.^2 + gradientY.^2);

% Apply a threshold to get binary edge map
threshold = max(magnitude(:)) * 0.25;  % Adjust this threshold as necessary
edges = magnitude > threshold;

% Step 2: Use imfindcircles to locate circle
[centers, radii] = imfindcircles(edges, [5 22], 'Sensitivity', 0.9);
centers = round(centers,0)

% Display the results
figure;
imshow(numData, []);
hold on;
viscircles(centers, radii, 'EdgeColor', 'r');

% Step 3: Plot centers
for i = 1:size(centers, 1)
    % Plot center
    plot(centers(i, 1), centers(i, 2), 'b+', 'MarkerSize', 10, 'LineWidth', 2);
end
hold off;