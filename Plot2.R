#check if the 'household_power_consumption.txt' exist in working directory. if not instruct user to store it in wd
if(!file.exists("./household_power_consumption.txt")){
    stop("File household_power_consumption.txt doesn't exist in wd. Store it in wd to proceed")
}else{

#check if requried packages are pre-installed. If else install them
if ("lubridate" %in% rownames(installed.packages())==FALSE){
    install.packages("lubridate")
}
if ("dplyr" %in% rownames(installed.packages())==FALSE){
    install.packages("dplyr")
}
#Loading the packages if not loaded already
if ("lubridate" %in% loadedNamespaces()==FALSE){
    library(lubridate)   
}
if ("dplyr" %in% loadedNamespaces()==FALSE){
    library(dplyr)   
}

#reading the file into dataframe 'house_pow_cons' only if it is not available
if("house_pow_cons" %in% ls()==FALSE){
    house_pow_cons<-read.table("./household_power_consumption.txt",header=TRUE,as.is = TRUE,na.strings = "?",sep = ";")
}

#subset for the dates 2007-02-01 and 2007-02-02 only if it not already done
if("hpc_subset" %in% ls()==FALSE){
    hpc_subset<-house_pow_cons[house_pow_cons$Date=="1/2/2007"|house_pow_cons$Date=="2/2/2007",]
    
}
#making a new column in date_time format for the next plot
hpc_subset<-hpc_subset%>%mutate(Date_Time=as.POSIXct(strptime(paste(dmy(Date),Time), "%Y-%m-%d %H:%M:%S")))


#Plot2:Making the plot with no data
plot(hpc_subset$Global_active_power~hpc_subset$Date_Time,type="n",xlab="",ylab="Global Active Power (kilowatt)")
#using lines command to connect the points using lines
lines(hpc_subset$Global_active_power~hpc_subset$Date_Time)
#choosing the 'png' device
dev.copy(png,file="plot2.png")
dev.off()
}
