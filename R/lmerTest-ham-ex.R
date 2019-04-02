library(lmerTest)
? ham # --> description of the  Ham testing data set

summary(ham) # 4 (Product) x 2 (Information) =  8 ratings per consumer
xtabs(~ Product + Consumer + Information, ham) # -> completely balanced

## Fit 'big' model:
fmL <- lmer(Informed.liking ~ Product*Information*Gender*Age # interactions up to 4-th order (is extreme!)
           + (1|Consumer)
           + (1|Consumer:Product)
           + (1|Consumer:Information),  data = ham)
drop1(fmL) # Fixed effects  => drop 4 x interaction:
fm. <- update(fmL, ~ . -Product:Information:Gender:Age)
## now you would go on ..
drop1(fm.) # ==>  drop all 3 x interactions,
## etc etc ..

## step() does all this ... and more: also for the *random* effects:
## ====>  help page --- read explanations:
?step.lmerModLmerTest
## ranova := anova-like table for [R]andom effects:
ranova(fmL) #=> yes, Consumer:Information  should be removed first

## Ok, now run step(): it eliminates random and fixed effects *stepwise*ly
step_fm <- step(fmL)
##  and reports the different steps when print()ed:
step_fm # Display elimination results

## ==> "Random": Dropped Consumer:Information (but not 'Consumer') - as default alpha.random = 0.10
## ==> "Fixed" : Only 2 main effects kept   (default alpha.fixed = 0.05)


fm <- final_fm <- get_model(step_fm)
summary(final_fm)
## What else can we do with a 'lmerTest' lmer() fit ?
##        E.g., how can we print the correlation matrix *symbolically* ?
## ==> find out:
class(fm)
methods(class=class(fm))
?summary.lmerModLmerTest # -> see 'symbolic.cor'
print(summary(fm), symbolic.cor=TRUE)

## Zeta-plots :
pfm <- profile(fm) # takes a few seconds
confint(pfm)
lattice::xyplot(pfm)
confint(pfm, level = 0.90) # here, CI for sig02 = \sigma_2 goes down to 0.168 (but not yet zero)


