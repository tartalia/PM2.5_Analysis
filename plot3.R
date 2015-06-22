library(data.table)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# sum and subset emissions by SCC (subject) and year
gdt <- nei[, sum(Emissions), by = "year,fips,type"]

# select Baltimore City
gdt <- gdt[(fips == "24510")]

# transform variables in factors
gdt$year <- factor(gdt$year)
gdt$type <- factor(gdt$type)

# plot the graph
png("plot3.png", width=800, height=600)

g <- ggplot(aes(year, V1, group = 1), data = gdt) + geom_bar(stat = "identity", width = .2) 
g <- g + geom_smooth(method="lm", se=FALSE, col="steelblue") + facet_wrap(~ type) 
g <- g + labs(title = "Total Emission of PM2.5 in Baltimore City by Year (1999 - 2008)")
g <- g + labs(x = "Year", y = "Total Amount of PM2.5 Emissions (in tons)")
print(g)

dev.off()
