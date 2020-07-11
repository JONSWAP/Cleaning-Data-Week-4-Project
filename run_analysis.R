#load library

library(data.table)
library(dplyr)
library(tidyr)

#download data

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="data.zip")
unzip(zipfile="data.zip")

# load labels

activelabels<-read.table("UCI HAR Dataset/activity_labels.txt")
activelabels<-tibble::as_tibble(activelabels)
names(activelabels)=c("label","activities")

#load features

feature<-read.table("UCI HAR Dataset/features.txt")
feature<-tibble::as_tibble(feature)
featurename<-pull(feature,2)
featurename<-gsub('()','',featurename)

#load train

xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
strain<-read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain<-tibble::as_tibble(xtrain)
ytrain<-tibble::as_tibble(ytrain)
strain<-tibble::as_tibble(strain)

#change column name

names(xtrain)<-featurename
names(ytrain)<-"label"
names(strain)<-"subject"

#screen column

screencol<-grep("mean|std",featurename)
xtrain<-xtrain[,screencol]

#add activities

ytrain<-left_join(ytrain,activelabels)
ytrain<-ytrain[,2]

#combine train data

alltrain<-bind_cols(strain,ytrain,xtrain)

#tidy data

#alltrain<- gather(alltrain,"feature","value",-activities, -subject)
alltrain<- mutate(alltrain, "type"="train")

#load test

xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
stest<-read.table("UCI HAR Dataset/test/subject_test.txt")
xtest<-tibble::as_tibble(xtest)
ytest<-tibble::as_tibble(ytest)
stest<-tibble::as_tibble(stest)

#change column name

names(xtest)<-featurename
names(ytest)<-"label"
names(stest)<-"subject"

#screen column

screencol<-grep("mean|std",featurename)
xtest<-xtest[,screencol]

#add activities

ytest<-left_join(ytest,activelabels)
ytest<-ytest[,2]

#combine test data

alltest<-bind_cols(stest,ytest,xtest)

#tidy data

#alltest<- gather(alltest,"feature","value",-activities, -subject)
alltest<- mutate(alltest, "type"="test")

#combine two data frames

alldata<- bind_rows(alltrain,alltest)

#write data

write.table(alldata,file="CleanData.txt")
