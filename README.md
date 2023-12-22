To use the application download the file whealbi_introgression_viewer.app.

Install dependencies:

install.packages("shiny","shinythemes","shinyWidgets","ggplot2","RColorBrewer","plotly")

If this works without an error you can either open the application in Rstudio and run it from there, or use the following command to access the application via your favorite webbrowser (the application was only tested on firefox):

library(shiny)
runApp("Whealbi_introgression_viewer_app.R", port =7775, host="your_ip")

