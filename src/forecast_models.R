
# =====================================================
#  Projection des taux de mortalité (2005–2019)
# =====================================================

# --- Paramètres de projection ---
horizon.train <- 15  # années 2005 à 2019

# --- Projections HOMMES ---

# Lee-Carter
LCfor.mrwd.male <- forecast(LCfit.male, h = horizon.train, kt.method = "mrwd")
LCfor.iarima.male <- forecast(LCfit.male, h = horizon.train, kt.method = "iarima")

# CBD
CBDfor.mrwd.male <- forecast(CBDfit.male, h = horizon.train, kt.method = "mrwd")
CBDfor.iarima.male <- forecast(CBDfit.male, h = horizon.train, kt.method = "iarima")

# RH
RHfor.mrwd.male <- forecast(RHfit.male, h = horizon.train, kt.method = "mrwd")
RHfor.iarima.male <- forecast(RHfit.male, h = horizon.train, kt.method = "iarima")

# APC
APCfor.mrwd.male <- forecast(APCfit.male, h = horizon.train, kt.method = "mrwd")
APCfor.iarima.male <- forecast(APCfit.male, h = horizon.train, kt.method = "iarima")

# --- Projections FEMMES ---

LCfor.mrwd.female <- forecast(LCfit.female, h = horizon.train, kt.method = "mrwd")
LCfor.iarima.female <- forecast(LCfit.female, h = horizon.train, kt.method = "iarima")

CBDfor.mrwd.female <- forecast(CBDfit.female, h = horizon.train, kt.method = "mrwd")
CBDfor.iarima.female <- forecast(CBDfit.female, h = horizon.train, kt.method = "iarima")

RHfor.mrwd.female <- forecast(RHfit.female, h = horizon.train, kt.method = "mrwd")
RHfor.iarima.female <- forecast(RHfit.female, h = horizon.train, kt.method = "iarima")

APCfor.mrwd.female <- forecast(APCfit.female, h = horizon.train, kt.method = "mrwd")
APCfor.iarima.female <- forecast(APCfit.female, h = horizon.train, kt.method = "iarima")

## Créer les graphiques des projections


# Liste des modèles
models <- c("LC", "CBD", "RH", "APC")


# Liste des méthodes de prévision
forecast_methods <- c("mrwd", "iarima")

# Liste des données masculines et féminines
genders <- c("male", "female")

# Palettes de couleurs pour chaque modèle
color_palettes <- list(
  LC = list(
    mrwd = "PuBu",
    iarima = "Blues"
  ),
  CBD = list(
    mrwd = "BuGn",
    iarima = "YlGnBu"
  ),
  RH = list(
    mrwd = "YlOrRd",
    iarima = "Oranges"
  ),
  APC = list(
    mrwd = "Reds",
    iarima = "Purples"
  )
)

# Fonction pour créer les graphiques interactifs en 3D
create_forecast_graph <- function(model, forecast_method, gender) {
  # Nom du modèle ajusté
  fit <- get(paste(paste(model, "fit",sep=""), gender, sep = "."))
  
  # Projections
  forecast_obj <- get(paste(paste(model, "for",sep=""), forecast_method, gender, sep = "."))
  
  mat <- as.matrix(forecast_obj$rates)
  
  
  # Création du graphique
  graph <- plot_ly(z = log(mat), 
                   x = years.test, 
                   y = ages.fit, 
                   type = "surface",
                   colorscale = color_palettes[[model]][[forecast_method]],
                   colorbar = list(title =paste(model,"&",forecast_method))) %>%
    layout(scene = list(
      xaxis = list(title = "Année"),
      yaxis = list(title = "Âge"),
      zaxis = list(title = "Taux de mortalité (log)")),
      title = paste("Taux de mortalité prévus avec", model, "&", forecast_method, "(", gender, ")"),
      colorbar = list(title = gender)
    )
  
  return(graph)
}

# Création et affichage des graphiques pour chaque modèle, méthode de prévision et sexe
graphs <- list()
for (model in models) {
  for (method in forecast_methods) {
    for (gender in genders) {
      graph_name <- paste(paste(model, "for",sep=""), method, gender, sep = ".")
      graphs[[graph_name]] <- create_forecast_graph(model, method, gender)
    }
  }
}

