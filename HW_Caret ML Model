library(tidyverse)

library(caret)

library(readr)

head(df)

## 1. split data
df <- read_csv("churn.csv")

train_test_split <- function(data, size=0.8) {
  set.seed(42)
  n <- nrow(data)
  train_id <- sample(1:n, size*n)
  train_df <- data[train_id, ]
  test_df <- data[-train_id, ]
  return( list(train_df,test_df))
  
}

prep_df <- train_test_split(df, size=0.8)


## 2. train model
## cv stand for K-Fold CV

ctrl <- trainControl(method = "cv", number = 5)

model <- train(churn ~ totaldayminutes + totaldaycalls + 
                 totalnightminutes + totalnightcalls +
                 numbercustomerservicecalls,
               data = prep_df[[1]],
               method = "glm",
               trControl = ctrl)

## 3. score model
pred_churn <- predict(model, newdata = prep_df[[2]])

## 4. evaluate model
actual_churn <- prep_df[[2]]$churn

## error =  actual - prediction

acc <- mean(pred_churn == prep_df[[2]]$churn)


