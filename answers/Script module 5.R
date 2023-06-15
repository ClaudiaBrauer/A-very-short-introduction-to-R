################
### Initializing
################

# Clear memory
rm(list=ls())

# Set working directory (change to your own location)
setwd("~/WUR/R/Module 5 - Pretty Plotting")


########
### Data
########


# Read discharge data
d = read.csv("data/Q_day_Rhine_Meuse_Rietholzbach_Hupsel_1989_2007.txt", sep="")


##############
### Processing
##############


# Make vector of discharge from high to low
Rhine_sorted = sort(d$Rhine, decreasing=TRUE)
Meuse_sorted = sort(d$Meuse, decreasing=TRUE)
Rietholzbach_sorted = sort(d$Rietholzbach, decreasing=TRUE)
Hupsel_sorted = sort(d$Hupsel, decreasing=TRUE)

# Compute normalized discharge
Rhine_normalQ = Rhine_sorted/mean(d$Rhine, na.rm=TRUE)
Meuse_normalQ = Meuse_sorted/mean(d$Meuse, na.rm = TRUE)
Rietholzbach_normalQ = Rietholzbach_sorted/mean(d$Rietholzbach, na.rm = TRUE)
Hupsel_normalQ = Hupsel_sorted/mean(d$Hupsel, na.rm = TRUE)

### Vectors for axes

# Make exceedance probability vectors from 0-1 for the x-axis
p_Rhine = seq(from=0, to=1, length=length(Rhine_normalQ))
p_Meuse = seq(from=0, to=1, length=length(Meuse_normalQ))
p_Rietholzbach = seq(from=0, to=1, length=length(Rietholzbach_normalQ))
p_Hupsel = seq(from=0, to=1, length=length(Hupsel_normalQ))

# Make a vectors for upper tick marks right graph
seq1 = seq(from=20,to=90, by=10)   
seq2 = seq(from=6,to=9, by=1)
T_right = c(seq1,seq2)                                            # combine vectors
p_right = 1/T_right

# Make a vector for upper tick marks left graph
seq3 = seq(from=200, to=900, by=100)
seq4 = seq(from=2000, to=9000, by=1000)
T_left_up = c(seq1,seq2,seq3,seq4)
p_left_up= 1/T_left_up

# Make a vector for lower tick marks left graph
seq5 = seq(from=0.0002, to=0.0009, by=0.0001)
seq6 = seq(from=0.002, to=0.009, by=0.001)
seq7 = seq(from=0.02, to=0.09, by=0.01)
seq8 = seq(from=0.2, to=0.9, by=0.1)
p_left_bot = c(seq5,seq6,seq7,seq8)

##########
### Output
##########


# Open pdf
pdf("figs/Return period and exceedance probabilities of discharge for four catchments.pdf", width=8.8, height=3.6, family="Times")

# Plotting parameters (set same layout for all graphs) 
par(mar=c(5, 3, 3, 1) + 0.1,                          # set margins
    mgp=c(1.5,0.5,0),                                 # set label locations 
    tcl=-0.3,                                         # set tick mark lengths
    las=1,                                            # turn labels x axis 90 degrees
    mfrow=c(1,2))                                     # get two figures next to each other

### Left figure: Logarithmic exceedance probability

# Plot normalized discharge Rhine
plot(x=p_Rhine, y=Rhine_normalQ,
     xlim=c(0.0001,1),                                # make axes the same
     ylim=c(0,35),
     xaxs="i", yaxs="i",                              # remove white space at start and end
     type="o",                                        # make points with a connecting line
     pch=19,                                          # make points solid
     cex=0.4,                                         # make points smaller
     xlab="Exceedance probability p [-]",             # create labels for axes
     ylab=expression("Q/Q"[ave]*" [-]"),
     col="Red",                                       # make line red
     log="x",                                         # logarithmic x-axis
     xaxt="n")                                        # suppress drawing the bottom x-axis

# Add normalized discharges other catchments
lines(x=p_Meuse, y=Meuse_normalQ, col="Purple", type="o", pch=19, cex=0.4)
lines(x=p_Rietholzbach, y=Rietholzbach_normalQ, col="Forestgreen", type="o", pch=19, cex=0.4)
lines(x=p_Hupsel, y=Hupsel_normalQ, col="Dodgerblue", type="o", pch=19, cex=0.4)

# Add labels to the lines (cex defines the letter size)
text("Rhine", x=0.0003, y=3.5, col="Red", cex=0.8)
text("Meuse", x=0.0003, y=9.5, col="Purple", cex=0.8)
text("Rietholzbach", x=0.0006, y=33, col="Forestgreen", cex=0.8)
text("Hupsel\nBrook", x=0.0003, y=16, col="Dodgerblue", cex=0.8) # place label on two lines


# Add axis on bottom
axis(side=1,                                           # axis on bottom side
     at= 1/c(1,10,100,1000,10000),                     # tick marks at x=1/T
     labels= 1/c(1,10,100,1000,10000))                 # add labels
# Add secondary tick marks bottom
axis(side=1,
     at=p_left_bot,
     labels=rep("", 32))                               # add empty labels


# Add axis on top
axis(side=3,                                           # axis on top side
     at= 1/c(1,10,100,1000,10000),                     # tick marks at x=1/T
     labels=c(1,10,100,1000,10000))                    # add labels
mtext("Return period T [days]", side=3, line=1.5)      # add axis title
# Add secondary tick marks top
axis(side=3,
     at=p_left_up,
     labels=rep("", 28))                               # add empty labels



### Right figure: Exceedance probability

# Plot normalized discharge Rhine
plot(x=p_Rhine, y=Rhine_normalQ,
     xlim=c(0,1),                                     # make axes the same
     ylim=c(0,4.5),
     xaxs="i", yaxs="i",                              # remove white space at start and end
     type="l",                                        # line instead of points
     xlab="Exceedance probability p [-]",             # create labels for axes
     ylab=expression("Q/Q"[ave]*" [-]"),              # write "ave" in subscript
     col="Red")                                       # make line red

# Add normalized discharges other catchments
lines(x=p_Meuse, y=Meuse_normalQ, col="Purple")
lines(x=p_Rietholzbach, y=Rietholzbach_normalQ, col="Forestgreen")
lines(x=p_Hupsel, y=Hupsel_normalQ, col="Dodgerblue")

# Add labels to the lines
text("Rhine", x=0.8, y=1, col="Red", cex=0.8)
text("Meuse", x=0.23, y=2.2, col="Purple", cex=0.8)
text("Rietholzbach", x=0.16, y=0.8, col="Forestgreen", cex=0.8)
text("Hupsel Brook", x=0.4, y=0.2, col="Dodgerblue", cex=0.8)


# Add axis on top
axis(side=3,                                           # axis on top side
     at= 1/c(1,2,3,4,5,10,100),                        # tick marks at x=1/T
     labels=c(1,2,3,4,5,10,100))                       # add labels
mtext("Return period T [days]", side=3, line=1.5)      # add axis title

# Add secondary tick marks
axis(side=3,
     at=p_right,
     labels=rep("", 12))                               # add empty labels


# Close pdf
graphics.off()