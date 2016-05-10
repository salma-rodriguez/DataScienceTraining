# Generate a line plot of global active power over time

genplot2 <- function () {
        
        source("getdata.R")
        library(lubridate) # makes things easier

        data <- getdata()
        datetime <- dmy_hms(paste(data$Date, data$Time))

        png("plot2.png", bg="transparent")

        plot(datetime,
             data$Global_active_power,
             type="l",
             xlab="",
             ylab="Global Active Power (kilowatts)")

        dev.off()

}
