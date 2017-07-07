#download file
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", colClasses = "character", nrows = 100000)
unlink(temp)

#convert variable columns to numeric
data[3:9] <- sapply(data[3:9], as.numeric)

#combine columns date and time
library(dplyr)
data <- mutate (data, Day = paste(Date, Time))

#subset records from 1st and 2nd Feb 2007
library(lubridate)
data$Day <- dmy_hms(data$Day)
data$Date <- dmy (data$Date)
data <- filter(data, Date == "2007-02-01" | Date == "2007-02-02")
data <- select(data, Day, Global_active_power)

#plot the data
with(data, plot(Day, Global_active_power, type = "l", xlab=NA, 
    ylab="Global Active Power (kilowatts)"))

#save a copy as png
dev.copy(png, file="plot2.png")
dev.off()

