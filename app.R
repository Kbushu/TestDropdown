#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyFiles)
library(fs)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            # shinyFilesExample()
            shinyDirButton("dirButton","Project Directory", "Choose directory"),
            verbatimTextOutput("ProjPath"),
            selectInput("selProjName", "Select projects", choices = "Set proj path")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    volumes <- c(Home = fs::path_home(), "R Installation" = R.home(), getVolumes()())
    shinyDirChoose(input, "dirButton", roots = volumes, session = session, restrictions = system.file(package = "base"), allowDirCreate = FALSE)

    output$ProjPath <- renderPrint({
        if (is.integer(input$dirButton)) {
            cat("No directory has been selected (shinyDirChoose)")
        } else {
            parseDirPath(volumes, input$dirButton)
        }
    })

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application
shinyApp(ui = ui, server = server)
