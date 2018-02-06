#-----------------------Importing and cleaning the dataframe-------------------------
#install.packages('dplyr')
library('dplyr')

#Since I'm from Belarus and my language is Russian for me personally necessary
#to change language of the environment and locale to English. You probably shouldn't 
#run the next two commands

Sys.setenv("LANGUAGE"="En") 
Sys.setlocale("LC_ALL", "English")

fileName <- "Electric_power_consumption.zip"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dir <- "Electric power consumption Dataset"

#downloading the file
if(!file.exists(fileName)){
  download.file(url,fileName, mode = "wb") 
}

#unzip the downloaded file
if(!file.exists(dir)){
  unzip("Electric_power_consumption.zip", files = NULL, exdir=".")
}

dataset<-read.table('household_power_consumption.txt', header = TRUE, sep=';')

dataset$Date<-as.Date(dataset$Date, "%d/%m/%Y")

Date1<-as.Date("2007-02-01")  
Date2<-as.Date("2007-02-02")
dates<- seq(Date1, Date2, by="days")

dataset<- subset(dataset, Date %in% dates)#filtering data between the dates 2007-02-01 and 2007-02-02

dataset$Global_active_power<-as.numeric(as.character(dataset$Global_active_power)) #removing ? and coverting data into the right format
dataset$Global_reactive_power<-as.numeric(as.character(dataset$Global_reactive_power))
dataset$Voltage<-as.numeric(as.character(dataset$Voltage))
dataset$Global_intensity<-as.numeric(as.character(dataset$Global_intensity))
dataset$Sub_metering_1<-as.numeric(as.character(dataset$Sub_metering_1))
dataset$Sub_metering_2<-as.numeric(as.character(dataset$Sub_metering_2))

dataset<- dataset %>% 
  mutate(Datetime=paste(Date, Time) %>% 
           as.POSIXct(., format="%Y-%m-%d %H:%M:%S", tz = "GMT")) #combining date and time into one column

#Plot 4

par(mfrow=c(2,2))
with(dataset,{
  plot(x=dataset$Datetime, y=dataset$Global_active_power, type = "l",
       ylab= 'Global Active Power', xlab = '')
  plot(Datetime, Voltage, type = "l",
       ylab= 'Voltage', xlab = 'datetime')
  plot(x=dataset$Datetime, y=dataset$Sub_metering_1, type = "l",
       ylab= 'Energy sub metering', xlab = '')
  lines(x=dataset$Datetime, y=dataset$Sub_metering_2, type='l', col='red')
  lines(x=dataset$Datetime, y=dataset$Sub_metering_3, type='l', col='blue')
  legend("topright", legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
         lwd = 1,cex = 0.8,  col = c('black','red','blue'), bty = "n")
  plot(Datetime, Global_reactive_power, type = "l",
       ylab= 'Global_reactive_power', xlab = 'datetime')
})
dev.copy(png,filename="plot4.png", width = 480, height = 480,units = "px")
dev.off ()