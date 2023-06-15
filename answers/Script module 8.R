################
### Initializing
################


# Clear memory
rm(list=ls())


# Set working directory (change to your own location)
setwd("~/WUR/R/Module 8 - GIS")

# load maptools package
library(raster)
library(rgdal)


########
### Data
########


# Read the ascii data files
surface_elev = raster("data/elevation.asc")
clay_elev = raster("data/clay_elevation.asc")
mask = raster("data/catchment_mask.asc")

# Read shape files
NL_border = readOGR("data/border_NL.shp")
water = readOGR("data/water.shp")

# Read coordinates
coordinates = read.csv("data/coordinates.dat", sep="", header=TRUE)


##############
### Processing
##############


# Cut off the elevation map at the catchment boundary
surface_elev[is.na(mask)]= NA

# Make a vector with 7 green colours
colours=colorRampPalette(c("darkgreen","forestgreen","yellowgreen", "yellow"))( 7 )

# Make a vector with break points
breaks=seq(from=2200, to=3600, by=200)

# Compute thickness aquifer
thickness = surface_elev/100-clay_elev

# Make resolution clay depth coarser
thickness_coarse = aggregate(x=thickness, fact=50)


##########
### Output
##########


# Open pdf
pdf("figs/Hupsel Brook catchment.pdf", family="Times", width=5, height=5)

# Set plotting parameters
par(mar=c(0,0,0,0), fig=c(0,1,0,1))

# Plot image
image(surface_elev,
      col=colours,
      breaks=breaks
      )

# Add colour legend to plot
legend(x=243050,y=452650, 
       legend=c("22-24", "24-26", "26-28", "28-30", "30-32", "32-34", "34-36"), 
       fill = colours,
       bty = "n",                                          # remove border
       cex=0.8
       )
text(x=243630,y=452810, "Elevation\n[m]", adj=1, cex=0.8)  # legend header

# Add contour lines for clay elevation
contour(thickness_coarse, add=TRUE, col="white", levels=seq(1,11,1), 
        drawlabels=TRUE, method="flattest", cex=3)

# Add primary and secondary water courses
lines(water, lwd=2)

## Add observation locations and labels
# Make white small points
points(coordinates$x, coordinates$y, 
       pch=c(15,17,16,16,16,16,16,16),                     # set symbol type
       col="white"                                         # make points white
       )
# Make black points
points(coordinates$x, coordinates$y, 
       pch=c(0,2,1,1,1,1,1,1),                             # set symbol type
       lwd=2
       )
# Add numbers to observations
text(coordinates$x, coordinates$y, labels=c(" ", " ", 1,5,6,3,2,4), pos=4, offset = 0.3, cex=0.7)

# Add legend in the bottom left
rect(239780,452060,239980,452190,col="#7B9C44", border=NA) # green box for white lines
legend(x=239750,y=452410,
       legend=c("Hupsel Brook", "Aquifer thickness [m]", "Catchment outlet", "Meteorological station", "Soil moisture measurement"),
       lty=c(1,1,NA,NA,NA),                                # line styles
       pch=c(NA,NA,0,2,1),                                 # point styles
       lwd=c(2,1,2,2,2),                                   # sign thickness
       bty = "n",                                          # remove border
       col=c("black", "white", "black", "black", "black"),
       cex=0.8
       )

# Add a scale bar with rectangles
rect(243160,454830,243620,454890,col="white")
rect(242700,454830,243160,454890,col="black")
text(243560,454730,"1 km", cex=0.8)
text(242720,454730,"0", cex=0.8)


# Add plot of the Netherlands
lines(c(239880,240250), c(453570,454500),lty=2)
lines(c(240250,241040), c(454500,454670),lty=2)


par(fig=c(0.05,0.3,0.75,0.95), new=TRUE)                 # place map in upper left corner
plot(NL_border,
     bg="transparent"                                    # avoid white overlaying the graph      
     )

# Close pdf
graphics.off()
