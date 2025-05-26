
# =======================================
# Chargement des données de mortalité
# (identifiants sécurisés via .Renviron)
# =======================================

library(demography)
library(plotly)

# --- Identifiants sécurisés via .Renviron ---
username <- Sys.getenv("HMD_USER")
password <- Sys.getenv("HMD_PASS")
country <- "USA"

# Vérification
if (username == "" || password == "") {
  stop("⚠️ Veuillez définir les variables d'environnement HMD_USER et HMD_PASS dans un fichier .Renviron")
}

# --- Chargement des données HMD ---
pays <- hmd.mx(country, username, password, country)

# --- Aperçu des données ---
print(names(pays))
print(summary(pays))
pays$type
pays$label
pays$lambda
pays$year
pays$age
pays$pop
pays$rate

# --- Vérification des taux de mortalité ---
check_mortality_rates <- function(rate_data) {
  summary_stats <- summary(rate_data)
  if (any(rate_data < 0)) {
    warning("Il y a des taux de mortalité négatifs dans les données.")
  }
  print(summary_stats)
}

check_mortality_rates(pays$rate$male)
check_mortality_rates(pays$rate$female)

# --- Vérification des données manquantes ---
check_missing_data <- function(rate_data) {
  missing_data <- sum(is.na(rate_data))
  cat("Nombre de valeurs manquantes :", missing_data, "\n")
}

check_missing_data(pays$rate$male)
check_missing_data(pays$rate$female)

#-----------------------------------------------------------------------------------------------------------------


#Les figures suivantes représentent 
#le logarithme des taux de mortalité en fonction de l'âge et du temps pour le pays concerné. 
#Plusieurs comportements sont présentés respectivement pour la population masculine, féminine et totale.

## Graphes du taux de mortalité par rapport aux âges
## Comme détaillé en vignette, les différentes couleurs indiquent différentes années (les plus récentes en violet, les plus anciennes en rouge).

par(mfrow=c(1,3))
plot(pays,series="male",datatype="rate",plot.type = "functions" ,main="Male rates")
plot(pays,series="female",datatype="rate",plot.type = "functions", main="Female rates")
plot(pays,"total",datatype="rate",plot.type = "functions",main="Total rates")


# Créer le graphique interactif en 3D
rates.male.plot<-plot_ly(z = log(pays$rate$male[seq(1,103,by=3), seq(1,90,by=3)]), 
                         y = pays$age[seq(1,103,by=3)], 
                         x = pays$year[seq(1,90,by=3)], 
                         type = "surface",
                         colorscale = "Viridis",
                         colorbar = list(title = "Hommes")) %>%
  layout(scene = list(
    xaxis = list(title = "Années"),
    yaxis = list(title = "Ages"),
    zaxis = list(title = "Log taux de mortalité")),
    title = "Taux de mortalité des hommes USA"
  )
rates.male.plot

rates.female.plot<-plot_ly(z = log(pays$rate$female[seq(1,103,by=3), seq(1,90,by=3)]), 
                           y = pays$age[seq(1,103,by=3)], 
                           x = pays$year[seq(1,90,by=3)], 
                           type = "surface",
                           colorscale = "RdBu",
                           colorbar = list(title = "Femmes")) %>%
  layout(scene = list(
    xaxis = list(title = "Années"),
    yaxis = list(title = "Ages"),
    zaxis = list(title = "Log taux de mortalité")),
    title = "Taux de mortalité des femmes USA"
  )
rates.female.plot

rate.plot <- subplot(rates.female.plot, rates.male.plot, nrows = 1) %>%
  layout(
    title = "Taux de mortalité des hommes et des femmes aux USA"
  )


rate.plot
