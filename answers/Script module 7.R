################
### Initializing
################


# Clear memory
rm(list=ls())

# Set working directory (change to your own location)
setwd("~/WUR/R/Module 7 - Matrix operations")


########
### Data
########


# Read diver data
d_walrus = read.csv("data/output_WALRUS.dat", sep="", header=TRUE)
d_Qmod = read.csv("data/Qmod_parameters.dat", sep="", header=FALSE)


##############
### Processing
##############

# Make a data frame with only the period 1 May - 30 June 2012
d_walrus_select = d_walrus[d_walrus$date>=20120501000000 & d_walrus$date<=20120630230000,]

# Make a vector of the mean modeled discharge of each time step
Qmod = rowMeans(d_Qmod)

# Compute the 10th and 90th percentile
percentile_10 = apply(X=d_Qmod, 
                      MARGIN=1,                        # Take percentiles of the columns
                      FUN=quantile,                    # Use function quantile
                      probs=0.1                        # compute 10th percentile
                      )

percentile_90 = apply(X=d_Qmod, MARGIN=1, FUN=quantile, probs=0.9)

### Make vectors to plot the percentile range

# Combine 10th and 90th percentile in one vector
percentiles_comb = c(percentile_10, rev(percentile_90))

# Make a vector of the number of data points and backwards
x_ax = c(seq(1:1464), rev(seq(1:1464)))

##########
### Output
##########

# Open pdf
pdf("figs/Simulated discharge with different parameter sets.pdf", family="Times", width=6.5, height=4)

# Set plotting parameters
par(mar=c(5, 5, 4, 4) + 0.1,
    mgp=c(1.8,0.7,0),                           # set label locations
    tcl=-0.4                                    # set tick mark length
    )

# Plot discharges
plot(d_walrus_select$Qobs, 
     type="l",                                       # make small, solid points
     ylim=c(0, 0.13),
     xaxs="i", yaxs="i",                             # remove white space at start and end
     col="black",
     xaxt="n",
     xlab=" ",
     ylab=expression("Q [mm h"^-1*"]")
     )            

# Add line for modeled discharge
lines(Qmod, col=rgb(0,128,255, max=255))             # make custom colour

# Add percentiles to the plot
polygon(x=x_ax,y=percentiles_comb, 
        col=rgb(0,128,255, max = 255, alpha = 50),   # make colour transparent
        border = NA)                                 # remove polygon border

# Add precipitation data to the plot
par(new=TRUE)
plot(new=TRUE,
     d_walrus_select$P,
     type="h",                                       # plot vertical lines
     ylim=c(18,0),                                   # reverse axis to get the lines on top
     xaxs="i", yaxs="i",                             # remove white space at start and end
     col="purple",
     ann=FALSE,                                      # suppress default annotation
     xaxt="n",
     yaxt="n"
     )

# Add x-axis
axis(side=1,                                                          # axis on bottom side
     at= c(1, (1/4)*1464, (2/4)*1464, (3/4)*1464, 1464),                       
     labels= c("1 May", "15 May", "1 Jun", "15 Jun", "30 Jun '12")    # add labels
     )   

# Add y-axis on the right
axis(side=4,
     at=c(0,2,4),
     labels=c(0,2,4),
     )
# Add label for y-axis
mtext(expression("P [mm h"^-1*"]"), 
      side=4,                                        # at right side
      line=2, at=2.5)                                # specify position of label

# Add legend to plot
legend(x=1220, y=6,                                                    # set position of legend
       legend=c("P", expression("Q"[obs]), expression("Q"[obs])),
       col=c("purple", "black", rgb(0,128,255, max=255)), 
       lty=1,                                                          # set line type (solid lines)
       cex=0.8,                                                        # set legend size
       box.lty=0)                                                      # remove legend border

# Add light blue rectangle in the legend
rect(xleft=1255, ybottom=10.5, xright=1340, ytop=9.5,                  # set location rectangle
     col=rgb(0,128,255, max = 255, alpha = 50),                        
     border=NA                                                         # remove rectangle borders
     )

# Close pdf
graphics.off()