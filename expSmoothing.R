#exponential smoothing for averaging past observations with exp decreasing weights over time
#Level (α):ave/initial value for series 
#Trend (β): trend/rate of change over time
#Seasonality (γ): repetitive patterns or cycles 
#Holt’s Method includes trend smoothing in addition to level smoothing
#Holt-Winters Method includes seasonality smoothing along with level and trend smoothing
library(vars)
library(forecast)
library(TTR)

# simple exponential smoothing, no seasonality or trend -------------------
ses_model <- ses(nottem)
print(ses_model)
forecast(ses_model, h = 5)  # h=future time points
# Plot as comparison
plot(nottem, lwd = 3)
lines(ses_model$fitted, col = "red")

# Exponential smoothing state space ---------------------------------------
etsmodel = ets(nottem); etsmodel
# model vs original
plot(nottem, lwd = 3)
lines(etsmodel$fitted, col = "red")

# plt the forecast
plot(forecast(etsmodel, h = 12))

# change prediction interval
plot(forecast(etsmodel, h = 12, level = 95))

# manually set
etsmodmult = ets(nottem, model ="MZM"); etsmodmult

# Plot as comparison
plot(nottem, lwd = 3)
lines(etsmodmult$fitted, col = "red")
