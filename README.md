# LogitDA_App

This project provides an interactive **Shiny web application** that allows users to generate predictions using pre-trained machine learning models on uploaded test data. The app supports **logistic regression models** for two different types of cancer (mUC and RCC) and enables users to upload their test dataset, select a model, and generate predictions. The resulting predictions can then be downloaded as a CSV file for further analysis.

## Features

- **Upload Test Data**: Upload a CSV file containing the test dataset.
- **Select Trained Model**: Choose from two pre-trained logistic regression models:
  - mUC Model
  - RCC Model
- **Generate Predictions**: Click a button to process the data and generate predictions.
- **Download Predictions**: After generating the predictions, users can download the results as a CSV file.
- **Model Validation**: Ensures that the test dataset has the required features (genes) for the selected model and notifies the user if there are any discrepancies.

## How It Works

1. **Upload your test data**: The test data should be in CSV format with features (genes) as columns and sample IDs as the first column.
2. **Select a pre-trained model**: Choose either the mUC or RCC model.
3. **Generate Predictions**: Once the model and test data are uploaded, click the "Generate Predictions" button. The app will process the data and display results.
4. **Download the Results**: After generating the predictions, a download button will appear, allowing you to save the predictions as a CSV file.

## Requirements

- **R**: Version 4.0.0 or higher.
- **Libraries**: `shiny`, `glmnet`, `data.table` (can be installed using `install.packages()`).
- **Trained Models**: The app requires pre-trained logistic regression models saved as `.rds` files. Example models are included in this project for **mUC** and **RCC**.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Prediction-GUI-for-Trained-Models.git

