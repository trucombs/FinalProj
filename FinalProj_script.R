install.packages("devtools")
library(devtools)
install_github("ropensci/prism") #use this instead of install.packages("prism") to get latest version 
packageVersion("prism") #should be >= 0.2.0 (required for 'prism_set_dl_dir')
library(prism)
#install.packages("tigris")
#install.packages("terra")
#library(terra)
#install.packages("magrittr")
#library(magrittr)
#install.packages("exactextractr")
#library(exactextractr)
install.packages("sf")
library(sf)
library(rgdal)

#clone https://github.com/trucombs/FinalProj

setwd("~/FinalProj")

dir.create("prism_data") #creates data archive in the working directory

prism_set_dl_dir("~/prism_data")

#pull mean daily temps"
get_prism_dailys(
  type = "tmean",
  minDate = "2020-01-01",
  maxDate = "2020-12-31",
  keepZip = FALSE
)

#pull daily precip"
get_prism_dailys(
  type = "ppt",
  minDate = "2020-01-01",
  maxDate = "2020-12-31",
  keepZip = FALSE
)

#monthly, annual data--if desired
#get_prism_monthlys(type = "tmean", year = 2018:2021, mon = 1:12, keepZip = FALSE)
#get_prism_annual("ppt", years = 2000:2015, keepZip = FALSE)

test <- prism_archive_subset(
  "tmean", "daily", dates = "2020-01-01")
pd_image(test)


##Edits from 12/8 (STL)

#get_prism_monthlys(type = "tmean", year = 2018:2021, mon = 1:12, keepZip = FALSE)
#get_prism_annual("ppt", years = 2000:2015, keepZip = FALSE)

#test <- prism_archive_subset(
#  "tmean", "monthly", year = 2018, mon = 11)
#pd_image(test)

##confirmed to be working
p <- pd_plot_slice(prism_archive_subset(
  "tmean", "daily", minDate = "2020-01-01", 
  maxDate = "2020-12-31"), c(-73.2119,44.4758))
print(p)

#not really sure what the purpose of stacking is here--use slice above
stack = pd_stack(prism_archive_subset(
  "tmean", "daily", 
  minDate = "2020-01-01", 
  maxDate = "2020-12-31"))

dim(stack)
typeof(stack)
writeRaster(stack, "/home/rstudio/FinalProj/test.tif", bandorder='BIL', format="GTiff", overwrite=TRUE)
slice = pd_plot_slice(stack,c(-73.2119,44.4758))

df <- as.data.frame(stack[[1]])

dim(df)


tigris::counties(state = "Arizona", cb = TRUE)
st_as_sf() %>%
  st_transform(terra::crs(r))

exact_extract
st_as_sf
r <- stack[[1]]
dim(r)
typeof(r)
##End edits from 12/8

pd_image(r)

library(raster)
library(rgdal)


plot(r)

install.packages("ggplot")
library(ggplot2)
ggplot() +
  geom_raster(data = df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho)) + 
  coord_quickmap()

# S4 method for Raster,ANY
plot(stack, col, alpha=NULL,
     colNA=NA, add=FALSE, ext=NULL, useRaster=TRUE, interpolate=FALSE, 
     addfun=NULL, nc, nr, maxnl=16, main, npretty=0)


library(maptools)  ## For wrld_simpl
library(raster)

## Example SpatialPolygonsDataFrame
data(test)
SPDF <- subset(wrld_simpl, NAME=="Brazil")

## Example RasterLayer
r <- raster(nrow=1e3, ncol=1e3, crs=proj4string(SPDF))
r[] <- 1:length(r)

## crop and mask
r2 <- crop(r, extent(SPDF))
r3 <- mask(r2, SPDF)

## Check that it worked
plot(r3)
plot(SPDF, add=TRUE, lwd=2)

test2 = brick(stack)

test3  <- as.data.frame(stack, xy = TRUE)

str(test3)


stack@layers

stack[[1]]

ggplot() +
  geom_histogram(data = test3, aes(PRISM_tmean_stable_4kmD2_20200402_bil))

ggplot() +
  geom_raster(data = test3,
              aes(x = x, y = y, alpha = PRISM_tmean_stable_4kmD2_20200401_bil)) + 
  coord_quickmap()

shp_path = "./AZ/Arizona_boundary.shp"

state <- readOGR(shp_path)

stack.sub <- crop(stack, extent(state))

test4  <- as.data.frame(stack.sub, xy = TRUE)

ggplot() +
  geom_raster(data = test4,
              aes(x = x, y = y, alpha = PRISM_tmean_stable_4kmD2_20200401_bil)) + 
  coord_quickmap()

clip.sub <- mask(stack.sub, state)

plot(clip.sub[[1]])
plot(state, add = TRUE)





