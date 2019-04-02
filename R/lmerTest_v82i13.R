##################################################################
##
## Replication code for
## Kuznetsova, Brockhoff, Christensen (2017)
## lmerTest package: Tests in Linear Mixed Effects Models
## Journal of Statistical Software *82* (13), 1--26.
## https://www.jstatsoft.org/article/view/v082i13
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^
c(DOI = "10.18637/jss.v082.i13")
##
## Requires installation of the following packages:
## lmerTest, ggplot2, xtable, pbkrtest, reshape, SASmixed
##
##################################################################

##################################################################
## Section 3

library("lmerTest")
library("ggplot2")
library("pbkrtest")
library("reshape")
data("PBIB", package = "SASmixed")

## Function simulates response from the model without Treatment and
## applies Satterthwaite's, KR and LRT.
simCompare <- function(mod, nsim) {
  res_no_treat <- matrix(NA, nsim, 3,
                         dimnames = list(NULL,
                                         c("pvalKenw", "pvalSat", "pvalLRT")))
  warns <- NULL
  for (j in 1:nsim) {
    PBIB$ysim <- simulate(mod)$sim_1
    tt <- tryCatch(mod2 <- lmer(ysim  ~ Treatment + (1|Block), data = PBIB),
                   warning = function(w) w)
    if(is(tt, "warning"))
      warns <- c(warns, j)

    an.sat <- anova(mod2)
    ## if (require("pbkrtest"))
    an.kr <- anova(mod2, ddf = "Kenward-Roger")
    Mod_no.treat <- lmer(ysim ~ 1 + (1|Block), data = PBIB)
    w_no.treat <- anova(mod2, Mod_no.treat)

    res_no_treat[j, ] <- unlist(c(an.kr["Pr(>F)"], an.sat["Pr(>F)"],
                                   w_no.treat[2, 8]))
  }
  v <- list(res_no_treat = res_no_treat, warns = warns)
}

## lme4 :
fm2P. <- lme4::lmer(response ~ 1 + (1|Block), PBIB)
summary(fm2P.)

## Model corresponding to the null hypothesis of no treatment effect.
fm2PBIB <- lmerTest::lmer(response ~ 1 + (1|Block), PBIB)
summary(fm2PBIB) # with P-values

set.seed(998)
nsim <- 1000
## takes some minutes .. and produces 1000+ messages
if(FALSE)
ressim <- simCompare(fm2PBIB, nsim)
## ==> rather cache the result for MEMo lecture:
sfile <- "~/Vorl/MEMo/examples_R/lmerTest_sim_m2PBIB.rds"
if(file.exists(sfile)) {
    ressim <- readRDS(sfile)
} else {
    ressim <- simCompare(fm2PBIB, nsim) ## takes some minutes .. and produces 1000+ messages
    "refitting model(s) with ML (instead of REML)"
    ## in addition, (2019-03):
        ## Warning messages:
        ## 1: In optwrap(optimizer, devfun, x@theta, lower = x@lower, calc.derivs = TRUE,  :
        ##   convergence code 3 from bobyqa: bobyqa -- a trust region step failed to reduce q
        ## 2: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
        ##   Model failed to converge with max|grad| = 0.0217152 (tol = 0.002, component 1)
    saveRDS(ressim, sfile)
}

pvals     <- ressim$res_no_treat[, "pvalSat"]
pvals.lrt <- ressim$res_no_treat[, "pvalLRT"]
pvals.kr  <- ressim$res_no_treat[, "pvalKenw"]

empLRT <- empSAT <- empKR <- rep(NA_real_, nsim)
alphas <- seq(0.001, 1, by = 0.001)
for (i in 1:length(alphas)) {
  empSAT[i] <- sum(pvals     < alphas[i]) / nsim
  empKR [i] <- sum(pvals.kr  < alphas[i]) / nsim
  empLRT[i] <- sum(pvals.lrt < alphas[i]) / nsim
}

dd <- data.frame(empSAT, empKR, empLRT, alphas)
str(dd)
head(dd)
## MM: simple traditional graphics plot
matplot(dd$alphas, dd[,1:3], type="l", lty=1, lwd=2, asp=1,
        xlab = quote("nominal" ~ alpha), ylab = "empirical P values")
