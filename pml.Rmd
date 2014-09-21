#Practical Machine Learning course Proect | Coursera
##=========================================================
##SYNOPSIS
Given both training and test data from six participants in a dumbell lifting exercise in five different ways, the outcome of 20 different test cases were predicted using practical machine learning modelling on the training data.

##QUESTION
By processing data gathered from accelerometers on the belt, forearm, arm, and dumbell of the participants, the question is how well can the appropriate activity quality (classe A-E) be predicted?

##INPUT DATA INTO R
First, I loaded caret package, then the datasets in R.

```{r}
setwd("c:/RCourse")
library(caret)
training = read.csv(file="pml-training.csv", na.strings=c('NA','#DIV/0!',''))

testing = read.csv("pml-testing.csv", na.strings=c('NA','#DIV/0!', ''))

```

##CLEANING UP THE DATA 
I removed the first 7 features since they are related to the time-series or are not numeric. I also removed columns full of NAs or empty spaces.

```{r}

for (i in c (8:ncol(training) -1))   {
  training[,i] = as.numeric(as.character(training[,i]))
  testing[,i] = as.numeric(as.character(testing[,i]))
}

clean_col <- colnames(training)
clean_col <- colnames(training[colSums(is.na(training)) ==0])
clean_col <- clean_col[-c(1:7)]
```

##PARTITIONING ROWS INTO TRAINING AND CROSSVALIDATION SAMPLES
I partitioned the training dataset into training and cross validation sample to enable a measure of out-of-sample error.

```{r}
inTrain <- createDataPartition(training$classe, p = 0.6, list=FALSE)
dat_train <- training[inTrain, clean_col]
crossv <- training[-inTrain, clean_col]
dim(dat_train)
dim(crossv)
```

##ALGORITHMS
I started modelling the training dataset using boosting, random forest and support vector machine, with the intention to stack the boosting model fit and the support vector machine using the random forest model fit. However, the random forest method and boosting technics turned out to be very slow, although very efficient. Hence I settled for using only the support vector machine

```{r}
set.seed(325)
library(AppliedPredictiveModeling)
library(e1071)
model_svm  <-  svm(classe ~ ., data = dat_train)

```

##Cross Validation and out of sample error 

The confusion matrices on the Cross Validation sample shows an accuracy of 93.75 %. Hence we have an out of sample error of 6.25%.
```{r}

#out-of-sample error
pred_svm <- predict(model_svm, crossv)

#show confusion matrices
confusionMatrix(pred_svm, crossv$classe)

```

##Predicting 20 different test cases
I then used the support vector model generated to Predict 20 different test cases as show below:

```{r}
Used_features <- length(colnames(testing[]))
colnames(testing)[Used_features] <- 'classe'
test_svm <- predict(model_svm, testing[,clean_col])
test_svm
```

##Conclusion
Since the accuracy of the svm fitted model is 93.75%, we would expect that about 18 of 20 cases are correctly predicted.
