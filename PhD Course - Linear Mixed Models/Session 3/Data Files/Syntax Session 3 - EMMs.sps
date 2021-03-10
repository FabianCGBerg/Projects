* Encoding: UTF-8.
*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
*Final Model from Last Time.
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

*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
*Adding Estimated Marginal Means.
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Visual_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Target 
    Session*Prime*Target | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION R
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH)
  /EMMEANS=TABLES(Session) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Session*Prime) COMPARE(Session) ADJ(SIDAK)
  /EMMEANS=TABLES(Session*Prime) COMPARE(Prime) ADJ(SIDAK)
  /EMMEANS=TABLES(Session*Prime*Target) COMPARE(Session) ADJ(SIDAK)
  /EMMEANS=TABLES(Session*Hemisphere*Target) COMPARE(Session) ADJ(SIDAK).



