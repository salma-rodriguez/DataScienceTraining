## This function makes a plot of coal combustion-related PM2.5 emission

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

genplot4 <- function() {

        code <- readRDS("Source_Classification_Code.rds")
        data <- readRDS("summarySCC_PM25.rds")

        coal <- code[c(grep(".*[Cc]oal.*", code$Short.Name)), 1]
        dat2 <- data[data$SCC %in% coal, ] ## select coal-related emissions

        g <- ggplot(dat2, aes(factor(year), Emissions)) +
             geom_bar(stat = "identity", width = .5) +
             theme(panel.background = element_rect(fill = NA, color = "gray"),
                   panel.grid.minor = element_line()) +
             labs(x = "Year") +
             labs(y = expression(PM[2.5] * " (tons)")) +
             labs(title = expression("US Coal-Related " * PM[2.5]))

        ggsave("plot4.png")
}
