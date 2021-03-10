* Encoding: UTF-8.
*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
* Model Construction for the Numeric Response Without Covariate.
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Numeric_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Prime Session*Hemisphere*Target 
    Session*Prime*Target Hemisphere*Prime*Target Session*Hemisphere*Prime*Target | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CS).


MIXED Numeric_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target
    Session*Prime*Target | SSTYPE(3)
  /METHOD=ML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH).


*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
* Final Model for the Numeric Response Without Covariate.
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Numeric_Response BY Session Hemisphere Prime Target
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target
    Session*Prime*Target | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH).
   /EMMEANS=TABLES(Session*Prime*Target) COMPARE(Session) ADJ(SIDAK).


*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
* Model Construction for the Numeric Response With Covariate.
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Numeric_Response BY Session Hemisphere Prime Target WITH Visual_Response
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Hemisphere*Prime Session*Hemisphere*Target 
    Session*Prime*Target Hemisphere*Prime*Target Session*Hemisphere*Prime*Target Visual_Response 
    Session*Visual_Response Hemisphere*Visual_Response Prime*Visual_Response Target*Visual_Response 
    Session*Hemisphere*Visual_Response Session*Prime*Visual_Response Session*Target*Visual_Response 
    Hemisphere*Prime*Visual_Response Hemisphere*Target*Visual_Response Prime*Target*Visual_Response 
    Session*Hemisphere*Prime*Visual_Response Session*Hemisphere*Target*Visual_Response 
    Session*Prime*Target*Visual_Response Hemisphere*Prime*Target*Visual_Response 
    Session*Hemisphere*Prime*Target*Visual_Response | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CS).


MIXED Numeric_Response BY Session Hemisphere Prime Target WITH Visual_Response
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Prime*Target  
    Visual_Response Hemisphere*Visual_Response | SSTYPE(3)
  /METHOD=ML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH).

*---------------------------------------------------------------------------------------------------------------------------------------------------.
* .
* Final Model for the Numeric Response With Covariate.
* .
*---------------------------------------------------------------------------------------------------------------------------------------------------.

MIXED Numeric_Response BY Session Hemisphere Prime Target WITH Visual_Response
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Session Hemisphere Prime Target Session*Hemisphere Session*Prime Session*Target 
    Hemisphere*Prime Hemisphere*Target Prime*Target Session*Prime*Target  
    Visual_Response Hemisphere*Visual_Response | SSTYPE(3)
  /METHOD=REML
  /REPEATED=Session*Hemisphere*Prime*Target | SUBJECT(PP) COVTYPE(CSH)
  /EMMEANS=TABLES(Hemisphere*Prime) COMPARE(Hemisphere) ADJ(SIDAK)
  /EMMEANS=TABLES(Hemisphere*Prime) COMPARE(Prime) ADJ(SIDAK)
  /EMMEANS=TABLES(Session*Prime*Target) COMPARE(Session) ADJ(SIDAK)
  /EMMEANS=TABLES(Hemisphere) WITH(Visual_Response=-4.623352) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Hemisphere) WITH(Visual_Response=-3.455150) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(Hemisphere) WITH(Visual_Response=-2.286948) COMPARE ADJ(SIDAK).