abline(0,1, col="gray50", lty=2); grid()
legend("topleft", c("Satterthwaite", "Kenward-Roger", "LRT"), lty=1, lwd=2, col=1:3)

## Melt data for ggplot()ing :
ddplot <- melt(dd, measure.vars = c("empSAT", "empKR", "empLRT"),
               variable_name = "test",
               value.name = "observed test level")

d <- ggplot(data = ddplot, aes(x = value, y = alphas, colour = test))
d + geom_line() + geom_abline(colour = "black") +
    xlab("Empirical p-value") + ylab("Nominal p-value") +
    scale_colour_manual(
        values  = c(empSAT = "forest green", empKR = "red", empLRT = "blue"),
        labels = c("Satterthwaite", "Kenward-Roger", "LRT"),
        name = "Test")

detach("package:lmerTest")

##################################################################

##################################################################
## Example in Section 8.2
## Load TVbo data from the local drive.
data("TVbo", package = "lmerTest")
library("lme4")

tv4 <- lme4::lmer(Sharpnessofmovement ~ TVset * Picture +
               (1 | Assessor) + (1 | Assessor:TVset) + (1 | Assessor:Picture),
               data = TVbo)
## MM:
summary(tv4) # shows correlations of fixed effects --> symbolically:
print(summary(tv4), symbolic.cor=TRUE)

anova(tv4)

library("lmerTest")
tv <- lmerTest::lmer(Sharpnessofmovement ~ TVset * Picture +
                       (1 | Assessor) + (1 | Assessor:TVset) + (1 | Assessor:Picture),
                     data = TVbo)
anova(tv)
anova(tv, type = 2, ddf = "Kenward-Roger") # here "exactly" the same (ddf are more accurat)

##################################################################

##################################################################
## Example in Section 8.3
m.carrots <- lmer(Preference ~ sens1 + sens2 +
                      (1 + sens1 + sens2|Consumer) + (1|Product),
                  data = carrots)
summary(m.carrots)
##################################################################

##################################################################
## Example in Section 8.4
## -- here, the very full model
tv <- lmer(Sharpnessofmovement ~ TVset * Picture +
               (1 | Assessor:TVset) + (1 | Assessor:Picture) +
               (1 | Assessor:Picture:TVset) + (1 | Repeat) + (1 | Repeat:Picture) +
               (1 | Repeat:TVset) + (1 | Repeat:TVset:Picture) +
               (1 | Assessor), data = TVbo)
##-> message  "boundary (singular) fit:"
st <- step(tv) # more singular fit messages
plot(st, effs = c("Picture", "TVset"))

st0 <- st
" ==== FIXME: 'st' is different!"

## Wrap the results to xtable from example in Section 8.4  -- page 13
library("xtable")
## Wrap the random part.________FIXME now has 7 columns !!
colnames(st0$random)
##  "Eliminated" "npar"  "logLik"  "AIC"  "LRT"  "Df" "Pr(>Chisq)"
st$random[, "Pr(>Chisq)"] <- format.pval(st0$random[, "Pr(>Chisq)"], digits = 3, eps = 1e-3)
st$random[, "Eliminated"] <- local({e <- st0$random[, "Eliminated"]; e[e == 0] <- "kept"; e })
names(st$random) <- c("$\\text{elim.num}$", "npar", "logLik", "AIC", "$\\chi^2$", "$\\text{Chi.DF}$" ,
                                                        "$p\\text{-value}$")
rand.table_tv <- xtable(st$random,
                        align = "lccccccc",
                        display = c("s", "f", "d","d","d", "d", "d", "s"),
                        label = "tab:rand")

caption(rand.table_tv) <- "Likelihood ratio tests for the
random-effects and their order of elimination representing Step 1 of
the automated analysis for the TVbo data for attribute Sharpnessofmovement"

print(rand.table_tv, caption.placement = "top", table.placement = "H",
      sanitize.text.function = function(x) x, size = "\\small")

## Wrap the fixed part. (s / anova.table / fixed /):

