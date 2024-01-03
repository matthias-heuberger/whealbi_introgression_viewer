### Prerequisites:

-Download the file whealbi_introgression_viewer.app
-Working R installation

### Install dependencies (in R):

install.packages("shiny")

install.packages("shinythemes")

install.packages("shinyWidgets")

install.packages("ggplot2")

install.packages("RColorBrewer")

### Run the app:

Either open the application in Rstudio and run it from there,
or use the following commands to access the application via your favorite webbrowser (the application was only tested on firefox):

# in a terminal open R console
R 

library(shiny)

runApp("Whealbi_introgression_viewer_app.R", port =7775, host="your_ip")

