library(data.table)
library (lubridate)
library(stringr)

setwd("C:/Users/tbowen/Documents/dGen/New York/NYISO Data/dWind-NY/LaTeX - ny_dwind_writeup")

start_date <- as.POSIXct("2018-06-17 00:00")
end_date <- as.POSIXct("2018-06-23 23:00")

tz(start_date) <- "EST"
tz(end_date) <- "EST"

weekdata <- seq(start_date, end_date, by = "1 hour")

heat_map_data <- data.table("time" = weekdata)
heat_map_data[, `:=` (Weekday = weekdays(time),
                      Hour = lubridate::hour(time))]

heat_map_data[!(Weekday %in% c("Sunday", "Saturday")) & Hour %in% c(14:18), Value := "Yes"]
heat_map_data[is.na(Value), Value := "No"]

heat_map_data[, `:=` (time2 = rep(heat_map_data[Weekday == "Sunday", time], times = 7)),]

heat_map_data$Weekday <- factor(heat_map_data$Weekday, levels = rev(c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")))

heat_map_data$Value <- factor(heat_map_data$Value, levels = c("Yes","No"))


weekday_date_labels <- setNames(nm= c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
                                object = heat_map_data[, .(Date = format(lubridate::date(time)[1], "%m-%d-%Y")), 
                                                       by = .(Weekday)][, do.call(paste, c(.SD, sep = "\n")),])

capacity_value_valid_hours <- ggplot(heat_map_data, aes(x = time2, y = Weekday))+ 
  geom_tile(aes(fill = Value), colour = "white")+ 
  scale_fill_manual(name = "Valid Hours for\nCapacity Value", 
                    values = setNames(object = c("lightpink", "palegreen4"), nm = c("No","Yes")))+
  scale_y_discrete(labels = function(x) str_replace_all(x, weekday_date_labels))+
  scale_x_datetime(date_breaks = "4 hours", minor_breaks = "2 hours", date_labels = "%H:%M")+
  labs(x = "\nHour", y = "Day\n")+
  theme_bw(base_size = 12)+
  theme(axis.text.y = element_text(hjust = .5), legend.title = element_text(hjust = .5))

ggsave(capacity_value_valid_hours, filename = "images/cap_val_hours.png", 
       device = "png", width = 20, height = 12, units = "cm", dpi = 330)
