## ----spCEH_pkg, eval=TRUE------------------------------------------------
#' Spatial functions and data from CEH.
#'
#' spCEH provides spatial utility functions and data.
"_PACKAGE"
#> [1] "_PACKAGE"

#' Function to initialise an empty SpatRaster for
#'   the UK or a sub-region
#'
#' @param domain Domain of the output raster: "UK", "Scotland" etc.
#' @param res Resolution of the output raster in metres (for OSGB) or decimal degrees (WGS84). For the 'UK_NAME' domain, the res is pre-specified.
#' @param proj CRS (coordinate reference system) of the output raster: "OSGB" or "WGS84".
#' @return An empty SpatRaster (from the terra package) object covering the domain.
#' @export
#' @examples
#' r <- getSpatRasterTemplate(domain = "UK", res = 10000, proj = 'OSGB')
#' r <- getSpatRasterTemplate(domain = "Scotland", res = 10000, proj = 'OSGB')
#' r <- getSpatRasterTemplate(domain = "NT_10km", res = 100, proj = 'OSGB')
#' r <- getSpatRasterTemplate(domain = "UK", res = 10000, proj = 'OSGB')
#' r <- getSpatRasterTemplate(domain = "UK", res = 0.1, proj = 'WGS84')
#' r <- getSpatRasterTemplate(domain = "UK_NAME", proj = 'WGS84')
#' r <- getSpatRasterTemplate(domain = "UK_NAME", proj = 'WGS84')
getSpatRasterTemplate <- function(domain = "UK", res = 100, proj = NULL){

  if (!(proj %in% c('OSGB', 'WGS84'))) stop("proj arguement must be one of: 'OSGB' or 'WGS84'.")

  if (proj == "OSGB"){ # easting - northing
    crs <- 'EPSG:27700'
    if (domain == "UK"){xmin <- 0; xmax <- 700000; ymin <- 0; ymax <- 1300000}
    if (domain == "Scotland"){xmin <- 0; xmax <- 500000; ymin <- 500000; ymax <- 1300000}
    if (domain == "England"){xmin <- 0; xmax <- 700000; ymin <- 0; ymax <- 700000}
    if (domain == "Wales"){xmin <- 150000; xmax <- 400000; ymin <- 150000; ymax <- 400000}
    if (domain == "Northern Ireland"){xmin <- 0; xmax <- 200000; ymin <- 450000; ymax <- 650000}
    if (domain == "Edinburgh_100km"){xmin <- 300000; xmax <- 400000; ymin <- 600000; ymax <- 700000}
    if (domain == "NO_100km"){xmin <- 300000; xmax <- 400000; ymin <- 700000; ymax <- 800000}
    if (domain == "NT_100km"){xmin <- 300000; xmax <- 400000; ymin <- 600000; ymax <- 700000}
    if (domain == "NT_10km"){xmin <- 300000; xmax <- 310000; ymin <- 600000; ymax <- 610000}
    if (domain == "NT_8km"){xmin <- 300000; xmax <- 308000; ymin <- 600000; ymax <- 608000}
  }

  if (proj == "WGS84") { # lon-lat
    crs <- 'EPSG:4326'
    if (domain == "UK")     {xmin <- -10.47;    xmax <- 4.9;     ymin <- 49.2;     ymax <- 61.9}
    if (domain == "UK_NAME"){xmin <- -10.47024; xmax <- 4.83472; ymin <- 49.28752; ymax <- 61.82992}
  }

  ext <- ext(xmin, xmax, ymin, ymax)

  ## S4 method for signature 'Extent'
  r <- rast(ext, resolution = res, crs = crs)
  #cat(wkt(r),"\n")

  if (domain == "UK_NAME"){
    res_x <- 0.01408; res_y <- 0.00936 # dx=0.352/25; dy=0.234/25
    r <- rast(ext, resolution = c(res_x, res_y), crs = crs)
  }
  return(r)
}


#' Function to mask out cells outwith polygons defining a country within the UK
#'
#' @param r A RasterLayer.
#' @param countryName The name of a country within the UK ("Scotland", "Northern Ireland", "England" or "Wales").
#' @return A RasterLayer masked to the named country.
#' @export
#' @examples
#' r <- getSpatRasterTemplate(domain = "UK", res = 10000, proj = 'OSGB')
#'r[] <- 1
#'r_masked <- maskByCountry(r, c("England", "Wales"))
#'plot(r_masked)
maskByCountry <- function(r, countryName){
  sfdf_mask <- subset(sfdf_uk, sfdf_uk$COUNTRY %in% countryName)
  # mask out non-countryName
  r_masked <- mask(r, sfdf_mask)
  return(r_masked)
}


