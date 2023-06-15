################
### Initializing
################

# Clear memory
rm(list=ls())

# Set working directory (change to your own location)
setwd("~/WUR/R/Module 4 - Basic Plotting")


########
### Data
########


# Read precipitation data
d = read.csv("data/P_gauge_radar.dat", sep="")


##############
### Processing
##############


# Fit linear model
regr = lm(d$radar ~ d$gauge)                    # fits linear model
a = regr$coef[1]                                # extract intercept
b = regr$coef[2]                                # extract slope
r2= summary(regr)$r.squared                     # extract r2 from summary

# Round a, b and r2 to two decimals
a = round(a, digits=2)
b = round(b, digits=2)
r2 =round(r2, digits=2)


##########
### Output
##########


# Open pdf
pdf("figs/compare_time_series.pdf", width=4, height=6)

# Change margins
# Make figure square
par(mar=c(4,4,0.5,0.5), pty="s")



### Scatter plot

plot(x=d$gauge, y=d$radar, 
     xlim=c(0,9),                               # make axes the same
     ylim=c(0,9),
     pch=16,                                    # make small, solid points
     xaxs="i", yaxs="i",                        # remove white space at start and end
     xlab="P gauge [mm/h]",                     # create labels for axes
     ylab="P radar [mm/h]",              
     col="dodgerblue")                          # make points dodgerblue


# Add 1:1 line
curve(1*x, xlim=c(0,9), col="purple", add=TRUE)
text("1:1", x=8, y=8.5, col="purple")

# Add regression line
curve(a+b*x, xlim=c(0,9), col="darkblue", add=TRUE)
text(paste0("y=",a,"+",b,"x"), x=7.3, y=5, col="darkblue")
text(bquote(paste("r"^{2},"=",.(r2))), x=8, y=6, col="darkblue")

# Close pdf
graphics.off()