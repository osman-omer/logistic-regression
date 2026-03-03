# Project 6 — Logistic Regression (Heart Disease Dataset)

## 📌 Project Goal
Learn how to use **Logistic Regression** for binary classification.  
The focus is on understanding:

- Binary outcome modeling  
- Odds ratios interpretation  
- Model comparison (deviance, AIC, BIC)  
- Classification metrics (accuracy, sensitivity, specificity)  
- ROC curve and AUC  

This project is **purely educational** and not intended for clinical use.

---

## 📊 Dataset
- Source: UCI / Kaggle Heart Disease dataset  
- Outcome variable:  
  - `target` → 0 = No heart disease  
  - `target` → 1 = Heart disease  

- Predictors include:  
  - Demographic: `age`, `sex`  
  - Clinical: `trestbps`, `chol`, `fbs`, `thalach`  
  - Diagnostic: `cp`, `restecg`, `exang`, `oldpeak`, `slope`, `ca`, `thal`

The dataset is approximately balanced between disease and non-disease cases.

---

## 🧪 Analysis Overview

- Data quality checks (`glimpse`, `summary`, missing values)  
- Convert categorical variables to factors  
- Exploratory Data Analysis (EDA)  
- Logistic regression using `glm(..., family = binomial)`  
- Model comparison using Deviance, AIC, and BIC  
- Confusion matrices  
- ROC curve and AUC  

Three models were built:

1. **Age-only model**
2. **Clinical model**
3. **Full diagnostic model**

Predicted probabilities were converted to class predictions using a 0.5 threshold.

---

## 📈 Key Findings

- The age-only model demonstrates how age influences disease odds.
- The clinical model improves predictive performance.
- The full diagnostic model achieves the strongest classification performance with higher accuracy and AUC.

---

## 🧠 Logistic Regression Model

Unlike linear regression, logistic regression models the probability of a binary outcome using the logistic function:

\[
P(Y=1) = \frac{1}{1 + e^{-(\beta_0 + \beta_1X_1 + \beta_2X_2 + ... + \beta_kX_k)}}
\]

Where:
- \(Y = 1\) represents presence of heart disease  
- \(\beta\) coefficients represent log-odds changes  

---

## 🧠 Odds Ratios (OR)

- Model coefficients are in **log-odds** form.
- Exponentiating coefficients gives **odds ratios**:

\[
OR = e^{\beta}
\]

Interpretation:
- OR > 1 → Increased odds of disease  
- OR < 1 → Decreased odds  
- OR = 1 → No effect  

Important: Odds ratio ≠ probability ratio.

---

## 📊 Model Evaluation Metrics

- **Accuracy** → Overall correct classification rate  
- **Sensitivity** → True positive rate  
- **Specificity** → True negative rate  
- **PPV / NPV** → Predictive values  
- **ROC Curve** → Sensitivity vs 1 − Specificity  
- **AUC** → Overall discriminative ability  

AUC interpretation:
- 0.5 → Random  
- 0.7–0.8 → Fair  
- 0.8–0.9 → Good  
- 0.9+ → Excellent  

---

## 📌 Limitations

- No train/test split  
- Model evaluated on training data  
- No cross-validation  
- No interaction terms explored  
- Fixed probability threshold (0.5)  

This project demonstrates **methodology**, not clinical validity.

---

## 🎯 Conclusion

This project illustrates how logistic regression can be used for binary classification, including:

- Model fitting in R  
- Interpretation of odds ratios  
- Model comparison  
- Classification performance evaluation  

The primary objective is methodological understanding and proper modeling workflow.

> This project is intended for learning and statistical practice only.
