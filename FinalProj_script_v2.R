install.packages("devtools")
library(devtools)
install_github("ropensci/prism")

#install.packages("ellipsis")
#install.packages("prism")

#update.packages("prism")

library(prism)
#library(ellipsis)

#getwd()

#dir.create("prism_data")

prism_set_dl_dir("~/prism_data")

# get_prism_dailys(
#   type = "tmean", 
#   minDate = "2013-06-01", 
#   maxDate = "2013-06-14", 
#   keepZip = FALSE
# )
#get_prism_monthlys(type = "tmean", year = 2018:2021, mon = 1:12, keepZip = FALSE)
#get_prism_annual("ppt", years = 2000:2015, keepZip = FALSE)

#test <- prism_archive_subset(
  "tmean", "monthly", year = 2018, mon = 12)
#pd_image(test)


#packageVersion("ellipsis")
#packageVersion("prism")



