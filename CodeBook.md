##Run_analysis Code Book

The run_analysis program analyzes data received from the UCI HAR Project regarding subject activity as recorded by the subjects? Samsung Galaxy S smartphones. The project demonstrates the feasibility of collecting actionable biometric data through the normal motion recorded by the smartphone?s accelerometer. Acceleration data is recorded in m/s^2, and times are recorded in seconds.

This program downloads the data from the Project internet data repository, separates required files from a zip archive, and generates a filtered subset of means and standard deviations from the accelerometer data. This data is then grouped by subject ID and activity type, and averaged for each group.

##DATA PROCESSING STEPS
The program includes the following intermediate steps:
1) load source archive for processing. The following intermediate objects were created in this step:
a. temp: placeholder for the downloaded data archive.
b. ziploc: the internet location for the downloaded data archive.
2) separate required files from archive. The following objects were created in this step:
a. x_test: the test metric data
b. y_test: the activity codes associated with the test metric data.
c. Subjtest: the subject id (integer id representing an anonymized test subject) associated with the test metric data.
d. x_train: the training metric data.
e. y_train: the activity codes associated with the training metric data.
f. subjtrain: the subject id (integer id representing an anonymized training subject) associated with the training metric data.
g. dataheaders: The names of the different data metrics collected by the smartphone; used for column headers in subsequent steps.
h. activitylist: unique identifiers and text descriptions of the activities monitored in this experiment. 
3) bind train and test datasets (distinction not meaningful for this exercise). After the two sets are merged, the measurement names from dataheaders are appended as column names to the dataset. The following intermediate object is created in this step:
a. x_combined: the merged test and train datasets, with column headers derived from original measurement names.
4) associate activity data and subject IDs. The following intermediate objects are created in this step:
a.  activity_train: subject ids and activity codes for the training dataset.
b. Activity_test: subject ids and activity codes for the test dataset.
c. Act_combined: the merged subject id and activity codes from the test and training datasets.
5) convert subject/activity pairs to data table. The following intermediate objects are created in this step:
a. dt_act:  A data table containing the merged subject ID and activity codes.
b. Act_lkup: A data table (equivalent to the activitylist file from step 2) containing the unique identifiers and text descriptions of the activities monitored in this experiment.
6) replace activity code id with user-friendly description. After the subject/activity codes and text descriptions of the activities have been loaded into data tables, the two datasets are joined on the activity id. The following intermediate objects are created in this step:
a. subject: the joined dataset connecting the subject id with a text description of the activity measured.

7) extract column headers only for columns having std() or mean() in name. The list containing these names is also converted from factors to strings.The following intermediate objects are created in this step:
a. dhsub: a data table containing a subset of the dataheaders pertaining only to means and standard deviations.
8) select data only pertaining to means and standard deviations. The following intermediate objects are created in this step:
a. combinedsub: a subset of the recorded measurements, pertaining only to means and standard deviations.
9) associate metrics with subject ids and activity descriptions. The subset of mean and std. deviations are merged with the corresponding subject ids and activity descriptions. The following intermediate objects are created in this step:
a.  subj_activity: the merged subset of measurements and their corresponding subject ids and activity descriptions.
b. Dt_subj_activity: data table corresponding to the data in subj_activity.
c. Keycols: list of columns used as keys in dt_subj_activity.
10) generate expressions for required averaged data columns. The following intermediate objects are created in this step:
a.  listcolname: a list of column names found in dt_subj_activity
b. avgcolname: a list of the column names for the final, averaged data set.
11) write resulting data set to text file. The following intermediate objects are created in this step:
a.  dtavg_Subj_act: a data table containing the final dataset of averaged measurements grouped by Activity description and subject id.
b.  Samsung_avg_subj_activity.txt: a text file incorporating all data from the dtavg_Subj_act data table.



##NAMES FOR TRANSFORMED DATA ELEMENTS
The final result set, located in the working directory and github repository, is named samsung_avg_subj_activity.txt. Average column names in this processed ?tidy? dataset include the name of the original data element with ?avg? prepended to it. Thus, the element ?tBodyAcc-mean()-X? is represented in the final dataset by ?avgtBodyAcc-mean()-X?. Time measurements are prepended with ?t? in the original dataset; and frequency domain signal measurements are prepended with ?f? in the original dataset. These prefixes are embedded in the name of the final averaged data element. Each record (representing averages for a subject/activity pair) also include: 
activity_desc: A user-friendly text description of the activity recorded.
subjectid: An integer id representing a unique anonymized test subject.
The following columns in Samsung_avg_subj_activity.txt represent averaged data:
avgtBodyAcc-mean()-X=mean(dt_subj_activity$tBodyAcc-mean()-X)
