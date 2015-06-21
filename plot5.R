library(data.table)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# Cut SCC to get all source that is related to motor vehicle
# I'm assuming all SCC where EI.Sector are in mobile - aircrafts, locomotives, non-road equipments, marine vessels, heavy and light vehicles

# Grepping in EI.Sector by Coal, subset SCC by the select rows, and select SCC column
scc <- SCC[grep("Mobile - ", SCC$EI.Sector), "SCC"]

# subset NEI dataset to select only SCC related to coal combustion
nei <- nei[(SCC %in% scc),]

# sum emission grouped by year
gdt <- nei[, sum(Emissions), by = "year,fips"]

# select Baltimore City
gdt <- gdt[(fips == "24510")]

# plot the graph with a linear regression line
png("plot5.png", width=800, height=600)
qplot(year, V1, data = gdt, geom = "line", ylab="Total Amount of PM2.5 Emissions (in tons) ", xlab="Year", 
      main="Total Emission of PM2.5 Related to Motor Vehicle in Baltimore City by Year (1999 - 2008)") + geom_smooth(size = 2, linetype = 3, method = "lm", se = FALSE)
dev.off()

