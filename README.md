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
# if not already installed:
library(devtools)
install_github("NERC-CEH/spCEH")
```


```r
library(spCEH)
```

### `getRasterTemplate`
Generate a raster grid covering the UK domain at 5-km resolution:


```r
r <- getRasterTemplate(domain = "UK", res = 5000, crs = crs_OSGB)
r
```

```
## class      : RasterLayer 
## dimensions : 260, 140, 36400  (nrow, ncol, ncell)
## resolution : 5000, 5000  (x, y)
## extent     : 0, 7e+05, 0, 1300000  (xmin, xmax, ymin, ymax)
## crs        : +proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs +towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894
```

### `maskByCountry`
Mask out cells which are not in England or Wales:


```r
plot(spgdf_uk)
r <- getRasterTemplate(domain = "UK", res = 10000, crs = crs_OSGB)
r <- setValues(r, 1) # add some dummy values to plot
r
```

```
## class      : RasterLayer 
## dimensions : 130, 70, 9100  (nrow, ncol, ncell)
## resolution : 10000, 10000  (x, y)
## extent     : 0, 7e+05, 0, 1300000  (xmin, xmax, ymin, ymax)
## crs        : +proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs +towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894 
## source     : memory
## names      : layer 
## values     : 1, 1  (min, max)
```

```r
r_masked <- maskByCountry(r, c("England", "Wales"))
plot(r_masked == 1, add = TRUE)
```

![](use_spCEH_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

### Load some data
Data sets included in the package are loaded into memory when needed (LazyData):


```r
r_alt  # and behold, it appears
```

```
## class      : RasterLayer 
## dimensions : 1300, 700, 910000  (nrow, ncol, ncell)
## resolution : 1000, 1000  (x, y)
## extent     : 0, 7e+05, 0, 1300000  (xmin, xmax, ymin, ymax)
## crs        : +proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +towgs84=446.448,-125.157,542.06,0.1502,0.247,0.8421,-20.4894 +units=m +no_defs 
## source     : memory
## names      : r_alt_1km 
## values     : -3, 1177.413  (min, max)
```

```r
plot(r_alt)
```

![](use_spCEH_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

You can enable figure captions by `fig_caption: yes` in YAML:

    output:
      rmarkdown::html_vignette:
        fig_caption: yes

Then you can use the chunk option `fig.cap = "Your figure caption."` in **knitr**.
