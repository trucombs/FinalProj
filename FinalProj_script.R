install.packages("devtools")
library(devtools)
install_github("ropensci/prism") #use this instead of install.packages("prism") to get latest version 
packageVersion("prism") #should be >= 0.2.0 (required for 'prism_set_dl_dir')
library(prism)
library(rgdal)
library(raster)


#clone https://github.com/trucombs/FinalProj

setwd("~/FinalProj") #may need to adjust accordingly

dir.create("prism_data") #creates data archive in the working directory

prism_set_dl_dir("./daily_tmean_ppt")

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

# ggplot() +
#   geom_histogram(data = test3, aes(PRISM_tmean_stable_4kmD2_20200402_bil))
# 

test3  <- as.data.frame(stack, xy = TRUE)


ggplot() +
  geom_raster(data = test3,
              aes(x = x, y = y, alpha = PRISM_tmean_stable_4kmD2_20200401_bil)) +
  coord_quickmap()

shp_path = "./AZ/Arizona_boundary.shp"

state <- readOGR(shp_path)

stack.sub <- crop(stack, extent(state))

clip.sub <- mask(stack.sub, state)

clip.sub_df <- as.data.frame(clip.sub)

fire = read.csv(file = 'AZ_2020_fire.csv') # read in file
head(fire) # inspect top portion of dataset

plot(clip.sub[[1]], ylab="latitude", xlab="longitude")
plot(state, add = TRUE)
points(fire$LONG, fire$LAT, pch = 16, col = fire$Fuels1)
legend(x = "left",                           # Add points to legend
       legend = unique(fire$Fuels1),
       text.col = "black",
       lwd = 1,
       col = unique(fire$Fuels1),
       lty = c(0, 0),
       pch = 15:16,
       bty = "n",
       cex = 0.65,
       pt.cex = 1)

plot(clip.sub[[1]], ylab="latitude", xlab="longitude")
plot(state, add = TRUE)
points(fire$LONG, fire$LAT, pch = 16, col = fire$Fuels1)
legend(x = "left",                           # Add points to legend
       legend = unique(fire$Fuels1),
       text.col = "black",
       lwd = 1,
       col = unique(fire$Fuels1),
       lty = c(0, 0),
       pch = 15:16,
       bty = "n",
       cex = 0.65,
       pt.cex = 1)


# print(length((fire$LONG)))
# 
# stack.sub_df  <- as.data.frame(stack.sub, xy = TRUE)
# 
# ggplot() +
#   geom_raster(data = stack.sub_df,
#               aes(x = x, y = y, alpha = PRISM_tmean_stable_4kmD2_20200401_bil)) + 
#   coord_quickmap()


plot(NULL, xlim=c(-115, -108), ylim=c(31, 37.5), yaxs="i", xaxs="i")
plot(clip.sub[[1]], ylab="latitude", xlab="longitude", add = TRUE)
image(seq.int(31, 38, length.out = nrow(clip.sub)), 
      seq(-116, -107, length.out = ncol(clip.sub[[1]])),
      clip.sub[[1]])





