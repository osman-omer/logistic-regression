# Project 6 — Logistic Regression: Heart Disease Prediction

## 📌 Project Goal
This project applies **logistic regression** to predict the presence of heart disease (binary outcome) using clinical and diagnostic variables.

The primary objective is methodological learning:
- Binary classification modeling
- Odds ratio interpretation
- Model comparison (Deviance, AIC, BIC)
- Confusion matrix evaluation
- ROC curve and AUC analysis

This project is strictly for educational purposes.

---

## 📊 Dataset
- Source: UCI / Kaggle Heart Disease dataset  
- Outcome: `target` (0 = No disease, 1 = Disease)  
- Sample size: n ≈ 1000  
- Balanced dataset (~50% disease prevalence)

A balanced outcome ensures unbiased classification performance.

---

# 🧠 Logistic Regression Model

Logistic regression models the probability of disease using:

P(disease = 1) = 1 / (1 + e^(-(β₀ + β₁X₁ + ... + βₖXₖ)))

Where:
- Coefficients (β) represent **log-odds**
- exp(β) gives **Odds Ratios (OR)**

Interpretation:
- OR > 1 → Increased odds of disease
- OR < 1 → Decreased odds
- OR = 1 → No association

Important: Odds ratios are not probability ratios.

---

# 🧪 Models Built

Three models were fitted:

### 1️⃣ Age-Only Model
- Demonstrates basic logistic regression
- Shows how age affects odds of heart disease
- Limited predictive power

---

### 2️⃣ Clinical Model
Includes:
- Age
- Sex
- Chest pain type
- Blood pressure
- Cholesterol
- Fasting blood sugar
- Maximum heart rate

**Performance:**
- Good discriminative ability
- Moderate sensitivity and specificity
- Suitable for screening-level modeling

---

### 3️⃣ Full Diagnostic Model
Includes all available predictors:
- ECG findings
- Exercise test variables
- Angiography results
- Clinical measurements

**Performance Improvements:**
- Substantially lower deviance
- Lower AIC and BIC
- Higher accuracy
- Higher sensitivity (fewer missed cases)
- Higher specificity (fewer false positives)
- Higher AUC

---

# 📊 Model Comparison

## Deviance Reduction
- Clinical model significantly improves over null model
- Full model provides substantial additional improvement

Lower deviance = better model fit.

---

## AIC / BIC
Both criteria favor the **Full Model**, indicating that the increase in complexity is justified by improved fit.

---

# 📈 Classification Performance

## Clinical Model
- Good overall accuracy
- Balanced sensitivity and specificity
- Useful when only routine measurements are available

## Full Model
- Higher accuracy
- Higher sensitivity
- Higher specificity
- Higher negative predictive value
- Stronger overall diagnostic performance

---

# 📉 ROC Curve & AUC

The ROC curve compares sensitivity vs 1-specificity across all thresholds.

### AUC Interpretation:
- 0.5 → Random guessing
- 0.7–0.8 → Fair
- 0.8–0.9 → Good
- >0.9 → Excellent

Results show:
- Clinical model → Good discrimination
- Full model → Excellent discrimination

The full model clearly outperforms the clinical model.

---

# ⚠️ Limitations

## Dataset Limitations
- Possible referral bias
- Hospital-based sample
- Unusual epidemiological patterns
- Not representative of general population

## Modeling Limitations
- No train/test split
- No cross-validation
- Evaluated on training data (optimistic performance)
- No interaction terms explored
- Fixed 0.5 probability threshold

---

# 🚫 Clinical Caution

This analysis:
- Does NOT provide a validated diagnostic tool
- Does NOT establish causation
- Should NOT be used for patient care

It demonstrates statistical methodology only.

---

# 🎯 Conclusion

The Full Diagnostic Model substantially outperforms the Clinical Model across:

- Deviance
- AIC/BIC
- Accuracy
- Sensitivity
- Specificity
- AUC

However, improved predictive performance comes at the cost of greater complexity and reliance on specialized diagnostic tests.

This project successfully demonstrates:

- Logistic regression for binary outcomes
- Interpretation of odds ratios
- Model comparison techniques
- ROC and AUC analysis
- Importance of validation and limitations

---

## 📚 Educational Value

This project serves as a practical implementation of logistic regression in a medical classification context and reinforces core statistical modeling principles.

Future improvements may include:
- Train/test validation
- Cross-validation
- Regularization (LASSO / Ridge)
- Interaction terms
- Comparison with machine learning models