st$fixed[, "Pr(>F)"] <- format.pval(st0$fixed[,  "Pr(>F)"], digits = 3, eps = 1e-3)
colnames(st$fixed) <-
  c("$\\text{elim.num}$", "Sum Sq", "Mean Sq", "NumDF", "DenDF", "$\\text{F.value}$", "Pr(>F)")

anova.table_tv <- xtable(st$fixed, align = "lccccccc",
                         display = c("s", "s", "f", "f", "s", "f", "f", "s"),
                         label = "tab:fixed")
caption(anova.table_tv) <- "$F$-tests for the fixed-effects and their
order of elimination representing Step 3 of the automated analysis for the TVbo data for attribute Sharpnessofmovement"

print(anova.table_tv, caption.placement = "top",
      table.placement = "H", sanitize.text.function = function(x) x, size = "\\small")
##################################################################

##################################################################
## Example in Section 8.5
L <- matrix(0, ncol = 12, nrow = 6)
L[1, 7] <- L[2, 8] <- L[3, 9] <- L[4, 10] <- L[5, 11] <- L[6, 12] <- 1
calcSatterth(tv, L)
##################################################################

##################################################################
## Example from Section 9
library("reshape")
size <- seq(0, 4000, by = 1000)

ind.size <- lapply(size, function(x)
    sample(seq_len(nrow(carrots)), size = x, replace = TRUE))

## Extend the carrots data by adding randomly selected rows from the
## carrots data.
dd <- lapply(ind.size, function(x) carrots[c(1:nrow(carrots), x), ])

fit.mcarrots <- function(d) {
  lmer(Preference ~ sens1 + sens2 +
           (1 + sens1 + sens2 | Consumer) + (1 | product), data = d)
}

## Apply model fit.mcarrots to all the data sets.
m.carrots.list <- lapply(dd, fit.mcarrots)

## Calculate timings for the satterthwaite.
time.sat <- lapply(m.carrots.list, function(x) system.time(anova(x))[1])

## Calculate timings for the KR.
if (require("pbkrtest")) {
    time.kr <- lapply(m.carrots.list,
                      function(x) system.time(anova(x, ddf = "Kenward-Roger"))[1])
}

## Plot the timings.
dd.plot <- data.frame(size = size + nrow(carrots),
                      "Kenward-Roger" = unlist(time.kr),
                      "Satterthwaite" = unlist(time.sat))
dd.plot

library("reshape")
time.plot <- melt(id = "size", dd.plot)

library("ggplot2")
ggplot(time.plot, aes(y = value, x = size, colour = variable)) + geom_line() +
  xlab("Number of observations") + ylab("Computation time in seconds")  +
  theme(legend.title = element_blank(), text = element_text(size = 20))

rm(m.carrots.list, dd)

##################################################################
## Example:
## number of observations = 11236
## KRmodcomp function throws an error on a computer with processor
## Intel(R) Core(TM) i3-5005U CPU 2.00GHz with 2 cores (4 threads)
## and 8 GB of memory.

set.seed(1234)
ind.size <- sample(seq(nrow(carrots)), size = 10000, replace = TRUE)

## Extend the carrots data by adding randomly selected rows from the
## carrots data.
data.extend <- carrots[c(1:nrow(carrots), ind.size), ]

m1 <- lmer(Preference ~ sens1 + sens2 +
               (1 + sens1 + sens2 | Consumer) + (1 | product), data = data.extend)
m2 <- lmer(Preference ~ sens1 +
               (1 + sens1 + sens2 | Consumer) + (1 | product), data = data.extend)
anova(m1) ## with Satterthwaite's method

library("pbkrtest")
try(KRmodcomp(m1, m2)) ## Kenward-Roger's method

##################################################################
## Appendix

m.carrots <- lmer(Preference ~ sens1 + sens2 +
                      (1 + sens1 + sens2 | Consumer) + (1 | product), data = carrots)
step(m.carrots, fixed.calc = FALSE)
m.carrots.red.sens1 <- lmer(Preference ~ sens1 + sens2 +
                                (1 + sens2 | Consumer) + (1 | product), data = carrots)
anova(m.carrots, m.carrots.red.sens1, refit = FALSE)

