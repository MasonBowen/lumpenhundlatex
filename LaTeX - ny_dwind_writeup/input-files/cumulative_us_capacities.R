library(data.table)
library(ggplot2)
library(lubridate)

setwd("C:/Users/tbowen/Documents/dGen/New York/NYISO Data/dWind-NY/LaTeX - ny_dwind_writeup/input-files")

capdata <- fread("cumulative_us_capacities.csv")
capdata <- capdata[, .(Year, `Cumulative Capacity`, `Capacity Addition`, Type)]

capdata[ , lapply(.SD, as.numeric), .SDcols = !"Type"]

capplot <- ggplot(capdata)+
  geom_bar(aes(x=Year, y = `Capacity Addition`, fill = Type), stat='identity')+
  geom_point(aes(x = Year, y = `Cumulative Capacity`/10), color = "black",  size = 3, shape = 4)+
  geom_line(aes(x = Year, y = `Cumulative Capacity`/10), color = "black",  size = 2)+
  scale_y_continuous("Annual Capacity\nAdditions (MW)\n", sec.axis = sec_axis(~ . /100, name = "Cumulative Capacity (GW)\n"))+
  xlab("\nYear")+
  facet_wrap(~Type, nrow=1, scale = "free_y")+
  theme_bw(base_size = 14)+
  theme(legend.position = "none", strip.text = element_text(size = 16))

ggsave(capplot, filename = "../images/cumulative_us_capacities.png", device = "png", width = 25, height = 15, units = "cm", dpi = 330)
