# R Packages for Mixed(-Effects) Models

## The absolute core:

### [`nlme`](https://CRAN.R-project.org/package=nlme)
### [`lme4`](https://CRAN.R-project.org/package=lme4)

## Other Packages with Mixed Effect Models as main purpose (and recommendable)

- [`lmerTest`](https://CRAN.R-project.org/package=lmerTest)
- [`glmmTMB`](https://CRAN.R-project.org/package=glmmTMB)

- [`pbkrtest`](https://CRAN.R-project.org/package=pbkrtest), see also the [`pbkrtest` page](http://people.math.aau.dk/~sorenh/software/pbkrtest/)    and notably the `demo.R` and resulting [`demo.html`](http://people.math.aau.dk/~sorenh/software/pbkrtest/doc/demo.html) example.

## [CRAN Task Views](https://cran.r-project.org/web/views)

There is none, with this topic
Is there no good one ?

- `nlme` is in
	`ChemPhys`,
	`Econometrics`,
	`Environmetrics`,
	`Finance`,
	`OfficialStatistics`,
	`Psychometrics`,
	`SocialSciences`,
	`Spatial`,
	`SpatioTemporal`,

	whereas

- `lme4` is in
	`Bayesian`,
	`Econometrics`,
	`Environmetrics`,
	`OfficialStatistics`,
	`Psychometrics`,
	`SocialSciences`,
	`SpatioTemporal`,

- with the intersection

| Task View          | URL                                           | CRAN packages | comments |
|--------------------|-----------------------------------------------|---------------|----------|
| `Econometrics`     | https://CRAN.R-project.org/view=Econometrics | nlme, lme4 |   |
| `Environmetrics`   | https://CRAN.R-project.org/view=Environmetrics | nlme, lme4 | Modelling species responses and other data   |
|`OfficialStatistics`| https://CRAN.R-project.org/view=OfficialStatistics | nlme, lme4, rsae | (robust) Small Area Estimation  |
| `Psychometrics`    | https://CRAN.R-project.org/view=Psychometrics | nlme, lme4, ordinal, MCMCglmm, irtrees | Item Response Theory (ITR), Rasch Mod.  |
| `SocialSciences`   | https://CRAN.R-project.org/view=SocialSciences | nlme, lme4, lmeSplines, lmm, MCMCglmm | Other Regression Methods |
| `SpatioTemporal`   | https://CRAN.R-project.org/view=SpatioTemporal | nlme, lme4 | (spatio-temporal data)  |

## R (CRAN) packages with `LMM` in their names:

```r
ip <- installed.packages() # ~ 13'000 for Martin Maechler
str(ip)
```

```
##  chr [1:13265, 1:16] "BiocInstaller" "pkgA" "copula_" "copulaData" ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : chr [1:13265] "BiocInstaller" "pkgA" "copula_" "copulaData" ...
##   ..$ : chr [1:16] "Package" "LibPath" "Version" "Priority" ...
```

```r
pkgs <- rownames(ip)
str(LMMs <- grep("lmm", pkgs, ignore.case=TRUE, value=TRUE))
```

```
##  chr [1:36] "denseFLMM" "designGLMM" "glmm" "glmmADMB" "glmmAK" ...
```

```r
pdLMM <- lapply(LMMs, packageDescription)
titLMM <-
    ttLMM <- gsub("\n", " ",
                  sapply(setNames(,LMMs), packageDescription, fields = "Title"))
longT <- nchar(ttLMM) > 80
ttLMM[longT] <- paste(substr(ttLMM[longT], 1, 77), "...")
cbind(ttLMM) # 80% are GLMM  amazing
```

```
##                ttLMM                                                                              
## denseFLMM      "Functional Linear Mixed Models for Densely Sampled Data"                          
## designGLMM     "Finding Optimal Block Designs for a Generalised Linear Mixed Model"               
## glmm           "Generalized Linear Mixed Models via Monte Carlo Likelihood Approximation"         
## glmmADMB       "Generalized Linear Mixed Models using AD Model Builder"                           
## glmmAK         "Generalized Linear Mixed Models"                                                  
## glmmBUGS       "Generalised Linear Mixed Models with BUGS and JAGS"                               
## glmmGS         "Gauss-Seidel Generalized Linear Mixed Model solver"                               
## glmmLasso      "Variable Selection for Generalized Linear Mixed Models by L1-Penalized Estima ..."
## glmmML         "Generalized Linear Models with Clustering"                                        
## GLMMRR         "Generalized Linear Mixed Model (GLMM) for Binary Randomized Response Data"        
## glmmsr         "Fit a Generalized Linear Mixed Model"                                             
## glmmTMB        "Generalized Linear Mixed Models using Template Model Builder"                     
## HGLMMM         "Hierarchical Generalized Linear Models"                                           
## HiLMM          "Estimation of Heritability in Linear Mixed Models"                                
## lmm            "Linear Mixed Models"                                                              
## lmmen          "Linear Mixed Model Elastic Net"                                                   
## lmmfit         "Goodness-of-fit-measures for linear mixed models with one-level-grouping"         
## lmmlasso       "Linear mixed-effects models with Lasso"                                           
## lmmot          "Multiple Ordinal Tobit (MOT) Model"                                               
## lmmpar         "Parallel Linear Mixed Model"                                                      
## lmms           "Linear Mixed Effect Model Splines for Modelling and Analysis of Time Course Data" 
## MCMCglmm       "MCMC Generalised Linear Mixed Models"                                             
## mlmm           "Multilevel Model for Multivariate Responses with Missing Values"                  
## mlmmm          "ML estimation under multivariate linear mixed models with missing values"         
## mvglmmRank     "Multivariate Generalized Linear Mixed Models for Ranking Sports Teams"            
## plmm           "Partially Linear Mixed Effects Model"                                             
## powerlmm       "Power Calculations for Longitudinal Multilevel Models"                            
## QGglmm         "Estimate Quantitative Genetics Parameters from Generalised Linear Mixed Models"   
## qrLMM          "Quantile Regression for Linear Mixed-Effects Models"                              
## qrNLMM         "Quantile Regression for Nonlinear Mixed-Effects Models"                           
## r2glmm         "Computes R Squared for Mixed (Multilevel) Models"                                 
## RLMM           "A Genotype Calling Algorithm for Affymetrix SNP Arrays"                           
## robustlmm      "Robust Linear Mixed Effects Models"                                               
## sparseFLMM     "Functional Linear Mixed Models for Irregularly or Sparsely Sampled Data"          
## StroupGLMM     "R Codes and Datasets for Generalized Linear Mixed Models: Modern Concepts, Me ..."
## VetResearchLMM "Linear Mixed Models - An Introduction with Applications in Veterinary Research"
```
<!-- When run by  `R RHOME`/bin/Rscript --no-restore --no-save -e 'knitr::knit("R-package-pointers.Rmd")'
 this fails with (R <-> R-devel) problem (and cache ?):
 Error in readRDS(file) :
  cannot read unreleased workspace version 3 written
  by experimental R 3.5.0 -->


## Closely related packages

- [`ordinal`](https://CRAN.R-project.org/package=ordinal), fn `clmm()` for *cumulative* LMMs.
- [`lmeSplines`](https://CRAN.R-project.org/package=lmeSplines), based on pkg `nlme`, allows splines for linear and non-linear MM.

- [`mgcv`](https://CRAN.R-project.org/package=mgcv), *Recommended* pkg, has `gamm()`, based on pkg `nlme`.  Alternatively, (and not possible inside *rec.* package `mgcv`):
- [`gamm4`](https://CRAN.R-project.org/package=gamm4), based on pkg `lme4`, has fn. `gamm4()` based on `lmer()` etc.


#### NB. "knit me" to markdown --> `*.md` simply by

	knitr::knit("~/R/D/GH/MEMo/R-package-pointers.Rmd")

