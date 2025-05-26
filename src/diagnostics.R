
# =====================================================
# Diagnostics : Résidus, AIC/BIC, MAE/RMSE
# =====================================================

library(ggplot2)
library(gridExtra)

# --- Liste des modèles ajustés ---
models_fit <- list(
  LC = list(male = LCfit.male, female = LCfit.female),
  CBD = list(male = CBDfit.male, female = CBDfit.female),
  RH = list(male = RHfit.male, female = RHfit.female),
  APC = list(male = APCfit.male, female = APCfit.female)
)



# Fonction pour générer et afficher des diagnostics pour chaque modèle
evaluate_models <- function(models_fit_list) {
  results <- data.frame(Model = character(), Gender = character(), AIC = numeric(), BIC = numeric())
  
  for (model_name in names(models_fit_list)) {
    fits <- models_fit_list[[model_name]]
    
    for (gender in names(fits)) {
      fit <- fits[[gender]]
      
      # Résidus et QQ-Plots
      residuals_fit <- residuals(fit)
      residuals_vector <- as.vector(residuals_fit$residuals)
      residuals_vector <- residuals_vector[is.finite(residuals_vector)]  # Supprimer les valeurs non-finies
      residuals_df <- data.frame(residuals = residuals_vector)
      
      
      qqplot <- ggplot(residuals_df, aes(sample = residuals)) +
        stat_qq() +
        stat_qq_line() +
        ggtitle(paste("QQ-Plot des résidus -", model_name, "-", ifelse(gender == "male", "Hommes", "Femmes"))) +
        xlab("Quantiles théoriques") +
        ylab("Quantiles échantillons")
      
      print(qqplot)
      
      # Graphique des résidus en fonction du temps et en fonction de l'âge
      
      plot(residuals_fit, type = "colourmap",
           main = paste("Résidus en fonction du temps -", model_name, "-", ifelse(gender == "male", "Hommes", "Femmes")))
      plot(residuals_fit, type = "colourmap",
           main = paste("Résidus en fonction de l'âge -", model_name, "-", ifelse(gender == "male", "Hommes", "Femmes")))
      
      # Calculer et stocker les critères d'information
      aic_value <- AIC(fit)
      bic_value <- BIC(fit)
      
      results <- rbind(results, data.frame(Model = model_name, Gender = ifelse(gender == "male", "Hommes", "Femmes"), AIC = aic_value, BIC = bic_value))
      
    }
  }
  
  return(results)
}

# Utiliser la fonction pour évaluer les modèles et obtenir les résultats
residual_results <- evaluate_models(models_fit)
# Afficher le tableau de comparaison des AIC et BIC
print(residual_results)

# --- Comparaison de performances (MAE / RMSE) ---
# Fonction pour obtenir les performances des modèles

calculate_performance <- function(observed, predicted) {
  error <- observed - predicted
  mae <- mean(abs(error))
  rmse <- sqrt(mean(error^2))
  return(list(MAE = mae, RMSE = rmse))
}

# Comparer les prévisions avec les taux de mortalité observés pour les années de test
compare_forecasts <- function(observed_rates, forecast_obj, ages, years) {
  observed <- as.matrix(observed_rates)
  predicted <- as.matrix(forecast_obj$rates[ages, years])
  return(calculate_performance(observed, predicted))
}

# Extraire les taux de mortalité observés pour les années de test
observed_male_test <- pays.test$rate$male
observed_female_test <- pays.test$rate$female

# Calculer les performances pour les projections des hommes
LC_mrwd_perf_male <- compare_forecasts(observed_male_test, LCfor.mrwd.male)
LC_iarima_perf_male <- compare_forecasts(observed_male_test, LCfor.iarima.male)
CBD_mrwd_perf_male <- compare_forecasts(observed_male_test, CBDfor.mrwd.male)
CBD_iarima_perf_male <- compare_forecasts(observed_male_test, CBDfor.iarima.male)
RH_mrwd_perf_male <- compare_forecasts(observed_male_test, RHfor.mrwd.male)
RH_iarima_perf_male <- compare_forecasts(observed_male_test, RHfor.iarima.male)
APC_mrwd_perf_male <- compare_forecasts(observed_male_test, APCfor.mrwd.male)
APC_iarima_perf_male <- compare_forecasts(observed_male_test, APCfor.iarima.male)

# Calculer les performances pour les projections des femmes
LC_mrwd_perf_female <- compare_forecasts(observed_female_test, LCfor.mrwd.female)
LC_iarima_perf_female <- compare_forecasts(observed_female_test, LCfor.iarima.female)
CBD_mrwd_perf_female <- compare_forecasts(observed_female_test, CBDfor.mrwd.female)
CBD_iarima_perf_female <- compare_forecasts(observed_female_test, CBDfor.iarima.female)
RH_mrwd_perf_female <- compare_forecasts(observed_female_test, RHfor.mrwd.female)
RH_iarima_perf_female <- compare_forecasts(observed_female_test, RHfor.iarima.female)
APC_mrwd_perf_female <- compare_forecasts(observed_female_test, APCfor.mrwd.female)
APC_iarima_perf_female <- compare_forecasts(observed_female_test, APCfor.iarima.female)

# Afficher les résultats des performances
performance_results <- data.frame(
  Model = c("LC MRWD", "LC IARIMA", "CBD MRWD", "CBD IARIMA", "RH MRWD", "RH IARIMA", "APC MRWD", "APC IARIMA"),
  MAE_Male = c(LC_mrwd_perf_male$MAE, LC_iarima_perf_male$MAE, CBD_mrwd_perf_male$MAE, CBD_iarima_perf_male$MAE,
               RH_mrwd_perf_male$MAE, RH_iarima_perf_male$MAE, APC_mrwd_perf_male$MAE, APC_iarima_perf_male$MAE),
  RMSE_Male = c(LC_mrwd_perf_male$RMSE, LC_iarima_perf_male$RMSE, CBD_mrwd_perf_male$RMSE, CBD_iarima_perf_male$RMSE,
                RH_mrwd_perf_male$RMSE, RH_iarima_perf_male$RMSE, APC_mrwd_perf_male$RMSE, APC_iarima_perf_male$RMSE),
  MAE_Female = c(LC_mrwd_perf_female$MAE, LC_iarima_perf_female$MAE, CBD_mrwd_perf_female$MAE, CBD_iarima_perf_female$MAE,
                 RH_mrwd_perf_female$MAE, RH_iarima_perf_female$MAE, APC_mrwd_perf_female$MAE, APC_iarima_perf_female$MAE),
  RMSE_Female = c(LC_mrwd_perf_female$RMSE, LC_iarima_perf_female$RMSE, CBD_mrwd_perf_female$RMSE, CBD_iarima_perf_female$RMSE,
                  RH_mrwd_perf_female$RMSE, RH_iarima_perf_female$RMSE, APC_mrwd_perf_female$RMSE, APC_iarima_perf_female$RMSE)
)

print(performance_results)