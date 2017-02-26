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

#choosing the 'png' device
png(file="plot4.png")

#Changing the area into 4 segments to accommodate 4 plots filled in a row-wise fashion
par(mfrow=c(2,2))

#Plot(1,1)
plot(hpc_subset$Global_active_power~hpc_subset$Date_Time,type="n",xlab="",ylab="Global Active Power")
lines(hpc_subset$Global_active_power~hpc_subset$Date_Time)

#Plot(1,2):

#Making the plot with no data
plot(hpc_subset$Voltage~hpc_subset$Date_Time,type="n",xlab="datetime",ylab="Voltage")
lines(hpc_subset$Voltage~hpc_subset$Date_Time)

#Plot(2,1):
plot(hpc_subset$Sub_metering_1~hpc_subset$Date_Time,type="n",xlab="",ylab="Energy sub metering")
lines(hpc_subset$Sub_metering_1~hpc_subset$Date_Time,col="black")
lines(hpc_subset$Sub_metering_2~hpc_subset$Date_Time,col="red")
lines(hpc_subset$Sub_metering_3~hpc_subset$Date_Time,col="blue")
legend("topright",legend = c(names(hpc_subset[7:9])),bty = "n",lty =1,lwd = 1,col=c("black","red","blue"),cex=0.95)

#Plot(2,2)
plot(hpc_subset$Global_reactive_power~hpc_subset$Date_Time,type="n",xlab="datetime",ylab=names(hpc_subset[4]))
lines(hpc_subset$Global_reactive_power~hpc_subset$Date_Time)
dev.off()
}
