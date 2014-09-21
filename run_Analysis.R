#######################################
## run_analysis.R
##
## a program for processing UCI HAR data
## based on the Samsung Galaxy S Smartphone
##
## Sept 2014
#######################################
library(data.table)
temp <- tempfile()
## load source archive for processing
ziploc <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(ziploc, temp)
## separate required files from archive
x_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
subjtest <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
x_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
subjtrain <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
dataheaders <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
activitylist <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
unlink(temp)
## bind train and test datasets 
## (distinction not meaningful for this exercise)
x_combined <- rbind(x_test, x_train)
colnames(x_combined) <- dataheaders[,2]
## associate activity data and subject IDs
activity_train <- cbind(subjtrain,y_train)
activity_test <- cbind(subjtest, y_test)
act_combined <-rbind(activity_test, activity_train)
## convert subject/activity pairs to data table
dt_act <- as.data.table(act_combined)
colnames(dt_act)<-c("subjectid","activityid")
setkey(dt_act,activityid)
act_lkup<- as.data.table(activitylist)
colnames(act_lkup)<-c("activityid","actdesc")
setkey(act_lkup,activityid)
## replace activity code id with user-friendly description
subjact<-dt_act[J(act_lkup$actdesc)]
colnames(subjact)<-c("activity_desc","subjectid")
## extract column headers only for columns having std() or mean() in name
dhsub <- subset(dataheaders, grepl("std()",dataheaders[,2])|grepl("mean()",dataheaders[,2]),select=V2)
i<-sapply(dhsub,is.factor)
dhsub[i]<-lapply(dhsub[i],as.character)
#combinedsub <- subset(x_combined,select=as.list(dhsub[,"V2"]))
## select data only pertaining to means and standard deviations
combinedsub<-subset(
  x_combined,select=c(
    1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,529:530,542:543
    ))
## associate metrics with subject ids and activity descriptions
subj_activity<-cbind(combinedsub,subjact)
dt_subj_activity<- as.data.table(subj_activity)
keycols<-c("activity_desc","subjectid")
setkeyv(dt_subj_activity,keycols)
#dt_subj_activity[,list(mean(dt_subj_activity[,1:64])),by=list(subjectid,activity_desc)]

# generate expressions for required averaged data columns
listcolname<-list(colnames(dt_subj_activity))
avgcolname<-NULL
for (i in 1:64) {
  avgcolname<-c(avgcolname,paste0("avg",listcolname[i],"=","mean(dt_subj_activity$",listcolname[i],")"))
  }
