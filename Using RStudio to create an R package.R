

#Create a package in Rstudio...

#Step 1:Install the ‘devtools’ package

install.packages("devtools")

#Step 2: Create folder for new R package files

#-Open a new project in RStudio. 
#-Go to the ‘File’ menu and click on ‘New Project.’ 
#-Then select ‘New Directory,’ and ‘R Package’ to create a new R package.


#Step 3: Import functions you have created and stored in .R scripts
#-Type the name of your package
#-under ‘Create package based on source files’. Click ‘Create project.’

#Step 4: Examine files and folders in files tab within bottom right panel of RStudio
#If the man folder has no rds helpfiles for your functions, then do the following

#--go to File > New File > R Documentation, enter the title of the function and select
#--‘Function’ under the ‘Rd template’ menu

#-update each file manually and save it to the man folder

##Or use roxygen2 and devtools "document()" function which is much easier
library(roxygen2)
library(devtools)
document()

#Step 5: Bundle your package so you can use it locally

#-Go to ‘Build’ on the top toolbar
#-select ‘Install and Restart’ (note you can also use the keyboard shortcut Ctrl+Shift+B). 
#If this works, your package will automatically load and you will see library(mynewpackage) 
#at the bottom of your console.   Your package will also be install locally and you will see
#it listed under the packages panel.

#-You can now test your functions to make sure they work.

library(cats3)

?cat_function()

cat_function(love=FALSE)





