# Architectural Overview

## Purpose
This repository contains a small MATLAB-based analysis workflow for reading pressure-map data from CSV files, detecting circular regions of interest, and quantifying pressure values across concentric radii. The system is primarily an interactive scientific-analysis pipeline rather than a production web or service application.

## Tech Stack
- Primary language: MATLAB
- Runtime environment: MATLAB interpreter with interactive plotting support
- Core libraries/dependencies:
  - Built-in MATLAB matrix and numerical computation functions
  - Image Processing capabilities for gradient estimation, image display, and circle detection
  - Visualization functions such as imshow, viscircles, plot, and errorbar
- Data sources:
  - CSV/Excel-style tabular data loaded through xlsread
  - Local helper script: imfindcircles.m

## High-Level Components
### 1. Entry-point analysis scripts
- Center_Finder_New.m
  - Loads a user-selected CSV file
  - Removes a non-useful header row
  - Computes image gradients and edge magnitude
  - Uses circle-detection logic to estimate one or more centers and radii
  - Displays the detected circle overlay on the pressure map

- Gradient_Analysis_New.m
  - Acts as a follow-on analysis step after center detection
  - Prompts the user for a manually supplied center and radius
  - Samples pressure values along multiple concentric circumferences
  - Computes the average pressure at each radius
  - Converts values to physical units and plots a radius-vs-pressure curve

### 2. Helper module
- imfindcircles.m
  - Provides circle-detection support used by the main script
  - Implements a MATLAB-style circular Hough transform workflow for identifying circles in a 2D matrix

### 3. Data directory
- Participant Data/
  - Stores input CSV files used as experimental/participant datasets
  - Each file appears to be a matrix-like pressure map that the MATLAB scripts analyze

## Data Flow
1. Input acquisition
   - The user selects a CSV file through a file dialog.
   - The script loads the file into a numeric matrix using xlsread.

2. Preprocessing
   - The first row is removed as non-useful metadata.
   - Matrix dimensions are computed so the script can safely index into the data.

3. Circle detection flow
   - The matrix is treated as a grayscale image-like surface.
   - A gradient magnitude map is computed from the numeric data.
   - A threshold is applied to isolate likely edges.
   - Circle detection is performed using the helper routine, which identifies candidate centers and radii.

4. Visualization
   - Detected circles are overlaid on the image using MATLAB visualization functions.
   - The user can inspect and adjust the result manually if needed.

5. Gradient analysis flow
   - The user provides a center coordinate and radius.
   - The script samples points along concentric circles at increasing radii.
   - Values at those sampled coordinates are extracted from the matrix.
   - Average pressure values are calculated for each radius.
   - Units are converted and plotted as a pressure-vs-radius graph.

6. Output
   - Results are primarily delivered through interactive plots and the MATLAB command window.
   - There is no separate database, API, or persistent output layer in the current implementation.

## Architectural Characteristics
- Batch-style scientific processing pipeline
- Strongly interactive and manual-driven analysis
- Deterministic for a given input file and user-specified parameters
- Tightly coupled scripts with minimal abstraction or modularization
- Suitable for exploratory data analysis rather than reusable production software
