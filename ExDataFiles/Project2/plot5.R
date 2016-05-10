## This function makes a plot of motor vehicle-related emission for Baltimore

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

genplot5 <- function() {

        code <- readRDS("Source_Classification_Code.rds")
        data <- readRDS("summarySCC_PM25.rds")

        veh <- code[c(grep(".*[Vv]ehicle.*", code$Short.Name)), 1]

        dat2 <- data[data$SCC %in% veh, ] ## select vehicle-related emissions
        dat3 <- dat2[dat2$fips == "24510", ] ## select Baltimore

        g <- ggplot(dat3, aes(factor(year), Emissions)) +
             geom_bar(stat = "identity", width = .5) +
             theme(panel.background = element_rect(fill = NA, color = "gray"),
                   panel.grid.minor = element_line()) +
             labs(x = "Year") +
             labs(y = expression(PM[2.5] * " (tons)")) +
             labs(title = expression("Baltimore Vehicle-Related " * PM[2.5]))

        ggsave("plot5.png")
}
