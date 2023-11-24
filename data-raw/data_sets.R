# This script is run to process raw data to create data objects
# stored in \data, which are built into the package.
# The contents of \data-raw are ignored when building.

library(sf)
library(terra)
setwd("./data-raw")

#Define geographic projections to be used
# lon-lat / EPSG:4326
# alternative specifications
# projlonlat <- CRS("+proj=longlat +datum=WGS84") # minimal
# projlonlat <- CRS("+init=epsg:4326")      # from rgdal
crs_lonlat <- crs('epsg:4326') # a terra CRS object
projlonlat <- crs('epsg:4326', proj = T) # a proj4 string for backwards compatability.
#cat(wkt(projlonlat),"\n")

# OSGB 1936 / British National Grid / EPSG:27700
#projOSGB <-  CRS("+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +towgs84=446.448,-125.157,542.06,0.15,0.247,0.842,-20.489 +units=m +no_defs")
crs_OSGB <- crs("EPSG:27700")  # a terra crs object
projOSGB <- crs("EPSG:27700", proj = T)  # a proj4 string for backwards compatability.

# TM75 / Irish Grid / EPSG:29903
crs_Ire <- crs("EPSG:29903")  # an terra crs object
projIre <- crs("EPSG:29903", proj = T) # a CRS from the proj4 string

usethis::use_data(projlonlat, projOSGB, projIre, overwrite = TRUE)
usethis::use_data(crs_lonlat, crs_OSGB, crs_Ire, overwrite = TRUE)

# read uk polygons
sfdf_uk <- sf::st_read("./uk_countries", "uk_countries")
#projection(spgdf_uk) <- projection(projOSGB)
#CRS(spgdf_uk) <- projection(projOSGB)
st_crs(sfdf_uk) <- crs_OSGB
#cat(wkt(spgdf_uk),"\n")

spgdf_uk <- sfdf_uk # for backwards comparability

usethis::use_data(sfdf_uk, spgdf_uk, overwrite = TRUE)

# # pre-existing raster format data
# r_alt   <- rast("r_alt_1km.tif")
# r_Csoil <- rast("r_Csoil_1km.tif")
# r_lcm   <- rast("r_lcm_1km.tif")
# r_twi   <- rast("r_twi_1km.tif")
#
# crs(r_alt) <- crs_OSGB
# crs(r_Csoil) <- crs_OSGB
# crs(r_lcm) <- crs_OSGB
# crs(r_twi) <- crs_OSGB
#
# r_alt <- wrap(r_alt)
# r_Csoil <- wrap(r_Csoil)
# r_lcm <- wrap(r_lcm)
# r_twi <- wrap(r_twi)
#
# # seems to work so long as in memory
# # but we have to force it there with readAll
# usethis::use_data(r_alt, r_Csoil,
#   r_lcm, r_twi, overwrite = TRUE)

# For testing:
# rm(r_twi)
# load("../data/r_twi.rda", verbose = TRUE)
# plot(terra::unwrap(r_twi))

setwd("..")