#' Function to load data distributed with the spCEH package.
#' Data are retrived from tif files stored in extdata.
#' getData masks the equivalent function in raster package,
#' so use raster::getData or spCEH::getData to be explicit.
#' For small-medium sized files, this function is not necessary;
#' the four rasters below can be saved as .rda files.
#' However, this will be needed for anything larger than 100 MB.
#'
#' @param name_var A variable name, one of "alt", "Csoil", "lcm", "twi".
#' @param res Resolution of the raster grid produced. Defaults to 1000 m.  Higher values produce coarser grids by aggregation (e.g. 5000 gives a 5-km grid).
#' @return A SpatRasterLayer containing the named variable at the specified resolution.
#' @export
# #' @examples
# #' r_alt <- getData(name_var = "alt", res = 1000)
getData <- function(name_var = c("alt", "Csoil", "lcm", "twi"), res = 1000){
  name_var <- match.arg(name_var)

  fname <- paste0("r_", name_var, "_1km.tif")
  fname <- system.file("extdata", fname, package="spCEH")
  r <- rast(fname)

  if (res != 1000){  # 1 km is reference value
    fact = res/1000
	if (fact != as.integer(fact)){
	  warning("Resolution not a multiple of 1000, so rounding down.")
	  fact <- as.integer(fact)
	}
    r <- aggregate(r, fact = res/1000)
  }
  return(r)
}

#' CRS object for null projection (longitude-latitude).
#'
#' A Coordinate Reference System object for the WGS84 lon-lat coordinate system / EPSG:4326
#'
#' @format A terra CRS object
#' @source \url{https://spatialreference.org/}
"crs_lonlat"

#' CRS object for the OSGB projection.
#'
#' A Coordinate Reference System object for the Transverse Mercator projection used by the Ordnance Survey in Great Britain (OSGB / EPSG:27700)
#'
#' @format A terra CRS object
#' @source \url{https://spatialreference.org/}
"crs_OSGB"

#' CRS object for the TM75 Irish Grid projection.
#'
#' A Coordinate Reference System object for the Transverse Mercator projection used by the Ordnance Survey in Ireland (TM75 / EPSG:29903)
#'
#' @format A terra CRS object
#' @source \url{https://spatialreference.org/}
"crs_Ire"

#' CRS object for null projection (longitude-latitude).
#'
#' A Coordinate Reference System object for the WGS84 lon-lat coordinate system / EPSG:4326
#'
#' @format A text string
#' @source \url{https://spatialreference.org/}
"projlonlat"

#' CRS object for the OSGB projection.
#'
#' A Coordinate Reference System object for the Transverse Mercator projection used by the Ordnance Survey in Great Britain (OSGB / EPSG:27700)
#'
#' @format A text string
#' @source \url{https://spatialreference.org/}
"projOSGB"

#' CRS object for the TM75 Irish Grid projection.
#'
#' A Coordinate Reference System object for the Transverse Mercator projection used by the Ordnance Survey in Ireland (TM75 / EPSG:29903)
#'
#' @format A text string
#' @source \url{https://spatialreference.org/}
"projIre"

#' UK coastline
#'
#' A SpatialPolygonsDataFrame of the UK coastline and borders
#'
#' @format A SimpleFeaturesDataFrame object from the sf package - included for backwards compatability.
#' @source \url{https://spatialreference.org/}
"spgdf_uk"

#' UK coastline
#'
#' A SimpleFeaturesDataFrame of the UK coastline and borders
#'
#' @format A SimpleFeaturesDataFrame object from the sf package
#' @source \url{https://spatialreference.org/}
"sfdf_uk"

#' Function to export UK altitude
#'
#' A raster layer of altitude in the UK
#'
#' @format A SpatRaster (Raster) object from the terra package. Units: metres above mean sea level. CRS: EPSG 27700 (British National Grid)
#' @source \url{https://SRTM space shuttle terrain mission I think/}
#' @export
#' @examples
#' r_alt <- get_r_alt()
get_r_alt <- function(){
  file_path <- system.file("extdata", "r_alt_1km.tif", package="spCEH")
  r <- rast(file_path)
  crs(r) <- 'EPSG:27700'
  return(r)
}

#' Function to export UK soil carbon
#'
#' A raster layer of soil carbon in the UK
#'
#' @format A SpatRaster object from the terra package. Units: kg C / m2. CRS: EPSG 27700 (British National Grid)
#' @source \url{https://Bradley et al 2005/}
#' @export
#' @examples
#' r_Csoil <- get_r_Csoil()
get_r_Csoil <- function(){
  file_path <- system.file("extdata", "r_Csoil_1km.tif", package="spCEH")
  r <- rast(file_path)
  crs(r) <- 'EPSG:27700'
  return(r)
}

#' Function to export UK Land Cover Map classes
#'
#' A raster layer of UK Land Cover Map classes.
#'
#' @format A SpatRaster object from the terra package. Units: integers representing land cover classes. CRS: EPSG 27700 (British National Grid)
#' @source \url{https://EIDC/}
#' @export
#' @examples
#' r_lcm <- get_r_lcm()
get_r_lcm <- function(){
  file_path <- system.file("extdata", "r_lcm_1km.tif", package="spCEH")
  r <- rast(file_path)
  crs(r) <- 'EPSG:27700'
  return(r)
}


#' Function to export UK Topographic Wetness Index
#'
#' A raster layer of Topographic Wetness Index in the UK.
#'
#' @format A SpatRaster object from the terra package. Units: dimensionless ratio. CRS: EPSG 27700 (British National Grid)
#' @source \url{https://Derived from OS DEM data by PL/}
#' @export
#' @examples
#' r_twi <- get_r_twi()
get_r_twi <- function(){
  file_path <- system.file("extdata", "r_twi_1km.tif", package="spCEH")
  r <- rast(file_path)
  crs(r) <- 'EPSG:27700'
  return(r)
}

