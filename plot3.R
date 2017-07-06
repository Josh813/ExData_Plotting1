temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", colClasses = "character", nrows = 100000)
unlink(temp)


data[3:9] <- sapply(data[3:9], as.numeric)

library(dplyr)
data <- mutate (data, Day = paste(Date, Time))

library(lubridate)
data$Day <- dmy_hms(data$Day)
data$Date <- dmy (data$Date)
data <- filter(data, Date == "2007-02-01" | Date == "2007-02-02")
data <- select(data, Day, Sub_metering_1, Sub_metering_2, Sub_metering_3)
data <- mutate (data, Weekday = wday(Day, label = TRUE))

with(data, plot(Day, Sub_metering_1, type = "l", xlab=NA, 
                ylab="Energy sub metering"))
with(data, points(Day, Sub_metering_2, type = "l", col="red"))
with(data, points(Day, Sub_metering_3, type = "l", col="blue"))

legend("topright", lwd=c(1,1,1), col=c("black", "red", "blue"), 
       legend = c("Sub_metering_1  ","Sub_metering_2  ","Sub_metering_3  "))

dev.copy(png, file="plot3.png")
dev.off()