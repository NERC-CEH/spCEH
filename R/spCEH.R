## ----spCEH_pkg, eval=TRUE------------------------------------------------
#' Spatial functions and data from CEH.
#'
#' spCEH provides spatial utility functions and data.
"_PACKAGE"
#> [1] "_PACKAGE"

#' Function to initialise an empty raster for 
#'   the UK or a sub-region
#'
#' @param domain Domain of the output raster: "UK", "Scotland".
#' @param res Resolution of the output raster in metres.
#' @param proj Projection of the output raster: "projOSGB" or "projlonlat".
#' @return An empty raster object covering the UK.
#' @export
#' @examples
#' r <- getRasterTemplate(domain = "Scotland", res = 10000)
#' r <- getRasterTemplate(domain = "NT_10km", res = 100)
#' r <- getRasterTemplate(domain = "UK", res = 10000, proj = projOSGB)
#' r <- getRasterTemplate(domain = "UK", res = 0.1, proj = projlonlat)
#' r <- getRasterTemplate(domain = "UK_NAME", proj = projlonlat)
getRasterTemplate <- function(domain = "UK", res = 100, proj = projOSGB){
  # OSGB 1936 / British National Grid 
  #proj <- "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
  if (substr(proj, 20, 21) == "49"){  # then it is OSGB
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
  } else if (substr(proj, 20, 21) == "53") {
    print("Irish Grid not yet implemented")  
    # proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
  } else if (substr(proj, 7, 13) == "longlat") { # lon-lat
    if (domain == "UK")     {xmin <- -10.47;    xmax <- 4.9;     ymin <- 49.2;     ymax <- 61.9}
    if (domain == "UK_NAME"){xmin <- -10.47024; xmax <- 4.83472; ymin <- 49.28752; ymax <- 61.82992}
  } else { print(paste("Unknown projection - check exact form of", proj))
  }
    
  ext <- extent(xmin, xmax, ymin, ymax)

  ## S4 method for signature 'Extent'
  r <- raster(ext, resolution = res, crs = proj)
  if (domain == "UK_NAME"){
    res_x <- 0.01408; res_y <- 0.00936 # dx=0.352/25; dy=0.234/25
    r <- raster(ext, resolution = c(res_x, res_y), crs = proj)
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
#' r <- getRasterTemplate(domain = "UK", res = 10000)
#' r_masked <- maskByCountry(r, c("England", "Wales"))
maskByCountry <- function(r, countryName){
  #ogrInfo("./uk_countries", "uk_countries")
  # read in shapefile for UK borders
  #uk.spoly <- rgdal::readOGR("./uk_countries", "uk_countries")
  # note that readOGR will read the .prj file if it exists
  # However, we need to enforce them to be the same
  #projection(spgdf_uk) <- projection(r)
  spgdf_mask <- subset(spgdf_uk, spgdf_uk@data$COUNTRY %in% countryName)
  # mask out non-countryName
  r_masked <- mask(r, spgdf_mask)
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
#' @return A RasterLayer containing the named variable at the specified resolution.
#' @export
#' # @examples
#' # r_alt <- getData(name_var = "alt", res = 1000)
getData <- function(name_var = c("alt", "Csoil", "lcm", "twi"), res = 1000){
  name_var <- match.arg(name_var)
 
  fname <- paste0("r_", name_var, "_1km.tif")
  fname <- system.file("extdata", fname, package="spCEH")
  r <- raster(fname)
  
  if (res != 1000){  # 1 km is reference value
    fact = res/1000
	if (fact != as.integer(fact)){
	  warning("Resolution not a multiple of 1000, so rounding down.")
	  fact <- as.integer(fact)
	}
    r <- raster::aggregate(r, fact = res/1000)
  }
  return(r)
}

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
#' @format A SpatialPolygonsDataFrame object from the sp package
#' @source \url{https://spatialreference.org/}
"spgdf_uk"

#' UK altitude
#'
#' A raster layer of altitude in the UK
#'
#' @format A Raster object from the raster package. Units: metres above mean sea level
#' @source \url{https://SRTM space shuttle terrain mission I think/}
"r_alt"

#' UK soil carbon
#'
#' A raster layer of soil carbon in the UK
#'
#' @format A Raster object from the raster package. Units: kg C / m2
#' @source \url{https://Bradley et al 2005/}
"r_Csoil"

#' UK Land Cover Map classes
#'
#' A raster layer of UK Land Cover Map classes
#'
#' @format A Raster object from the raster package. Units: integers representing land cover classes
#' @source \url{https://EIDC/}
"r_lcm"

#' UK Topographic Wetness Index
#'
#' A raster layer of Topographic Wetness Index in the UK
#'
#' @format A Raster object from the raster package. Units: dimensionless ratio
#' @source \url{https://Derived from OS DEM data by PL/}
"r_twi"
