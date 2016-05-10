# Generate a histogram of Global Active Power

genplot1 <- function() {

        source("getdata.R")

        data <- getdata()

        png("plot1.png", bg="transparent")

        hist(data$Global_active_power,
             col="red",
             main="Global Active Power",
             xlab="Global Active Power (kilowatts)")

        dev.off()

}
