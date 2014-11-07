## This program creates a time series on historical food stamps participation rates ##
## in the US using historical food stamps data from the USDA (fs_ts.csv file)       ##

## UPDATE: creates the time series using rCharts for interactivity!                 ##

library(ggplot2)
library(rCharts) # library("rCharts")? if not, just load manually in packages

setwd("C:\\Users\\Alice Feng\\Documents\\721 - Stat Graphics and Viz\\finalproj\\data")

# read in time series data on SNAP participation levels from 1969-2012
fsts = read.table("fs_ts.csv", sep=",", header=TRUE)
save(fsts, file="snap_ts.rData")

# create data frame with years of US economic recessions (data from NBER)
recessions.df = read.table(textConnection(
  "Peak, Trough
  1970, 1971
  1973, 1975
  1980, 1980.5
  1981.5, 1983
  1990.5, 1991
  2000, 2001
  2007, 2009.5"), sep=',', header=TRUE)


# make time series plot with recession years highlighted
ggplot(data=fsts) + 
  geom_rect(data=recessions.df, aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill='pink', alpha=0.7) + 
  geom_line(aes(x=Year, y=Part_pct)) +
  ggtitle("SNAP Participation Rates, 1969-2012") +
  ylab("% of Population Receiving SNAP Benefits")

ggplot(data=fsts) + 
  geom_rect(data=recessions.df, aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill='pink', alpha=0.7) + 
  geom_line(aes(x=Year, y=Benefit)) +
  ggtitle("Average Amount of Monthly SNAP Benefits (per person), 1969-2012")

ggplot(data=fsts) + 
  geom_rect(data=recessions.df, aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill='pink', alpha=0.7) + 
  geom_line(aes(x=Year, y=Part_count)) +
  ggtitle("Total Number of People Enrolled in SNAP, 1969-2012")

ggplot(data=fsts) + 
  geom_rect(data=recessions.df, aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill='pink', alpha=0.7) + 
  geom_line(aes(x=Year, y=TotBen), color="blue") +
  geom_line(aes(x=Year, y=Costs), color="red") +
  ggtitle("Total SNAP Benefits Distributed and Program Cost, 1969-2012")

# convert datasets for use in rCharts
fsts_3 = transform(fsts, Year = as.character(Year))
str(fsts_3)
recessions.df2 = transform(recessions.df, Peak=as.character(Peak), 
                           Trough=as.character(Trough))
str(recessions.df2)

# convert into a rCharts chart
m1 <- mPlot(x = "Year", y = "Part_pct", type = "Line", data = fsts_3)
m1$set(pointSize = 0, lineWidth = 2)
m1$set(hoverCallback = "#! function(index, options, content){
  return options.data[index].Year + ':  ' + options.data[index].Part_pct + '%'
} !#")
m1$print("chart2")

# publish chart to rpubs
m1$publish('Food Stamps Time Series', host='rpubs')

# 