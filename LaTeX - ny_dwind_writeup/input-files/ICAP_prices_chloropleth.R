library(maptools)
library(ggplot2)
library(rgdal)

library(data.table)

setwd("C:/Users/tbowen/Documents/dGen/New York/NYISO Data/dWind-NY/LaTeX - ny_dwind_writeup/")

# ----------------------------- / 
# Load ICAP data and shapefiles
# ----------------------------- /

# http://bl.ocks.org/prabhasp/raw/5030005/

icap_data <- fread("input-files/ICAP_values.csv", header = TRUE)
icap_data <- melt.data.table(icap_data, id.vars = "Zone", variable.name = "Year", value.name = "ICAP")
icap_data[, `:=` (Year = as.numeric(as.character(Year)),
                  ICAP = as.numeric(as.character(ICAP)))]

zones_loc <- "../Utility and Load Zone maps/Updated Utility Territories and Load Zone/nyiso_load_zone_files_updated.shp"
zones <- readOGR(zones_loc)

# ----------------------------- / 
# Lplot chloropleth
# ----------------------------- /

# http://bl.ocks.org/prabhasp/raw/5030005/

zones <- fortify(zones, region = "Title")

icap_chloropleth <- ggplot() + 
  geom_map(data = icap_data[Year == 2018,,], 
           aes(map_id = Zone, fill = ICAP), color = "gray", size = .1,
           map = zones) + 
  expand_limits(x = zones$long, y = zones$lat)+
  scale_fill_gradient(low = "steelblue3", high = "navy")+
  theme_bw()+
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(), 
        axis.line = element_blank(),
        panel.background = element_rect(fill = "white", color = "white"),
        panel.grid = element_blank(),
        panel.border = element_blank())+
  guides(fill=guide_colorbar(title="ICAP Values\n($/kWh)", barwidth = 0.75, barheight = 7.5))

ggsave(icap_chloropleth, filename = "images/ICAP_chloropleth.png", 
       device = "png", width = 20, height = 10, units = "cm", dpi = 330)
