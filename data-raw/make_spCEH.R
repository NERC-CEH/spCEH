rm(list=ls(all=TRUE))
library(devtools)
library(roxygen2)

# quick way of testing pkg functions without building package
#source("./R/spCEH.R")

#load(file = "spCEH.RData", verbose = TRUE)
#nSectors, sectorName, sectorLongName, alpha_year_byGHG_df, mod.yday, alpha_wday_df, mod.hour

#create("spCEH") # if it doesn't already exist
# Add functions in files to R/ directory

getwd()
#setwd("./spCEH")
setwd("..")
#use_data_raw()
use_build_ignore("data-raw")
#devtools::use_data(nSectors, sectorName, sectorLongName, alpha_year_byGHG_df, mod.yday, alpha_wday_df, mod.hour, overwrite = TRUE)
#devtools::use_data(ch4BySector, co2BySector, n2oBySector, internal = TRUE)

check_man()
document()
clean_vignettes()
build_vignettes()
system.time(build())

# build the manual
#Sys.getenv(c("R_TEXI2DVICMD", "R_PAPERSIZE", "RD2PDF_INPUTENC"))
#Sys.setenv(RD2PDF_INPUTENC = "inputenx ")
path <- find.package("spCEH")
system(paste(shQuote(file.path(R.home("bin"), "R")),"CMD", "Rd2pdf", shQuote(path)))
#C:/PROGRA~1/R/R-32~1.4RE/bin/x64/R R CMD Rd2pdf --no-clean N:/0Peter/prop/UKinverseFlux/GHG_TAP/DelD/anthEmis/spCEH


#  check(manual = FALSE, vignettes = FALSE)
system.time(
  check(manual = FALSE)
)
build(manual = FALSE, vignettes = FALSE)
build(binary = TRUE)

getwd()
setwd("..")
detach("package:spCEH", unload=TRUE)

#install("spCEH") # locally
#install_github("NERC-CEH/spCEH") # direct from GitHub
# need to install from a tarball for vignettes to be found
install.packages("C:/Users/plevy/Downloads/spCEH-0.2.2.tar.gz", repos = NULL, type="source")
install.packages("./spCEH_0.4.1.tar.gz", repos = NULL, type="source")
library(spCEH)
packageVersion("spCEH")
?spCEH
?getRasterTemplate
?projOSGB
r_lcm
r <- getRasterTemplate(domain = "UK", res = 10000, proj = 'OSGB')