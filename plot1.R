library(data.table)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# transform to data.table for better performance
nei <- data.table(NEI)

# sum Emissions by SCC (subject) and year
gdt <- nei[, sum(Emissions), by = "year"]

png("plot1.png")

# supress cientific notation on y label
options(scipen=5)

# plot the graph
plot(gdt$year, gdt$V1, type="l", ylab="Total Amount of PM2.5 Emissions (in tons) ", xlab="Year", col="red", main="Total Emission of PM2.5 by Year")

# add linear model line
r <- lm(V1 ~ year, data = gdt)
abline(r, lty = "dashed")

dev.off()
