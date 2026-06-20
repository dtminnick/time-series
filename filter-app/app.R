library(shiny)
library(plotly)

ui <- fluidPage(
    titlePanel("Interactive Linear Trend Filtering"),
    
    sidebarLayout(
        sidebarPanel(
            h4("Filter Weights"),
            
            sliderInput("psi_m2", "psi -2", min = -1, max = 1, value = 0, step = 0.1),
            sliderInput("psi_m1", "psi -1", min = -1, max = 1, value = 0, step = 0.1),
            sliderInput("psi_0",  "psi 0",  min = -1, max = 1, value = 1, step = 0.1),
            sliderInput("psi_1",  "psi 1",  min = -1, max = 1, value = 0, step = 0.1),
            sliderInput("psi_2",  "psi 2",  min = -1, max = 1, value = 0, step = 0.1),
            
            checkboxInput("normalize", "Force weights to sum to 1", value = FALSE),
            checkboxInput("symmetric", "Force symmetry", value = FALSE),
            
            hr(),
            h4("Line Parameters"),
            sliderInput("a", "Intercept (a)", min = -10, max = 10, value = 0),
            sliderInput("b", "Slope (b)", min = -5, max = 5, value = 1)
        ),
        
        mainPanel(
            plotlyOutput("plot"),
            hr(),
            verbatimTextOutput("weights")
        )
    )
)

server <- function(input, output) {
    
    output$plot <- renderPlotly({
        
        # Time index
        t <- -20:20
        
        # Original line
        x <- input$a + input$b * t
        
        # Filter weights
        psi <- c(input$psi_m2, input$psi_m1, input$psi_0, input$psi_1, input$psi_2)
        
        # Apply symmetry if selected
        if (input$symmetric) {
            psi[1] <- psi[5]
            psi[2] <- psi[4]
        }
        
        # Normalize if selected
        if (input$normalize) {
            psi <- psi / sum(psi)
        }
        
        # Apply filter (convolution)
        y <- stats::filter(x, psi, sides = 2)
        
        # Plot
        plot_ly() %>%
            add_lines(x = t, y = x, name = "Original Line", line = list(color = "black")) %>%
            add_lines(x = t, y = y, name = "Filtered Line", line = list(color = "blue")) %>%
            layout(title = "Linear Trend vs Filtered Trend",
                   xaxis = list(title = "t"),
                   yaxis = list(title = "Value"))
    })
    
    output$weights <- renderPrint({
        psi <- c(input$psi_m2, input$psi_m1, input$psi_0, input$psi_1, input$psi_2)
        
        if (input$symmetric) {
            psi[1] <- psi[5]
            psi[2] <- psi[4]
        }
        if (input$normalize) {
            psi <- psi / sum(psi)
        }
        
        names(psi) <- c("psi -2","psi -1","psi 0","psi 1","psi 2")
        psi
    })
}

shinyApp(ui = ui, server = server)
