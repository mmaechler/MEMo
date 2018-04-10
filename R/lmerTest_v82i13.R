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
    an.kr <- anova(mod2, ddf = "kenw")
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
summary(fm2PBIB)

set.seed(998)
nsim <- 1000
ressim <- simCompare(fm2PBIB, nsim)

pvals <- ressim$res_no_treat[, "pvalSat"]
pvals.lrt <- ressim$res_no_treat[, "pvalLRT"]
pvals.kr <- ressim$res_no_treat[, "pvalKenw"]

n <- nsim
empLRT  <- empSAT <- empKR <- rep(NA_real_, n)
alphas <- seq(0.001, 1, by = 0.001)
for (i in 1:length(alphas)) {
  empSAT[i] <- sum(pvals < alphas[i]) / nsim
  empKR[i] <- sum(pvals.kr < alphas[i]) / nsim
  empLRT[i] <- sum(pvals.lrt < alphas[i]) / nsim
}

dd <- data.frame(empSAT, empKR, empLRT, alphas)

## Melt data for satterthwaite.
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
anova(tv4)

library("lmerTest")
tv <- lmerTest::lmer(Sharpnessofmovement ~ TVset * Picture +
                       (1 | Assessor) + (1 | Assessor:TVset) + (1 | Assessor:Picture),
                     data = TVbo)
anova(tv)
anova(tv, type = 2, ddf = "Kenward-Roger") # here exactly the same

##################################################################

##################################################################
## Example in Section 8.3
m.carrots <- lmer(Preference ~ sens1 + sens2 +
                      (1 + sens1 + sens2|Consumer) + (1|product),
                  data = carrots)
summary(m.carrots)
##################################################################

##################################################################
## Example in Section 8.4
tv <- lmer(Sharpnessofmovement ~ TVset * Picture +
               (1 | Assessor:TVset) + (1 | Assessor:Picture) +
               (1 | Assessor:Picture:TVset) + (1 | Repeat) + (1 | Repeat:Picture) +
               (1 | Repeat:TVset) + (1 | Repeat:TVset:Picture) +
               (1 | Assessor), data = TVbo)
st <- step(tv)
plot(st, effs = c("Picture", "TVset"))

## Wrap the results to xtable from example in Section 8.4
## Wrap the random part.
library("xtable")
st$rand.table[, 4] <- format.pval(st$rand.table[, 4], digits = 3, eps = 1e-3)
colnames(st$rand.table) <- c("$\\chi^2$", "$\\text{Chi.DF}$" ,
                             "$\\text{elim.num}$", "$p\\text{-value}$")
rand.table_tv <- xtable(st$rand.table, align = "lcccc",
                        display = c("s", "f", "d", "d", "s"),
                        label = "tab:rand")

caption(rand.table_tv) <- "Likelihood ratio tests for the
random-effects and their order of elimination representing Step 1 of
the automated analysis for the TVbo data for attribute Sharpnessofmovement"

## Wrap the fixed part.
print(rand.table_tv, caption.placement = "top", table.placement = "H",
      sanitize.text.function = function(x) x, size = "\\small")

st$anova.table[, 7] <- format.pval(st$anova.table[, 7], digits = 3, eps = 1e-3)
colnames(st$anova.table) <-
  c("Sum Sq", "Mean Sq", "NumDF", "DenDF", "$\\text{F.value}$",
    "$\\text{elim.num}$", "Pr(>F)")

anova.table_tv <- xtable(st$anova.table, align = "lccccccc",
                         display = c("s", "f", "f", "s", "f", "f", "s", "s"),
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

