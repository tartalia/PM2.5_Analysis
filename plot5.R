library(data.table)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# Cut SCC to get all source that is related to motor vehicle
# I'm assuming that motor vehicle is all SCC with EI.Sector in mobile. eg:
# - aircrafts, locomotives, non-road equipments, marine vessels, heavy and light vehicles

# Grepping in EI.Sector by Mobile, subset SCC by the select rows, and select SCC column
scc <- SCC[grep("Mobile - ", SCC$EI.Sector), "SCC"]

# subset NEI dataset to select only SCC related to motor vehicle
nei <- nei[(SCC %in% scc),]

# sum emission grouped by year and fips
gdt <- nei[, sum(Emissions), by = "year,fips"]

# select Baltimore City
gdt <- gdt[(fips == "24510")]

# transform variables in factors
gdt$year <- factor(gdt$year)

# plot the graph
png("plot5.png", width=800, height=600)
g <- ggplot(aes(year, V1), data = gdt) + geom_bar(stat = "identity", width = .5) 
g <- g + labs(title = "Total Emission of PM2.5 Related to Motor Vehicle In Baltimore City by Year (1999 - 2008))")
g <- g + labs(x = "Year", y = "Total Amount of PM2.5 Emissions (in tons)")
print(g)

dev.off()
