install.packages("devtools")
library(devtools)
install_github("ropensci/prism") #use this instead of install.packages("prism") to get latest version 
packageVersion("prism") #should be >= 0.2.0 (required for 'prism_set_dl_dir')
library(prism)
library(rgdal)
library(raster)
library(lubridate)
install.packages(TDPanalysis)
library(tpdanalysis)

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
typeof(fire)
fire_variables = c("Fuels1", "Cause", "Agency")  #defining relevant variables
print(fire_variables)
rain_good = rain[which(rain$quality=='Good'), cols]


fire_sub = fire[,fire_variables]
head(fire_sub)



for (i in colnames(fire_sub)) {
  plot(clip.sub[[1]], ylab="latitude", xlab="longitude")
  plot(state, add = TRUE)
  points(fire$LONG, fire$LAT, pch = 16, col = fire_sub[[i]])
  legend(x = "left",                           # Add points to legend
         legend = unique(fire_sub[[i]]),
         text.col = "black",
         lwd = 1,
         col = unique(fire_sub[[i]]),
         lty = c(0, 0),
         pch = 16,
         bty = "n",
         cex = 0.50,
         pt.cex = 1)
}

for (i in range(1:length))) {
  plot(ppt_sum.sub[[275]], ylab="latitude", xlab="longitude")
  plot(state, add = TRUE)
  points(fire$LONG, fire$LAT, pch = 16, col = fire_sub$Cause)
  legend(x = "left",                           # Add points to legend
         legend = unique(fire_sub$Cause),
         text.col = "black",
         lwd = 1,
         col = unique(fire_sub$Cause),
         lty = c(0, 0),
         pch = 16,
         bty = "n",
         cex = 0.50,
         pt.cex = 1)
}


# print(length((fire$LONG)))
# 
# stack.sub_df  <- as.data.frame(stack.sub, xy = TRUE)
# 
# ggplot() +
#   geom_raster(data = stack.sub_df,
#               aes(x = x, y = y, alpha = PRISM_tmean_stable_4kmD2_20200401_bil)) + 
#   coord_quickmap()



######## Precip sum stack ##################

ppt_stack = pd_stack(prism_archive_subset(
  "ppt", "daily", 
  minDate = "2020-01-01", 
  maxDate = "2020-12-31"))

dim(ppt_stack)
typeof(ppt_stack)

print(length(stack))

ppt_stack.sub <- crop(ppt_stack, extent(state))

ppt_clip.sub <- mask(ppt_stack.sub, state)

ppt_sum.sub <- calc(ppt_clip.sub, cumsum)


plot(ppt_sum.sub[[310]], ylab="latitude", xlab="longitude")
plot(state, add = TRUE)
points(fire$LONG, fire$LAT, pch = 16, col = fire_sub$Cause)
legend(x = "left",                           # Add points to legend
       legend = unique(fire_sub$Cause),
       text.col = "black",
       lwd = 1,
       col = unique(fire_sub$Cause),
       lty = c(0, 0),
       pch = 16,
       bty = "n",
       cex = 0.50,
       pt.cex = 1)

plot(ppt_sum.sub[[2]])

typeof(ppt_sum.sub)

lubridate()

start_doy <- c()
end_doy <- c()
duration <- c()
acres_burned <- c()
sum_ppt_start = c()
sum_ppt_end = c()

lat = fire$LAT
long = fire$LONG
coords = data.frame(lat, long)
print(coords)
firstPoints <- SpatialPoints(coords = cbind(fire$LONG,fire$LAT))
print(firstPoints)

for (i in 1:dim(fire)[1]) {
  
  #get start dates and convert to DOY, store as vector
  start_date <- toString(fire$Start[i])
  start_date <- mdy(start_date)
  start_doy[i] <- yday(start_date)
  
  #get end dates, store as vector
  end_date <- toString(fire$End[i])
  end_date <- mdy(end_date)
  end_doy[i] <- yday(end_date)
  
  #compute duration of fire events, store as vector
  duration[i] <- end_doy[i] - start_doy[i]
  
  #get acreage burned for each fire event, store as vector
  acres_burned[i] <- toString(fire$Acres[i])
  
  #print(i)
  
  #extract the pixel value for each fire even at their appropriate band in clipped ppt summation cube ('ppt_sum.sub')
  
  #coords = c("LAT", "LONG")
  #pointCoordinates= fire[,coords]
  
  #test[i] = extract(ppt_sum.sub[i], coords[i])
  
  #coordinates(pointCoordinates)= ~ LONGITUDE+ LATITUDE
  #quality_per1 <- data_quality[grep(per1, as.Date(data_quality$readingDate)), cols]
  #print(list_doy)
}

for (i in 1:dim(fire)[1]){
  print(firstPoints[i])
}

for (i in 1:dim(fire)[1]){
  start = start_doy[i]
  end = end_doy[i]
  #print(x)
  #print(typeof(firstPoints))
  sum_ppt_start[i] = extract(ppt_sum.sub, firstPoints[i], layer = start, nl = 1)
  sum_ppt_end[i] = extract(ppt_sum.sub, firstPoints[i], layer = end, nl = 1)
  #test[i] = toString(tmp)
  #print(coords[i])
}

print(sum_ppt_start)
print(sum_ppt_end)
#print(start_doy)
#print(end_doy)
#print(duration)
#print(acres_burned)

plot(sum_ppt_start, acres_burned)
plot(sum_ppt_start, duration)
plot(sum_ppt_end, acres_burned)
plot(sum_ppt_end, duration)

###attempting animation###

install.packages(magick)
library(magick)
#newlogo <- image_scale(image_read("https://jeroen.github.io/images/Rlogo.png"))
#oldlogo <- image_scale(image_read("https://jeroen.github.io/images/Rlogo-old.png"))

image_morph(ppt_sum.sub) %>%
image_animate(optimize = TRUE)

path_base = "./ppt_clip"

for (i in 1:length(clip.sub_df)) {
  path2 = paste0(path_base, "_", i)
  print(path2)
  #writeRaster(ppt_clip.sub[[i]], filename= path2, ".GTiff", options="INTERLEAVE=BAND", overwrite=TRUE)
}

