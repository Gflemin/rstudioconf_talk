
### Speed benchmarking - arrow 

# first, source our libraries
source(here::here("libraries.R"))

# make our spark connection and save it 
sc <- spark_connect(master = "local",
                    config = list("sparklyr.shell.driver-memory" = "6g"))

# generate our data
data <- tibble(y = runif(10^7, 0, 1))


# Error in prepare_windows_environment(spark_home, environment) : 
#   FindFileOwnerAndPermission error (1789): The trust relationship between this workstation and the primary domain failed.
# In addition: Warning message:
#   In system2(winutils, c("ls", shQuote(hivePath)), stdout = TRUE) :
#   running command '"C:\Users\grant.fleming\AppData\Local\spark\spark-2.4.3-bin-hadoop2.7\tmp\hadoop\bin\winutils.exe" ls "C:\Users\grant.fleming\AppData\Local\spark\spark-2.4.3-bin-hadoop2.7\tmp\hive"' had status 1