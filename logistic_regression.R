# --------------------------------------------------------
# Project: Logistic Regression - Heart Disease Prediction
# Goal: Predict binary outcome (disease presence) using 
#       logistic regression modeling
#
# Variables:
#   - Outcome (Y): Heart Disease (0 = No, 1 = Yes) — Binary
#   - Predictors (X): 
#       * Age (Years) — Continuous
#       * Sex (0 = Female, 1 = Male) — Binary
#       * Chest Pain Type — Categorical
#       * Resting Blood Pressure — Continuous
#       * Cholesterol — Continuous
#       * Fasting Blood Sugar — Binary
#       * Max Heart Rate — Continuous
#
# Key Concepts:
#   1. Binary classification
#   2. Odds ratios and interpretation
#   3. Model evaluation (confusion matrix, accuracy)
#   4. ROC curve and AUC
#   5. Sensitivity and specificity
#
# Author: Osman Omer Mustafa (Medical Student & Data Analyst Trainee)
# Date: February 2026
# --------------------------------------------------------

# 0) Load required libraries
library(tidyverse)
library(broom)
library(pROC)
library(caret)

# 1) Read data
data <- read_csv("heart.csv")

# 2) Basic checks
glimpse(data)
summary(data)
sum(is.na(data))

# 3) Check outcome distribution
table(data$target)
prop.table(table(data$target))

# 4) Ensure proper data types
data <- data %>%
  mutate(
    target = as.factor(target),
    sex = as.factor(sex),
    cp = as.factor(cp),
    fbs = as.factor(fbs),
    restecg = as.factor(restecg),
    exang = as.factor(exang),
    slope = as.factor(slope),
    ca = as.factor(ca),
    thal = as.factor(thal)
  )

glimpse(data)

# --------------------------------------------------------
# EXPLORATORY DATA ANALYSIS
# --------------------------------------------------------

# 5) Outcome distribution by sex
outcome_sex <- data %>%
  group_by(sex, target) %>%
  summarise(n = n()) %>%
  group_by(sex) %>%
  mutate(proportion = n / sum(n))
outcome_sex

# 6) Outcome distribution by age groups
data_age_groups <- data %>%
  mutate(age_group = cut(age, breaks = c(0, 40, 50, 60, 100),
                         labels = c("<40", "40-49", "50-59", "60+")))

outcome_age <- data_age_groups %>%
  group_by(age_group, target) %>%
  summarise(n = n()) %>%
  group_by(age_group) %>%
  mutate(proportion = n / sum(n))
outcome_age

