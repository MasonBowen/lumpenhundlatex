# Plot power curves

library(data.table)
library(ggplot2)
library(stringr)

setwd("C:/Users/tbowen/Documents/dGen/New York/NYISO Data/dWind-NY/LaTeX - ny_dwind_writeup/input-files/")

curve_data <- fread("dwind_power_curves.csv")
curve_data <- curve_data[turbine_id %in% c(1:4),,]
curve_data[, turbine_class := 
             str_replace_all(turbine_id, 
                             setNames(nm = c(1:4), object = c("Small-\nResidential",
                                                              "Small-\nCommercial",
                                                              "Midsize", "Large")))]

# curve_data[, turbine_id := factor(turbine_id, levels = as.character(curve_data[, unique(turbine_id)])), ]

ggplot(curve_data)+
  geom_line(aes(x = windspeed_ms, 
                y = kw_per_kw_peak, 
                color = turbine_class, group = turbine_class))+
  scale_color_manual(values = setNames(nm = c("Small-\nResidential",
                                              "Small-\nCommercial",
                                              "Midsize", "Large"),
                                       object = c("red", "blue", "green", "black")))+
  theme_bw()
