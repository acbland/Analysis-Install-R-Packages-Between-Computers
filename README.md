# Analysis-Install-R-Packages-Between-Computers
 
Notebook.The purpose of this code is to identify and install any packages between two different computers.  The code is based off of [R-Blogger's Quick Way of Installing your old R libraries on a new device](https://www.r-bloggers.com/quick-way-of-installing-all-your-old-r-libraries-on-a-new-device/) written on July 26, 2017.

I also used the [anti_join](http://zevross.com/blog/2014/08/05/using-the-r-function-anti_join-to-find-unmatched-records/) as the method to compare.  Futher extended the compare back across the new computer to show what packages were on the new computer that were not yet on the old computer.

I also added interactivity with being able to choose the packages file.  

The hashtags are where I left the colde from the r-blogger's website example code.  


I took off the last 6 characters of the computer name as I use a Mac and this is .local and did not want that in the file name.  
```{r set_up}
library(tidyverse)

computer_info <- as.list(Sys.info())
#computer_name <- as.data.frame(computer_info$nodename)
computer_name <- substr(computer_info$nodename,1,nchar(computer_info$nodename)-6)
computer_name <- as.data.frame(computer_name)
##
#Step 1: Save a list of packages installed in your old computing device (from your old device).

#newsystime<-format(Sys.time(),"%Y-%m-%d-%H-%M-%S") 
newsystime_1 <-Sys.Date()

installed <- as.data.frame(installed.packages())


```

This section creates a CSV file in the root path of the project that displays the current packages loaded into R.  The file is named by the date and computer name for easy use
```{r write_csv}
#write.csv(installed, paste(computer_name$computer_name, "_",newsystime_1,".csv"))
write_csv(installed, paste(newsystime_1, "_",computer_name$computer_name,"Packages.csv"))

#This saves information on installed packages in a csv file named installed_previously.csv. Now copy or e-mail this file to your new device and access it from your working directory in R.
```

This section allows you to select a file to compare your current r settings against.  This will be in the main directory and will end with the Packages.csv file name.  It requires the tcklk2 package to be installed in the computer. 
```{r select comparison file}
library(tcltk2)
select_file <- as.data.frame(tk_choose.files((caption="Choose a file")))
select_file_name <- as.character(select_file[4,])
select_file_only <- as.character(basename(select_file_name))
myfile <- read_csv(file = select_file_name)
```

This section creates the other_install data frame and the baseR data frame.  This is designed to create the data frams for comparison of the packages.  Since they are transformed from system parameters and due to the desire to customize the names of the files, the column names need to be renamed to a common heading "Package".  This is the same name when using the installed.packages command.  This also section creates a subdirectory to save the files to.  This subdirectory is named for the computer the user is currently using.
```{r create comparison data frames}
other_install <- as.data.frame(myfile$Package)
colnames(other_install) <- "Package"
baseR <- as.data.frame(installed.packages())
current_install <- as.data.frame(baseR$Package)
colnames(current_install) <- "Package"
dir_name <- substr(computer_info$nodename,1,nchar(computer_info$nodename)-6)
dir.create(dir_name)
setwd(dir_name)
```




This section creates two files that are saved to the subdirectory.  The first gives a list of packages that are not on the current computer as of the date in the front of the file.  The second gives a list of packages not on the comparison computer but that are present on the current computer.  This allows one to see if there are packages on the current computer that are not on the computer that generated the original CSV of packages to compare against.
```{r analytic files}
not_on_current <- anti_join(other_install, current_install, by="Package" )
write_csv(not_on_current, paste(newsystime_1, "Not_on",computer_name$computer_name,"but on orginal file.csv"))
not_on_other <- anti_join(current_install, other_install, by="Package")
write_csv(not_on_other, paste(newsystime_1, "On_",computer_name$computer_name,"but_not orginal file.csv"))

```

This last section of code installs any packages that are missing
```{r install packages}
toInstall <- as.character(not_on_current$Package)
install.packages(toInstall)


```

