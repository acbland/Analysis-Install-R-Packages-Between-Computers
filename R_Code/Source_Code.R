
library(tidyverse)

computer_info <- as.list(Sys.info())

computer_name <- substr(computer_info$nodename,1,nchar(computer_info$nodename)-6)
computer_name <- as.data.frame(computer_name)


newsystime_1 <-Sys.Date()

installed <- as.data.frame(installed.packages())


write_csv(installed, paste(newsystime_1, "_",computer_name$computer_name,"Packages.csv"))

#This saves information on installed packages in a csv file named installed_previously.csv. Now copy or e-mail this file to your new device and access it from your working directory in R.

#Step 2: Create a list of libraries from your old list that were not already installed when you freshly download R (from your new device).



library(tcltk2)
select_file <- as.data.frame(tk_choose.files((caption="Choose a file")))
select_file_name <- as.character(select_file[4,])
select_file_only <- as.character(basename(select_file_name))
myfile <- read_csv(file = select_file_name)

other_install <- as.data.frame(myfile$Package)
colnames(other_install) <- "Package"
baseR <- as.data.frame(installed.packages())
current_install <- as.data.frame(baseR$Package)
colnames(current_install) <- "Package"
dir_name <- substr(computer_info$nodename,1,nchar(computer_info$nodename)-6)
dir.create(dir_name)
setwd(dir_name)
not_on_current <- anti_join(other_install, current_install, by="Package" )
write_csv(not_on_current, paste(newsystime_1, "Not_on",computer_name$computer_name,"but on orginal file.csv"))
not_on_other <- anti_join(current_install, other_install, by="Package")
write_csv(not_on_other, paste(newsystime_1, "On_",computer_name$computer_name,"but_not orginal file.csv"))

toInstall <- as.character(not_on_current$Package)
install.packages(toInstall)
