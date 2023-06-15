################
### Initializing
################

# Clear memory
rm(list=ls())

# Set working directory (change to your own location)
setwd("~/WUR/R/Module 6 - Reading data files")

# Set the system's clock to UTC
Sys.setenv(tz='UTC')

########
### Data
########


# Read diver data
d = read.csv("data/Diver_piezometer.MON.txt", sep="", skip = 53, header=FALSE)
d2 = read.csv("data/Diver_baro.MON.txt", sep="", skip=53, header=FALSE)

##############
### Processing
##############

### Select the year 2014 from piezometer data

# Separate columns of data into vectors
date_d = d$V1
time_d = d$V2
level_d = d$V3

# Combine date and time vectors in one date-time vector
datetime_d = paste(date_d,time_d)

# Convert date-time vector to POSIX class
datetime_d_POSIX = strptime(datetime_d, format="%Y/%m/%d %H:%M:%OS", tz="UTC")

# Create new data frame containing the level, and the time in POSIX format
d_POSIX = data.frame(date=datetime_d_POSIX, level=level_d)


### Select the year 2014 from the new data frame

# Set a start and end date
start_date = strptime("2014/01/01 00:00:00.0", format="%Y/%m/%d %H:%M:%OS", tz="UTC")
end_date = strptime("2014/12/31 23:00:00.0", format="%Y/%m/%d %H:%M:%OS", tz="UTC")

# Select the year 2014 from the time series
d_2014 = d_POSIX[d_POSIX$date>=start_date & d_POSIX$date<=end_date,]
level_d_2014 = d_2014$level
date_d_2014 = d_2014$date


### Select the year 2014 from atmospheric pressure data (same as previous, but for the other data set)

# Separate columns of data into vectors
date_d2 = d2$V1
time_d2 = d2$V2
level_d2 = d2$V3

# Combine date and time vectors in one date-time vector
datetime_d2 = paste(date_d2,time_d2)

# Convert date-time vector to POSIX class
datetime_d2_POSIX = strptime(datetime_d2, format="%Y/%m/%d %H:%M:%OS", tz="UTC")

# Create new data frame with atmospheric pressure and time in POSIX format
d2_POSIX = data.frame(date=datetime_d2_POSIX, level=level_d2)

# Select the year 2014 from the new data frame
d2_2014 = d2_POSIX[d2_POSIX$date>=start_date & d2_POSIX$date<=end_date,]
level_d2_2014 = d2_2014$level
date_d2_2014 = d2_2014$date


### Compute levels

# Get the pressure of the water column
p_column = level_d_2014 - level_d2_2014

# Convert to water level above sensor
h_above_sensor = p_column*100/9.81

# Convert to groundwater depth
h_sensor = 3.46
gw_depth = h_above_sensor-h_sensor


### Remove strange values from the data frame

# Create new data frame with two columns: date and water level below surface
gw_depth_2014 = data.frame(date=date_d_2014, groundwater_depth=gw_depth)

# Remove the strange values from this data frame
# After making a quick plot, you see that all strange values are > -2.8
gw_depth_cor = gw_depth_2014[gw_depth_2014[,2]>-2.8,]


### Make vectors for the x-axis

# Make vector with dates the tick marks should be at
# Convert it to POSIXct because the dates in the data frame are also in this format
tick_marks = as.POSIXct(x=c("2014-01-01 00:00:00", "2014-03-01 00:00:00", "2014-05-01 00:00:00", "2014-07-01 00:00:00", "2014-09-01 00:00:00", "2014-11-01 00:00:00"), format="%Y-%m-%d %H:%M:%OS", tz="UTC")

# Make vector containing the labels
labels = c("Jan 2014", "1 Mar", "1 May", "1 Jul", "1 Sep", "1 Nov")
       
##########
### Output
##########

# Open pdf
pdf("figs/Time series of groundwater depth.pdf", width=4.4, height=4.4, family="Times")

# General plotting parameters
par(mar=c(5, 4, 4, 2) + 0.1, 
    pty="s",                                    # make figure square
    mgp=c(1.4,0.3,0),                           # set label locations
    tcl=-0.2,                                   # set tick mark length
    cex.axis=0.61
    )

### Plot water level

plot(x=gw_depth_cor$date, y=gw_depth_cor$groundwater_depth, 
     ylim=c(-2.8,-1.8),
     type='l',                                  # make small, solid points
     xaxs="i", yaxs="i",                        # remove white space at start and end
     ylab="Groundwater depth [m-surface]",      # create label y-axis
     xlab="",                                   # leave x-axis empty
     cex.lab=0.7,                               # make axis label smaller
     xaxt="n",                                  # suppress default x-axis
     col="aquamarine3")                         # give the line a pretty colour

# Plot x-axis with customized labels
axis(side=1,                                    # axis on bottom side
     at= tick_marks,                       
     labels= labels)                            # add labels

# Close pdf
graphics.off()