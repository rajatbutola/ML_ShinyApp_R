# ML_ShinyApp_R

**ML_ShinyApp_R** is an interactive R-based Shiny web application that allows users to generate predictions using pre-trained machine learning models on uploaded test data. The app supports logistic regression models for two different types of cancer: mUC (metastatic urothelial carcinoma) and RCC (renal cell carcinoma). Users can upload a test dataset, select a model, and generate predictions, which can then be downloaded as a CSV file for further analysis.

## Features

- **Upload Test Data**: Upload a CSV file containing the test dataset.
- **Select Trained Model**: Choose from two pre-trained logistic regression models:
  - mUC Model
  - RCC Model
- **Generate Predictions**: Click a button to process the data and generate predictions.
- **Download Predictions**: After generating the predictions, users can download the results as a CSV file.
- **Model Validation**: Ensures that the test dataset has the required features (genes) for the selected model and notifies the user if there are any discrepancies.

## How It Works

1. **Upload Your Test Data**: The test data should be in CSV format with features (genes) as columns and sample IDs as the first column.
2. **Select a Pre-trained Model**: Choose either the mUC or RCC model.
3. **Generate Predictions**: Once the model and test data are uploaded, click the **"Generate Predictions"** button. The app will process the data and display results.
4. **Download the Results**: After generating the predictions, a **download button** will appear, allowing you to save the predictions as a CSV file.

## Requirements

- **R**: Version 4.0.0 or higher.
- **Libraries**: The following libraries are required:
  - shiny
  - glmnet
  - data.table
  - (can be installed using `install.packages()`)

- **Trained Models**: The app requires pre-trained logistic regression models saved as `.rds` files. Example models for mUC and RCC are included in this project.

## Installation

Clone the repository:

```bash
git clone https://github.com/rajatbutola/ML_ShinyApp_R.git

