library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# sum Emissions by SCC (subject) and year
gdt <- nei[, sum(Emissions), by = "year,fips"]
gdt <- gdt[(fips == "24510")]

# transform variables in factors
gdt$year <- factor(gdt$year)

# supress cientific notation on y label
options(scipen=5)

# plot the graph
png("plot2.png")
plot(gdt$year, gdt$V1, lwd = 3, ylab="Total Amount of PM2.5 Emissions (in tons) ", xlab="Year", col="red", main="Total Emission of PM2.5 in Baltimore City by Year (1999 - 2008)")

dev.off()
