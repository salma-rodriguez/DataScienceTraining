## This function makes a plot of the total fine particulate matter
## emission by year and aggregated from all sources.

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

genplot2 <- function() {
        
        data <- readRDS("summarySCC_PM25.rds")

        baltimore = data[data$fips == "24510", ] ## baltimore data
        total <- tapply(baltimore$Emission, baltimore$year, sum)##PM2.5 totals

        png("plot2.png", bg="transparent")

        barplot(total,                                  ## the cumulate total
             names.arg = names(total),                  ## the years
             col = c("lightgreen", "lightblue", "lightgreen", "lightblue"), 
             width = c(.1, .1, .1, .1),
             xlab = "Year",
             ylab = expression(PM[2.5] * " (tons)"),
             main = expression("Total " * PM[2.5] * " for Baltimore"))

        dev.off()
}
