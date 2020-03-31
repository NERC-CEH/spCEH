# This script is run to process raw data to create data objects 
# stored in \data, which are built into the package.
# The contents of \data-raw are ignored when building.

library(raster)
setwd("./data-raw")

#Define geographic projections to be used
# lat / lon 
projlonlat <- CRS("+proj=longlat +datum=WGS84")
# OSGB 1936 / British National Grid 
projOSGB <-  CRS("+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs")
usethis::use_data(projlonlat, projOSGB, overwrite = TRUE)

# read uk polygons
spgdf_uk <- rgdal::readOGR("./uk_countries", "uk_countries")
projection(spgdf_uk) <- projection(projOSGB)
usethis::use_data(spgdf_uk, overwrite = TRUE)
setwd("..")
