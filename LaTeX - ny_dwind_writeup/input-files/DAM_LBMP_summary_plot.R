library(data.table)
library(ggplot2)
library(lubridate)

setwd("C:/Users/tbowen/Documents/dGen/New York/NYISO Data/dWind-NY/LaTeX - ny_dwind_writeup/input-files")

lbmp_data_loc <- "../../Raw Utility and NYISO Input Data/Zonal_DAM_LBMP.csv"
year <- 2018


lbmp_data <- fread(lbmp_data_loc)
lbmp_data[, `:=`(`Time Stamp`= as.POSIXct(`Time Stamp`, tz = "US/Eastern", format = "%m/%d/%Y %H:%M")),]
lbmp_data <- lbmp_data[year(`Time Stamp`) == year,,]

zone_renames <- c('WEST'='West', 
                  'GENESE'='Genesee',
                  'CENTRL'='Central',
                  'NORTH'='North',
                  'MHK VAL'='Mohawk Valley',
                  'CAPITL'='Capital',
                  'HUD VL'='Hudson Valley',
                  'MILLWD'='Millwood',
                  'DUNWOD'='Dunwoodie',
                  'N.Y.C.'='N.Y.C.',
                  'LONGIL'='Long Island')

lbmp_data[, Name := str_replace_all(Name, zone_renames)]

p1 <- ggplot()+
  geom_boxplot(mapping = aes(Name, `LBMP ($/MWHr)`), outlier.shape = NA,
               data = lbmp_data[Name %in% as.character(zone_renames),,])+
  geom_point(mapping = aes(Name, `LBMP ($/MWHr)`), pch = 8, color = "black",
             data = lbmp_data[Name %in% as.character(zone_renames), 
                              .(`LBMP ($/MWHr)` = mean(`LBMP ($/MWHr)`)), 
                              by = .(Name)])+
  coord_cartesian(ylim = c(0,80))+
  labs(x = "", y = "Day-Ahead Market LBMP ($/MWh)\n")+
  theme_bw(base_size = 14)+
  theme(axis.text = element_text(size = 14), axis.text.x = element_text(size=14, hjust = 1, angle = 30))

ggsave(p1, filename = "../images/boxplot_dam_lbmp_prices.png", device = "png", width = 24, height = 12, dpi = 330, units = "cm")
