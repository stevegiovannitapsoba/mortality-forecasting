
# ============================================
# Script principal d'exécution du projet
# ============================================

# Ce fichier exécute les différentes étapes du projet
# Vérifiez que tous les fichiers .R sont bien présents dans src/

# Étape 1 : Chargement des données
source("src/load_data.R")

# Étape 2 : Calibration des modèles
source("src/fit_models.R")

# Étape 3 : Projection des modèles
source("src/forecast_models.R")

# Étape 4 : Diagnostics & performances
source("src/diagnostics.R")
