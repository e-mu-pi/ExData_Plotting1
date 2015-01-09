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

#copied from plot2.R to keep this file self-contained
make_second_plot <- function(data) {
  with(data, {
    plot(DateTime,Global_active_power,
                  ylab = "Global Active Power",
                  xlab = "",
                  pch = "")
    lines(DateTime,Global_active_power)
  })
}

#copied from plot3.R to keep this file self-contained
make_third_plot <- function(data) {
  with(data, {
    plot(DateTime,Sub_metering_1,
         ylab = "Energy sub metering",
         xlab = "",
         pch = "")
    lines(DateTime,Sub_metering_1, col = "black")
    lines(DateTime,Sub_metering_2, col = "red")
    lines(DateTime,Sub_metering_3, col = "blue")
  })
  legend("topright", lty = 1, col = c("black", "red", "blue"),
         bty = "n",
         legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
}

make_line_plot <- function(data, variable){
  with(data, {
    plot(DateTime,eval(variable),
                  pch = "",
                  xlab = "datetime",
                  ylab = variable )
    lines(DateTime,eval(variable))
  })
}



make_fourth_plot <- function(data) {
  par(mfrow = c(2,2))
  make_second_plot(data)
  make_line_plot(data, quote(Voltage))
  make_third_plot(data)
  make_line_plot(data, quote(Global_reactive_power))
  par(mfrow = c(1,1))
}
make_fourth_plot(data)

save_fourth_png <- function(data){
  png(file = "plot4.png")
  make_fourth_plot(data)
  dev.off()
}
save_fourth_png(data)