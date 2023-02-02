
#Already unzipped 
#Read test data
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names=("activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names=("subject"))
test_df <- cbind(test_set, test_labels, subject_test)

#Read train data
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names=("activity"))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names=("subject"))
train_df <- cbind(train_set, train_labels, subject_train)

#Merge 
merged_df <- rbind(test_df, train_df)

# 2
feature <- read.table("./UCI HAR Dataset/features.txt") #read features file
index <- grep("mean()|std()", feature$V2) #find mean and std vars
mean_std_data <- merged_df[,c(index, 562:563)] #subset mean and std vars

#3
#check if dyplr is loaded
mean_std_data <- mutate(mean_std_data, activity = factor(1*activity, labels = c("walking", "walking_upstairs",
                                                                                "walking_downstairs", "sitting", "standing", "laying"))) #descriptive labels
head(select(mean_std_data, activity), 20) 

#4
desc_var_name <- grep("mean()|std()", feature$V2, value=TRUE) #find and store mean and std vars
colnames(mean_std_data) <- c(desc_var_name, "activity", "subject") #use descriptive var names
head(str(mean_std_data),2) #check headers

#5
independent_tidy_df <- mean_std_data %>%
  group_by(activity, subject) %>%
  summarise_at(vars(1:79), mean)
write.table(independent_tidy_df, "TidyData.txt", row.names = FALSE)
