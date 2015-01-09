# make sure the unzipped data is in your working directory. It
# should be named household_power_consumption.txt

library(dplyr)
library(data.table)

# data starts on 20061216, every minute for almost 4 years
# looking to get 20070201-20070202
first_row <- 46*24*60 + 6*60 + 37
two_days <- 2*24*60
data <- read.table("household_power_consumption.txt",
                   sep = ";",
                   col.names = c("Date","Time","Global_active_power",
                                 "Global_reactive_power","Voltage",
                                 "Global_intensity","Sub_metering_1",
                                 "Sub_metering_2","Sub_metering_3"),
                   nrows = two_days,
                   skip = first_row,
                   na.strings = '?',
                   colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),
)
data$DateTime <- strptime( paste(data$Date, data$Time), '%d/%m/%Y %H:%M:%S', tz = 'GMT')
data <- data %>% select(-Date) %>% select(-Time)

make_second_plot <- function(data) {
  with(data, plot(DateTime,Global_active_power,
                  ylab = "Global Active Power (kilowatts)",
                  xlab = "",
                  pch = ""))
  with(data, lines(DateTime,Global_active_power))
  dev.copy(png, file = "plot2.png")
  dev.off()
}
make_second_plot(data)