Module 6: Reading data files
---

***Process groundwater diver data***

In this assignment you will read data from a data file, process and plot them as in the figure below.

1. Download `Diver_piezometer.MON`. This file contains pressure data from the water column and air above a sensor in a groundwater well (also called piezometer). Open it in Notepad to see what it looks like.
2. Initialize the script with standard headers and working directory. 
3. Add the command `Sys.setenv(tz=`UTC')` to set the system's clock to UTC. This is not always necessary, but it's often the safe option (to avoid trouble with time zones or daylight savings time).
4. Add lines (under `Data`) to read the data. Use an extra argument to prevent R from reading the text before the data begins. 
5. Use the function `head` to show the first rows of the data frame. Check if those are the same lines as in the file.
6. Make three vectors, each consisting of one of the columns in the matrix, and give them three logical names. You can ignore the last column.
7. Check the class of each vector. Look up in *A (very) short introduction to R* what is meant with classes and how to check it.
8. Use the function `paste` to combine the date- and time vectors to one date-time vector. Its class should now be character.
9. Convert this date-time vector (which is still a character) to a POSIX class. Look up in *A (very) short introduction to R* what is meant with POSIX and how to convert character strings to it. Add `tz="UTC"` to set the timezone.
10. Make 2 new vectors which only contain the year 2014 from the larger date-time vector and the data series:
		1. Use a similar code to make two variables with POSIX class: one for the start date and one for the end date.
		2. Select the part of the vector where the date-time is larger than the start date and smaller than the end date. Something similar is done in the figure in the introduction of module 4.
11. Repeat steps 5-11 for `Diver_baro.MON`. This file contains atmospheric pressure data (the air above a sensor which is not submerged a piezometer).  
12. Under `Processing`, subtract the atmospheric pressure from the from the pressure from the piezometer to get the pressure of the water column in the piezometer. Make a quick plot to check your values.
13. Convert the pressure time series ($p$) to water levels above the sensor ($h$) according to $h = p \times 100\, /\, 9.81$. 
14. The sensor is 3.46 m below soil surface. Convert the water columns above the sensor to m below surface. Make a quick plot to check your values.
15. Remove strange values.
16. Under `Output`, plot the water level as a line with a pretty colour. 
17. Modify the plot to get the time on the $x$-axis.
18. Make a vector with the dates belonging to the labels on the $x$-axis and a vector with the text you want to plot at these tick marks.
19. Add an argument to the plot function to suppress the default $x$-axis (search in the list with plotting parameters: `?par` or Google it). Then plot the $x$-axis separately with your customized labels. 
20. Add a label on the $y$-axis.
21. Force the $x$-axis to range from the first measurement to the last using argument (use the whole horizontal space instead of the default white spaces). Search in `par` again.
22. Above the figure, add a line with general plotting parameters for margins, tick marks, etc. Also include an argument to make the firgure square.
23. Add commands to write the figure to a pdf of 4.4x4.4 inch, with Times font. Don't forget the command to close the pdf after the figure. 

![Time series of groundwater depth. *Figure taken from computer practical in the course ``Field Research Water and Atmosphere'', Wageningen University.*](fig_module_6.png)

