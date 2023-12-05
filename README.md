---
title: "spCEH - spatial utility functions and data from CEH Edinburgh"
author: "Peter Levy"
date: "2021-08-30"
output:
  html_document:
    keep_md: yes
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  \usepackage[utf8]{inputenc}
---

<!-- badges: start -->
[![R-CMD-check](https://github.com/NERC-CEH/spCEH/workflows/R-CMD-check/badge.svg)](https://github.com/NERC-CEH/spCEH/actions)
<!-- badges: end -->

	
`spCEH` is an attempt to gather together some common functions and spatial data from CEH Edinburgh.
The idea is to standardise where possible such things as UK coastline data, topography data, raster grids for the UK (& Scotland, ...).
We share these in an easily accessible and updateable way by building them into an R package on GitHub. 

## Data
So far, data sets include:

- UK coastline polygons
- altitude data
- CEH LCM land cover map
- topographic wetness index
- soil carbon


## Functions
So far, the package includes functions for:

- retrieving template rasters
- masking rasters with the coastline to exclude sea (or land) cells

## Planned additions
### Data
- mean nitrogen deposition


### Functions

- colour palette diverging from zero


## Examples
### Install and load


```r
# if not already installed, install "remotes" package:
# install.packages("remotes")
remotes::install_github("NERC-CEH/spCEH")
```


```r
library(spCEH)
```

### `getSpatRasterTemplate`
Generate a raster grid covering the UK domain at 5-km resolution:


```r
r <- getSpatRasterTemplate(domain = "UK", res = 5000, proj = 'OSGB')
r
```

```
## class       : SpatRaster 
## dimensions  : 260, 140, 1  (nrow, ncol, nlyr)
## resolution  : 5000, 5000  (x, y)
## extent      : 0, 7e+05, 0, 1300000  (xmin, xmax, ymin, ymax)
## coord. ref. : OSGB36 / British National Grid (EPSG:27700) 
```

### `maskByCountry`
Mask out cells which are not in England or Wales:


```r
plot(st_geometry(sfdf_uk))
r <- getSpatRasterTemplate(domain = "UK", res = 10000, proj = 'OSGB')
r <- setValues(r, 1) # add some dummy values to plot
r
```

```
## class       : SpatRaster 
## dimensions  : 130, 70, 1  (nrow, ncol, nlyr)
## resolution  : 10000, 10000  (x, y)
## extent      : 0, 7e+05, 0, 1300000  (xmin, xmax, ymin, ymax)
## coord. ref. : OSGB36 / British National Grid (EPSG:27700) 
## source(s)   : memory
## name        : lyr.1 
## min value   :     1 
## max value   :     1 
```

```r
r_masked <- maskByCountry(r, c("England", "Wales"))
plot(r_masked == 1, add = TRUE)
```

![](use_spCEH_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

### Load some data
Data sets included in the package are loaded into memory when needed (LazyData):


```r
get_r_alt()  # and behold, it appears
```

```
## class       : SpatRaster 
## dimensions  : 1300, 700, 1  (nrow, ncol, nlyr)
## resolution  : 1000, 1000  (x, y)
## extent      : 0, 7e+05, 0, 1300000  (xmin, xmax, ymin, ymax)
## coord. ref. : OSGB36 / British National Grid (EPSG:27700) 
## source      : r_alt_1km.tif 
## name        : r_alt_1km 
## min value   :    -3.000 
## max value   :  1177.413 
```

```r
plot(get_r_alt())
```
