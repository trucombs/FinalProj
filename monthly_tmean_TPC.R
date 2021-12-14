library(prism) #load prism library

prism_set_dl_dir("~/FinalProj/prism_monthly") #set this directory to the location that you will save the prism data (create a new folder, if needed)

get_prism_monthlys(type = "tmean", year = 2020, mon = 1:12, keepZip = FALSE) #downloading prism data to directory above
#get_prism_annual("ppt", years = 2000:2015, keepZip = FALSE)

# test <- prism_archive_subset(
#   "tmean", "monthly", year = 2020, mon = 11)    #only use this code if you wish to plot a map of the full dataset; adjust parameters accordingly
# pd_image(test)

fire = read.csv(file = 'AZ_2020_fire.csv') # read in csv fire data
tail(fire) #view head subset of fire data

len <- 103 # number of fires in the fire dataset

list <- vector(mode = "list", length = len) #create an empty vector that will contain the prism curves for all sites
list_site <- c() #storing 12 months for each fire in vector for future use

for (i in 1:dim(fire)[1]) {
  temp_list <- rep(toString(fire$INC_Name[i]), length = 12)
  list_site <- c(list_site, temp_list)
  coords <- c(fire$LONG[i], fire$LAT[i])
  
  list[i] <- pd_plot_slice(
  prism_archive_subset("tmean", "monthly", year = 2020),
  coords)
  #plot(p, add= TRUE)
  print(i)
}

test = do.call(rbind.data.frame, list)
typeof(test)
test$date

points(test$date, test$data)

# for (i in 1:2) {
#   for (j in 1:12) {
#     points(list[[i]][j,2],list[[i]][j,1])
#   }
# }

