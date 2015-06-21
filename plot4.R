library(data.table)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# Cut SCC to get all source that is related to coal combustion.
# I'm assuming that subseting SCC by EI.Sector, where there's word Coal is ok. 
# This will return 99 observations, where we visualy can verify that all variable are like 
# "Fuel Comb - ... - Coal", for example:
#
# Fuel Comb - Electric Generation - Coal
# Fuel Comb - Comm/Institutional - Coal
# Fuel Comb - Industrial Boilers, ICEs - Coal 
# 
# Other variables are varying, because we see that EI.Sector are repeating

# Grepping in EI.Sector by Coal, subset SCC by the select rows, and select SCC column
scc <- SCC[grep("Coal", SCC$EI.Sector), "SCC"]

# subset NEI dataset to select only SCC related to coal combustion
nei <- nei[(SCC %in% scc),]

# sum emission grouped by year
gdt <- nei[, sum(Emissions), by = "year"]

# plot the graph with a linear regression line
png("plot4.png", width=800, height=600)
qplot(year, V1, data = gdt, geom = "line", ylab="Total Amount of PM2.5 Emissions (in tons) ", xlab="Year", 
      main="Total Emission of PM2.5 Related to Coal Combustion in US by Year (1999 - 2008)") + geom_smooth(size = 2, linetype = 3, method = "lm", se = FALSE)
dev.off()
