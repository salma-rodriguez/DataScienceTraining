## This function makes a plot of the total fine particulate matter
## emission by year and aggregated from all sources.

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

genplot1 <- function() {
        
        data <- readRDS("summarySCC_PM25.rds")

        ## cumulate value of PM2.5 on all sources per year
        total <- tapply(data$Emission, data$year, sum) ## PM2.5 totals

        png("plot1.png", bg="transparent")

        barplot(total,                                  ## the cumulate total
             names.arg = names(total),                  ## the years
             col = c("lightgreen", "lightblue", "lightgreen", "lightblue"),
             width = c(.1, .1, .1, .1),
             xlab = "Year",
             ylab = expression(PM[2.5] * " (tons)"),
             main = expression("Total " * PM[2.5] * " for all US Counties"))

        dev.off()
}
