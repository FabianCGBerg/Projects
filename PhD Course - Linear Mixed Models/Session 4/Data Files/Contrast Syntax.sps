* Encoding: UTF-8.

*Use the syntax below on the Track Scores (Multivariate) file.
GLM Year_1 Year_2 Year_3 Year_4 BY Track
  /WSFACTOR=Year 4 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /PRINT=PARAMETER 
  /WSDESIGN=Year
  /DESIGN=Track
  /CONTRAST(Track)=Helmert
  /CONTRAST(Track) SPECIAL(3 -1 -1 -1) 
  /LMATRIX = "CN vs All" Track 1/2 -1/6 -1/6 -1/6
  /LMATRIX = "CN/FN vs. NP/PP" Track 1/4 -1/4 -1/4 1/4
  /LMATRIX = "Mean FN" Intercept 1/2 Track 0 0 0 1/2
  /KMATRIX = 0
  /EMMEANS=TABLES(Track) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Year) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Track*Year) COMPARE(Track) ADJ(SIDAK)
  /EMMEANS=TABLES(Track*Year) COMPARE(Year) ADJ(SIDAK).

*Use the syntax below on the Track Scores (Univariate) file.
MIXED Time_score BY Track Year
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Track Year | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Year | SUBJECT(PP) COVTYPE(UN)
  /PRINT=LMATRIX SOLUTION     
  /TEST = "Contrast CN vs all"  Track 3 -1 -1 -1 DIVISOR=3
  /TEST = "Contrast CN/FN vs NP/PP"  Track 1 -1 -1 1 DIVISOR=2.

MIXED Time_score BY Track Year
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Track Year Track*Year | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Year | SUBJECT(PP) COVTYPE(UN)
  /PRINT=LMATRIX SOLUTION     
  /TEST = "Contrast CN vs all"  Track 12 -4 -4 -4
                                             Year 0 0 0 0 
                                             Track*Year 3 3 3 3 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 DIVISOR=12
  /TEST = "Contrast CN/FN vs NP/PP"  Track 4 -4 -4 4
                                             Track*Year 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 1 1 1 1 DIVISOR=8
  /TEST(8) = "Contrast CN/FN vs NP/PP"  Track 4 -4 -4 4
                                             Track*Year 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 1 1 1 1 DIVISOR=8
  /TEST = "Contrast INT vs FN" Intercept 1
                                             Track 0 0 0 1
                                             Year 1/4 1/4 1/4 1/4 
                                             Track*Year 0 0 0 0 0 0 0 0 0 0 0 0 1/4 1/4 1/4 1/4
  /TEST = "Contrast CN vs FN"  Track 12 0 0 -12
                                             Year 0 0 0 0 
                                             Track*Year 3 3 3 3 0 0 0 0 0 0 0 0 -3 -3 -3 -3 DIVISOR=12
  /TEST = "Linear Year"          Year -12 -4 4 12
                                             Track*Year -3 -1 1 3 -3 -1 1 3 -3 -1 1 3 -3 -1 1 3 DIVISOR=12
  /TEST = "Quadratic Year"      Year 4 -4 -4 4
                                             Track*Year 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 DIVISOR=4 
  /TEST = "Cubic Year"          Year -4 12 -12 4
                                             Track*Year -1 3 -3 1 -1 3 -3 1 -1 3 -3 1 -1 3 -3 1 DIVISOR=12	
  /TEST = "Linear*Cubic Interaction" Track*Year	3 -9 9 -3 1 -3 3 -1 -1 3 -3 1 -3 9 -9 3 DIVISOR=	9     
  /EMMEANS=TABLES(Track) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Year) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Track*Year) COMPARE(Track) ADJ(SIDAK)
  /EMMEANS=TABLES(Track*Year) COMPARE(Year) ADJ(SIDAK).


*Use the syntax below on the Track Scores (Univariate) file.
* Generalized Estimating Equations.
GENLIN Time_score BY Track Year (ORDER=ASCENDING)
  /MODEL Track Year Track*Year INTERCEPT=YES
 DISTRIBUTION=NORMAL LINK=IDENTITY
  /CRITERIA SCALE=MLE PCONVERGE=1E-006(ABSOLUTE) SINGULAR=1E-012 ANALYSISTYPE=3(WALD) CILEVEL=95 
    LIKELIHOOD=FULL
  /EMMEANS TABLES=Track SCALE=ORIGINAL COMPARE=Track CONTRAST=PAIRWISE PADJUST=LSD
  /EMMEANS TABLES=Track SCALE=ORIGINAL COMPARE=Track CONTRAST=HELMERT PADJUST=LSD
  /EMMEANS TABLES=Year SCALE=ORIGINAL COMPARE=Year CONTRAST=POLYNOMIAL PADJUST=LSD
  /EMMEANS TABLES=Track*Year SCALE=ORIGINAL COMPARE=Track*Year CONTRAST=PAIRWISE PADJUST=LSD
  /EMMEANS TABLES=Track*Year SCALE=ORIGINAL COMPARE=Track CONTRAST=PAIRWISE PADJUST=LSD
  /EMMEANS TABLES=Track*Year SCALE=ORIGINAL COMPARE=Year CONTRAST=PAIRWISE PADJUST=LSD
  /REPEATED SUBJECT=PP WITHINSUBJECT=Year SORT=YES CORRTYPE= UNSTRUCTURED  ADJUSTCORR=YES COVB=ROBUST
  /MISSING CLASSMISSING=EXCLUDE
  /PRINT CPS DESCRIPTIVES MODELINFO FIT SUMMARY SOLUTION.


