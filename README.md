
# 📈 Modélisation prospective de la mortalité (1933–2021)

Projet de fin d’année – Master Ingénierie Actuarielle  
Université Paris-Dauphine – Campus de Tunis

## 🎯 Objectif

Ce projet vise à modéliser l’évolution des taux de mortalité aux États-Unis en utilisant des modèles actuariels de projection (Lee-Carter, CBD, APC, RH), et à comparer leurs performances sur données historiques (1933–2019).

## 🧰 Données utilisées

- Source : [Human Mortality Database (HMD)](https://www.mortality.org)
- Période d’étude : 1933–2019
- Population : hommes et femmes aux États-Unis
- Format : taux de mortalité par âge et par année

## 🛠️ Méthodologie

### 🔹 Étapes
1. **Importation & vérification des données** (`load_data.R`)
2. **Calibration des modèles** actuariels sur la période 1933–2004 (`fit_models.R`)
3. **Projection** des taux de mortalité sur la période test 2005–2019 (`forecast_models.R`)
4. **Diagnostics** des modèles (résidus, AIC/BIC, MAE, RMSE) (`diagnostics.R`)

### 🔹 Modèles utilisés
- Lee-Carter (LC)
- Cairns-Blake-Dowd (CBD)
- Age-Period-Cohort (APC)
- Renshaw-Haberman (RH)

### 🔹 Méthodes de projection
- Marche aléatoire avec dérive (`mrwd`)
- Modèle ARIMA (`iarima`)

## 📊 Résultats

Les performances des modèles ont été comparées via AIC, BIC, MAE et RMSE sur la période de test.

| Modèle | MAE Hommes | RMSE Femmes |
|--------|------------|-------------|
| APC + IARIMA | ... | ... |  
| LC + MRWD | ... | ... |  
(_résultats affichés dans le script `diagnostics.R`_)

Des visualisations interactives 3D des projections sont générées avec `plotly`.

## 💼 Technologies

- R (base)
- `StMoMo`, `demography`, `ggplot2`, `plotly`, `gridExtra`, `lifecontingencies`

## 📁 Structure du projet

```
mortality-forecasting/
├── main.R                      # Script principal pour lancer toutes les étapes
├── README.md                   # Présentation du projet et des résultats
├── .gitignore                  # Fichiers à exclure du dépôt (RData, .Renviron…)
├── .Renviron                   # Identifiants HMD (non publié sur GitHub)
│
├── src/                        # Scripts organisés par étapes
│   ├── load_data.R             # Téléchargement et visualisation des données HMD
│   ├── fit_models.R            # Calibration des modèles LC, CBD, RH, APC
│   ├── forecast_models.R       # Projections sur la période test (2005–2019)
│   └── diagnostics.R           # Évaluation des modèles : résidus, AIC, MAE, RMSE
│
├── data/                       # Données locales (vide, mais suivi avec .gitkeep)
│   └── .gitkeep
│
├── visuals/                    # Graphiques (3D, QQ-plots, etc.) à inclure dans le README
│   └── taux_projection_3D.png, qqplot_LC.png, ...

```

## 🔓 Licence

Ce projet est partagé sous licence MIT pour usage pédagogique.

---

📬 Contact : [LinkedIn de l’auteur](https://www.linkedin.com/in/w-steve-giovanni-tapsoba)
