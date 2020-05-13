
### tidymodels time

## Setup 

# first, source our libraries
source(here::here("libraries.R"))

# download our data from mlbench and take a peek at it
trees_df <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-28/sf_trees.csv")
glimpse(trees_df) # 5 numerics, 7 chars, legal_status is our target

## Split data into train/test sets
trees_split <- initial_split(trees_df, strata = legal_status)
trees_train <- training(trees_split)
trees_test <- testing(trees_split)

## Build a recipe

# create a recipe object which we will use as an input into our tidymodels functions
iono_rec <-
  # initialize our recipe object
  recipe(Class ~ ., data = Ionosphere) %>%
  # remove zero variance predictors 
  step_zv(all_predictors()) %>% 
  # convert the remaining factor variable into a dummy variable
  step_dummy(V1) %>%
  # Scale it the same as the others
  step_range(matches("V1_")) 

# confirm that our recipe worked as planned by "prepping" and "juicing" it 
iono_rec %>%
  # "prep" our recipe so that the previous steps specified execute
  prep() %>% 
  # "juice" our recipe to extract the prepped() data from our recipe 
  juice %>% 
  glimpse() # v1_x1 is our new dummy variable, Class is the only factor left (the target)

## Build our models

# Note: How do we know which modeling functions, engines, and hyperparameters are available? As far as I can tell,
# there isn't currently a way to easily check this within R. However, navigating to:
# https://www.tidymodels.org/find/parsnip/ should provide any details needed

# svm
mod_svm <-
  svm_rbf(cost = tune(), rbf_sigma = tune()) %>%
  set_mode("classification") %>%
  set_engine("kernlab")

## Set a resampling strategy 

# set a seed
set.seed(19)

# define a series of boostrap samples to use for resampling
iono_rs <- bootstraps(Ionosphere, times = 30)

## OPTIONAL: Specify the metrics we want to track 

# specify that we want roc_auc as our metric of interest
roc_vals <- metric_set(roc_auc)

## OPTIONAL: Specify a hyperparameter tuning grid

# specify our hyperparameter tuning grid (using defaults)
ctrl <- control_grid(verbose = FALSE)

## Tune our model

# create and execute our tuning formula
tuning <-
  # specify a model that we have already defined 
  mod_svm %>% 
  # set our tuning grid to our parameters of interest
  tune_grid(
    iono_rec,
    resamples = iono_rs,
    metrics = roc_vals,
    control = ctrl
  )

# show our estimated tuning metrics
tuning_metrics <- collect_metrics(tuning) %>% 
  arrange(-mean)

# only show our top 5 combinations
tuning_metrics_best <- show_best(tuning, metric = "roc_auc")

## Load all models
mods = map(model_names, load_models)

