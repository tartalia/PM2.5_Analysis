library(data.table)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# Subset SCC to get all source that is related to coal combustion.
# I'm assuming that subseting SCC by EI.Sector, where there's word Coal is ok.
# This will return 99 observations, where we visualy can verify that all variable are related do fuel combustion and coal, eg: 
#
# Fuel Comb - Electric Generation - Coal
# Fuel Comb - Comm/Institutional - Coal
# Fuel Comb - Industrial Boilers, ICEs - Coal 

# Grepping in EI.Sector by Coal, subset SCC by the selected rows, and select SCC column
scc <- SCC[grep("Coal", SCC$EI.Sector), "SCC"]

# subset NEI dataset to select only SCC related to coal combustion
nei <- nei[(SCC %in% scc),]

# sum emission grouped by year
gdt <- nei[, sum(Emissions), by = "year"]

# transform variables in factors
gdt$year <- factor(gdt$year)

#non scientific notation on graphs
options(scipen=10000)

# plot the graph
png("plot4.png", width=800, height=600)
g <- ggplot(aes(year, V1), data = gdt) + geom_bar(stat = "identity", width = .5) 
g <- g + labs(title = "Total Emission of PM2.5 Related to Coal Combustion in US by Year (1999 - 2008)")
g <- g + labs(x = "Year", y = "Total Amount of PM2.5 Emissions (in tons)")
print(g)

dev.off()
