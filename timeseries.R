## create time series functions,visualization, irregular time series, missing data 
library(lattice)
library(forecast)
library(ggplot2)
library(zoo) # general irregular time series
library(tidyr) 
library(dplyr)
library(lmtest)
library(tseries)

# example time series object - class ts
data = runif(n = 50, min = 10, max = 45)
# ts for class time series
# Data starts in 1956 with quarterly obs
t_series = ts(data = data, 
                  start = 1956, frequency = 4)
plot(t_series)
# class
class(t_series)
# Checking the timestamp
time(t_series)
# change start argument
mytimeseries = ts(data = mydata, 
                  start = c(1956,3), frequency = 4)

# example -----------------------------------------------------------------
x = cumsum(rnorm(n = 450)) 
y = ts(x, start = c(1914,11), frequency = 12)
plot(y)
xyplot.ts(y)
## U Plots for time series data
plot(nottem) 
# Plot of components
plot(decompose(nottem)) 
# Directly plotting a forecast of a model
plot(forecast(auto.arima(nottem)), h = 5)
# Random walk
plot.ts(cumsum(rnorm(500)))
autoplot((nottem))
autoplot(nottem) + ggtitle("Autoplot of Nottingham temperature data")
ggseasonplot(nottem) 
ggmonthplot(nottem)

# Irregular Time Series ---------------------------------------------------
sensor<-read.csv("irregular_sensor.csv")
colnames(sensor2)
class(sensor2$V1) 
# removing the time component
sensor2 <- sensor %>%
mutate(date = substr(V1, 1, 8),  # Extract characters 1 to 7 for date
       time = substr(V1, 9, nchar(V1)))  # Extract characters 9 to end for time
sensor2 <- select(sensor2, -V1)
View(sensor2)
sensor2$date <- as.Date(sensor2$date, format = "%m/%d/%y")
sensor2$datetime <- as.POSIXct(paste(sensor2$date, sensor2$time), format = "%Y-%m-%d %I:%M %p")
View(sensor2)
# Getting a zoo object
irreg.dates = zoo(sensor2$y,
                  order.by = sensor2$datetime)

#plot
# Convert to data frame
df_irreg <- data.frame(DateTime = index(irreg.dates), Value = coredata(irreg.dates))
p<-ggplot(df_irreg, aes(x = DateTime, y = Value)) +
  geom_line(color = "blue") +
  labs(title = "Time Series Plot", x = "Datetime", y = "Values") +
  scale_x_datetime(date_breaks = "48 hours", date_labels = "%m-%d") +
  theme_minimal()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  axis.line = element_line(color = "black"),  # Keep axis lines
  axis.ticks = element_line(color = "black"))
p

# Regularizing with aggregate
ag.irregtime = aggregate(irreg.dates,as.Date, mean)
df_irreg3 <- data.frame(DateTime = index(ag.irregtime), Value = coredata(ag.irregtime))
#make time series obj
norm_ts = ts(ag.irregtime) # converting to a standard ts, the days start at 1
#exp smoothing
agg_ses <- ses(norm_ts)
fore_vals<-forecast(agg_ses, h = 5)  # h=future time points
# Plot as comparison
#plot(agg_ses, lwd = 3)
#lines(agg_ses$fitted, col = "red")
df <- data.frame(
  Date = as.Date(time(norm_ts)),
  Value = as.numeric(coredata(norm_ts)),
  Fitted = agg_ses$fitted
)
View(df)
df_forecast <- data.frame(
  Date = as.Date(time(fore_vals$mean)),
  Forecasted = as.numeric(fore_vals$mean)
)
p<-ggplot(df, aes(x = Date)) +
  geom_line(aes(y = Value), color = "blue", linewidth = 1.5) +
  geom_line(aes(y = Fitted), color = "red", linetype = "dashed", linewidth= 1.2) +
  geom_line(data = df_forecast, aes(y = Forecasted), color = "green", linetype = "dashed", size = 1.2) +
  labs(title = "Simple Exponential Smoothing with Forecast", x = "Date", y = "Value") +
  theme_minimal()
p

# Missing Data and Outliers -----------------------------------------------
summary(norm_ts)
# Automatic detection of outliers
ts1 = tsoutliers(norm_ts)
ts1

# Missing data handling, zoo
ts1.NAlocf = na.locf(ts1)
ts1.NAfill = na.fill(ts1, 33)

# na.trim gets rid of NAs at the beginning or end of dataset
# Standard NA method 
ts1.NAinterp = na.interp(ts1)

# Cleaning NA and outliers 
ts1clean = tsclean(ts1)
plot(ts1clean)
summary(ts1clean)

# Basic forecast methods --------------------------------------------------
set.seed(95)
ts1 <- ts(rnorm(200), start = (1818))
plot(ts1)

meanm <- meanf(ts1, h=20)
naivem <- naive(ts1, h=20)
driftm <- rwf(ts1, h=20, drift = T)

plot(meanm, plot.conf = F, main = "")
lines(naivem$mean, col=123, lwd = 2)
lines(driftm$mean, col=22, lwd = 2)
legend("topleft",lty=1,col=c(4,123,22),
       legend=c("Mean method","Naive method","Drift Method"))

# Model Comparison --------------------------------------------------------
set.seed(95)
myts <- ts(rnorm(200), start = (1818))
mytstrain <- window(myts, start = 1818, end = 1988)
plot(mytstrain)

meanm <- meanf(mytstrain, h=30)
naivem <- naive(mytstrain, h=30)
driftm <- rwf(mytstrain, h=30, drift = T)
mytstest <- window(myts, start = 1988)

accuracy(meanm, mytstest)
accuracy(naivem, mytstest)
accuracy(driftm, mytstest)

# Residuals ---------------------------------------------------------------
set.seed(95)
myts <- ts(rnorm(200), start = (1818))
plot(myts)

meanm <- meanf(myts, h=20)
naivem <- naive(myts, h=20)
driftm <- rwf(myts, h=20, drift = T)

var(meanm$residuals)
mean(meanm$residuals)

mean(naivem$residuals)

naivwithoutNA <- naivem$residuals
naivwithoutNA <- naivwithoutNA[2:200]
var(naivwithoutNA)
mean(naivwithoutNA)

driftwithoutNA <- driftm$residuals
driftwithoutNA <- driftwithoutNA[2:200]
var(driftwithoutNA)
mean(driftwithoutNA)

hist(driftm$residuals)

acf(driftwithoutNA)


# Stationarity: same stats throughout the series? -------------------------
x <- rnorm(1000) # no unit-root, stationary
adf.test(x) # augmented Dickey Fuller Test
plot(nottem) # nottem dataset
plot(decompose(nottem))
adf.test(nottem)
y <- diffinv(x) # non-stationary
plot(y)
adf.test(y)

# Autocorrelation ---------------------------------------------------------
# Durbin Watson test for autocorrelation

length(lynx); head(lynx); head(lynx[-1]); head(lynx[-114]) # check the required traits for the test
dwtest(lynx[-114] ~ lynx[-1])
x = rnorm(700) # random numbers
dwtest(x[-700] ~ x[-1])
length(nottem) # and the nottem dataset
dwtest(nottem[-240] ~ nottem[-1])

### Autocorrelation function and PACF
acf(lynx, lag.max = 20); 
pacf(lynx, lag.max =20, plot = F) #partial ACF

# lag.max for numbers of lags to be calculated
# plot = F to suppress plotting
acf(rnorm(500), lag.max = 20)
