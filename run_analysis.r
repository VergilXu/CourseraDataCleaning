library(dplyr)
# Read test datasets.
path_test <- "C:/Users/Administrator/Desktop/Cousera课程/数据清洗/Week 4 Ass/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test"
path_train <- "C:/Users/Administrator/Desktop/Cousera课程/数据清洗/Week 4 Ass/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train"
setwd(path_test)
test_subject <- read.table("subject_test.txt")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
# Bind three test datasets
test_ds <- cbind(test_subject, test_x, test_y)
# Read train datasets
setwd(path_train)
train_subject <- read.table("subject_train.txt")
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
# Bind three train datasets
train_ds <- cbind(train_subject, train_x, train_y)
# Combine test_ds and train_ds together
ds <- rbind(test_ds, train_ds)
# Read feature dataset
path <- "C:/Users/Administrator/Desktop/Cousera课程/数据清洗/Week 4 Ass/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset"
setwd(path)
feature <- read.table("features.txt")
# Extract the second colnum of feature data 
# Change the class to character vector
feature <- feature$V2
# Insert a subject name and a label name into the first position and the last position of "feature" vector respectively.
# So the length of feature is equal to the number of columns in datasets.
feature <- append(feature, "subject", 0)
feature <- append(feature, "label")
# Change ds's names of header
colnames(ds) <- feature


# Step 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
sd_mean_data <- ds[, grep("std\\()$|mean\\()$|subject|label", names(ds))]


# Step 3 Uses descriptive activity names to name the activities in the data set
ds <- sd_mean_data
# Read the activity labels datasets
setwd(path)
label <- read.table("activity_labels.txt")
# Because merge function will automatically change the order after applying merge function. So how to keep origin order is the key.
# We can use the following method to solve this problem.
# 1. Create a new column called "id" and give the row number to it.
# 2. By using arrange "id" in ascending order after using merge function, the data will be turned into origin order.
ds$id <- 1:nrow(ds)
ds <- arrange(merge(ds, label, by.x = "label", by.y = "V1"), id)
# Reselect the columns we want.
ds <- select(ds, -labels, -id)

# Step 4 Appropriately labels the data set with descriptive variable names.
# Rename V2 by using rename in dplyr package.
ds <- dplyr::rename(ds, activity_label = V2)

# Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
ds <- select(ds, -id, -label)
ds <- aggregate(.~ subject + activity_label, data = ds, mean)

# output a txt file
write.table(ds, file = "C:/Users/Administrator/Desktop/assignment.txt", row.names = FALSE)
