# Stats 506, fall 2019
# Group project
# This script answer the following question:
# Question: In terms of demographic features, alcohol use and dietary habits, 
# what features are most associated with the prevalence of diabetes? 
#
# Here we use logistic regression to answer this question.
#
# Data Source:
# https://wwwn.cdc.gov/nchs/nhanes/ContinuousNhanes/Default.aspx?BeginYear=2015
#
# Author: Yinuo Chen (chenyn@umich.edu)
# Date: 12/02/2019

### Data loading
# data: ------------------------------------------------------------------------
library(SASxport)
path = "H:/Personal/STATS506/project"
files = list.files(path, pattern = "*.XPT", full.names = T)
dataset = sapply(files, read.xport, simplify = FALSE)

# rename data
names = c("alcohol", "demo", "diabetes", "total_nutri", 
          "occupation", "sleep")
names(dataset) = names


### Variables selecting
# clean up key variables used in this problem: ---------------------------------
library(data.table)
# select all key variables
ds1 = as.data.table(dataset$alcohol)[,.(SEQN, alcohol = ALQ130)]
ds2 = as.data.table(dataset$demo)[,.(SEQN, gender = RIAGENDR, age = RIDAGEYR)]
ds3 = as.data.table(dataset$diabete)[,.(SEQN, 
                                        diabetes = ifelse(DIQ010 == 2, 0, DIQ010))]
ds4 = as.data.table(dataset$total_nutri)[,.(SEQN, 
                                            tot_sugar = DR1TSUGR, 
                                            tot_fat = DR1TTFAT)]


ds5 = as.data.table(dataset$occupation)[,.(SEQN, occupation = OCQ260)]
ds6 = as.data.table(dataset$sleep)[,.(SEQN, sleep = SLD012)]

# merge all datasets
DS = Reduce(merge,list(ds1,ds2,ds3,ds4,ds5,ds6))


### Data cleaning
# remove missing values and unqualified values: --------------------------------
DS = na.omit(DS)[diabetes %in% c(0,1),
                 ][!(alcohol %in% c(777,999)),
                   ][!(occupation %in% c(6, 77, 99)),
                     ][occupation %in% c(2,3,4), occupation := 2
                       ][occupation == 5, occupation := 3
                         ][
                                 , `:=`(occupation = as.factor(occupation),
                                        diabetes = as.factor(diabetes),
                                        gender = as.factor(gender))
                                 ][, -c("SEQN"), with = FALSE
                                   ][, `:=`(age = age - mean(age),
                                            tot_sugar = tot_sugar - mean(tot_sugar),
                                            tot_fat = tot_fat - mean(tot_fat),
                                            sleep = sleep - mean(sleep))]
summary(DS)

write.csv(DS, "data_cleaned.csv")

# After data cleaning, we got a dataset with 2017 observations.

### Two-way contingency table
# preliminary exploration: -----------------------------------------------------
# two-way contingency table
table(DS$diabetes, DS$occupation)
table(DS$diabetes, DS$gender)

# table using proportions:
# prop.table(table(DS$diabete, DS$occupation))
# prop.table(table(DS$diabete, DS$gender))


# It seems like that occupation 1 has the lowest diabete percentage and 
# occupation 3 has the highest diabete percentage.     
# From the diabete percetage, men are more likely to get diabetes than women.


### Logistic model
# logistic model: --------------------------------------------------------------
# training
fit = glm(diabetes ~ ., data = DS, family = "binomial")
summary(fit)

# We can see from the result that age, total sugar and total fat 
# are significant to this model.     
# Then do some additional analysis.

### Data visualization and additional analysis
# plots: ------------------------------------------------------------------------
# graphs: 
# 1. plot the fraction of respondents who have diabete against their age
# 2. plot the fraction of all respondents against their age
# 3. plot the fraction of respondents who have diabete against their sleep hours
# 4. plot the fraction of all respondents against their hours
# 5. plot the fraction of respondents who have diabete against their total sugar
# 6. plot the fraction of all respondents against their total sugar

diabetes_1 = DS[diabetes == '1']
hist(diabetes_1$age, main = "* Graph 1: AGE pattern in diabetes *",
     xlab="age", las = 1 )
hist(DS$age, main = "* Graph 2: AGE pattern in all respondents *",
     xlab="age", las = 1 )

hist(diabetes_1$sleep, main = "* Graph 3: SLEEP pattern in diabetes *",
     xlab="sleep", las = 1  )
hist(DS$sleep, main = "* Graph 4: SLEEP pattern in all respondents *",
     xlab="sleep", las = 1 )

hist(diabetes_1$tot_sugar, main = "* Graph 5: SUGAR pattern in diabetes *",
     xlab="sugar", las = 1  )
hist(DS$tot_sugar, main = "* Graph 6: SUGAR pattern in all respondents *",
     xlab="sugar", las = 1 )

# Graph 2 and 3 prove that sleeping hours has little to do with diabetes, 
# because the distribution of both look very similar. 
# And that is also corresponding to our model result.
#         
# We can see from the model result that the coefficient of sugar is negative, 
# which contradicts our intuition that more sugar intake increases the probability
# of developing diabete. So maybe genetic effect is much more important than the 
# amount of sugar intake. Since people who have family diabete history are likely 
# to be more carefull about sugar intake.