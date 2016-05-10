# Generate a line plot of submetering over time

genplot3 <- function() {
       
        source("getdata.R")
        library(lubridate) # makes things easier

        data <- getdata()
        datetime <- dmy_hms(paste(data$Date, data$Time))

        png("plot3.png", bg="transparent")

        plot(datetime,
             data$Sub_metering_1,
             type="l",
             xlab="",
             ylab="Energy sub metering")

        lines(datetime,
              data$Sub_metering_2,
              col="red")

        lines(datetime,
              data$Sub_metering_3,
              col="blue")

        legend("topright",
               legend=c("Sub_metering_1", "Sub_metering_1", "Sub_metering_3"),
               lwd=c(1, 1, 1),
               col=c("black", "red", "blue"))

        dev.off()
}