dtavg_Subj_act<-dt_subj_activity[,list(
  "avgtBodyAcc-mean()-X"=mean(dt_subj_activity$"tBodyAcc-mean()-X"),                    
  "avgtBodyAcc-mean()-Y"=mean(dt_subj_activity$"tBodyAcc-mean()-Y"),                    
  "avgtBodyAcc-mean()-Z"=mean(dt_subj_activity$"tBodyAcc-mean()-Z"),                    
  "avgtBodyAcc-std()-X"=mean(dt_subj_activity$"tBodyAcc-std()-X"),                      
  "avgtBodyAcc-std()-Y"=mean(dt_subj_activity$"tBodyAcc-std()-Y"),                      
  "avgtBodyAcc-std()-Z"=mean(dt_subj_activity$"tBodyAcc-std()-Z"),                      
  "avgtGravityAcc-mean()-X"=mean(dt_subj_activity$"tGravityAcc-mean()-X"),              
  "avgtGravityAcc-mean()-Y"=mean(dt_subj_activity$"tGravityAcc-mean()-Y"),              
  "avgtGravityAcc-mean()-Z"=mean(dt_subj_activity$"tGravityAcc-mean()-Z"),              
  "avgtGravityAcc-std()-X"=mean(dt_subj_activity$"tGravityAcc-std()-X"),                
  "avgtGravityAcc-std()-Y"=mean(dt_subj_activity$"tGravityAcc-std()-Y"),                
  "avgtGravityAcc-std()-Z"=mean(dt_subj_activity$"tGravityAcc-std()-Z"),                
  "avgtBodyAccJerk-mean()-X"=mean(dt_subj_activity$"tBodyAccJerk-mean()-X"),            
  "avgtBodyAccJerk-mean()-Y"=mean(dt_subj_activity$"tBodyAccJerk-mean()-Y"),            
  "avgtBodyAccJerk-mean()-Z"=mean(dt_subj_activity$"tBodyAccJerk-mean()-Z"),            
  "avgtBodyAccJerk-std()-X"=mean(dt_subj_activity$"tBodyAccJerk-std()-X"),              
  "avgtBodyAccJerk-std()-Y"=mean(dt_subj_activity$"tBodyAccJerk-std()-Y"),              
  "avgtBodyAccJerk-std()-Z"=mean(dt_subj_activity$"tBodyAccJerk-std()-Z"),              
  "avgtBodyGyro-mean()-X"=mean(dt_subj_activity$"tBodyGyro-mean()-X"),                  
  "avgtBodyGyro-mean()-Y"=mean(dt_subj_activity$"tBodyGyro-mean()-Y"),                  
  "avgtBodyGyro-mean()-Z"=mean(dt_subj_activity$"tBodyGyro-mean()-Z"),                  
  "avgtBodyGyro-std()-X"=mean(dt_subj_activity$"tBodyGyro-std()-X"),                    
  "avgtBodyGyro-std()-Y"=mean(dt_subj_activity$"tBodyGyro-std()-Y"),                    
  "avgtBodyGyro-std()-Z"=mean(dt_subj_activity$"tBodyGyro-std()-Z"),                   
  "avgtBodyGyroJerk-mean()-X"=mean(dt_subj_activity$"tBodyGyroJerk-mean()-X"),          
  "avgtBodyGyroJerk-mean()-Y"=mean(dt_subj_activity$"tBodyGyroJerk-mean()-Y"),          
  "avgtBodyGyroJerk-mean()-Z"=mean(dt_subj_activity$"tBodyGyroJerk-mean()-Z"),          
  "avgtBodyGyroJerk-std()-X"=mean(dt_subj_activity$"tBodyGyroJerk-std()-X"),            
  "avgtBodyGyroJerk-std()-Y"=mean(dt_subj_activity$"tBodyGyroJerk-std()-Y"),            
  "avgtBodyGyroJerk-std()-Z"=mean(dt_subj_activity$"tBodyGyroJerk-std()-Z"),            
  "avgtBodyAccMag-mean()"=mean(dt_subj_activity$"tBodyAccMag-mean()"),                  
  "avgtBodyAccMag-std()"=mean(dt_subj_activity$"tBodyAccMag-std()"),                    
  "avgtGravityAccMag-mean()"=mean(dt_subj_activity$"tGravityAccMag-mean()"),            
  "avgtGravityAccMag-std()"=mean(dt_subj_activity$"tGravityAccMag-std()"),              
  "avgtBodyAccJerkMag-mean()"=mean(dt_subj_activity$"tBodyAccJerkMag-mean()"),          
  "avgtBodyAccJerkMag-std()"=mean(dt_subj_activity$"tBodyAccJerkMag-std()"),            
  "avgtBodyGyroMag-mean()"=mean(dt_subj_activity$"tBodyGyroMag-mean()"),                
  "avgtBodyGyroMag-std()"=mean(dt_subj_activity$"tBodyGyroMag-std()"),                  
  "avgtBodyGyroJerkMag-mean()"=mean(dt_subj_activity$"tBodyGyroJerkMag-mean()"),        
  "avgtBodyGyroJerkMag-std()"=mean(dt_subj_activity$"tBodyGyroJerkMag-std()"),          
  "avgfBodyAcc-mean()-X"=mean(dt_subj_activity$"fBodyAcc-mean()-X"),                    
  "avgfBodyAcc-mean()-Y"=mean(dt_subj_activity$"fBodyAcc-mean()-Y"),                    
  "avgfBodyAcc-mean()-Z"=mean(dt_subj_activity$"fBodyAcc-mean()-Z"),                    
  "avgfBodyAcc-std()-X"=mean(dt_subj_activity$"fBodyAcc-std()-X"),                      
  "avgfBodyAcc-std()-Y"=mean(dt_subj_activity$"fBodyAcc-std()-Y"),                      
  "avgfBodyAcc-std()-Z"=mean(dt_subj_activity$"fBodyAcc-std()-Z"),                      
  "avgfBodyAccJerk-mean()-X"=mean(dt_subj_activity$"fBodyAccJerk-mean()-X"),           
  "avgfBodyAccJerk-mean()-Y"=mean(dt_subj_activity$"fBodyAccJerk-mean()-Y"),            
  "avgfBodyAccJerk-mean()-Z"=mean(dt_subj_activity$"fBodyAccJerk-mean()-Z"),            
  "avgfBodyAccJerk-std()-X"=mean(dt_subj_activity$"fBodyAccJerk-std()-X"),              
  "avgfBodyAccJerk-std()-Y"=mean(dt_subj_activity$"fBodyAccJerk-std()-Y"),              
  "avgfBodyAccJerk-std()-Z"=mean(dt_subj_activity$"fBodyAccJerk-std()-Z"),              
  "avgfBodyGyro-mean()-X"=mean(dt_subj_activity$"fBodyGyro-mean()-X"),                  
  "avgfBodyGyro-mean()-Y"=mean(dt_subj_activity$"fBodyGyro-mean()-Y"),                  
  "avgfBodyGyro-mean()-Z"=mean(dt_subj_activity$"fBodyGyro-mean()-Z"),                  
  "avgfBodyGyro-std()-X"=mean(dt_subj_activity$"fBodyGyro-std()-X"),                    
  "avgfBodyGyro-std()-Y"=mean(dt_subj_activity$"fBodyGyro-std()-Y"),                    
  "avgfBodyGyro-std()-Z"=mean(dt_subj_activity$"fBodyGyro-std()-Z"),                    
  "avgfBodyAccMag-mean()"=mean(dt_subj_activity$"fBodyAccMag-mean()"),                  
  "avgfBodyAccMag-std()"=mean(dt_subj_activity$"fBodyAccMag-std()"),                    
  "avgfBodyBodyGyroMag-mean()"=mean(dt_subj_activity$"fBodyBodyGyroMag-mean()"),        
  "avgfBodyBodyGyroMag-std()"=mean(dt_subj_activity$"fBodyBodyGyroMag-std()"),          
  "avgfBodyBodyGyroJerkMag-mean()"=mean(dt_subj_activity$"fBodyBodyGyroJerkMag-mean()"),
  "avgfBodyBodyGyroJerkMag-std()"=mean(dt_subj_activity$"fBodyBodyGyroJerkMag-std()") 
), keyby=list(activity_desc,subjectid)]
## write resulting data set to text file
write.table(dtavg_Subj_act,file="samsung_avg_subj_activity.txt",row.names=FALSE)