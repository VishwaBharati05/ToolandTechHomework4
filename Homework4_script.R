setwd('C:/Users/prady_000/Documents/Vishwa/MSDA/Tools & Techniques/Homework 4/UCI HAR Dataset')
#Test set
x_test = read.table('test/X_test.txt')
#Test labels
y_test = read.table('test/y_test.txt')
#test Subject IDs
subject_test = read.table('test/subject_test.txt')
#training data
x_train = read.table('train/X_train.txt')
#Training labels
y_train = read.table('train/y_train.txt')
#Train Subject IDs
subject_train = read.table('train/subject_train.txt')
# feature names
fnames = read.table('features.txt')
#The subject_test/subject_train contain the subject ID and hence their column names are modified to the same.
names(subject_test) = "Subject_ID"
names(subject_train) = "Subject_ID"
#Similarly, y_test/y_train contain the Activity ID hence their column names are modified to the same.
names(y_test) = "Activity_ID"
names(y_train) = "Activity_ID"
#The fnames dataframe read from the features.txt file has 561 features in the second column. This is assigned as the column names of x_test/x_train.
names(x_test) = fnames$V2
names(x_train) = fnames$V2
#The x_test,y_test,subject_test are combined column wise using cbind. Similarly, x_train,y_train,subject_train are combined using cbind. Later these two cbind results are combined using rbind.
test = cbind(x_test,y_test,subject_test)
train = cbind(x_train,y_train,subject_train)
comb = rbind(train,test)
#The feature names in the rbind result, 'comb' are filtered using regex for mean/std measures of all the different features. This is the final dataset.
mean_std_only=grep("mean\\W|std|Activity|Subject",names(comb), value= T)
final = comb[mean_std_only]
#The Activity_ID column has activities codes which are replaced by their respective activity names.
final$Activity_ID = as.factor(final$Activity_ID)
levels(final$Activity_ID) = c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING')
#Any special characters in the feature names are removed and names are converted to lowercase.
names(final) = gsub('[-()_]+','',names(final))
names(final) = tolower(names(final))
#Another tidy dataset is made with the average of each variable for each activity and each subject.
library(dplyr)
final_tidy = group_by(final,subjectid,activityid) %>% summarize_all(mean)
write.table(final_tidy,file = 'tidy_dataset.txt',row.names = F)






