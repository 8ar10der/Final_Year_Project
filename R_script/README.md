## The functions of the script

The script will do the PCA for the Linear-Accelerator data from the csv file we got from the Android App.

Then it will filter the result of the PCA and draw three plots about the Phone A's movement, Phone B's movement and the 
correlation between the two dataset.

## Before you run the script

Make sure you have installed the R language in your system. If not, please download it from [R-Project offical website](https://www.r-project.org/) 

Then please install the R packages via the `install.packages()` command:
* ggplot2
* cowplot
* rowr
* signal
* scales

## How to use this script

Put the two csv file in the folder and rename them (or modified the script line 8 and 9)

Open the terminal (PowerShell, Tilix, iTerm2, whatever)

Change directory to the R_script folder

Run `Rscript run.r`

The plot will create in the folder named "output_plot.pdf", the importance of components of PCA will output in the terminal.

If you want to change the size of the plot, just modified the last line of the script.

## [BUG] The plot may break and shift !

It seems to be a bug of the ggplot2. I make a post at [here](https://stackoverflow.com/questions/61311410/why-ggplot2-will-draw-a-breakshift-time-series-line-plot)。
Welcome to discussion.