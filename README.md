## run_analysis.R
This program analyzes data received from the UCI HAR Project regarding subject activity as recorded by the subjects? Samsung Galaxy S smartphones. The project demonstrates the feasibility of collecting actionable biometric data through the normal motion recorded by the smartphone?s accelerometer.

This program downloads the data from the Project internet data repository, separates required files from a zip archive, and generates a filtered subset of means and standard deviations from the accelerometer data. This data is then grouped by subject ID and activity type, and averaged for each group.
