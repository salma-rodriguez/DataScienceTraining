## This function makes a plot tracking the movement of fine particulate mater
## medians over time for four sources: point, nonpoint, onroad, and nonroad.

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

genplot3 <- function() {

        data <- readRDS("summarySCC_PM25.rds")

        baltimore <- data[data$fips == "24510", ]

        g <- ggplot(baltimore, aes(factor(year), Emissions)) +
             geom_bar(stat = "identity") +
             geom_point(color = "steelblue", alpha = 1/2, size = 4) + 
             facet_grid(. ~ type) + 
             theme(panel.background = element_rect(fill = NA, color = "gray"),
                   panel.grid.minor = element_line()) +
             labs(x = "Year") +
             labs(y = expression(PM[2.5] * " (tons)")) +
             labs(title = expression(PM[2.5] * " in Baltimore by Source Type"))

        ggsave("plot3.png")

}