# 7) Boxplot: Age by outcome
box_age <- ggplot(data, aes(x = target, y = age, fill = target)) +
  geom_boxplot() +
  labs(
    x = "Heart Disease",
    y = "Age (Years)",
    title = "Age Distribution by Heart Disease Status"
  ) +
  scale_x_discrete(labels = c("No", "Yes")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")
box_age

# 8) Boxplot: Cholesterol by outcome
box_chol <- ggplot(data, aes(x = target, y = chol, fill = target)) +
  geom_boxplot() +
  labs(
    x = "Heart Disease",
    y = "Cholesterol (mg/dl)",
    title = "Cholesterol Distribution by Heart Disease Status"
  ) +
  scale_x_discrete(labels = c("No", "Yes")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")
box_chol

# 9) Boxplot: Max heart rate by outcome
box_thalach <- ggplot(data, aes(x = target, y = thalach, fill = target)) +
  geom_boxplot() +
  labs(
    x = "Heart Disease",
    y = "Max Heart Rate",
    title = "Max Heart Rate by Heart Disease Status"
  ) +
  scale_x_discrete(labels = c("No", "Yes")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")
box_thalach

# --------------------------------------------------------
# LOGISTIC REGRESSION MODELS
# --------------------------------------------------------

# 10) Simple logistic regression - Age only
model_age <- glm(target ~ age, data = data, family = binomial)

tidy_age <- tidy(model_age, conf.int = TRUE, exponentiate = TRUE)
tidy_age

glance_age <- glance(model_age)
glance_age

# 11) Simple logistic regression - Sex only
model_sex <- glm(target ~ sex, data = data, family = binomial)

tidy_sex <- tidy(model_sex, conf.int = TRUE, exponentiate = TRUE)
tidy_sex

glance_sex <- glance(model_sex)
glance_sex
# 12) Multiple logistic regression - Clinical model
model_clinical <- glm(target ~ age + sex + cp + trestbps + chol + fbs + thalach, 
                      data = data, family = binomial)

tidy_clinical <- tidy(model_clinical, conf.int = TRUE, exponentiate = TRUE)
tidy_clinical

glance_clinical <- glance(model_clinical)
glance_clinical

# 13) Full model - All predictors
model_full <- glm(target ~ age + sex + cp + trestbps + chol + fbs + restecg + 
                    thalach + exang + oldpeak + slope + ca + thal,
                  data = data, family = binomial)

tidy_full <- tidy(model_full, conf.int = TRUE, exponentiate = TRUE)
tidy_full

glance_full <- glance(model_full)
glance_full

# --------------------------------------------------------
# MODEL COMPARISON
# --------------------------------------------------------

# 14) ANOVA comparison
anova(model_age, model_clinical, model_full, test = "Chisq")

# 15) AIC/BIC comparison
aic_comparison <- data.frame(
  model = c("Age only", "Clinical", "Full"),
  AIC = c(AIC(model_age), AIC(model_clinical), AIC(model_full)),
  BIC = c(BIC(model_age), BIC(model_clinical), BIC(model_full))
)
aic_comparison

# --------------------------------------------------------
# MODEL PREDICTIONS
# --------------------------------------------------------

# 16) Get predicted probabilities
data$pred_prob_clinical <- predict(model_clinical, type = "response")
data$pred_prob_full <- predict(model_full, type = "response")

# 17) Convert to predicted class (threshold = 0.5)
data$pred_class_clinical <- ifelse(data$pred_prob_clinical > 0.5, "1", "0")
data$pred_class_full <- ifelse(data$pred_prob_full > 0.5, "1", "0")

# --------------------------------------------------------
# MODEL EVALUATION
# --------------------------------------------------------

# 18) Confusion matrix - Clinical model
conf_matrix_clinical <- confusionMatrix(
  as.factor(data$pred_class_clinical),
  data$target,
  positive = "1"
)
conf_matrix_clinical

# 19) Confusion matrix - Full model
conf_matrix_full <- confusionMatrix(
  as.factor(data$pred_class_full),
  data$target,
  positive = "1"
)
conf_matrix_full

# 20) Extract key metrics
metrics_clinical <- data.frame(
  model = "Clinical",
  accuracy = conf_matrix_clinical$overall["Accuracy"],
  sensitivity = conf_matrix_clinical$byClass["Sensitivity"],
  specificity = conf_matrix_clinical$byClass["Specificity"],
  ppv = conf_matrix_clinical$byClass["Pos Pred Value"],
  npv = conf_matrix_clinical$byClass["Neg Pred Value"]
)

metrics_full <- data.frame(
  model = "Full",
  accuracy = conf_matrix_full$overall["Accuracy"],
  sensitivity = conf_matrix_full$byClass["Sensitivity"],
  specificity = conf_matrix_full$byClass["Specificity"],
  ppv = conf_matrix_full$byClass["Pos Pred Value"],
  npv = conf_matrix_full$byClass["Neg Pred Value"]
)

metrics_comparison <- bind_rows(metrics_clinical, metrics_full)
metrics_comparison

# --------------------------------------------------------
# ROC CURVE AND AUC
# --------------------------------------------------------

# 21) ROC curve - Clinical model
roc_clinical <- roc(data$target, data$pred_prob_clinical)
auc_clinical <- auc(roc_clinical)

# 22) ROC curve - Full model
roc_full <- roc(data$target, data$pred_prob_full)
auc_full <- auc(roc_full)

# 23) Plot ROC curves
plot(roc_clinical, col = "blue", main = "ROC Curves Comparison")
plot(roc_full, col = "red", add = TRUE)
legend("bottomright", 
       legend = c(paste0("Clinical (AUC = ", round(auc_clinical, 3), ")"),
                  paste0("Full (AUC = ", round(auc_full, 3), ")")),
       col = c("blue", "red"), lwd = 2)



# 24) AUC comparison
auc_comparison <- data.frame(
  model = c("Clinical", "Full"),
  AUC = c(auc_clinical, auc_full)
)
auc_comparison

# --------------------------------------------------------
# ODDS RATIOS INTERPRETATION
# --------------------------------------------------------

# 25) Extract significant predictors with odds ratios
significant_predictors <- tidy_clinical %>%
  filter(p.value < 0.05, term != "(Intercept)") %>%
  select(term, estimate, conf.low, conf.high, p.value) %>%
  arrange(p.value)

significant_predictors

# --------------------------------------------------------
# VISUALIZATION: PREDICTED PROBABILITIES
# --------------------------------------------------------

# Create plots directory
if (!dir.exists("plots")) dir.create("plots")

# 26) Predicted probability distribution
prob_dist <- ggplot(data, aes(x = pred_prob_clinical, fill = target)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
  labs(
    x = "Predicted Probability",
    y = "Frequency",
    title = "Distribution of Predicted Probabilities by Actual Outcome",
    fill = "Heart Disease"
  ) +
  scale_fill_discrete(labels = c("No", "Yes")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("plots/predicted_probabilities.png", prob_dist, width = 8, height = 5)
prob_dist

# 27) Predicted probability by age
prob_age <- ggplot(data, aes(x = age, y = pred_prob_clinical, color = target)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(
    x = "Age (Years)",
    y = "Predicted Probability of Heart Disease",
    title = "Predicted Probability by Age and Actual Outcome",
    color = "Heart Disease"
  ) +
  scale_color_discrete(labels = c("No", "Yes")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("plots/probability_by_age.png", prob_age, width = 8, height = 5)
prob_age

# --------------------------------------------------------
# OPTIMAL THRESHOLD SELECTION
# --------------------------------------------------------

# 28) Find optimal threshold using Youden's index
coords_clinical <- coords(roc_clinical, "best", best.method = "youden")
optimal_threshold <- coords_clinical$threshold
optimal_threshold

# 29) Re-classify using optimal threshold
data$pred_class_optimal <- ifelse(data$pred_prob_clinical > optimal_threshold, "1", "0")

conf_matrix_optimal <- confusionMatrix(
  as.factor(data$pred_class_optimal),
  data$target,
  positive = "1"
)
conf_matrix_optimal

# 30) Compare thresholds
threshold_comparison <- data.frame(
  threshold = c(0.5, optimal_threshold),
  accuracy = c(conf_matrix_clinical$overall["Accuracy"],
               conf_matrix_optimal$overall["Accuracy"]),
  sensitivity = c(conf_matrix_clinical$byClass["Sensitivity"],
                  conf_matrix_optimal$byClass["Sensitivity"]),
  specificity = c(conf_matrix_clinical$byClass["Specificity"],
                  conf_matrix_optimal$byClass["Specificity"])
)
threshold_comparison

# --------------------------------------------------------
# END OF SCRIPT
# --------------------------------------------------------
