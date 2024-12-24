# Load required libraries
library(shiny)
library(ggplot2)
library(DT)
library(corrplot)
library(broom)
library(plotly)

# Define the UI
ui <- fluidPage(
    titlePanel("Multiple Linear Regression Dashboard"),
    
    # Sidebar layout
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Upload CSV File", accept = ".csv"),
            uiOutput("var_select"),
            uiOutput("target_select"),
            actionButton("run_model", "Run Regression")
        ),
        
        # Main panel for displaying results
        mainPanel(
            tabsetPanel(
                tabPanel("Data", DTOutput("data_table")),
                tabPanel("Summary", verbatimTextOutput("model_summary")),
                tabPanel("Diagnostics", plotOutput("residual_plot"), plotOutput("qq_plot")),
                tabPanel("Correlation Heatmap", plotOutput("cor_plot")),
                tabPanel("Scatter Plots", plotlyOutput("scatter_plots"))
            )
        )
    )
)

# Define the server logic
server <- function(input, output, session) {
    
    # Reactive data upload
    data <- reactive({
        req(input$file)
        read.csv(input$file$datapath)
    })
    
    # Dynamically generate UI for selecting variables
    output$var_select <- renderUI({
        req(data())
        checkboxGroupInput("predictors", "Select Predictor Variables", 
                           choices = names(data()), selected = names(data())[1])
    })
    
    output$target_select <- renderUI({
        req(data())
        selectInput("target", "Select Target Variable", choices = names(data()))
    })
    
    # Reactive model fitting
    model <- eventReactive(input$run_model, {
        req(input$predictors, input$target)
        lm(as.formula(paste(input$target, "~", paste(input$predictors, collapse = "+"))), data = data())
    })
    
    # Display uploaded data
    output$data_table <- renderDT({
        req(data())
        datatable(data())
    })
    
    # Display model summary
    output$model_summary <- renderPrint({
        req(model())
        summary(model())
    })
    
    # Plot residuals
    output$residual_plot <- renderPlot({
        req(model())
        ggplot(data(), aes(x = fitted(model()),, y = .resid)) +
            geom_point(aes(y = residuals(model()))) +
            geom_hline(yintercept = 0, linetype = "dashed") +
            labs(title = "Residual Plot", x = "Fitted Values", y = "Residuals")
    })
    
    # QQ plot
    output$qq_plot <- renderPlot({
        req(model())
        qqnorm(residuals(model()))
        qqline(residuals(model()), col = "red")
    })
    
    # Correlation heatmap
    output$cor_plot <- renderPlot({
        req(data(), input$predictors)
        corr_data <- data()[, c(input$predictors, input$target)]
        corr_matrix <- cor(corr_data, use = "complete.obs")
        corrplot(corr_matrix, method = "color", addCoef.col = "black", number.cex = 0.7)
    })
    
    # Scatter plots
    output$scatter_plots <- renderPlotly({
        req(data(), input$predictors, input$target)
        p <- ggplot(data(), aes_string(x = input$predictors[1], y = input$target)) +
            geom_point() +
            geom_smooth(method = "lm", se = FALSE, color = "blue") +
            labs(title = paste("Scatter Plot:", input$predictors[1], "vs", input$target))
        ggplotly(p)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
