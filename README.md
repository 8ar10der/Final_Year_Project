# Capturing movement data using mobile phones
Yuehao Sui   
16206781  
yuehao.sui@ucdconnect.ie  

Supervisor: Professor Fred Cummins

School of Computer Science  
University College Dublin

## The Repository Structure 

The **Android_application** folder store the source code of the Android application I modified. 
For more details such as how to use it, please read the [README file](./Android_application/README.md) in this folder.

The **R_script** folder store the R script used to do the PCA and draw the result plots.
For more details such as how to use it, please read the [README file](./R_script/README.md) in this folder.

## Project Specification
In this project, the core goals are developing an app to record accelerometer data in the X, Y and
Z planes for movement over a short specified interval, e.g. when tracing shapes in the air with the
hand.

And extracting this data to the computer. Examine the sampling characteristics. Interpolate to
obtain equally sampled intervals if necessary. Low pass filter to remove tremor and high-frequency
jitter. Perform principal component analysis on the three streams, and provide means for plotting
the first 1 or 2 principal components.

The advanced goals are, to distinguish between roughly periodic movement(as when tracing a
series of loops with the finger) and aperiodic (as when tracing an arbitrary figure) and to provide
utilities for further analysis and display of the information captured(statistical summary, zooming,
etc.)

## About this Repository
Upon request, upload all the original code about the project to GitHub.

All the code published follow the [Mozilla Public License](./LICENSE.md)
