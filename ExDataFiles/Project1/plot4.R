# Generate four plots as follows:

# topleft:      global active power over time
# topright:     voltage over time
# bottomleft:   energy submetering over time
# bottomright:  global reactive power over time

genplot4 <- function() {

        source("getdata.R")
        library(lubridate) # makes things easier

        data <- getdata()
        datetime <- dmy_hms(paste(data$Date, data$Time))

        png("plot4.png", bg="transparent")
        par(mfcol=c(2, 2)) # arrange column-wise: %___%___%
                           #                      | 1 | 3 |
                           #                      | 2 | 4 |
                           #                      %===%===%

        # first plot

        plot(datetime,
             data$Global_active_power,
             type="l",
             xlab="",
             ylab="Global Active Power")

        # second plot

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
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               lwd=c(1, 1, 1),
               bty="n",
               col=c("black", "red", "blue"))

        # third plot

        plot(datetime,
             data$Voltage,
             type="l",
             xlab="datetime",
             ylab="Voltage")

        # fourth plot

        with(data,
             plot(datetime,
                  Global_reactive_power,
                  type="l",
                  xlab="datetime"))

        dev.off()
}
