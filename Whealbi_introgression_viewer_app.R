#load the required libraries

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(ggplot2)
library(RColorBrewer)



# download the data in current working directory

download.file("https://zenodo.org/records/10406469/files/WW_bwa_minQ30_bamCompare", "WW_bwa_bamCoverage_hexaploid_final")

# load the data

df <- read.table("WW_bwa_bamCoverage_hexaploid_final", header = T)

#set maximum for heatmap normalization

df$cov_ratio[df$cov_ratio>2] <- 2


# Define UI for application that draws a histogram
ui <- navbarPage(
    "Whealbi Introgression Visualizer",
    theme = shinytheme("cosmo"),
    tabPanel("Main",
             fluidRow(
               column(2, selectInput(
                 "accession", "Choose accession/s to display",
                 choices = sort(unique(df$Sample_name)), multiple = TRUE,
                 selected = sort(unique(df$Sample_name))[1]
               )),
               column(1,h3("Or"), class = "text-center", style ="padding-top: 10px;font-size:35px;"),
              column(3, fileInput("accession_list", "upload list as .csv", accept = ".csv")),
               column(2, switchInput("use_file",label = "use list", labelWidth = 50, handleWidth = 25, onLabel = "yes", offLabel = "no", width = "300px"), style = "padding-top: 25px;"),
               column(2, selectInput(
                "chr", "Choose chromosome/s to display", choices = c("All Chromosomes",sort(unique(df$chromosome))),
                multiple = TRUE, selected = "All Chromosomes"
              )),
               
    ),
    fluidRow(
      column(5,plotOutput('heatmap', inline = T)),
      column(7,plotOutput('lineplot', height = "780px")),
      )
    ),
    
)



############# server  ####################################################

server <- function(input, output) {

    #chr_list <- c("Chr1A", "Chr2A", "Chr3A",
    #            "Chr4A", "Chr5A", "Chr6A",
    #            "Chr7A", "Chr1B", "Chr2B",
    #            "Chr3B","Chr4B", "Chr5B", 
    #            "Chr6B","Chr7B","Chr1D", 
    #            "Chr2D", "Chr3D","Chr4D",
    #            "Chr5D", "Chr6D","Chr7D")
	chr_list <- c("Chr1A", "Chr1B", "Chr1D",
           "Chr2A", "Chr2B", "Chr2D",
                "Chr3A", "Chr3B", "Chr3D",
                "Chr4A","Chr4B", "Chr4D",
                "Chr5A","Chr5B","Chr5D",
                "Chr6A", "Chr6B","Chr6D",
                "Chr7A", "Chr7B","Chr7D")


    observe({
      inFile <- input$accession_list
      acc_input <- c()
      if (!(is.null(inFile))){
        acc_input <- read.csv(inFile$datapath, header = F)
        acc_input <- acc_input$V1
      }
          
    my_height <- 0.7
    acc_sel <- input$accession
    chr_sel <- input$chr
    if (input$use_file){
      acc_sel <-acc_input
      chr_list_new <- paste(rep(acc_input, each = length(chr_list)),chr_list, sep = "_") 
      
    } else {
      acc_sel <- input$accession
      chr_list_new <- paste(rep(input$accession, each = length(chr_list)),chr_list, sep = "_") 
      
    }
    df$unique_chr <- factor(df$unique_chr, levels = rev(chr_list_new))
    
    if ("All Chromosomes"%in%chr_sel){
      chr_sel<-chr_list
    }
    output$heatmap <- renderPlot({

    ggplot(data = df[df$chromosome%in%chr_sel & df$Sample_name%in%acc_sel,], aes(x=bin_beg/1000000,y=unique_chr, color=cov_ratio, fill=cov_ratio)) +
        geom_tile(height=my_height) +
        scale_fill_distiller(name="coverage",palette = "RdBu", limits = c(0,2)) +
        scale_color_distiller(name="coverage",palette = "RdBu", limits = c(0,2)) +
        scale_x_continuous(expand = c(0,0), breaks = seq(0,1000,50), position = "bottom") +
        theme_classic() +
        theme(
          legend.justification = "top",
          text = element_text(size=15),
          axis.line.y = element_blank(),
          axis.title = element_blank(),
          legend.position = "right"
        )

    
      }, height = 780*length(chr_sel)*length(acc_sel)/21, width = 700)
    
    output$lineplot <- renderPlot({
      df$chromosome <- factor(df$chromosome, levels = (chr_list))
      
      chr_sel <- input$chr
      if ("All Chromosomes"%in%chr_sel){
        chr_sel<-chr_list
        }
      
      
      mycols <- brewer.pal(8, "Dark2")
      
      if (length(acc_sel)>8) {
        mycols <- colorRampPalette(mycols)(length(acc_sel))
      }
      ggplot(data=df[df$chromosome%in%chr_sel & df$Sample_name%in%acc_sel,], aes(x=bin_beg/1000000, y=log(cov_ratio), color=Sample_name)) +
        geom_line(size=0.3)+
        scale_x_continuous(name = "", breaks=seq(0,1000,200)) +
        scale_y_continuous(name = "Coverage[Log2]", limits = c(-7.5,2)) +
        theme_classic() +
        scale_color_manual(name="", values =mycols ) +
        guides(color = guide_legend(override.aes = list(linewidth = 1.5))) +
        theme(
          legend.justification = "bottom",
          legend.position = "right"
        ) +
        facet_wrap(~chromosome, scales = "free", ncol = 4) +
        theme(strip.text = element_text(hjust = 0),
              strip.background = element_blank()
        )
    })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
