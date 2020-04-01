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

# pre-existing raster format data
r_alt   <- raster("r_alt_1km.tif")
r_Csoil <- raster("r_Csoil_1km.tif")
r_lcm   <- raster("r_lcm_1km.tif")
r_twi   <- raster("r_twi_1km.tif")

canProcessInMemory(r_Csoil, n=4, verbose=TRUE)

r_alt   <- readAll(r_alt)
r_Csoil <- readAll(r_Csoil)
r_lcm   <- readAll(r_lcm)
r_twi   <- readAll(r_twi)

inMemory(r_alt  )
inMemory(r_Csoil)
inMemory(r_lcm  )
inMemory(r_twi  )

# seems to work so long as in memory
# but we have to force it there with readAll
usethis::use_data(r_alt, r_Csoil, 
  r_lcm, r_twi, overwrite = TRUE)

# For testing:
# rm(r_twi)
# load("../data/r_twi.rda", verbose = TRUE)
# plot(r_twi)

setwd("..")

