
### Define our functions

# not a function, but save a list of all the models 
model_names = c("logistic_regression", "svm", "decision_tree", "random_forest", "xgboost")

# function to load all models
load_models = function(x) {
  
  # define a list that we'll hold our models in 
  holder = list()
  
  # linear regression
  if ("logistic_regression" %in% x) {
    holder[["mod_log"]] <- 
      logistic_reg(penalty = tune()) %>% 
      set_mode("classification") %>% 
      set_engine("glmnet")
  }
  
  # svm
  else if ("svm" %in% x) {
    # svm
    holder[["mod_svm"]] <-
      svm_rbf(cost = tune(), rbf_sigma = tune()) %>%
      set_mode("classification") %>%
      set_engine("kernlab")
  }
  
  # decision tree
  else if ("decision_tree" %in% x) {
    mod_tree <-
      decision_tree(tree_depth = tune()) %>% 
      set_mode("classification") %>% 
      set_engine("rpart")
  }

  # random forest
  else if ("random_forest" %in% x) {
    holder[["mod_forest"]] <- 
      rand_forest(trees = tune(), mtry = tune()) %>% 
      set_mode("classification") %>% 
      set_engine("ranger")
  }
  
  # boosted trees
  else if ("xgboost" %in% x) {
    holder[["mod_boost"]] <-
      boost_tree(mtry = tune(), tree_depth = tune()) %>% 
      set_mode("classification") %>% 
      set_engine("xgboost")
  }
  
  # return our list of models
  return(holder)
  
}

