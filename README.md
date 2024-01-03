# Prerequisites:

-Download the file whealbi_introgression_viewer.app

-Working R installation

# Install dependencies (in R):

install.packages("shiny")

install.packages("shinythemes")

install.packages("shinyWidgets")

install.packages("ggplot2")

install.packages("RColorBrewer")

# Run the app:

Either open the application in Rstudio and run it from there,
or use the following commands to access the application via your favorite webbrowser (the application was only tested on firefox):

#### in a terminal open R console:
R 

#### load shiny library:
library(shiny)

#### Run the application from port 77775 (make sure to specify your IP):
runApp("Whealbi_introgression_viewer_app.R", port =7775, host="your_ip")

#### Open your web browser and type the following in the adress bar:
"your_ip":7775

