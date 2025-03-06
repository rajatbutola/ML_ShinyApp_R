library(shiny)
library(glmnet)
library(data.table)

# Increase maximum upload size to 30MB
options(shiny.maxRequestSize = 40 * 1024^2)

# UI Definition
ui <- fluidPage(
  titlePanel("LogitDA Predictor"),
  sidebarLayout(
    sidebarPanel(
      br(), br(), fileInput("testFile", "Upload Test.csv (For mUC or RCC)", accept = c(".csv")),
      br(),
      selectInput("modelFile", "Select Trained Model", 
                  choices = c("Select Model" = "",
                              "mUC Model" = "logistic-Model-train-muc-test-muc.rds", 
                              "RCC Model" = "logistic-Model-train-rcc-test-rcc.rds")),
      br(), br(),
      actionButton("predictButton", "Generate Predictions"),
      br(), br(), br(), br(), br(),
      uiOutput("downloadUI")
    ),
    mainPanel(
      h4("Instructions:"),
      p("1. Upload your Test.csv file."),
      p("2. Select a pre-trained model from the dropdown."),
      p("3. Click 'Generate Predictions' to process the data."),
      p("4. Download the predictions as a CSV file."),
      br(),
      textOutput("status"),
      textOutput("predictionsCount")
    )
  )
)

# Server Definition
server <- function(input, output, session) {
  predictions <- reactiveVal(NULL)
  
  testData <- reactive({
    req(input$testFile)
    expr.test0 <- fread(input$testFile$datapath, header = TRUE, sep = ",")
    sampleIDs <- expr.test0[[1]]
    expr.test0 <- expr.test0[, -1, with = FALSE]
    expr.test0_matrix <- as.matrix(expr.test0)
    rownames(expr.test0_matrix) <- sampleIDs
    return(list(data = expr.test0_matrix, sampleIDs = sampleIDs))
  })
  
  observeEvent(input$predictButton, {
    req(input$testFile, input$modelFile)
    tryCatch({
      withProgress(message = "Generating Predictions", value = 0, {
        model_path <- file.path("models", input$modelFile)
        bestModel <- readRDS(model_path)
        
        test_data <- testData()
        expr.test0_matrix <- test_data$data
        sampleIDs <- test_data$sampleIDs
        
        gene_ids_clean <- sub("^X", "", bestModel$beta@Dimnames[[1]])
        test_colnames_clean <- sub("^X", "", colnames(expr.test0_matrix))
        test_cols <- match(gene_ids_clean, test_colnames_clean)
        
        if (any(is.na(test_cols))) {
          missing_genes <- gene_ids_clean[is.na(test_cols)]
          output$status <- renderText(paste("Error: Some genes in the model are not found in the test data. Missing:", paste(missing_genes, collapse = ", ")))
          return()
        }
        
        x.test <- expr.test0_matrix[, test_cols, drop = FALSE]
        
        if (input$modelFile == "logistic-Model-train-muc-test-muc.rds") {
          if (ncol(x.test) != 49) {
            stop("Error: mUC model expects 49 features, but after subsetting, test data has ", ncol(x.test), " features.")
          }
          x.test <- scale(x.test)
        } else if (input$modelFile == "logistic-Model-train-rcc-test-rcc.rds") {
          if (ncol(x.test) != 27) {
            stop("Error: RCC model expects 27 features, but after subsetting, test data has ", ncol(x.test), " features.")
          }
          # No scaling for RCC
        }
        
        pred_prob <- as.vector(predict(bestModel, newx = x.test, type = "response", s = bestModel$lambda))
        pred_class <- ifelse(pred_prob > 0.5, 1, 0)
        pred_labels <- ifelse(pred_class == 1, "Respondent", "Non-Respondent")
        pred_labels2 <- ifelse(pred_class == 1, 1, 0)
        
        predictions_data <- data.frame(
          SampleIDs = sampleIDs,
          #Observed = sampleAnnot.test$RESPONSE,  # Adjust if observed data is available
          Probabilities = as.vector(pred_prob),
          Predicted = pred_labels2,
          Label = pred_labels,
          stringsAsFactors = FALSE
        )
        
        predictions(predictions_data)
        
        # Now render the download button UI
        output$downloadUI <- renderUI({
          downloadButton("downloadPredictions", "Download Predictions")
        })
        
        output$status <- renderText("Predictions generated successfully!")
      })
    }, error = function(e) {
      output$status <- renderText(paste("Error generating predictions:", e$message))
    })
  })
  
  output$predictionsCount <- renderText({
    preds <- predictions()
    if (is.null(preds)) {
      return("Rows in predictions: 0")
    }
    paste("Rows in predictions:", nrow(preds))
  })
  
  output$downloadPredictions <- downloadHandler(
    filename = function() {
      paste("predictions-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      preds <- predictions()
      
      if (is.null(preds)) {
        stop("No predictions available to download. Please generate predictions first.")
      }
      fwrite(preds, file, row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
  output$status <- renderText("")
}


# Run the app
shinyApp(ui = ui, server = server)