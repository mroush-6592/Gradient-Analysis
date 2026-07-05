%% NOTES

% This is meant to be used after using Circle Finder first. The Top Left of

% the image indicates (0,0) and the Bottom Right indicates (44,44). If

% trial and error must be run, first assume (22,22) and a radius of 11.

% Radius is irrelevant in data collection but helps determine if the circle

% fits correctly



% For any data I already collected, the coordinates were put into a text

% file for reproducability 



% For the control pressure maps for AFM, Silver, and Ultra -> Center was

% (22,22) and Radius was 1

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



%% Top Left is (0,0) and Bottom Right is (44,44)

prompt1 = input('What is the x coordinate of the center of the circle (1-44)?: ');

prompt2 = input('What is the y coordinate of the center of the circle (1-44)?: ');  

prompt3 = input('What is the radius of the circle?: ');

centersInRange = [prompt1,prompt2];

radiiInRange = prompt3;

% Display the results

figure;

imshow(numData, []);

hold on;

viscircles(centersInRange, radiiInRange, 'EdgeColor', 'r');



% Step 3: Plot centers

for i = 1:size(centersInRange, 1)

    % Plot center

    plot(centersInRange(i, 1), centersInRange(i, 2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);

end

hold off;





% Step 4: Increment Circle Radii and Find Avg Value of Circumferences

% Define parameters

numPoints = 30; % Number of points on the circumference of each circle

radiiRange = 1:1:22; % Range of radii for circles



% Initialize arrays to store results

circleRadii = [];

averageValues = [];



% Iterate over detected circles

for i = 1:size(centersInRange, 1)

    % Get center coordinates

    center_x = centersInRange(i, 1);

    center_y = centersInRange(i, 2);

    

    % Initialize array to store values for each radius

    valuesForRadius = [];

    

    % Iterate over range of radii

    for radius = radiiRange

        % Compute coordinates of points on the circumference

        theta = linspace(0, 2*pi, numPoints);

        x = center_x + radius * cos(theta);

        y = center_y + radius * sin(theta);

        

        % Round coordinates to integer indices

        x_indices = round(x);

        y_indices = round(y);

        

        % Ensure indices are within bounds

        x_indices = max(1, min(x_indices, numCols));

        y_indices = max(1, min(y_indices, numRows));

        

        % Get values of cells touched by circumference points

        values = numData(sub2ind(size(numData), y_indices, x_indices));

        

        % Compute average value for this radius

        avgValue = mean(values, 'omitnan');

        valuesForRadius = [valuesForRadius, avgValue];

    end

    

    % Store results for this circle

    circleRadii = [circleRadii; radiiRange];

    averageValues = [averageValues; valuesForRadius];

end



%% Convert Values

circleRadii = circleRadii * 1.27 % convert to mm

pressureValues = averageValues * 0.133322 % convert to kPa

pressureStd = std(pressureValues)

%% Plot results

figure;

hold on;

errorbar(circleRadii', pressureValues', pressureStd', '-o');

xlabel('Circle Radius [mm]' );

xlim([0 30]);

ylim([-50 170]);

ylabel('Pressure Value [kPa]');

title('Circle Radius vs Average Pressure Value');

hold off;