
# ===========================================
#  Calibration des modèles de mortalité
# ===========================================

library(StMoMo)
library(plotly)

# --- Paramètres généraux ---
ages.fit <- 0:103
years <- 1933:2019
years.train <- 1933:2004
years.test <- 2005:2019

# --- Extraction des données ---
pays.extract <- extract.ages(pays, ages = ages.fit)
pays.extract <- extract.years(pays.extract, years = years)
pays.train <- extract.years(pays.extract, years = years.train)
pays.test <- extract.years(pays.extract, years = years.test)


# --- Matrice de pondération ---
wxt.train <- genWeightMat(ages = ages.fit, years = years.train, clip = 3)

# --- Données format StMoMo ---
male.StMoMoData <- StMoMoData(data = pays.train, series = "male", type = "central")
female.StMoMoData <- StMoMoData(data = pays.train, series = "female", type = "central")

# --- Modèle Lee-Carter ---
LC <- lc(link = "log")
LCfit.male <- fit(LC, data = male.StMoMoData, ages.fit = ages.fit, wxt = wxt.train)
LCfit.female <- fit(LC, data = female.StMoMoData, ages.fit = ages.fit, wxt = wxt.train)

# --- Modèle Cairns-Blake-Dowd ---
CBD <- cbd(link = "logit")
CBDfit.male <- fit(CBD, data = male.StMoMoData, ages.fit = ages.fit, wxt = wxt.train)
CBDfit.female <- fit(CBD, data = female.StMoMoData, ages.fit = ages.fit, wxt = wxt.train)

# --- Modèle Renshaw-Haberman ---
RH <- rh(link = "log", cohortAgeFun = "1")
RHfit.male <- fit(RH, data = male.StMoMoData, ages.fit = ages.fit, wxt = wxt.train,
                  start.ax = LCfit.male$ax, start.bx = LCfit.male$bx, start.kt = LCfit.male$kt)
RHfit.female <- fit(RH, data = female.StMoMoData, ages.fit = ages.fit, wxt = wxt.train,
                    start.ax = LCfit.female$ax, start.bx = LCfit.female$bx, start.kt = LCfit.female$kt)

# --- Modèle Age-Period-Cohort ---
APC <- apc(link = "log")
APCfit.male <- fit(APC, data = male.StMoMoData, ages.fit = ages.fit, wxt = wxt.train)
APCfit.female <- fit(APC, data = female.StMoMoData, ages.fit = ages.fit, wxt = wxt.train)

# --- Affichage des résultats ---
print(LCfit.male)
print(LCfit.female)
print(CBDfit.male)
print(CBDfit.female)
print(RHfit.male)
print(RHfit.female)
print(APCfit.male)
print(APCfit.female)

# Tracé des paramètres résultants des modèles
plot(LCfit.male)
plot(LCfit.female)
plot(CBDfit.male, parametricbx = TRUE)
plot(CBDfit.female, parametricbx = TRUE)
plot(RHfit.male)
plot(RHfit.female)
plot(APCfit.male, parametricbx = TRUE)
plot(APCfit.female, parametricbx = TRUE)