# Affichage des graphiques
#for (graph in graphs) {
#  print(graph)
#}

rates.train.male.plot<-plot_ly(z = log(pays.train$rate$male[seq(1,length(ages.fit),by=3), seq(1,length(years.train),by=3)]), 
                               y = pays.train$age[seq(1,length(ages.fit),by=3)], 
                               x = pays.train$year[seq(1,length(years.train),by=3)], 
                               type = "surface",
                               colorscale = "Viridis",
                               colorbar = list(title = "Hommes train")) %>%
  layout(scene = list(
    xaxis = list(title = "Années"),
    yaxis = list(title = "Ages"),
    zaxis = list(title = "Log taux de mortalité")),
    title = "Taux de mortalité des hommes train USA"
  )

rates.train.female.plot<-plot_ly(z = log(pays.train$rate$female[seq(1,length(ages.fit),by=3), seq(1,length(years.train),by=3)]), 
                                 y = pays.train$age[seq(1,length(ages.fit),by=3)], 
                                 x = pays.train$year[seq(1,length(years.train),by=3)], 
                                 type = "surface",
                                 colorscale = "Viridis",
                                 colorbar = list(title = "femmes train")) %>%
  layout(scene = list(
    xaxis = list(title = "Années"),
    yaxis = list(title = "Ages"),
    zaxis = list(title = "Log taux de mortalité")),
    title = "Taux de mortalité des femmes train USA"
  )



rates.test.male.plot<-plot_ly(z = log(pays.test$rate$male[seq(1,length(ages.fit),by=3), seq(1,length(years.test),by=3)]), 
                              y = pays.test$age[seq(1,length(ages.fit),by=3)], 
                              x = pays.test$year[seq(1,length(years.test),by=3)], 
                              type = "surface",
                              colorscale = "Viridis",
                              colorbar = list(title = "Taux réels"))%>%
  layout(scene = list(
    xaxis = list(title = "Années"),
    yaxis = list(title = "Ages"),
    zaxis = list(title = "Log taux de mortalité")),
    title = "Taux de mortalité des femmes USA"
  )

rates.test.female.plot<-plot_ly(z = log(pays.test$rate$female[seq(1,length(ages.fit),by=3), seq(1,length(years.test),by=3)]), 
                                y = pays.test$age[seq(1,length(ages.fit),by=3)], 
                                x = pays.test$year[seq(1,length(years.test),by=3)], 
                                type = "surface",
                                colorscale = "Viridis",
                                colorbar = list(title = "Taux réels"))%>%
  layout(scene = list(
    xaxis = list(title = "Années"),
    yaxis = list(title = "Ages"),
    zaxis = list(title = "Log taux de mortalité")),
    title = "Taux de mortalité des femmes USA"
  )  




#Hommes
subplot(rates.train.male.plot, graphs$LCfor.iarima.male, graphs$LCfor.mrwd.male,rates.test.male.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des hommes sur la période test"
  )

subplot(rates.train.male.plot,graphs$CBDfor.mrwd.male,graphs$CBDfor.iarima.male, rates.test.male.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des hommes sur la période test"
  )

subplot(rates.train.male.plot, graphs$RHfor.mrwd.male,graphs$RHfor.iarima.male,rates.test.male.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des hommes sur la période test"
  )

subplot(rates.train.male.plot,graphs$APCfor.mrwd.male,graphs$APCfor.iarima.male,rates.test.male.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des hommes sur la période test"
  )

#Femmes
subplot(rates.train.female.plot, graphs$LCfor.mrwd.female,graphs$LCfor.iarima.female,rates.test.female.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des femmes sur la période test"
  )


subplot(rates.train.female.plot, graphs$CBDfor.mrwd.female,graphs$CBDfor.iarima.female, rates.test.female.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des femmes sur la période test"
  )

subplot(rates.train.female.plot,graphs$RHfor.mrwd.female,graphs$RHfor.iarima.female,rates.test.female.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des femmes sur la période test"
  )

subplot(rates.train.female.plot,graphs$APCfor.mrwd.female,graphs$APCfor.iarima.female,rates.test.female.plot, nrows = 1) %>%
  layout(
    title = "Projection des taux de mortalité des femmes sur la période test"
  )


# --- Résumé simple ---
print("Projections terminées pour tous les modèles")

