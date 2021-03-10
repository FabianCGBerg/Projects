* Encoding: UTF-8.

MIXED Visual_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Prime Session*Hemisphere*Target 
    Session*Prime*Target Hemisphere*Prime*Target Session*Hemisphere*Prime*Target | SSTYPE(3)
  /METHOD=ML
  /SAVE RESID PRED
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CS).


*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
*Covariance matrix comparisons (Switch to REML).
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Visual_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Prime Session*Hemisphere*Target 
    Session*Prime*Target Hemisphere*Prime*Target Session*Hemisphere*Prime*Target | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CS).

*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
* Model Reduction (Switch to ML).
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Visual_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Target 
    Session*Prime*Target | SSTYPE(3)
  /METHOD=ML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH).

*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
* Final Model (Switch to REML).
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Visual_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Target 
    Session*Prime*Target | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH).