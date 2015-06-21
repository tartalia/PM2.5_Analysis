library(data.table)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# sum and subset emissions by SCC (subject) and year
gdt <- nei[, sum(Emissions), by = "year,fips,type"]
gdt <- gdt[(fips == "24510")]

# plot the graph
png("plot3.png", width=800, height=600)
qplot(year, V1, data = gdt, geom = c("line"), color = type, ylab="Total Amount of PM2.5 Emissions (in tons) ", xlab="Year", main="Total Emission of PM2.5 in Baltimore City by Year and Type (1999 - 2008)")
dev.off()
