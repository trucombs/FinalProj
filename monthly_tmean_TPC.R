library(prism) #load prism library

prism_set_dl_dir("~/FinalProj/prism_monthly") #set this directory to the location that you will save the prism data (create a new folder, if needed)

#takes a few seconds to download from PRISM
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

#loops through all sites to extract site name and mean monthly temp -- takes a few minutes
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

#converts list data into data frame
df = do.call(rbind.data.frame, list) #create dataframe from month/tmean data
df['name'] = list_site #add site name column to dataframe

site_sub = 5 #number of sites to visualize; change this # to add/remove site count
months = 12 #number of months for which data are available in 2020
pt_count = site_sub*months
df_sub = df[1:pt_count,] #subset the dataframe

plot(df_sub$date, df_sub$data, pch = 16, col = factor(df_sub$name), main="Mean Monthly Temp: 5 Sites",
     xlab="Month", ylab="Mean Temp (C)")
legend(x = "topleft",                           # Add points to legend
       legend = unique(df_sub$name),
       text.col = "black",
       lwd = 1,
       col = unique(factor(df_sub$name)),
       lty = c(0, 0),
       pch = 16,
       bty = "n",
       cex = 0.50,
       pt.cex = 1)