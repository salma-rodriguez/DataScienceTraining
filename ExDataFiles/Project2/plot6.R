## This function makes a plot of motor vehicle-related emission for Baltimore

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

genplot6 <- function() {

        code <- readRDS("Source_Classification_Code.rds")
        data <- readRDS("summarySCC_PM25.rds")

        veh <- code[grep(".*[Vv]ehicle.*", code$Short.Name), 1]

        dat2 <- data[data$SCC %in% veh, ] ## select vehicle-related emissions
        dat3 <- dat2[dat2$fips %in% c("06037", "24510"), ] ## Baltimore and LA

        dat3$fip2 <- factor(dat3$fips, labels = c("Los Angeles", "Baltimore"))

        g <- ggplot(dat3, aes(factor(year), Emissions)) +
             geom_bar(stat = "identity") + 
             geom_point(color = "steelblue", alpha = 1/2, size = 4) + 
             facet_grid(. ~ fip2) + 
             theme(panel.background = element_rect(fill = NA, color = "gray"),
                   panel.grid.minor = element_line()) +
             labs(x = "Year") +
             labs(y = expression(PM[2.5] * " (tons)")) +
             labs(title = expression("Vehicle-Related " * PM[2.5]))

        ggsave("plot6.png")

}
