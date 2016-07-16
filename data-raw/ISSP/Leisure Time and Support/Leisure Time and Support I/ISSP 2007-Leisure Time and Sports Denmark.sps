recode dk5 (else=copy) into v3.
recode dk1 (5889=208) into v4.
recode dk1 (5889=208) into v5.
recode dk6 (else=copy) into v6.
recode dk7 (else=copy) into v7.
recode dk8 (else=copy) into v8.
recode dk9 (else=copy) into v9. 
recode dk10 (else=copy) into v10. 
recode dk11 (else=copy) into v11. 
recode dk12 (else=copy) into v12. 
recode dk13 (else=copy) into v13. 
recode dk14 (else=copy) into v14. 
recode dk15 (else=copy) into v15. 
recode dk16 (else=copy) into v16. 
recode dk17 (else=copy) into v17. 
recode dk18 (else=copy) into v18. 
recode dk19 (else=copy) into v19. 
recode dk20 (else=copy) into v20. 
recode dk21 (else=copy) into v21. 
recode dk22 (else=copy) into v22. 
recode dk23 (else=copy) into v23. 
recode dk24 (else=copy) into v24. 
recode dk25 (else=copy) into v25. 
recode dk26 (else=copy) into v26. 
recode dk27 (else=copy) into v27.
recode dk28 (else=copy) into v28.
recode dk29 (else=copy) into v29.
recode dk30 (else=copy) into v30.
recode dk31 (else=copy) into v31.
recode dk32 (else=copy) into v32.
recode dk33 (else=copy) into v33.
recode dk34 (else=copy) into v34.

recode dk35 (else=copy) into v35.
recode dk36 (else=copy) into v36.
recode dk37 (else=copy) into v37.
recode dk39 (else=copy) into v38.
recode dk40 (else=copy) into v39.
recode dk41 (else=copy) into v40.
recode dk42 (else=copy) into v41.
recode dk43 (else=copy) into v42.
recode dk44 (else=copy) into v43.
recode dk46 (else=copy) into v44.
recode dk48 (else=copy) into v45.
recode dk49 (else=copy) into v46.
recode dk50 (else=copy) into v47.
recode dk51 (else=copy) into v48.
recode dk52 (else=copy) into v49.
recode dk53 (else=copy) into v50.
recode dk54 (else=copy) into v51.
recode dk55 (else=copy) into v52.
recode dk56 (else=copy) into v53.
recode dk57 (else=copy) into v54.
recode dk58 (else=copy) into v55.
recode dk60 (else=copy) into v56.
recode dk61 (else=copy) into v57.
recode dk62 (else=copy) into v58.
recode dk63 (else=copy) into v59.
recode dk64 (else=copy) into v60.
recode dk65 (else=copy) into v61.
recode dk66 (else=copy) into v62.
recode dk67 (else=copy) into v63.
recode dk68 (else=copy) into v64.
recode dk69 (else=copy) into v65.


compute SEX=dk111.

compute AGE=(dk112-2008)*-1.

compute MARITAL=dk116.
if dk117=5 and dk116 =1 MARITAL=4.
exe.

recode dk118 (1=1) (5=2) (10=0) (else=copy) into COHAB.
exe.

recode dk125 (0=97) (88=98) (100=0) (else=copy) into EDUCYRS.
if dk125=2 EDUCYRS=95.
if dk124=3 EDUCYRS=96.
exe.

compute DEGREE=0.
if dk121=1 and dk123=9 DEGREE=1.
if any(dk121,2,3,4,7) and dk123=9 DEGREE=2.
if any(dk121,5,6) and any(dk123,1,2,3,4,8,9) DEGREE=3.
if any(dk121,1,2,3,4,7) and any(dk118,1,2,3,4,8) DEGREE=3.
if dk121=9 or dk118=99 DEGREE=9.
if dk123=5 DEGREE=4.
if dk123=6 DEGREE=4.
if dk123=7 DEGREE=5.
exe.

compute DK_DEGR=0.
if dk121=1 and dk123=9 DK_DEGR=1.
if dk121=2 and dk123=9 DK_DEGR=2.
if dk121=3 and dk123=9 DK_DEGR=3.
if dk121=4 and dk123=9 DK_DEGR=4.
if dk121=5 and dk123=9 DK_DEGR=5.
if dk121=6 and dk123=9 DK_DEGR=6.
if dk121=7 and dk123=9 DK_DEGR=7.
if any(dk118,1,2,3) DK_DEGR=8.
if dk123=4 DK_DEGR=9.
if dk123=5 DK_DEGR=10.
if dk123=6 DK_DEGR=11.
if dk123=7 DK_DEGR=12.
if dk123=8 DK_DEGR=13.
if dk121=9 or dk123=99 DK_DEGR=99.
exe.

recode dk126 (1=1) (2=1) (3=2) (4=2) (5=3) (6=3) 
(7=3) (8=4) (9=6) (10=5) (11=6) (12=6) (13=7) (14=9) (15=7) (16=8) 
(17=10) (else=copy) into WRKST.
exe.

recode dk132 (98,100,112,168,185=96) (999=99) (1000=00) (888=98) (else=copy) into WRKHRS.
if dk131=1 WRKHRS=98.
exe.

recode ISCO88 (else=copy) into ISCO88.
exe.

recode dk133 (10=0) (5=2) (else=copy) into WRKSUP.
exe.

recode dk134 (10=0) (else=copy) into WRKTYPE.
exe.

recode dk136 (10000=0) (9999=9999) (8888=9998) (else=copy) into NEMPLOY.
if WRKTYPE<=3 NEMPLOY=0000.
if dk135=5 NEMPLOY=9995.
exe.

recode dk144 (else=copy) into UNION.
exe.

recode dk138 (1=1) (2=1) (3=2) (4=2) (5=3) (6=3) (7=3) (8=4) (9=6) (10=5) (11=6) (12=6) (13=7) (14=9) (15=7) (16=8) 
(17=10) (88=98) (100=0) (else=copy) into SPWRKST.
exe.

recode SPISCO88 (else=copy) into SPISCO88.			
if dk142=2 SPISCO88= 0000.
exe.

recode dk143 (10=0) (else=copy) into SPWRKTYP.
if dk137=2 SPWRKTYP=0.
exe.

recode dk155 (1=70000) (2=125000) (3=175000) (4=225000) (5=275000) (6=350000) (7=450000)
(8=550000) (9=650000) (88=999998) (99=999999) into DK_RINC.
exe.

recode dk156 (1=70000) (2=125000) (3=175000) (4=225000) (5=275000) (6=350000) (7=450000)
(8=550000) (9=650000) (10=750000) (11=850000) (12=950000) (13=1050000) (88=999998) (99=999999) into DK_INC.
exe.

recode dk119 (else=copy) into HOMPOP.
exe.

compute HHCYCLE=99.
if dk119=1 and dk120=1 HHCYCLE=1.
if dk119=1 and dk120>=2 HHCYCLE=99.
if dk119=2 and dk120=1 HHCYCLE=5.
if dk119=2 and dk120=2 HHCYCLE=2.
if dk119=2 and dk120=99 HHCYCLE=99.
if dk119=3 and dk120=1 HHCYCLE=9.
if dk119=3 and dk120=2 HHCYCLE=6.
if dk119=3 and dk120=3 HHCYCLE=3.
if dk119=3 and dk120=99 HHCYCLE=99.
if dk119=4 and dk120=1 HHCYCLE=11.
if dk119=4 and dk120=2 HHCYCLE=10.
if dk119=4 and dk120=3 HHCYCLE=7.
if dk119=4 and dk120=4 HHCYCLE=4.
if dk119=4 and dk120=99 HHCYCLE=99.
if dk119=5 and dk120=1 HHCYCLE=13.
if dk119=5 and dk120=2 HHCYCLE=12.
if dk119=5 and dk120=3 HHCYCLE=10.
if dk119=5 and dk120=4 HHCYCLE=8.
if dk119=5 and dk120=5 HHCYCLE=4.
if dk119=5 and dk120=6 HHCYCLE=99.
if dk119=5 and dk120=99 HHCYCLE=99.
if dk119=6 and dk120=1 HHCYCLE=15.
if dk119=6 and dk120=2 HHCYCLE=14.
if dk119=6 and dk120=3 HHCYCLE=12.
if dk119=6 and dk120=4 HHCYCLE=10.
if dk119=6 and dk120=5 HHCYCLE=8.
if dk119=6 and dk120=6 HHCYCLE=4.
if dk119=6 and dk120=7 HHCYCLE=95.
if dk119=6 and dk120=99 HHCYCLE=99.
if dk119=7 and dk120=1 HHCYCLE=17.
if dk119=7 and dk120=2 HHCYCLE=16.
if dk119=7 and dk120=3 HHCYCLE=14.
if dk119=7 and dk120=4 HHCYCLE=12.
if dk119=7 and dk120=5 HHCYCLE=10.
if dk119=7 and dk120=6 HHCYCLE=8.
if dk119=7 and dk120=7 HHCYCLE=95.
if dk119=7 and dk120=99 HHCYCLE=99.
if dk119=8 and dk120=1 HHCYCLE=19.
if dk119=8 and dk120=2 HHCYCLE=18.
if dk119=8 and dk120=3 HHCYCLE=16.
if dk119=8 and dk120=4 HHCYCLE=14.
if dk119=8 and dk120=5 HHCYCLE=12.
if dk119=8 and dk120=6 HHCYCLE=10.
if dk119=8 and dk120=7 HHCYCLE=95.
if dk119=8 and dk120=99 HHCYCLE=99.
if dk119=9 and dk120=1 HHCYCLE=21.
if dk119=9 and dk120=2 HHCYCLE=20.
if dk119=9 and dk120=3 HHCYCLE=18.
if dk119=9 and dk120=4 HHCYCLE=16.
if dk119=9 and dk120=5 HHCYCLE=14.
if dk119=9 and dk120=6 HHCYCLE=8.
if dk119=9 and dk120=7 HHCYCLE=95.
if dk119=9 and dk120=99 HHCYCLE=99.
if dk119=10 and dk120=1 HHCYCLE=23.
if dk119=10 and dk120=2 HHCYCLE=22.
if dk119=10 and dk120=3 HHCYCLE=20.
if dk119=10 and dk120=4 HHCYCLE=18.
if dk119=10 and dk120=5 HHCYCLE=16.
if dk119=10 and dk120=6 HHCYCLE=14.
if dk119=10 and dk120=99 HHCYCLE=99.
if dk119=11 and dk120=1 HHCYCLE=25.
if dk119=11 and dk120=2 HHCYCLE=24.
if dk119=11 and dk120=3 HHCYCLE=22.
if dk119=11 and dk120=4 HHCYCLE=20.
if dk119=11 and dk120=5 HHCYCLE=18.
if dk119=11 and dk120=6 HHCYCLE=16.
if dk119=11 and dk120=7 HHCYCLE=95.
if dk119=11 and dk120=99 HHCYCLE=99.
if dk119=12 and dk120=1 HHCYCLE=27.
if dk119=12 and dk120=2 HHCYCLE=26.
if dk119=12 and dk120=3 HHCYCLE=24.
if dk119=12 and dk120=4 HHCYCLE=22.
if dk119=12 and dk120=5 HHCYCLE=20.
if dk119=12 and dk120=6 HHCYCLE=18.
if dk119=12 and dk120=7 HHCYCLE=95.
if dk119=12 and dk120=99 HHCYCLE=99.
if dk119=13 HHCYCLE=95.
if dk119=99 or dk120=99 HHCYCLE=99.
exe.

recode dk152 (1=2) (2=3) (3=4) (4=1) (5=3) (6=5) (7=5) (8=3) (9=1) (10=6) (11=7) (12=8) 
(88=8) (99=9) (100=00) into PARTY_LR.
exe.

recode dk152 (10=95) (11=96) (12,88=98) (100=0) (else=copy) into DK_PRTY. 
exe.

recode dk151 (1=1) (2=2) (3=2) (9=9) into VOTE_LE.
exe.

recode dk147 (88=98) (else=copy) into ATTEND.
exe.

recode dk145 (1=250) (2=100) (3=500) (4=600) (5=960) (6=0) (8=998) (9=999) into RELIG. 
exe.

recode RELIG (0=1) (100=2) (200 thru 290=3) (300 thru 390=4)  (400 thru 490=9) (500 thru 590=5) (600 thru 690=6) (700 thru 790=7)
(800 thru 890=8) (900 thru 950=10) (960=11) (998=98) (999=99) into RELIGGRP.
exe. 

recode dk148 (1=10) (2=9) (3=8) (4=7) (5=6) (6=5) (7=4) (8=3) (9=2) (10=1) into TOPBOT.
exe.

if knr=101 DK_REG=6.
if knr=147 DK_REG=7.
if (knr>=151) and (knr<=250) DK_REG=1.
if knr=260 DK_REG=1.
if knr=270 DK_REG=1.
if knr=400 DK_REG=1.
if knr=411 DK_REG=1.
if (knr>=306) and (knr<=390) DK_REG=2.
if knr=253 DK_REG=2.
if knr=259 DK_REG=2.
if knr=265 DK_REG=2.
if knr=269 DK_REG=2.
if (knr>=420) and (knr<=607) DK_REG=3.
if knr=410 DK_REG=3.
if knr=621 DK_REG=3.
if knr=630 DK_REG=3.
if (knr>=657) and (knr<=766) DK_REG=4.
if knr=615 DK_REG=4.
if knr=779 DK_REG=4.
if knr=791 DK_REG=4.
if (knr>=810) and (knr<=860) DK_REG=5.
if knr=773 DK_REG=5.
if knr=787 DK_REG=5.
exe.

recode dk150 (1=1) (2=5) (3=4) (4=3) (5=2) (8=98) (9=99) into DK_SIZE.
exe.

recode dk149 (8=9) (9=9) (else=copy) into URBRURAL.
exe.

recode r10 (31,32=34) (1,2=40) into MODE.
exe.


  .
VARIABLE LABEL v1 "ZA Study Number".
COMMENT TO v1: leave blank!
.
VALUE LABELS v1
 -999999 "SYSMIS"
.
VARIABLE LABEL v2 "Edition of the data file".
VALUE LABELS v2
 1 "1"
.
VARIABLE LABEL v3 "Respondent Number".
VALUE LABELS v3
 -999999 "SYSMIS"
.
VARIABLE LABEL v4 "Country/Sample (see V5 for codes for whole nation states)".
COMMENT TO v4: To be coded using the three digit ISO-Code for the country at hand and a numeric appendix after the decimal comma to indicate a subsample. If no subsamples exist for a given country, this holds the country's original ISO code (see V5)
1. covers disproportional regional samples
2. covers oversamples of subgroups or technically independent samples
Both cases will require special weighting if analyses are meant to be representative for a country.
.
VALUE LABELS v4
 036 "AU-Australia"
 040 "AT-Austria"
 056.1 "FLA-Flanders"
 056.2 "WAL-Wallony"
 076 "BR-Brazil"
 100 "BG-Bulgaria"
 124 "CA-Canada"
 152 "CL-Chile"
 158 "TW-Taiwan"
 191 "HR-Croatia"
 196 "CY-Cyprus"
 203 "CZ-Czech Republic"
 208 "DK-Denmark"
 214 "DO-Dominican Republic"
 246 "FI-Finland"
 250 "FR-France"
 276.1 "DE-W-Germany-West"
 276.2 "DE-E-Germany-East"
 348 "HU-Hungary"
 372 "IE-Ireland"
 376 "IL-Israel"
 392 "JP-Japan"
 410 "KR-South Korea"
 428 "LV-Latvia"
 484 "MX-Mexico"
 528 "NL-Netherlands"
 554 "NZ-New Zealand"
 578 "NO-Norway"
 608 "PH-Philippines"
 616 "PL-Poland"
 620 "PT-Portugal"
 643 "RU-Russia"
 703 "SK-Slovak Republic"
 705 "SI-Slovenia"
 710 "ZA-South Africa"
 724 "ES-Spain"
 752 "SE-Sweden"
 756 "CH-Switzerland"
 792 "TR-Turkey"
 826.1 "GB-Great Britain"
 826.2 "NIRL-Northern Ireland"
 840 "US-United States"
 858 "UY-Uruguay"
 862 "VE-Venezuela"
.
VARIABLE LABEL v5 "Country (see V4 for codes for the sample)".
COMMENT TO v5: To be coded using the three digit ISO-Code for the country at hand.
.
VALUE LABELS v5
 036 "AU-Australia"
 040 "AT-Austria"
 056 "BE-Belgium"
 076 "BR-Brazil"
 100 "BG-Bulgaria"
 124 "CA-Canada"
 152 "CL-Chile"
 158 "TW-Taiwan"
 191 "HR-Croatia"
 196 "CY-Cyprus"
 203 "CZ-Czech Republic"
 208 "DK-Denmark"
 214 "DO-Dominican Republic"
 246 "FI-Finland"
 250 "FR-France"
 276 "DE-Germany"
 348 "HU-Hungary"
 372 "IE-Ireland"
 376 "IL-Israel"
 392 "JP-Japan"
 410 "KR-South Korea"
 428 "LV-Latvia"
 484 "MX-Mexico"
 528 "NL-Netherlands"
 554 "NZ-New Zealand"
 578 "NO-Norway"
 608 "PH-Philippines"
 616 "PL-Poland"
 620 "PT-Portugal"
 643 "RU-Russia"
 703 "SK-Slovak Republic"
 705 "SI-Slovenia"
 710 "ZA-South Africa"
 724 "ES-Spain"
 752 "SE-Sweden"
 756 "CH-Switzerland"
 792 "TR-Turkey"
 826 "GB-Great Britain"
 840 "US-United States"
 858 "UY-Uruguay"
 862 "VE-Venezuela"
.
VARIABLE LABEL v6 "Q1a Frequency of activities in free time: Watch TV".
COMMENT TO v6: The following questions are related to your free time, that is, time you are not occupied with work or household duties or other activities that you are obliged to do
Q.1 How often do you do each of the following activities in your free time?
(Please tick one box on each line) 
Q.1a Watch TV, DVD, videos
.
VALUE LABELS v6
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v7 "Q1b Frequency of free time activities: Go to movies".
COMMENT TO v7: Q1 How often do you do each of the following activities in your free time? 
Q1b Go to the movies
.
VALUE LABELS v7
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v8 "Q1c Frequency of free time activities: Go out shopping".
COMMENT TO v8: Q1 How often do you do each of the following activities in your free time?
Q1c Go out shopping <TN: for pleasure>
.
VALUE LABELS v8
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v9 "Q1d Frequency of free time activities: Read books".
COMMENT TO v9: Q1 How often do you do each of the following activities in your free time? 
Q1d Read books
.
VALUE LABELS v9
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v10 "Q1e Frequency of free time activities: Attend cultural events".
COMMENT TO v10: Q1 How often do you do each of the following activities in your free time?
Q1e Attend cultural events such as concerts, live theatre, exhibitions
.
VALUE LABELS v10
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v11 "Q1f Frequency of free time activities: Get together with relatives".
COMMENT TO v11: Q1 How often do you do each of the following activities in your free time?
Q1f Get together with relatives <TN: who do not live in your household>
.
VALUE LABELS v11
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v12 "Q1g Frequency of free time activities: Get together with friends".
COMMENT TO v12: Q1 How often do you do each of the following activities in your free time? 
Q1g Get together with friends
.
VALUE LABELS v12
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v13 "Q1h Frequency of free time activities: Play cards".
COMMENT TO v13: Q1 How often do you do each of the following activities in your free time? 
Q1h Play cards or board games
.
VALUE LABELS v13
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v14 "Q1i Frequency of free time activities: Listen to music".
COMMENT TO v14: Q1 How often do you do each of the following activities in your free time?
Q1i Listen to music
.
VALUE LABELS v14
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v15 "Q1j Frequency of free time activities: Sports, Gym".
COMMENT TO v15: Q1 How often do you do each of the following activities in your free time?
Q1j Take part in physical activities such as sports, going to the gym, going for a walk
.
VALUE LABELS v15
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v16 "Q1k Frequency of free time activities: Attend sporting events".
COMMENT TO v16: Q1 How often do you do each of the following activities in your free time?
Q1k Attend sporting events as a spectator
.
VALUE LABELS v16
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v17 "Q1l Frequency of free time activities: Do handicrafts".
COMMENT TO v17: Q1 How often do you do each of the following activities in your free time?
Q1l Do handicraft such as needle work, wood work, etc.
.
VALUE LABELS v17
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v18 "Q1m Frequency of free time activities: Spend time on the Internet".
COMMENT TO v18: Q1 How often do you do each of the following activities in your free time?
Q1m Spend time on the Internet/ PC
.
VALUE LABELS v18
 1 "Daily"
 2 "Several times a week"
 3 "Several times a month"
 4 "Several times a year or less often"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v19 "Q2a Free time activities enable you to be yourself".
COMMENT TO v19: Q2 When you are involved in free time activities to what extent do they enable you:
(Please tick one box one each line) 
Q2a ... to be the kind of person you really are?
.
COMMENT TO 3: Code 3 Somewhat <TN: somewhat: to some extent>
.
VALUE LABELS v19
 1 "Very much"
 2 "A lot"
 3 "Somewhat"
 4 "A little"
 5 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v20 "Q2b Free time activities strengthen your relationships".
COMMENT TO v20: Q2b ... to strengthen your relationships with other people?
.
COMMENT TO 3: Code 3 Somewhat <TN: somewhat: to some extent>
.
VALUE LABELS v20
 1 "Very much"
 2 "A lot"
 3 "Somewhat"
 4 "A little"
 5 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v21 "Q3a Enjoyment from free time activities: Reading books".
COMMENT TO v21: Q3 Please, indicate how much enjoyment you get from the following free time activities: 
(Please tick one box on each line)
Q3a Reading books
.
VALUE LABELS v21
 1 "No enjoyment"
 2 "Not much enjoyment"
 3 "Some enjoyment"
 4 "A fair amount of enjoyment"
 5 "A great amount of enjoyment"
 6 "I never do that"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v22 "Q3b Enjoyment from: Getting together with friends".
COMMENT TO v22: Q3 Please, indicate how much enjoyment you get from the following free time activities: 
Q3b Getting together with friends
.
VALUE LABELS v22
 1 "No enjoyment"
 2 "Not much enjoyment"
 3 "Some enjoyment"
 4 "A fair amount of enjoyment"
 5 "A great amount of enjoyment"
 6 "I never do that"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v23 "Q3c Enjoyment from: Taking part in physical activities".
COMMENT TO v23: Q3 Please, indicate how much enjoyment you get from the following free time activities: 
Q3c Taking part in physical activities such as sports, going to the gym, going for a walk
.
VALUE LABELS v23
 1 "No enjoyment"
 2 "Not much enjoyment"
 3 "Some enjoyment"
 4 "A fair amount of enjoyment"
 5 "A great amount of enjoyment"
 6 "I never do that"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v24 "Q3d Enjoyment from: Watching TV, videos".
COMMENT TO v24: Q3 Please, indicate how much enjoyment you get from the following free time activities:
Q3d Watching TV, DVD, videos
.
VALUE LABELS v24
 1 "No enjoyment"
 2 "Not much enjoyment"
 3 "Some enjoyment"
 4 "A fair amount of enjoyment"
 5 "A great amount of enjoyment"
 6 "I never do that"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v25 "Q4a How often in free time: Establish useful contacts".
COMMENT TO v25: Q4 People do different things during their free time. For each of the following, please indicate how often you use your free time to:
(Please tick one box on each line) 
Q4a ... establish useful contacts
.
VALUE LABELS v25
 1 "Very often"
 2 "Often"
 3 "Sometimes"
 4 "Seldom"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v26 "Q4b How often in free time: Relax and recover".
COMMENT TO v26: Q4 People do different things during their free time. For each of the following, please indicate how often you use your free time to:
Q4b ... relax and recover
.
VALUE LABELS v26
 1 "Very often"
 2 "Often"
 3 "Sometimes"
 4 "Seldom"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v27 "Q4c How often in free time: Learn or develop skills".
COMMENT TO v27: Q4 People do different things during their free time. For each of the following, please indicate how often you use your free time to:
Q4c .... try to learn or develop skills
.
VALUE LABELS v27
 1 "Very often"
 2 "Often"
 3 "Sometimes"
 4 "Seldom"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v28 "Q5aa How often in free time: Feel bored".
COMMENT TO v28: Q5a In your free time, how often do you:
(Please tick one box on each line) 
Q5aa .... feel bored?
.
VALUE LABELS v28
 1 "Very often"
 2 "Often"
 3 "Sometimes"
 4 "Seldom"
 5 "Never"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v29 "Q5ab How often in free time: Feel rushed".
COMMENT TO v29: Q5a In your free time, how often do you:
Q5ab ... feel rushed?
.
VALUE LABELS v29
 1 "Very often"
 2 "Often"
 3 "Sometimes"
 4 "Seldom"
 5 "Never"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v30 "Q5ac How often in free time: Thinking about work".
COMMENT TO v30: Q5a In your free time, how often do you:
Q5ac ... find yourself  thinking about work?
.
VALUE LABELS v30
 1 "Very often"
 2 "Often"
 3 "Sometimes"
 4 "Seldom"
 5 "Never"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v31 "Q5b Preference in free time: With other people or by oneself".
COMMENT TO v31: Q5b In your free time, do you prefer to be with other people or do you prefer to be by yourself? 
(Please tick one box only)
.
VALUE LABELS v31
 1 "Most of time with other people"
 2 "More with other people than alone"
 3 "More alone than with other people"
 4 "Most of time alone"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v32 "Q6a Change in spending time: Time in a paid job".
COMMENT TO v32: Q6 Suppose you could change the way you spend your time, spending more time on some things and less time on others. Which of the things on the following list would you like to spend more time on, which would you like to spend less time on and which would you like to spend the same amount of time on as now? 
(Please tick one box on each line) 
Q6a Time in a paid job
.
VALUE LABELS v32
 1 "Much more time"
 2 "A bit more time"
 3 "Same time as now"
 4 "A bit less time"
 5 "Much less time"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v33 "Q6b Change in spending time: Doing household work".
COMMENT TO v33: Q6 Suppose you could change the way you spend your time, spending more time on some things and less time on others. Which of the things on the following list would you like to spend more time on, which would you like to spend less time on and which would you like to spend the same amount of time on as now? 
Q6b Time doing household work
.
VALUE LABELS v33
 1 "Much more time"
 2 "A bit more time"
 3 "Same time as now"
 4 "A bit less time"
 5 "Much less time"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v34 "Q6c Change in spending time: Time with your family".
COMMENT TO v34: Q6 Suppose you could change the way you spend your time, spending more time on some things and less time on others. Which of the things on the following list would you like to spend more time on, which would you like to spend less time on and which would you like to spend the same amount of time on as now? 
Q6b Time with your family
.
VALUE LABELS v34
 1 "Much more time"
 2 "A bit more time"
 3 "Same time as now"
 4 "A bit less time"
 5 "Much less time"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v35 "Q6d Change in spending time: Time in leisure activities".
COMMENT TO v35: Q6 Suppose you could change the way you spend your time, spending more time on some things and less time on others. Which of the things on the following list would you like to spend more time on, which would you like to spend less time on and which would you like to spend the same amount of time on as now?
Q6d Time in leisure activities
.
VALUE LABELS v35
 1 "Much more time"
 2 "A bit more time"
 3 "Same time as now"
 4 "A bit less time"
 5 "Much less time"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v36 "Q7a How many nights away from home for holidays".
COMMENT TO v36: Q7a In the last 12 months, how many nights altogether did you stay away from home for holidays or social visits?  
(Please tick one box only) 
<TN: holidays: vacation>
.
VALUE LABELS v36
 0 "I was not away"
 1 "1-5 nights"
 2 "6-10 nights"
 3 "11-20 nights"
 4 "21-30 nights"
 5 "More than 30 nights"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v37 "Q7b How many days of leave from work".
COMMENT TO v37: Q7b In the last 12 months, how many days of leave from your work, if any, did you take altogether (do not include maternity or sick leaves or similar types of leave)?
(Please tick one box only)
.
VALUE LABELS v37
 0 "None"
 1 "1-5 days"
 2 "6-10 days"
 3 "11-20 days"
 4 "21-30 days"
 5 "More than 30 days"
 6 "I do not work"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v38 "Q8a Most frequent sport or physical activity".
COMMENT TO v38: Q8a What sport or physical activity do you take part in most frequently?
(If you do not take part in any sport or physical activity, please tick the box provided below)
<Open-ended>
(Most frequent sport or physical activity  ... Please write in)
<"Code" to be used when directly coded in face-to-face interviews>  
<coding list at the end of questionnaire>
Coding list for Sports (Questions 8a, 10a and 10b)
Coding instructions: 
The following list is based on ISSP countries' most prominent sport activities. The questions on sport activities are asked open-ended. Thus, respondents' answers or entries have to be coded either by interviewer, coder or other persons from ISSP countries' staff according to that scheme into numeric values (three digits). Please note that country-specific codes or codes not included in the following list cannot be accepted for the international and integrated ISSP file
Sport activities are organized into four main groups (100=Team sports, 200=Racket sports, 300=Athletics and fitness sports, and 400=other sports) The main groups offer detailed categories. Team sports, eg starts with American football (101) and ends with volleyball (112). If possible, then these detailed categories should be coded prior to the general ones of the main groups. Main groups should only be coded if respondents answer or enter a general main group, e.g. racket sports. If there are any activities which are not explicitly listed, then, please, code into one of the 'other' categories: 199='other team sport', 299='other racket or bat sport', 399='other fitness sport' or 499='other sport'
Please only use 499='other sport' if more precise classification is not possible.
.
VALUE LABELS v38
 100 "Team sports"
 101 "American football"
 102 "Baseball, softball"
 103 "Basketball"
 104 "Cricket"
 105 "Ice hockey"
 106 "Field hockey"
 107 "Football, soccer"
 108 "Handball"
 109 "Netball"
 110 "Polo, water polo"
 111 "Rugby"
 112 "Volleyball"
 199 "Other team sports"
 200 "Racket sports"
 201 "Badminton"
 202 "Squash"
 203 "Table tennis"
 204 "Tennis"
 299 "Other racket or bat sports"
 300 "Athletics and fitness sports"
 301 "Athletics (e.g. running, long-/high-jumping), marathon"
 302 "Body training (eg body-building, artist.gymnastics)"
 303 "Fitness (aerobics, exercise machine-training, work-out)"
 304 "Jogging"
 305 "Walking, Nordic-w, trekking, climbing)"
 399 "Other fitness sports"
 400 "Other sports"
 401 "Adrenaline sports (e.g. bungee-jumping, paragliding)"
 402 "Billiards, pool, snooker"
 403 "Biathlon, triathlon"
 404 "Bowling, curling, bocce"
 405 "Boat sports (e.g. sailing, rowing, yachting)"
 406 "Bullfight"
 407 "Cockfighting"
 408 "Cycling, mountain-biking"
 409 "Dancing (e.g. ballroom dancing, ballet)"
 410 "Darts"
 411 "Fencing"
 412 "Fishing, hunting"
 413 "Golf, minigolf"
 414 "Horse riding, horse racing"
 415 "Ice skating"
 416 "Inline skating, skateboarding, roller skating"
 417 "Martial arts (e.g. Boxing, wrestling, Judo)"
 418 "Motor sports (motor racing, go carting)"
 419 "Rodeo"
 420 "Shooting (pistols, rifle, archery)"
 421 "Swimming, diving, snorkeling"
 422 "Surfing, water-skiing"
 423 "Snow-sports (skiing, snowboarding, cross-country)"
 499 "Other sports"
 999 "NA"
.
VARIABLE LABEL v39 "Q8b Type of games played most frequently".
COMMENT TO v39: Q8b Thinking about games rather than sports or physical activities, what type of game do you play most frequently? 
(Select the most appropriate game from the list below and tick the corresponding box)
(If you do not play any game, please tick the box at the very bottom of the list)
(Please tick one box only) 
 <TN: Give two or three country specific examples in parenthesis for the generic categories  "Other board games", "Card games", "Word or number games" and "Gambling games">
.
VALUE LABELS v39
 1 "Backgammon"
 2 "Checkers (brit. draughts)"
 3 "Chess"
 4 "Go"
 5 "Other board games"
 6 "Card games"
 7 "Dominoes"
 8 "Mah-jongg"
 9 "Jigsaw puzzles"
 10 "Word or number games"
 11 "Video games, computer games"
 12 "Gambling games"
 13 "Country specific games"
 14 "Other games"
 96 "I do not play any game"
 99 "NA"
.
VARIABLE LABEL v40 "Q9a Reasons for sport or games: Physical or mental health".
COMMENT TO v40: Q9 Please indicate how important the following reasons are for you to take part in sports or games
(Please tick one box on each line)  
Q9a For physical or mental health
.
VALUE LABELS v40
 1 "Very important"
 2 "Somewhat important"
 3 "Not very important"
 4 "Not important"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v41 "Q9b Reasons for sport or games: To meet other people".
COMMENT TO v41: Q9 Please indicate how important the following reasons are for you to take part in sports or games
(Please tick one box on each line)  
Q9b To meet other people
.
VALUE LABELS v41
 1 "Very important"
 2 "Somewhat important"
 3 "Not very important"
 4 "Not important"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v42 "Q9c Reasons for sport or games: To compete against others".
COMMENT TO v42: Q9 Please indicate how important the following reasons are for you to take part in sports or games
(Please tick one box  on each line)  
Q9c To compete against others
.
VALUE LABELS v42
 1 "Very important"
 2 "Somewhat important"
 3 "Not very important"
 4 "Not important"
 8 "Can't choose"
 9 "NA"
 0 "Doesn't apply"
.
VARIABLE LABEL v43 "Q9d Reasons for sport or games: To look good".
COMMENT TO v43: Q9 Please indicate how important the following reasons are for you to take part in sports or games
(Please tick one box on each line)  
Q9d To look good
.
VALUE LABELS v43
 1 "Very important"
 2 "Somewhat important"
 3 "Not very important"
 4 "Not important"
 8 "Can't choose"
 0 "Doesn't apply"
.
VARIABLE LABEL v44 "Q10a Most frequent sport watched on TV".
COMMENT TO v44: Q10a What sport do you watch on TV most frequently?
(If you do not watch any sport on TV, please tick the box provided below and skip to question 11)
<Open-ended> 
Most frequent sport watched ... (Please write in)
(Code ....) 
I do not watch any sport on TV   ..  > go to Question 11
<"Code" to be used when directly coded in face-to-face interviews)
<Coding list at the end of the questionnaire> 
Coding instructions are reported with v38
.
VALUE LABELS v44
 100 "Team sports"
 101 "American football"
 102 "Baseball, softball"
 103 "Basketball"
 104 "Cricket"
 105 "Ice hockey"
 106 "Field hockey"
 107 "Football, soccer"
 108 "Handball"
 109 "Netball"
 110 "Polo, water polo"
 111 "Rugby"
 112 "Volleyball"
 199 "Other team sports"
 200 "Racket sports"
 201 "Badminton"
 202 "Squash"
 203 "Table tennis"
 204 "Tennis"
 299 "Other racket or bat sports"
 300 "Athletics and fitness sports"
 301 "Athletics (eg running, long-/high-jumping), marathon"
 302 "Body training (eg body-building, artist.gymnastics)"
 303 "Fitness (aerobics, exercise machine-training, work-out)"
 304 "Jogging"
 305 "Walking, Nordic-w, trekking, climbing)"
 399 "Other fitness sports"
 400 "Other sports"
 401 "Adrenaline sports (e.g. bungee-jumping, paragliding)"
 402 "Billiards, pool, snooker"
 403 "Biathlon, triathlon"
 404 "Bowling, curling, bocce"
 405 "Boat sports (e.g. sailing, rowing, yachting)"
 406 "Bullfight"
 407 "Cockfighting"
 408 "Cycling, mountain-biking"
 409 "Dancing (e.g. ballroom dancing, ballet)"
 410 "Darts"
 411 "Fencing"
 412 "Fishing, hunting"
 413 "Golf, minigolf"
 414 "Horse riding, horse racing"
 415 "Ice skating"
 416 "Inline skating, skateboarding, roller skating"
 417 "Martial arts (e.g. Boxing, wrestling, Judo)"
 418 "Motor sports (motor racing, go carting)"
 419 "Rodeo"
 420 "Shooting (pistols, rifle, archery)"
 421 "Swimming, diving, snorkeling"
 422 "Surfing, water-skiing"
 423 "Snow-sports (skiing, snowboarding, cross-country)"
 499 "Other sports"
 999 "NA"
.
VARIABLE LABEL v45 "Q10b Second most frequent sport watched on TV".
COMMENT TO v45: Q10b What sport is the SECOND MOST FREQUENT that you watch on TV? 
<Open-ended> 
Second most frequent sport watched ... (Please write in)
(Code ....) 
I do not watch a second sport on TV  
<"Code" to be used when directly coded in face-to-face interviews)
<Coding list at the end of the questionnaire> 
Coding instructions are reported with v38
.
VALUE LABELS v45
 100 "Team sports"
 101 "American football"
 102 "Baseball, softball"
 103 "Basketball"
 104 "Cricket"
 105 "Ice hockey"
 106 "Field hockey"
 107 "Football, soccer"
 108 "Handball"
 109 "Netball"
 110 "Polo, water polo"
 111 "Rugby"
 112 "Volleyball"
 199 "Other team sports"
 200 "Racket sports"
 201 "Badminton"
 202 "Squash"
 203 "Table tennis"
 204 "Tennis"
 299 "Other racket or bat sports"
 300 "Athletics and fitness sports"
 301 "Athletics (eg running, long-/high-jumping), marathon"
 302 "Body training (eg body-building, artist.gymnastics)"
 303 "Fitness (aerobics, exercise machine-training, work-out)"
 304 "Jogging"
 305 "Walking, Nordic-w, trekking, climbing)"
 399 "Other fitness sports"
 400 "Other sports"
 401 "Adrenaline sports (e.g. bungee-jumping, paragliding)"
 402 "Billiards, pool, snooker"
 403 "Biathlon, triathlon"
 404 "Bowling, curling, bocce"
 405 "Boat sports (e.g. sailing, rowing, yachting)"
 406 "Bullfight"
 407 "Cockfighting"
 408 "Cycling, mountain-biking"
 409 "Dancing (e.g. ballroom dancing, ballet)"
 410 "Darts"
 411 "Fencing"
 412 "Fishing, hunting"
 413 "Golf, minigolf"
 414 "Horse riding, horse racing"
 415 "Ice skating"
 416 "Inline skating, skateboarding, roller skating"
 417 "Martial arts (e.g. Boxing, wrestling, Judo)"
 418 "Motor sports (motor racing, go carting)"
 419 "Rodeo"
 420 "Shooting (pistols, rifle, archery)"
 421 "Swimming, diving, snorkeling"
 422 "Surfing, water-skiing"
 423 "Snow-sports (skiing, snowboarding, cross-country)"
 499 "Other sports"
 500 "None"
 999 "NA"
.
VARIABLE LABEL v46 "Q11 How proud about an international sport competition?".
COMMENT TO v46: Q11 How proud are you when <R's Country> does well at an international sports or games competition?
(Please tick one box only)
.
VALUE LABELS v46
 1 "I am very proud"
 2 "I am somewhat proud"
 3 "I am not very proud"
 4 "I am not proud at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v47 "Q12a Opinion: Sport develops children's character".
COMMENT TO v47: Q12 People have different opinions about sports. To what extent do you agree or disagree with the following statements? 
(Please tick one box on each line) 
Q12a Taking part in sports develops children's character.
.
VALUE LABELS v47
 1 "Agree strongly"
 2 "Agree"
 3 "Neither agree nor disagree"
 4 "Disagree"
 5 "Disagree strongly"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v48 "Q12b Opinion: Too much sport on TV".
COMMENT TO v48: Q12 People have different opinions about sports. To what extent do you agree or disagree with the following statements? 
(Please tick one box on each line) 
Q12b There is too much sport on TV.
.
VALUE LABELS v48
 1 "Agree strongly"
 2 "Agree"
 3 "Neither agree nor disagree"
 4 "Disagree"
 5 "Disagree strongly"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v49 "Q12c Opinion: Sport brings different groups together".
COMMENT TO v49: Q12 People have different opinions about sports. To what extent do you agree or disagree with the following statements? 
(Please tick one box on each line) 
Q12c Sports bring different groups and races inside (R's Country) closer together.
.
VALUE LABELS v49
 1 "Agree strongly"
 2 "Agree"
 3 "Neither agree nor disagree"
 4 "Disagree"
 5 "Disagree strongly"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v50 "Q12d Opinion: Intern. sport competition create tension betw. countries".
COMMENT TO v50: Q12 People have different opinions about sports. To what extent do you agree or disagree with the following statements? 
(Please tick one box on each line) 
Q12d International sports competitions create more tension between countries than good feelings.
.
VALUE LABELS v50
 1 "Agree strongly"
 2 "Agree"
 3 "Neither agree nor disagree"
 4 "Disagree"
 5 "Disagree strongly"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v51 "Q12e Opinion: Government should spend more money on sports".
COMMENT TO v51: Q12 People have different opinions about sports. To what extent do you agree or disagree with the following statements? 
(Please tick one box on each line) 
Q12e (R's Country's) government should spend more money on sports.
.
VALUE LABELS v51
 1 "Agree strongly"
 2 "Agree"
 3 "Neither agree nor disagree"
 4 "Disagree"
 5 "Disagree strongly"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v52 "Q13a Participation: A sports association/group".
COMMENT TO v52: Now, some questions about your social involvement
Q13 In the last 12 months, how often have you participated in the activities of one of the following associations or groups? I have participated in:
(Please tick one box on each line) 
Q13a ... A sports association/group 
<TN: "Association/group": countries should choose between the wording "association" or "group" as considered best in their country>
.
VALUE LABELS v52
 1 "At least once a week"
 2 "At least once a month"
 3 "Several times"
 4 "Once or twice"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v53 "Q13b Participation: A cultural association/group".
COMMENT TO v53: Q13 In the last 12 months, how often have you participated in the activities of one of the following associations or groups? I have participated in:
Q13b  ... A cultural association/group 
<TN "Association/group": countries should choose between the wording "association" or "group" as considered best in their country>
.
VALUE LABELS v53
 1 "At least once a week"
 2 "At least once a month"
 3 "Several times"
 4 "Once or twice"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v54 "Q13c Participation: A church or religious organisation".
COMMENT TO v54: Q13 In the last 12 months, how often have you participated in the activities of one of the following associations or groups? I have participated in
Q13c ... A church or other religious organisation 
<TN "Association/group": countries should choose between the wording "association" or "group" as considered best in their country>
.
VALUE LABELS v54
 1 "At least once a week"
 2 "At least once a month"
 3 "Several times"
 4 "Once or twice"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v55 "Q13d Participation: A community-service or civic association/group".
COMMENT TO v55: Q13 In the last 12 months, how often have you participated in the activities of one of the following associations or groups? I have participated in
Q13d ... A community-service or civic association/group
<TN "Association/group": countries should choose between the wording "association" or "group" as considered best in their country>
.
VALUE LABELS v55
 1 "At least once a week"
 2 "At least once a month"
 3 "Several times"
 4 "Once or twice"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v56 "Q13e Participation: A political party or organisation".
COMMENT TO v56: Q13 In the last 12 months, how often have you participated in the activities of one of the following associations or groups? I have participated in
Q13e ...A political party or organisation
<TN "Association/group": countries should choose between the wording "association" or "group" as considered best in their country>
.
VALUE LABELS v56
 1 "At least once a week"
 2 "At least once a month"
 3 "Several times"
 4 "Once or twice"
 5 "Never"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v57 "Q14a Trust in people or careful in dealing with people".
COMMENT TO v57: Q14a Generally speaking, would you say that people can be trusted or that you can't be too careful in dealing with people?
(Please tick one box only)
.
VALUE LABELS v57
 1 "People can almost always be trusted"
 2 "People can usually be trusted"
 3 "You usually can't be too careful in dealing with people"
 4 "You almost always can't be too careful in dealing with people"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v58 "Q14b Personal interest in politics".
COMMENT TO v58: Q14b How interested would you say you personally are in politics? 
(Please tick one box only)
.
VALUE LABELS v58
 1 "Very interested"
 2 "Fairly interested"
 3 "Not very interested"
 4 "Not at all interested"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v59 "Q15a Obstacle: Lack of facilities nearby".
COMMENT TO v59: Now, some questions about your personal situation
Q15 To what extent do the following conditions prevent you from doing the free time activities you would like to do? 
(Please tick one box on each line) 
Q15a Lack of facilities nearby
.
VALUE LABELS v59
 1 "Very much"
 2 "To a large extent"
 3 "To some extent"
 4 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v60 "Q15b Obstacle:  Lack of money".
COMMENT TO v60: Q15 To what extent do the following conditions prevent you from doing the free time activities you would like to do? 
Q15b Lack of money
.
VALUE LABELS v60
 1 "Very much"
 2 "To a large extent"
 3 "To some extent"
 4 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v61 "Q15c Obstacle: Personal health, age or disability".
COMMENT TO v61: Q15 To what extent do the following conditions prevent you from doing the free time activities you would like to do? 
Q15c Personal health, age or disability
.
VALUE LABELS v61
 1 "Very much"
 2 "To a large extent"
 3 "To some extent"
 4 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v62 "Q15d Obstacle: Taking care of someone".
COMMENT TO v62: Q15 To what extent do the following conditions prevent you from doing the free time activities you would like to do? 
Q15d Need to take care of someone (elderly, children,...)
.
VALUE LABELS v62
 1 "Very much"
 2 "To a large extent"
 3 "To some extent"
 4 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v63 "Q15e Obstacle: Lack of time".
COMMENT TO v63: Q15 To what extent do the following conditions prevent you from doing the free time activities you would like to do? 
Q15e Lack of time
.
VALUE LABELS v63
 1 "Very much"
 2 "To a large extent"
 3 "To some extent"
 4 "Not at all"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v64 "Q16 How happy or unhappy in general, these days".
COMMENT TO v64: Q16 If you were to consider your life in general these days, how happy or unhappy would you say you are, on the whole?
(Please tick one box only)
.
VALUE LABELS v64
 1 "Very happy"
 2 "Fairly happy"
 3 "Not very happy"
 4 "Not at all happy"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL v65 "Q17 Status of health in general".
COMMENT TO v65: Q17 In general, would you say your health is:
(Please tick one box only)
.
VALUE LABELS v65
 1 "Excellent"
 2 "Very good"
 3 "Good"
 4 "Fair"
 5 "Poor"
 8 "Can't choose"
 9 "NA"
.
VARIABLE LABEL sex "R: Sex".
VALUE LABELS sex
 1 "Male"
 2 "Female"
 9 "NA, refused"
.
VARIABLE LABEL age "R: Age".
VALUE LABELS age
 99 "NA, refused"
.
VARIABLE LABEL marital "R: Marital status".
COMMENT TO marital: The aim of this variable is to measure the ‘legal’ status. Cohabitation outside a formal marriage should be coded separately in variable COHAB.
.
VALUE LABELS marital
 1 "Married"
 2 "Widowed"
 3 "Divorced"
 4 "Separated (married but sep./not living w legal spouse)"
 5 "Never married"
 9 "NA, refused"
.
VARIABLE LABEL cohab "R: Steady life-partner".
COMMENT TO cohab: Use this variable to code relationships outside a formal marriage, i.e. when the R is NOT married or NOT living together with the legal spouse.
.
VALUE LABELS cohab
 0 "NAP (married and living w legal spouse, Code 1 in MARITAL)"
 1 "Yes"
 2 "No"
 9 "NA,refused"
.
VARIABLE LABEL educyrs "R: Education I: years of schooling".
VALUE LABELS educyrs
 0 "NAV"
 95 "Still at school"
 96 "Still at college,university"
 97 "No formal schooling"
 98 "Dont know"
 99 "NA, refused"
.
VARIABLE LABEL degree "R: Education II-highest education level".
VALUE LABELS degree
 0 "No formal qualification"
 1 "Lowest formal qualification"
 2 "Above lowest qualification"
 3 "Higher secondary completed"
 4 "Above higher secondary level"
 5 "University degree completed"
 9 "NA"
.
VARIABLE LABEL dk_degr "Country specific education: Denmark".
VALUE LABELS dk_degr
 0 "NAP, other countries"
 1 "7 yrs primary school or shorter"
 2 "8 yrs primary school"
 3 "9 yrs primary school"
 4 "Secondary, 10 yrs. or similar"
 5 "Gymnasium, general"
 6 "Gymnasium, technical"
 7 "Other school education"
 8 "Basic vocational+apprenticeship"
 9 "Other compl.vocational educ"
 10 "Short advanced education <3 yrs"
 11 "Middlerange advanced, 3-4 yrs"
 12 "Further advanced >4 yrs"
 13 "Other vocational education"
 97 "Refused"
 98 "DK"
 99 "NA"
.
VARIABLE LABEL wrkst "R: Current employment status".
VALUE LABELS wrkst
 0 "Not available"
 1 "Employed-full time"
 2 "Employed-part time"
 3 "Empl-< part-time"
 4 "Helpg family member"
 5 "Unemployed"
 6 "Studt,school,vocat.traing"
 7 "Retired"
 8 "Housewife,-man,home duties"
 9 "Permanently disabled"
 10 "Other,not in labour force"
 98 "Dont know"
 99 "NA"
.
VARIABLE LABEL wrkhrs "R: Hours worked weekly".
VALUE LABELS wrkhrs
 0 "NAV;NAP"
 96 "96 and more"
 97 "Refused"
 98 "DK,cant say,varies too much"
 99 "NA"
.
VARIABLE LABEL isco88 "R: Occupation ILO,ISCO 1988 4-digit".
VALUE LABELS isco88
 0 "NAP,NAV"
 1 "D:Soldiers"
 2 "D:Officers"
 100 "Armed forces"
 110 "Armed forces"
 111 "N:Soldiers"
 112 "N:Officers"
 1000 "Legislators,senior off.+managers"
 1100 "Legislators and senior officials"
 1110 "Legislators"
 1120 "Senior government official"
 1130 "Traditional chiefs+heads of villages"
 1140 "Sen.officials of interest organisation"
 1141 "Sen.officials of pol.party"
 1142 "Sen.officials of empl+workers org"
 1143 "Sen.off.of human+other interest org"
 1200 "Corporate managers"
 1210 "Directors and chief executives"
 1220 "Production+operations dep.manager"
 1221 "Prod.+oper.managers in agriculture"
 1222 "Prod.+oper.managers:manufacturing"
 1223 "Prod.+oper.managers:construction"
 1224 "Prod.+oper.managers:retail trade"
 1225 "Prod.+oper.managers:hotels rest."
 1226 "Prod.+oper.managers:transport,comm"
 1227 "Prod.+oper.managers:business serv."
 1228 "Prod.+oper.managers:cleaning"
 1229 "Prod.+oper.dep. managers nec"
 1230 "Other department managers"
 1231 "Finance+administration dep.managers"
 1232 "Personnel+industrial rel.dep.managers"
 1233 "Sales+marketing dep.managers"
 1234 "Advertising+pub.relations dep.managers"
 1235 "Supply+distribution dep.managers"
 1236 "Computing services dep.managers"
 1237 "Research+development dep.managers"
 1238 "Other department managers nec"
 1239 "Other department managers"
 1240 "USA:Misc.office supervisors"
 1250 "PL:Military officer"
 1251 "H,PL:High-grade military officer"
 1252 "H,PL:Low-grade commissioned officer"
 1300 "General managers"
 1310 "General managers"
 1311 "General managers in agriculture"
 1312 "General managers in manufacture"
 1313 "General managers in construction"
 1314 "Gen.managers in wholesale+retail trade"
 1315 "Gen.managers of rest.+hotels"
 1316 "Gen.managers in transport+comm."
 1317 "General managers of business services"
 1318 "Gen.managers in personal care,cleaning"
 1319 "General managers nec"
 1320 "N:Managers in non-specific trade areas"
 2000 "Professionals"
 2100 "Physical,math.+engineering science"
 2110 "Physicists,chemists+rel.professionals"
 2111 "Physicists, and astronomers"
 2112 "Meteorologists"
 2113 "Chemists"
 2114 "Geologists and geophysicists"
 2120 "Mathematicians, statisticians+rel.prof"
 2121 "Mathematiciians and related prof"
 2122 "Statisticians"
 2130 "Computing professionals"
 2131 "Computing systems designers+analysts"
 2132 "Computer programmers"
 2139 "Computing professionals n.e.c."
 2140 "Architects,engineers+rel.profess"
 2141 "Architects, town+traffic planners"
 2142 "Civil engineers"
 2143 "Electrical engineers"
 2144 "Electronics+telecomm.engineers"
 2145 "Mechanical engineers"
 2146 "Chemical engineers"
 2147 "Mining engineers,metallurgists+rel"
 2148 "Cartographers and surveyors"
 2149 "Architects,engineers+rel.prof"
 2199 "Other natural scientist"
 2200 "Life science+health professionals"
 2210 "Life science professionals"
 2211 "Biologist,botanist,zoologist+rel"
 2212 "Pharmacologists, pathologists"
 2213 "Agronomists+related professionals"
 2220 "Health professionals"
 2221 "Medical doctors"
 2222 "Dentists"
 2223 "Veterinarians"
 2224 "Pharmacists"
 2229 "Health professionals n.e.c."
 2230 "Nursing+midwifery professionals"
 2300 "Teaching professionals"
 2310 "College,uni+higher educ.teacher"
 2320 "Secondary education teacher"
 2321 "H:Secondary (high)-school teacher"
 2322 "H:Teacher in vocational training"
 2330 "Primary+pre-primary educ.teacher"
 2331 "Primary educ.teaching prof"
 2332 "Pre-primary educ.teaching prof"
 2340 "Special educ.teaching profess"
 2350 "Other teaching profess,nec"
 2351 "Education methods specialists"
 2352 "School inspectors"
 2359 "Extra-systemic. teacher"
 2400 "Other professionals"
 2410 "Business professionals"
 2411 "Accountants"
 2412 "Personnel+careers professionals"
 2419 "Business professionals n.e.c"
 2420 "Legal professionals"
 2421 "Lawyers"
 2422 "Judges"
 2429 "Legal professionals nec"
 2430 "Archivists,librarians+rel.info.prof"
 2431 "Archivists and curators"
 2432 "Librarians+rel.information prof."
 2440 "Social science+rel. prof."
 2441 "Economists"
 2442 "Sociologists,anthropologists+rel"
 2443 "Philosophers,historians+pol.scientist"
 2444 "Philologists,translators+interpreter"
 2445 "Psychologists"
 2446 "Social work professionals"
 2450 "Writers and creative artists"
 2451 "Authors,journalists+other writers"
 2452 "Sculptors, painters+rel.artists"
 2453 "Composers, musicians+singers"
 2454 "Choreographers and dancers"
 2455 "Film, stage+rel.actors+directors"
 2460 "Religious professionals"
 2470 "Public service administrative prof"
 2500 "Education prof. n.e.c."
 2510 "N:Soc.scientific,juridical+techn.planng"
 2511 "N:Economical+soc.scientific planng"
 2512 "N:Juridical planning"
 2513 "N:Technical+scientific planng"
 2519 "N:Others within this group"
 3000 "Technicians and related prof."
 3100 "Physical+engineering science techn."
 3110 "Physical+engineering science techn."
 3111 "Chemical+physical science techn."
 3112 "Civil engineering technicians"
 3113 "Electrical engineering technicians"
 3114 "Electronics+telecommunication techn"
 3115 "Mechanical engineering technicians"
 3116 "Chemical engineering technicians"
 3117 "Mining and metallurgical techn."
 3118 "Draughtspersons"
 3119 "Physical+engin.science techn.nec"
 3120 "Computer associate professionals"
 3121 "Computer assistants"
 3122 "Computer equipment operators"
 3123 "Industrial robot controllers"
 3130 "Optical+electronic equipement oper"
 3131 "Photographers+image+sound oper"
 3132 "Broadcasting+telecommunications oper"
 3133 "Medical equipment operators"
 3139 "Optical+electronic operators nec"
 3140 "Ship,aircraft controllers+techn."
 3141 "Ships engineers"
 3142 "Ships deck officers and pilots"
 3143 "Aircraft pilots+rel. professionals"
 3144 "Air traffic pilots"
 3145 "Air traffic safety technicians"
 3150 "Safety and quality inspectors"
 3151 "Building and fire inspectors"
 3152 "Safety, health+quality inspectors"
 3200 "Life science+health ass.profess"
 3210 "Life science technicians+rel.prof"
 3211 "Life science technicians"
 3212 "Agronomy and forestry technicians"
 3213 "Farming and forestry advisers"
 3220 "Modern health ass.professionals"
 3221 "Medical assistants"
 3222 "Sanitarians"
 3223 "Dieticians and nutritionists"
 3224 "Optometrists and opticians"
 3225 "Dental assistants"
 3226 "Physiotherapists+rel.ass.profess"
 3227 "Veterinary assistants"
 3228 "Pharmaceutical assistants"
 3229 "Modern health ass.profess.nec"
 3230 "Nursing+midwifery ass.professionals"
 3231 "Nursing associate professionals"
 3232 "Midwifery associate professionals"
 3240 "Trad.medicine practitioner+faith healer"
 3241 "Traditional medicine practitioners"
 3242 "Faith healers"
 3300 "Teaching associate professionals"
 3310 "Primary educ.teachg  ass.prof."
 3320 "Pre-primary educ. teachg ass. prof."
 3330 "Spec.educ. teaching ass. prof."
 3340 "Other teaching associate profess"
 3341 "N:Teachers in technical college"
 3342 "N:Other educational occ"
 3400 "Other associate professionals"
 3410 "Finance+sales associate professionals"
 3411 "Securities+finance dealers and brokers"
 3412 "Insurance representatives"
 3413 "Estate agents"
 3414 "Travel consultants and organisers"
 3415 "Technical+commercial sales represent"
 3416 "Buyers"
 3417 "Appraisers,valuers+auctioneers"
 3418 "N:Customer consultant in a bank"
 3419 "Finance+sales ass.professionals nec"
 3420 "Business services agents+trade broker"
 3421 "Trade brokers"
 3422 "Clearing and forwarding agents"
 3423 "Employment agents+labour contractors"
 3429 "Other business services agents nec"
 3430 "Administrative ass.professionals"
 3431 "Administrative secretaries+rel.prof"
 3432 "Legal+rel.business ass. profess"
 3433 "Bookkeepers"
 3434 "Statistical,mathematical+rel.prof"
 3439 "Administrative ass.profess. nec"
 3440 "Customs,tax+rel.government prof"
 3441 "Customs and border inspectors"
 3442 "Government tax and excise officials"
 3443 "Government social benefits officials"
 3444 "Government licensing officials"
 3445 "N:Public employment service worker"
 3449 "Customs,tax+rel. government prof nec"
 3450 "Police inspectors and detectives"
 3452 "H,PL:Armed forces non-commiss. officer"
 3460 "Social work associate professionals"
 3470 "Artistic,entertainment+sports prof"
 3471 "Decorators and commercial designers"
 3472 "Radio,television+other announcers"
 3473 "Musicians,singers,dancers"
 3474 "Clowns,magicians,acrobates+rel.prof"
 3475 "Athletes,sportspersons+rel.prof"
 3480 "Religious associate professionals"
 3491 "N:Informationworker+journalist"
 3492 "N:Librarians"
 4000 "Office worker,clerks"
 4100 "Office clerks"
 4110 "Secretaries+keyboard-operating clerks"
 4111 "Stenographers and typists"
 4112 "Word-processor and rel.operators"
 4113 "Data entry operators"
 4114 "Calculating machine operators"
 4115 "Secretaries"
 4116 "N:Clerical officer"
 4120 "Numerical clerks"
 4121 "Accounting and bookkeeping clerks"
 4122 "Statistical and finance clerks"
 4130 "Material-recording+transport clerks"
 4131 "Stock clerks"
 4132 "Production clerks"
 4133 "Transport clerks"
 4140 "Library, mail and related clerks"
 4141 "Library and filing clerks"
 4142 "Mail carriers and sorting clerks"
 4143 "Coding, proof-reading+rel.clerks"
 4144 "Scribes and related workers"
 4190 "Other office clerks"
 4200 "Customer services clerks"
 4210 "Cashiers, tellers and rel.clerks"
 4211 "Cashiers and ticket clerks"
 4212 "Tellers and other counter clerks"
 4213 "Bookmakers and croupiers"
 4214 "Pawnbrokers and money-lenders"
 4215 "Debt-collectors and related workers"
 4220 "Client information clerks"
 4221 "Travel agency and related clerks"
 4222 "Receptionists+information clerks"
 4223 "Telephone switchboard operators"
 4300 "Office helping workers"
 4400 "Post office,higher civil service"
 4500 "Railway official,higher civil service"
 5000 "Personal service, sale"
 5100 "Personal+protective services workers"
 5110 "Travel attendents+related workers"
 5111 "Travel attendents+travel stewards"
 5112 "Transport conductors"
 5113 "Travel guides"
 5120 "Housekeeping+rest. services workers"
 5121 "Housekeepers and related workers"
 5122 "Cooks"
 5123 "Waiters, waitresses and bartenders"
 5130 "Personal care and related workers"
 5131 "Child care workers"
 5132 "Institution-based personal care workers"
 5133 "Home-based personal care workers"
 5134 "N:Dental secretaries"
 5135 "N:Medical secretaries"
 5136 "N:Childminders etc"
 5139 "Personal care+related workers nec"
 5140 "Other personal services workers"
 5141 "Hairdressers,beauticians+rel.workers"
 5142 "Companions and valets"
 5143 "Undertakers and embalmers"
 5149 "Other personal services workers nec"
 5150 "Astrologers,fortune-tellers"
 5151 "Astrologers and related workers"
 5152 "Fortune-tellers+related workers"
 5160 "Protective services workers"
 5161 "Fire-fighters"
 5162 "Police officers"
 5163 "Prison guards"
 5164 "N:Caretakers, houseporters"
 5169 "Protective services workers nec"
 5200 "Models,salespersons+demonstrators"
 5210 "Fashion and other models"
 5220 "Shop salespersons and demonstrators"
 5221 "N:Shop staff, sales staff+other"
 5222 "N:Door-to-door+telephone salesmen"
 5223 "N:Wholesale merchants"
 5230 "Stall and market salespersons"
 6000 "Skilled agricultural+fishery worker"
 6100 "Market-orient.agric.skilled worker"
 6110 "Market gardeners and crop growers"
 6111 "Field crop and vegetable growers"
 6112 "Tree and shrub crop growers"
 6113 "Gardeners,hortic.+nursery growers"
 6114 "Mixed-crop growers"
 6120 "Market-oriented animal producers"
 6121 "Dairy and livestock producers"
 6122 "Poultry producers"
 6123 "Apiarists and sericulturists"
 6124 "Mixed animal producers"
 6129 "Market-oriented animal producers nec"
 6130 "Market-oriented crop animal producer"
 6132 "USA: Farmers"
 6133 "USA: Farm supervisors"
 6140 "Forestry and related worker"
 6141 "Forestry workers and logger"
 6142 "Charcoal burners and related worker"
 6150 "Fishery workers,hunters+trappers"
 6151 "Aquatic-life cultivation worker"
 6152 "Inland+coastal waters fishery worker"
 6153 "Deep-sea fishery worker"
 6154 "Hunters and trappers"
 6200 "Subsistence agricultural+fishery worker"
 6210 "Subsistence agricultural+fishery worker"
 7000 "Craft and trade workers"
 7100 "Extraction and building trades worker"
 7110 "Miners,shotfirers,stone cutters+carvers"
 7111 "Miners and quarry workers"
 7112 "Shotfirers and blasters"
 7113 "Stone splitters, cutters and carvers"
 7120 "Building frame+related trades workers"
 7121 "Builders, traditional materials"
 7122 "Bricklayers and stonemasons"
 7123 "Concrete placers,finishers+rel"
 7124 "Carpenters and joiners"
 7125 "N:Joiner, formwork"
 7126 "N:Carpenters"
 7127 "N:Foundation workers"
 7128 "N:Tunnel+mountain workers"
 7129 "Building frame+rel.trades workers nec"
 7130 "Building finishers+rel.trades workers"
 7131 "Roofers"
 7132 "Floor layers and tile setters"
 7133 "Plasterers"
 7134 "Insulation workers"
 7135 "Glaziers"
 7136 "Plumbers and pipe fitters"
 7137 "Building+rel.electricians"
 7139 "Building finishers+rel.trade workers"
 7140 "Painters,building cleaners+rel worker"
 7141 "Painters and related workers"
 7142 "Varnishers and related painters"
 7143 "Building structure cleaners"
 7144 "N:Chimney sweepers"
 7200 "Metal,machinery+rel.trades workers"
 7210 "Metal moulders,sheetmetal workers+rel"
 7211 "Metal moulders vand coremakers"
 7212 "Welders and flamecutters"
 7213 "Sheet-metal workers"
 7214 "Structural-metal preparers+erectors"
 7215 "Riggers and cable splicers"
 7216 "Underwater workers"
 7217 "N:Car+airstructure mechanics"
 7220 "Blacksmiths,tool-makers+rel.trade"
 7221 "Blacksmiths+forging-press worker"
 7222 "Tool-makers and related workers"
 7223 "Machine-tool setters+setter-operators"
 7224 "Metal wheel-grinders+tool sharpeners"
 7230 "Machinery mechanics and fitters"
 7231 "Motor vehicle mechanics and fitters"
 7232 "Aircraft engine mechanics and fitters"
 7233 "Agricultural-industrial mechanics"
 7234 "N:Shipmechanics etc"
 7240 "Electrical+electronic equipm.mechanic"
 7241 "Electrical mechanics and fitters"
 7242 "Electronics fitters"
 7243 "Electronics mechanics+servicers"
 7244 "Telegraph+telephone installers+service"
 7245 "Electrical line installers,repairers"
 7300 "Precision,handicraft,printing+other"
 7310 "Precision metal workers+rel.materials"
 7311 "Precision-instrument makers+repairers"
 7312 "Musical-instrument makers+tuners"
 7313 "Jewellery and precious-metal workers"
 7320 "Potters,glass-makers+rel.trades worker"
 7321 "Abrasive wheel formers,potters+rel."
 7322 "Glass-makers,cutters+finishers"
 7323 "Glass engravers and etchers"
 7324 "Glass,ceramics+rel.decorative painter"
 7330 "Handicraft in wood,textile a.s."
 7331 "Handicraft in wood+rel.materials"
 7332 "Handicraft in textile,leather+rel"
 7340 "Printing+related trades workers"
 7341 "Compositors,typesetters+rel.worker"
 7342 "Stereotypers,electrotypers"
 7343 "Printing engravers and etchers"
 7344 "Photographic+related workers"
 7345 "Bookbinders+related workers"
 7346 "Silk-screen,block+textile printers"
 7350 "N:Technical drawers"
 7400 "Other craft+rel.trades workers"
 7410 "Food processing+rel.trades workers"
 7411 "Butchers+rel.food preparers"
 7412 "Bakers+confectionary makers"
 7413 "Dairy-products makers"
 7414 "Fruit,vegetable+related preservers"
 7415 "Food+beverage tasters+graders"
 7416 "Tobacco preparers+tobacco prod.maker"
 7420 "Wood treaters+rel.trades"
 7421 "Wood treaters"
 7422 "Cabinet-makers+related workers"
 7423 "Woodworking-machine setters+operators"
 7424 "Basketry weavers+rel.worker"
 7430 "Textile,garment+rel.trades workers"
 7431 "Fibre preparers"
 7432 "Weavers,knitters+related workers"
 7433 "Tailors,dressmakers+hatters"
 7434 "Furriers and related workers"
 7435 "Textile,leather+rel.pattern-makers"
 7436 "Sewers, embroiderers+rel.workers"
 7437 "Upholsterers and related workers"
 7440 "Pelt,leather+shoemaking trades worker"
 7441 "Pelt dressers,tanners+fellmongers"
 7442 "Shoemakers+rel.workers"
 7450 "N:Laboratory assistants"
 7500 "Metal worker general"
 7510 "Metal worker nec"
 7520 "Electronics engineers nec"
 7900 "Master craftsmen,supervisor"
 8000 "Plant+machine operators"
 8100 "Stationary-plant+related operators"
 8110 "Mining+mineral-proc.-plant operator"
 8111 "Mining-plant operators"
 8112 "Mineral-ore+stone-proc.-plant oper"
 8113 "Well drillers+borers+related workers"
 8120 "Metal-processing-plant operators"
 8121 "Ore ad metal furnace operators"
 8122 "Metal melters,casters"
 8123 "Metal-heat-treating-plant operator"
 8124 "Metal drawers and extruders"
 8130 "Glass,ceramics+rel.plant operators"
 8131 "Glass,ceramics+rel.machine operator"
 8132 "N:Operators in insul.glass prod"
 8139 "Glass,ceramics+rel.plant operators nec"
 8140 "Wood-processing+papermaking-plant oper"
 8141 "Wood-processing-plant operators"
 8142 "Paper-pulp plant operators"
 8143 "Papermaking-plant operators"
 8150 "Chemical-processing-plant operators"
 8151 "Crushing-,grinding mach.operator"
 8152 "Chemical-heat-treating-plant oper"
 8153 "Chemical-filtering-equipment oper"
 8154 "Chemical-still+reactor operators"
 8155 "Petroleum+natural-gas-refing-plant oper"
 8159 "Chemical-processing-plant oper,nec"
 8160 "Power-production+rel.plant operators"
 8161 "Power-production plant operators"
 8162 "Steam-engine and boiler operators"
 8163 "Icinerator,water-treatment+rel.oper"
 8170 "Auto.-assembly-line+ind.-robot oper"
 8171 "Automated-assembly-line operators"
 8172 "Industrial-robot operators"
 8200 "Machine operators and assemblers"
 8210 "Metal+mineral-products machine oper"
 8211 "Machine-tool operators"
 8212 "Cement+o.mineral products machine oper"
 8220 "Chemical-products machine operators"
 8221 "Pharma.products machine operator"
 8222 "Ammunition products machine operator"
 8223 "Metal finishing+coating-machine oper"
 8224 "Photographic-products machine operator"
 8229 "Chemical-products machine oper.nec"
 8230 "Rubber+plastic-products machine oper"
 8231 "Rubber-products machine oper"
 8232 "Plastic-products machine operators"
 8240 "Wood-products machine operators"
 8250 "Printing+paper-products machine oper"
 8251 "Printing-machine operators"
 8252 "Bookbinding-machine operators"
 8253 "Paper-products machine operators"
 8260 "Textile+leather-products machine oper"
 8261 "Spinning+winding-machine operators"
 8262 "Weaving+knitting-machine operators"
 8263 "Sewing-machine operators"
 8264 "Bleaching+cleaning-machine operators"
 8265 "Fur+leather-preparing-machine operator"
 8266 "Shoemaking+related machine operator"
 8269 "Textile products machine operators nec"
 8270 "Food+rel.products machine operators"
 8271 "Meat+fish-processing-machine operator"
 8272 "Dairy-products machine operators"
 8273 "Grain+spice-milling-machine operator"
 8274 "Baked-goods+chocolate-products m-oper"
 8275 "Fruit+nut-processing-machine oper"
 8276 "Sugar production machine operators"
 8277 "Tea,coffee+cocoa-processing-m.oper"
 8278 "Beverage machine operators"
 8279 "Tobacco production machine operators"
 8280 "Assemblers"
 8281 "Mechanical-machinery assemblers"
 8282 "Electrical-equipment assemblers"
 8283 "Electronic-equipment assemblers"
 8284 "Metal+plastic-products assemblers"
 8285 "Wood+rel.products assemblers"
 8286 "Paperboard,textile+rel.prod.assembler"
 8287 "Composite products assemblers"
 8290 "Other machine operators+assemblers"
 8300 "Drivers and mobile-plant operators"
 8310 "Locomotive-engine drivers+rel.workers"
 8311 "Locomotive-engine drivers"
 8312 "Railway brakers,signallers+shunters"
 8320 "Motor-vehicle drivers"
 8321 "Motor-cycle drivers"
 8322 "Car, taxi and van drivers"
 8323 "Bus and tram drivers"
 8324 "Heavy truck and lorry drivers"
 8330 "Agricultural+other mobile-plant oper"
 8331 "Motorised farm+forestry plant oper."
 8332 "Earth-moving+rel.plant operators"
 8333 "Crane, hoist and related plant oper"
 8334 "Lifting-truck operators"
 8340 "Ships deck crews and rel.workers"
 8341 "N:Deck crew, ship"
 8342 "N:Engine crew, ship"
 9000 "Elementary occ.+unskilled workers"
 9100 "Sales+services elementary occupation"
 9110 "Street vendors and related workers"
 9111 "Street food vendors"
 9112 "Street vendors, non-food products"
 9113 "Door-to-door,telephone salesperson"
 9120 "Shoe cleaning+other street services"
 9130 "Domestic+rel.helpers"
 9131 "Domestic helpers and cleaners"
 9132 "Helpers+cleaners in offices, hotels"
 9133 "Hand-launderers and pressers"
 9134 "N:Kitchen+serv.assistants"
 9140 "Building caretakers,window+rel.cleaner"
 9141 "Building caretakers"
 9142 "Vehicle, window+related cleaners"
 9150 "Messengers,porters,doorkeepers+rel."
 9151 "Messengers,package,luggage porters"
 9152 "Doorkeepers,watchpersons"
 9153 "Vending-machine money collectors"
 9160 "Garbage collectors+rel.labourers"
 9161 "Garbage collectors"
 9162 "Sweepers and related labourers"
 9200 "Agricultural,fishery+rel.labourers"
 9210 "Agricultural,fishery+rel.labourers"
 9211 "Farm-hands and labourers"
 9212 "Forestry labourers"
 9213 "Fishery, hunting+trapping labourers"
 9300 "Labour. mining,constr.,manufacturing"
 9310 "Mining and construction labourers"
 9311 "Mining and quarrying labourers"
 9312 "Construction+maintenance labourers"
 9313 "Building construction labourers"
 9320 "Manufacturing labourers"
 9321 "Assembling labourers"
 9322 "Hand packers+other manufacturing lab"
 9330 "Transport labourers+freight handlers"
 9331 "Hand or pedal vehicle drivers"
 9332 "Drivers of animal-drawn vehicles+machines"
 9333 "Freight handlers"
 9996 "Not classifiable;inadeq described"
 9997 "Refused"
 9998 "Dont know"
 9999 "NA"
.
VARIABLE LABEL wrktype "R: Workg f priv.,pub sector, selfempl.".
VALUE LABELS wrktype
 0 "NAP,NAV"
 1 "Work f government"
 2 "Public owned firm,nat.ind"
 3 "Private firm, others"
 4 "Self employed"
 9 "NA, dont know"
.
VARIABLE LABEL nemploy "R: Self-employed - number of employees".
VALUE LABELS nemploy
 0 "NAV,NAP"
 9995 "No employee"
 9997 "Refused"
 9998 "Dont know"
 9999 "NA"
.
VARIABLE LABEL wrksup "R: Supervises others at work".
VALUE LABELS wrksup
 0 "NAP,NAV"
 1 "Yes,supervises"
 2 "No,do n supervise"
 7 "Refused"
 8 "Dont know"
 9 "NA"
.
VARIABLE LABEL union "R: Trade union membership".
VALUE LABELS union
 0 "NAP, NAV"
 1 "Currently member"
 2 "Once member, not now"
 3 "Never member"
 8 "Dont know"
 9 "NA, refused"
.
VARIABLE LABEL spwrkst "S-P: Current employment status".
VALUE LABELS spwrkst
 0 "NAV;N mar;n spou/partn"
 1 "F-t empl,main job"
 2 "P-t empl,main job"
 3 "Less part-time"
 4 "Help family member"
 5 "Unemployed"
 6 "Studt,school,educ"
 7 "Retired"
 8 "Housewife,-man,home duties"
 9 "Permanently disabled"
 10 "Other,not in lab force"
 97 "Refused"
 98 "Dont know"
 99 "NA"
.
VARIABLE LABEL spisco88 "S-P: Occupation ILO,ISCO 1988 4-digit".
VALUE LABELS spisco88
 0 "NAP,NAV"
 1 "D:Soldiers"
 2 "D:Officers"
 100 "Armed forces"
 110 "Armed forces"
 111 "N:Soldiers"
 112 "N:Officers"
 1000 "Legislators,senior off.+managers"
 1100 "Legislators and senior officials"
 1110 "Legislators"
 1120 "Senior government official"
 1130 "Traditional chiefs+heads of villages"
 1140 "Sen.officials of interest organisation"
 1141 "Sen.officials of pol.party"
 1142 "Sen.officials of empl+workers org"
 1143 "Sen.off.of human+other interest org"
 1200 "Corporate managers"
 1210 "Directors and chief executives"
 1220 "Production+operations dep.manager"
 1221 "Prod.+oper.managers in agriculture"
 1222 "Prod.+oper.managers:manufacturing"
 1223 "Prod.+oper.managers:construction"
 1224 "Prod.+oper.managers:retail trade"
 1225 "Prod.+oper.managers:hotels rest."
 1226 "Prod.+oper.managers:transport,comm"
 1227 "Prod.+oper.managers:business serv."
 1228 "Prod.+oper.managers:cleaning"
 1229 "Prod.+oper.dep. managers nec"
 1230 "Other department managers"
 1231 "Finance+administration dep.managers"
 1232 "Personnel+industrial rel.dep.managers"
 1233 "Sales+marketing dep.managers"
 1234 "Advertising+pub.relations dep.managers"
 1235 "Supply+distribution dep.managers"
 1236 "Computing services dep.managers"
 1237 "Research+development dep.managers"
 1238 "Other department managers nec"
 1239 "Other department managers"
 1240 "USA:Misc.office supervisors"
 1250 "PL:Military officer"
 1251 "H,PL:High-grade military officer"
 1252 "H,PL:Low-grade commissioned officer"
 1300 "General managers"
 1310 "General managers"
 1311 "General managers in agriculture"
 1312 "General managers in manufacture"
 1313 "General managers in construction"
 1314 "Gen.managers in wholesale+retail trade"
 1315 "Gen.managers of rest.+hotels"
 1316 "Gen.managers in transport+comm."
 1317 "General managers of business services"
 1318 "Gen.managers in personal care,cleaning"
 1319 "General managers nec"
 1320 "N:Managers in non-specific trade areas"
 2000 "Professionals"
 2100 "Physical,math.+engineering science"
 2110 "Physicists,chemists+rel.professionals"
 2111 "Physicists, and astronomers"
 2112 "Meteorologists"
 2113 "Chemists"
 2114 "Geologists and geophysicists"
 2120 "Mathematicians, statisticians+rel.prof"
 2121 "Mathematiciians and related prof"
 2122 "Statisticians"
 2130 "Computing professionals"
 2131 "Computing systems designers+analysts"
 2132 "Computer programmers"
 2139 "Computing professionals n.e.c."
 2140 "Architects,engineers+rel.profess"
 2141 "Architects, town+traffic planners"
 2142 "Civil engineers"
 2143 "Electrical engineers"
 2144 "Electronics+telecomm.engineers"
 2145 "Mechanical engineers"
 2146 "Chemical engineers"
 2147 "Mining engineers,metallurgists+rel"
 2148 "Cartographers and surveyors"
 2149 "Architects,engineers+rel.prof"
 2199 "Other natural scientist"
 2200 "Life science+health professionals"
 2210 "Life science professionals"
 2211 "Biologist,botanist,zoologist+rel"
 2212 "Pharmacologists, pathologists"
 2213 "Agronomists+related professionals"
 2220 "Health professionals"
 2221 "Medical doctors"
 2222 "Dentists"
 2223 "Veterinarians"
 2224 "Pharmacists"
 2229 "Health professionals n.e.c."
 2230 "Nursing+midwifery professionals"
 2300 "Teaching professionals"
 2310 "College,uni+higher educ.teacher"
 2320 "Secondary education teacher"
 2321 "H:Secondary (high)-school teacher"
 2322 "H:Teacher in vocational training"
 2330 "Primary+pre-primary educ.teacher"
 2331 "Primary educ.teaching prof"
 2332 "Pre-primary educ.teaching prof"
 2340 "Special educ.teaching profess"
 2350 "Other teaching profess,nec"
 2351 "Education methods specialists"
 2352 "School inspectors"
 2359 "Extra-systemic. teacher"
 2400 "Other professionals"
 2410 "Business professionals"
 2411 "Accountants"
 2412 "Personnel+careers professionals"
 2419 "Business professionals n.e.c"
 2420 "Legal professionals"
 2421 "Lawyers"
 2422 "Judges"
 2429 "Legal professionals nec"
 2430 "Archivists,librarians+rel.info.prof"
 2431 "Archivists and curators"
 2432 "Librarians+rel.information prof."
 2440 "Social science+rel. prof."
 2441 "Economists"
 2442 "Sociologists,anthropologists+rel"
 2443 "Philosophers,historians+pol.scientist"
 2444 "Philologists,translators+interpreter"
 2445 "Psychologists"
 2446 "Social work professionals"
 2450 "Writers and creative artists"
 2451 "Authors,journalists+other writers"
 2452 "Sculptors, painters+rel.artists"
 2453 "Composers, musicians+singers"
 2454 "Choreographers and dancers"
 2455 "Film, stage+rel.actors+directors"
 2460 "Religious professionals"
 2470 "Public service administrative prof"
 2500 "Education prof. n.e.c."
 2510 "N:Soc.scientific,juridical+techn.planng"
 2511 "N:Economical+soc.scientific planng"
 2512 "N:Juridical planning"
 2513 "N:Technical+scientific planng"
 2519 "N:Others within this group"
 3000 "Technicians and related prof."
 3100 "Physical+engineering science techn."
 3110 "Physical+engineering science techn."
 3111 "Chemical+physical science techn."
 3112 "Civil engineering technicians"
 3113 "Electrical engineering technicians"
 3114 "Electronics+telecommunication techn"
 3115 "Mechanical engineering technicians"
 3116 "Chemical engineering technicians"
 3117 "Mining and metallurgical techn."
 3118 "Draughtspersons"
 3119 "Physical+engin.science techn.nec"
 3120 "Computer associate professionals"
 3121 "Computer assistants"
 3122 "Computer equipment operators"
 3123 "Industrial robot controllers"
 3130 "Optical+electronic equipement oper"
 3131 "Photographers+image+sound oper"
 3132 "Broadcasting+telecommunications oper"
 3133 "Medical equipment operators"
 3139 "Optical+electronic operators nec"
 3140 "Ship,aircraft controllers+techn."
 3141 "Ships engineers"
 3142 "Ships deck officers and pilots"
 3143 "Aircraft pilots+rel. professionals"
 3144 "Air traffic pilots"
 3145 "Air traffic safety technicians"
 3150 "Safety and quality inspectors"
 3151 "Building and fire inspectors"
 3152 "Safety, health+quality inspectors"
 3200 "Life science+health ass.profess"
 3210 "Life science technicians+rel.prof"
 3211 "Life science technicians"
 3212 "Agronomy and forestry technicians"
 3213 "Farming and forestry advisers"
 3220 "Modern health ass.professionals"
 3221 "Medical assistants"
 3222 "Sanitarians"
 3223 "Dieticians and nutritionists"
 3224 "Optometrists and opticians"
 3225 "Dental assistants"
 3226 "Physiotherapists+rel.ass.profess"
 3227 "Veterinary assistants"
 3228 "Pharmaceutical assistants"
 3229 "Modern health ass.profess.nec"
 3230 "Nursing+midwifery ass.professionals"
 3231 "Nursing associate professionals"
 3232 "Midwifery associate professionals"
 3240 "Trad.medicine practitioner+faith healer"
 3241 "Traditional medicine practitioners"
 3242 "Faith healers"
 3300 "Teaching associate professionals"
 3310 "Primary educ.teachg  ass.prof."
 3320 "Pre-primary educ. teachg ass. prof."
 3330 "Spec.educ. teaching ass. prof."
 3340 "Other teaching associate profess"
 3341 "N:Teachers in technical college"
 3342 "N:Other educational occ"
 3400 "Other associate professionals"
 3410 "Finance+sales associate professionals"
 3411 "Securities+finance dealers and brokers"
 3412 "Insurance representatives"
 3413 "Estate agents"
 3414 "Travel consultants and organisers"
 3415 "Technical+commercial sales represent"
 3416 "Buyers"
 3417 "Appraisers,valuers+auctioneers"
 3418 "N:Customer consultant in a bank"
 3419 "Finance+sales ass.professionals nec"
 3420 "Business services agents+trade broker"
 3421 "Trade brokers"
 3422 "Clearing and forwarding agents"
 3423 "Employment agents+labour contractors"
 3429 "Other business services agents nec"
 3430 "Administrative ass.professionals"
 3431 "Administrative secretaries+rel.prof"
 3432 "Legal+rel.business ass. profess"
 3433 "Bookkeepers"
 3434 "Statistical,mathematical+rel.prof"
 3439 "Administrative ass.profess. nec"
 3440 "Customs,tax+rel.government prof"
 3441 "Customs and border inspectors"
 3442 "Government tax and excise officials"
 3443 "Government social benefits officials"
 3444 "Government licensing officials"
 3445 "N:Public employment service worker"
 3449 "Customs,tax+rel. government prof nec"
 3450 "Police inspectors and detectives"
 3452 "H,PL:Armed forces non-commiss. officer"
 3460 "Social work associate professionals"
 3470 "Artistic,entertainment+sports prof"
 3471 "Decorators and commercial designers"
 3472 "Radio,television+other announcers"
 3473 "Musicians,singers,dancers"
 3474 "Clowns,magicians,acrobates+rel.prof"
 3475 "Athletes,sportspersons+rel.prof"
 3480 "Religious associate professionals"
 3491 "N:Informationworker+journalist"
 3492 "N:Librarians"
 4000 "Office worker,clerks"
 4100 "Office clerks"
 4110 "Secretaries+keyboard-operating clerks"
 4111 "Stenographers and typists"
 4112 "Word-processor and rel.operators"
 4113 "Data entry operators"
 4114 "Calculating machine operators"
 4115 "Secretaries"
 4116 "N:Clerical officer"
 4120 "Numerical clerks"
 4121 "Accounting and bookkeeping clerks"
 4122 "Statistical and finance clerks"
 4130 "Material-recording+transport clerks"
 4131 "Stock clerks"
 4132 "Production clerks"
 4133 "Transport clerks"
 4140 "Library, mail and related clerks"
 4141 "Library and filing clerks"
 4142 "Mail carriers and sorting clerks"
 4143 "Coding, proof-reading+rel.clerks"
 4144 "Scribes and related workers"
 4190 "Other office clerks"
 4200 "Customer services clerks"
 4210 "Cashiers, tellers and rel.clerks"
 4211 "Cashiers and ticket clerks"
 4212 "Tellers and other counter clerks"
 4213 "Bookmakers and croupiers"
 4214 "Pawnbrokers and money-lenders"
 4215 "Debt-collectors and related workers"
 4220 "Client information clerks"
 4221 "Travel agency and related clerks"
 4222 "Receptionists+information clerks"
 4223 "Telephone switchboard operators"
 4300 "Office helping workers"
 4400 "Post office,higher civil service"
 4500 "Railway official,higher civil service"
 5000 "Personal service, sale"
 5100 "Personal+protective services workers"
 5110 "Travel attendents+related workers"
 5111 "Travel attendents+travel stewards"
 5112 "Transport conductors"
 5113 "Travel guides"
 5120 "Housekeeping+rest. services workers"
 5121 "Housekeepers and related workers"
 5122 "Cooks"
 5123 "Waiters, waitresses and bartenders"
 5130 "Personal care and related workers"
 5131 "Child care workers"
 5132 "Institution-based personal care workers"
 5133 "Home-based personal care workers"
 5134 "N:Dental secretaries"
 5135 "N:Medical secretaries"
 5136 "N:Childminders etc"
 5139 "Personal care+related workers nec"
 5140 "Other personal services workers"
 5141 "Hairdressers,beauticians+rel.workers"
 5142 "Companions and valets"
 5143 "Undertakers and embalmers"
 5149 "Other personal services workers nec"
 5150 "Astrologers,fortune-tellers"
 5151 "Astrologers and related workers"
 5152 "Fortune-tellers+related workers"
 5160 "Protective services workers"
 5161 "Fire-fighters"
 5162 "Police officers"
 5163 "Prison guards"
 5164 "N:Caretakers, houseporters"
 5169 "Protective services workers nec"
 5200 "Models,salespersons+demonstrators"
 5210 "Fashion and other models"
 5220 "Shop salespersons and demonstrators"
 5221 "N:Shop staff, sales staff+other"
 5222 "N:Door-to-door+telephone salesmen"
 5223 "N:Wholesale merchants"
 5230 "Stall and market salespersons"
 6000 "Skilled agricultural+fishery worker"
 6100 "Market-orient.agric.skilled worker"
 6110 "Market gardeners and crop growers"
 6111 "Field crop and vegetable growers"
 6112 "Tree and shrub crop growers"
 6113 "Gardeners,hortic.+nursery growers"
 6114 "Mixed-crop growers"
 6120 "Market-oriented animal producers"
 6121 "Dairy and livestock producers"
 6122 "Poultry producers"
 6123 "Apiarists and sericulturists"
 6124 "Mixed animal producers"
 6129 "Market-oriented animal producers nec"
 6130 "Market-oriented crop animal producer"
 6132 "USA: Farmers"
 6133 "USA: Farm supervisors"
 6140 "Forestry and related worker"
 6141 "Forestry workers and logger"
 6142 "Charcoal burners and related worker"
 6150 "Fishery workers,hunters+trappers"
 6151 "Aquatic-life cultivation worker"
 6152 "Inland+coastal waters fishery worker"
 6153 "Deep-sea fishery worker"
 6154 "Hunters and trappers"
 6200 "Subsistence agricultural+fishery worker"
 6210 "Subsistence agricultural+fishery worker"
 7000 "Craft and trade workers"
 7100 "Extraction and building trades worker"
 7110 "Miners,shotfirers,stone cutters+carvers"
 7111 "Miners and quarry workers"
 7112 "Shotfirers and blasters"
 7113 "Stone splitters, cutters and carvers"
 7120 "Building frame+related trades workers"
 7121 "Builders, traditional materials"
 7122 "Bricklayers and stonemasons"
 7123 "Concrete placers,finishers+rel"
 7124 "Carpenters and joiners"
 7125 "N:Joiner, formwork"
 7126 "N:Carpenters"
 7127 "N:Foundation workers"
 7128 "N:Tunnel+mountain workers"
 7129 "Building frame+rel.trades workers nec"
 7130 "Building finishers+rel.trades workers"
 7131 "Roofers"
 7132 "Floor layers and tile setters"
 7133 "Plasterers"
 7134 "Insulation workers"
 7135 "Glaziers"
 7136 "Plumbers and pipe fitters"
 7137 "Building+rel.electricians"
 7139 "Building finishers+rel.trade workers"
 7140 "Painters,building cleaners+rel worker"
 7141 "Painters and related workers"
 7142 "Varnishers and related painters"
 7143 "Building structure cleaners"
 7144 "N:Chimney sweepers"
 7200 "Metal,machinery+rel.trades workers"
 7210 "Metal moulders,sheetmetal workers+rel"
 7211 "Metal moulders vand coremakers"
 7212 "Welders and flamecutters"
 7213 "Sheet-metal workers"
 7214 "Structural-metal preparers+erectors"
 7215 "Riggers and cable splicers"
 7216 "Underwater workers"
 7217 "N:Car+airstructure mechanics"
 7220 "Blacksmiths,tool-makers+rel.trade"
 7221 "Blacksmiths+forging-press worker"
 7222 "Tool-makers and related workers"
 7223 "Machine-tool setters+setter-operators"
 7224 "Metal wheel-grinders+tool sharpeners"
 7230 "Machinery mechanics and fitters"
 7231 "Motor vehicle mechanics and fitters"
 7232 "Aircraft engine mechanics and fitters"
 7233 "Agricultural-industrial mechanics"
 7234 "N:Shipmechanics etc"
 7240 "Electrical+electronic equipm.mechanic"
 7241 "Electrical mechanics and fitters"
 7242 "Electronics fitters"
 7243 "Electronics mechanics+servicers"
 7244 "Telegraph+telephone installers+service"
 7245 "Electrical line installers,repairers"
 7300 "Precision,handicraft,printing+other"
 7310 "Precision metal workers+rel.materials"
 7311 "Precision-instrument makers+repairers"
 7312 "Musical-instrument makers+tuners"
 7313 "Jewellery and precious-metal workers"
 7320 "Potters,glass-makers+rel.trades worker"
 7321 "Abrasive wheel formers,potters+rel."
 7322 "Glass-makers,cutters+finishers"
 7323 "Glass engravers and etchers"
 7324 "Glass,ceramics+rel.decorative painter"
 7330 "Handicraft in wood,textile a.s."
 7331 "Handicraft in wood+rel.materials"
 7332 "Handicraft in textile,leather+rel"
 7340 "Printing+related trades workers"
 7341 "Compositors,typesetters+rel.worker"
 7342 "Stereotypers,electrotypers"
 7343 "Printing engravers and etchers"
 7344 "Photographic+related workers"
 7345 "Bookbinders+related workers"
 7346 "Silk-screen,block+textile printers"
 7350 "N:Technical drawers"
 7400 "Other craft+rel.trades workers"
 7410 "Food processing+rel.trades workers"
 7411 "Butchers+rel.food preparers"
 7412 "Bakers+confectionary makers"
 7413 "Dairy-products makers"
 7414 "Fruit,vegetable+related preservers"
 7415 "Food+beverage tasters+graders"
 7416 "Tobacco preparers+tobacco prod.maker"
 7420 "Wood treaters+rel.trades"
 7421 "Wood treaters"
 7422 "Cabinet-makers+related workers"
 7423 "Woodworking-machine setters+operators"
 7424 "Basketry weavers+rel.worker"
 7430 "Textile,garment+rel.trades workers"
 7431 "Fibre preparers"
 7432 "Weavers,knitters+related workers"
 7433 "Tailors,dressmakers+hatters"
 7434 "Furriers and related workers"
 7435 "Textile,leather+rel.pattern-makers"
 7436 "Sewers, embroiderers+rel.workers"
 7437 "Upholsterers and related workers"
 7440 "Pelt,leather+shoemaking trades worker"
 7441 "Pelt dressers,tanners+fellmongers"
 7442 "Shoemakers+rel.workers"
 7450 "N:Laboratory assistants"
 7500 "Metal worker general"
 7510 "Metal worker nec"
 7520 "Electronics engineers nec"
 7900 "Master craftsmen,supervisor"
 8000 "Plant+machine operators"
 8100 "Stationary-plant+related operators"
 8110 "Mining+mineral-proc.-plant operator"
 8111 "Mining-plant operators"
 8112 "Mineral-ore+stone-proc.-plant oper"
 8113 "Well drillers+borers+related workers"
 8120 "Metal-processing-plant operators"
 8121 "Ore ad metal furnace operators"
 8122 "Metal melters,casters"
 8123 "Metal-heat-treating-plant operator"
 8124 "Metal drawers and extruders"
 8130 "Glass,ceramics+rel.plant operators"
 8131 "Glass,ceramics+rel.machine operator"
 8132 "N:Operators in insul.glass prod"
 8139 "Glass,ceramics+rel.plant operators nec"
 8140 "Wood-processing+papermaking-plant oper"
 8141 "Wood-processing-plant operators"
 8142 "Paper-pulp plant operators"
 8143 "Papermaking-plant operators"
 8150 "Chemical-processing-plant operators"
 8151 "Crushing-,grinding mach.operator"
 8152 "Chemical-heat-treating-plant oper"
 8153 "Chemical-filtering-equipment oper"
 8154 "Chemical-still+reactor operators"
 8155 "Petroleum+natural-gas-refing-plant oper"
 8159 "Chemical-processing-plant oper,nec"
 8160 "Power-production+rel.plant operators"
 8161 "Power-production plant operators"
 8162 "Steam-engine and boiler operators"
 8163 "Icinerator,water-treatment+rel.oper"
 8170 "Auto.-assembly-line+ind.-robot oper"
 8171 "Automated-assembly-line operators"
 8172 "Industrial-robot operators"
 8200 "Machine operators and assemblers"
 8210 "Metal+mineral-products machine oper"
 8211 "Machine-tool operators"
 8212 "Cement+o.mineral products machine oper"
 8220 "Chemical-products machine operators"
 8221 "Pharma.products machine operator"
 8222 "Ammunition products machine operator"
 8223 "Metal finishing+coating-machine oper"
 8224 "Photographic-products machine operator"
 8229 "Chemical-products machine oper.nec"
 8230 "Rubber+plastic-products machine oper"
 8231 "Rubber-products machine oper"
 8232 "Plastic-products machine operators"
 8240 "Wood-products machine operators"
 8250 "Printing+paper-products machine oper"
 8251 "Printing-machine operators"
 8252 "Bookbinding-machine operators"
 8253 "Paper-products machine operators"
 8260 "Textile+leather-products machine oper"
 8261 "Spinning+winding-machine operators"
 8262 "Weaving+knitting-machine operators"
 8263 "Sewing-machine operators"
 8264 "Bleaching+cleaning-machine operators"
 8265 "Fur+leather-preparing-machine operator"
 8266 "Shoemaking+related machine operator"
 8269 "Textile products machine operators nec"
 8270 "Food+rel.products machine operators"
 8271 "Meat+fish-processing-machine operator"
 8272 "Dairy-products machine operators"
 8273 "Grain+spice-milling-machine operator"
 8274 "Baked-goods+chocolate-products m-oper"
 8275 "Fruit+nut-processing-machine oper"
 8276 "Sugar production machine operators"
 8277 "Tea,coffee+cocoa-processing-m.oper"
 8278 "Beverage machine operators"
 8279 "Tobacco production machine operators"
 8280 "Assemblers"
 8281 "Mechanical-machinery assemblers"
 8282 "Electrical-equipment assemblers"
 8283 "Electronic-equipment assemblers"
 8284 "Metal+plastic-products assemblers"
 8285 "Wood+rel.products assemblers"
 8286 "Paperboard,textile+rel.prod.assembler"
 8287 "Composite products assemblers"
 8290 "Other machine operators+assemblers"
 8300 "Drivers and mobile-plant operators"
 8310 "Locomotive-engine drivers+rel.workers"
 8311 "Locomotive-engine drivers"
 8312 "Railway brakers,signallers+shunters"
 8320 "Motor-vehicle drivers"
 8321 "Motor-cycle drivers"
 8322 "Car, taxi and van drivers"
 8323 "Bus and tram drivers"
 8324 "Heavy truck and lorry drivers"
 8330 "Agricultural+other mobile-plant oper"
 8331 "Motorised farm+forestry plant oper."
 8332 "Earth-moving+rel.plant operators"
 8333 "Crane, hoist and related plant oper"
 8334 "Lifting-truck operators"
 8340 "Ships deck crews and rel.workers"
 8341 "N:Deck crew, ship"
 8342 "N:Engine crew, ship"
 9000 "Elementary occ.+unskilled workers"
 9100 "Sales+services elementary occupation"
 9110 "Street vendors and related workers"
 9111 "Street food vendors"
 9112 "Street vendors, non-food products"
 9113 "Door-to-door,telephone salesperson"
 9120 "Shoe cleaning+other street services"
 9130 "Domestic+rel.helpers"
 9131 "Domestic helpers and cleaners"
 9132 "Helpers+cleaners in offices, hotels"
 9133 "Hand-launderers and pressers"
 9134 "N:Kitchen+serv.assistants"
 9140 "Building caretakers,window+rel.cleaner"
 9141 "Building caretakers"
 9142 "Vehicle, window+related cleaners"
 9150 "Messengers,porters,doorkeepers+rel."
 9151 "Messengers,package,luggage porters"
 9152 "Doorkeepers,watchpersons"
 9153 "Vending-machine money collectors"
 9160 "Garbage collectors+rel.labourers"
 9161 "Garbage collectors"
 9162 "Sweepers and related labourers"
 9200 "Agricultural,fishery+rel.labourers"
 9210 "Agricultural,fishery+rel.labourers"
 9211 "Farm-hands and labourers"
 9212 "Forestry labourers"
 9213 "Fishery, hunting+trapping labourers"
 9300 "Labour. mining,constr.,manufacturing"
 9310 "Mining and construction labourers"
 9311 "Mining and quarrying labourers"
 9312 "Construction+maintenance labourers"
 9313 "Building construction labourers"
 9320 "Manufacturing labourers"
 9321 "Assembling labourers"
 9322 "Hand packers+other manufacturing lab"
 9330 "Transport labourers+freight handlers"
 9331 "Hand or pedal vehicle drivers"
 9332 "Drivers of animal-drawn vehicles+machines"
 9333 "Freight handlers"
 9996 "Not classifiable;inadeq described"
 9997 "Refused"
 9998 "Dont know"
 9999 "NA"
.
VARIABLE LABEL spwrktyp "S-P:Workg f priv,pub sector,self-empl.".
VALUE LABELS spwrktyp
 0 "NAP,NAV"
 1 "Work f government"
 2 "Public owned firm,nat.ind"
 3 "Private firm, others"
 4 "Self employed"
 9 "NA, dont know"
.
VARIABLE LABEL dk_rinc "R: Earnings: Denmark".
VALUE LABELS dk_rinc
 0 "No own income, not in paid work"
 70000 "below dkr 100.000"
 125000 "dkr 100.000 to 149.999"
 175000 "dkr 150.000 to 199.999"
 225000 "dkr 200.000 to 249.999"
 275000 "dkr 250.000 to 299.999"
 350000 "dkr 300.000 to 399.999"
 450000 "dkr 400.000 to 499.999"
 550000 "dkr 500.000 to 599.999"
 650000 "dkr 600.000 or more"
 999990 "NAP, other countries"
 999997 "Refused"
 999998 "DK"
 999999 "NA"
.
VARIABLE LABEL dk_inc "Family income: Denmark".
VALUE LABELS dk_inc
 0 "No income"
 70000 "below dkr 100.000"
 125000 "dkr 100.000 to 149.999"
 175000 "dkr 150.000 to 199.999"
 225000 "dkr 200.000 to 249.999"
 275000 "dkr 250.000 to 299.999"
 350000 "dkr 300.000 to 399.999"
 450000 "dkr 400.000 to 499.999"
 550000 "dkr 500.000 to 599.999"
 650000 "dkr 600.000 to 699.999"
 750000 "dkr 700.000 to 799.999"
 850000 "dkr 800.000 to 899.999"
 950000 "dkr 900.000 to 999.999"
 999990 "NAP, other countries"
 999997 "Refused"
 999998 "DK"
 999999 "NA"
 1050000 "dkr 1 million or more"
.
VARIABLE LABEL hompop "How many persons in household".
COMMENT TO hompop: number of people currently living in local household of R, including R!
.
VALUE LABELS hompop
 0 "Not available"
 99 "NA, refused"
.
VARIABLE LABEL hhcycle "Household composition:children+adults".
VALUE LABELS hhcycle
 0 "NAV"
 1 "Single household"
 2 "1 adult,1 child"
 3 "1 adult,2 child"
 4 "1 adult,3 or > ch"
 5 "2 adults"
 6 "2 adults,1 child"
 7 "2 adults,2 child"
 8 "2 adults,3 or > ch"
 9 "3 adults"
 10 "3 adults+children"
 11 "4 adults"
 12 "4 adults+ children"
 13 "5 adults"
 14 "5 adults+children"
 15 "6 adults"
 16 "6 adults+children"
 17 "7 adults"
 18 "7 adults+children"
 19 "8 adults"
 20 "8 adults+children"
 21 "9 adults"
 22 "9 adults+children"
 23 "10 adults"
 24 "10 adults+children"
 25 "11 adults"
 26 "11 adults+children"
 27 "12 adults"
 28 "12 adults+children"
 95 "Other"
 99 "NA,refused"
.
VARIABLE LABEL party_lr "R: Party affiliation: left-right (derived)".
VALUE LABELS party_lr
 0 "NAV, NAP"
 1 "Far left etc"
 2 "Left,center left"
 3 "Center,liberal"
 4 "Right,conservative"
 5 "Far right etc"
 6 "Other,no specific"
 7 "No party,no preference"
 8 "Dont know"
 9 "No answer,refused"
.
VARIABLE LABEL dk_prty "R: Party affiliation: Denmark".
VALUE LABELS dk_prty
 0 "NAP, other countries"
 1 "Social Democratic P"
 2 "Radical Liberal P"
 3 "Conservative Party"
 4 "Centre Democratic"
 5 "Socialist Peoples P"
 6 "Danish Peoples Prty"
 7 "Christian Peoples P"
 8 "Liberal"
 9 "Progressive"
 10 "Leftwing Alliance"
 95 "Other Party"
 96 "Did not vote, blank vote"
 97 "Refused"
 98 "DK"
 99 "NA"
.
VARIABLE LABEL vote_le "R: Vote last election: yes, no".
VALUE LABELS vote_le
 0 "NAV, NAP"
 1 "Yes"
 2 "No"
 8 "DK"
 9 "No answer"
.
VARIABLE LABEL relig "R: Religious denomination".
VALUE LABELS relig
 0 "No religion"
 100 "Roman Catholic"
 110 "Greek Catholic"
 200 "Protestant"
 210 "Anglican,Ch Engl,Episcopal"
 220 "Baptists"
 230 "Congregationalists"
 240 "European Free Church (Anabaptists)"
 241 "Mennonite"
 250 "Lutheran, evangelical church"
 260 "Methodist"
 270 "Pentecostal"
 271 "Full Gospel Church of God"
 272 "Apostolic Faith Mission"
 273 "Intern Pentecostal Holiness"
 274 "St Johnes Apostolic Faith Mission"
 275 "Nazareth Baptist Church"
 276 "Zion Christian Church"
 280 "Presbyterian,Ch of Scot"
 281 "GB:Free Presbytarian"
 282 "Jehovas Witnesses"
 283 "Church of Christ"
 284 "New Apostolic"
 285 "LDS Church, Apostle Twelve"
 286 "Church of God a Saints of Christ"
 287 "Church of God"
 290 "Other Protestants (no spec. denom.)"
 291 "Brethren"
 292 "Mormon"
 293 "Salvation Army"
 294 "Assemblies of God"
 295 "Seventh Day Adventists"
 296 "CZ:Hussites"
 297 "Unitarians,AUS:Uniting church"
 298 "United Church CDN"
 299 "United Church of Christ"
 300 "Orthodox; Eastern Orthodox"
 310 "Greek Orthodox"
 320 "Russian Orthodox"
 325 "LV: Old Believers"
 390 "Orthodox (no spec. mentioned)"
 400 "Other Christian Groups"
 401 "PH: Aglipayan"
 402 "Born Again"
 403 "Alliance"
 404 "Dating Daan"
 405 "Jesus Miracle Crusad"
 406 "Jesus is Lord"
 407 "Christians"
 408 "Espiritista"
 409 "Iglesia ni Christo"
 410 "Phil Independent Church"
 411 "Iglesia Filipina Ind"
 412 "Sayon"
 413 "Bible Christian"
 414 "Gods Ordains Ministry"
 415 "Inspirutalist"
 417 "Jesus is Alive"
 422 "Ministry of the Light"
 423 "Four Square Gospel"
 424 "Christian Spirit of the Philippines"
 425 "Assembly of Yahweh"
 426 "Iglesia ng Dios"
 427 "Klak, Kapatiran at Litaw Na Katalinuhan"
 490 "Unspecified Christian Groups"
 500 "Jewish"
 510 "Orthodox Jewish"
 520 "Conservative Jewish"
 530 "Reformist Jewish"
 590 "Jewish Religion general"
 600 "Islam"
 610 "Kharijism"
 620 "Mutazilism"
 630 "Sunni"
 640 "Shiism"
 650 "Ismailis"
 660 "Other Muslim Religions"
 670 "Druse"
 690 "Muslim,Mohammedan,Islam"
 700 "Buddhists"
 701 "Specific Buddhist Groups"
 790 "Buddhism general"
 800 "Hinduism"
 810 "Specific Groups"
 820 "Sikhism"
 890 "Hinduism general"
 900 "Other Asian Religion"
 901 "Shintoism"
 902 "Taoism"
 903 "Confucianism"
 950 "Other East Asian Religion"
 960 "Other Religions"
 961 "NZ:Ratana"
 962 "US: Native American"
 963 "BR, UY: Afro brazilian religion"
 970 "Other non-Christian Religions"
 997 "NAV"
 998 "Dont know"
 999 "No answer"
.
VARIABLE LABEL religgrp "R: Religious main groups (derived)".
VALUE LABELS religgrp
 0 "NAV"
 1 "No religion"
 2 "Roman Catholic"
 3 "Protestant"
 4 "Christian Orthodox"
 5 "Jewish"
 6 "Islam"
 7 "Buddhism"
 8 "Hinduism"
 9 "Other Christian Religions"
 10 "Other Eastern Religions"
 11 "Other Religions"
 98 "Dont know"
 99 "No answer"
.
VARIABLE LABEL attend "R: Attendance of religious services".
VALUE LABELS attend
 0 "NAV, NAP"
 1 "Several times a week"
 2 "Once a week"
 3 "2 or 3 times a month"
 4 "Once a month"
 5 "Sev times a year"
 6 "Once a year"
 7 "Less frequently than once a year"
 8 "Never"
 97 "Refused"
 98 "DK, varies too much"
 99 "No answer"
.
VARIABLE LABEL topbot "R:Top Bottom self-placement 10 pt scale".
VALUE LABELS topbot
 1 "Lowest, 01"
 2 "02"
 3 "03"
 4 "04"
 5 "05"
 6 "06"
 7 "07"
 8 "08"
 9 "09"
 10 "Highest, 10"
 98 "DK"
 99 "NA"
.
VARIABLE LABEL dk_reg "Region: Denmark".
VALUE LABELS dk_reg
 0 "NAP, other countries"
 1 "Copenhagen county"
 2 "Frederiksborg county"
 3 "Roskilde county"
 4 "Westernzealand county"
 5 "Storstroms county"
 6 "Bornholms county"
 7 "Funen county"
 8 "Southern Jutland"
 9 "Ribe county"
 10 "Vejle county"
 11 "Ringkobing county"
 12 "Arhus county"
 13 "Viborg county"
 14 "Northern Jutland"
 15 "Copenhagen municipality"
 16 "Frederiksberg municipality"
 97 "Refused"
 98 "DK"
 99 "NA"
.
VARIABLE LABEL dk_size "Size of community: Denmark".
VALUE LABELS dk_size
 0 "NAP, other countries"
 1 "Greater Copenhagen area"
 2 "City, 50 000-500 000"
 3 "Town,city 10 000-49 999"
 4 "Town,city  5 000- 9 999"
 5 "Town,less than    5 000"
 97 "Refused"
 98 "DK"
 99 "NA"
.
VARIABLE LABEL urbrural "Type of community: R.s self-assesment".
VALUE LABELS urbrural
 0 "Not available"
 1 "Urban,a big city"
 2 "Suburb,outskirt of a big city"
 3 "Town or small city"
 4 "Country village"
 5 "Farm or home in the country"
 9 "NA"
.
VARIABLE LABEL subscase "Case substitution flag".
VALUE LABELS subscase
 0 "NAP, no substitution in this survey"
 1 "case from original sample"
 2 "case substituted"
.
VARIABLE LABEL weight "Weighting factor".
VALUE LABELS weight
 1 "No weighting"
.
MISSING VALUES v6 (8,9).
MISSING VALUES v7 (8,9).
MISSING VALUES v8 (8,9).
MISSING VALUES v9 (8,9).
MISSING VALUES v10 (8,9).
MISSING VALUES v11 (8,9).
MISSING VALUES v12 (8,9).
MISSING VALUES v13 (8,9).
MISSING VALUES v14 (8,9).
MISSING VALUES v15 (8,9).
MISSING VALUES v16 (8,9).
MISSING VALUES v17 (8,9).
MISSING VALUES v18 (8,9).
MISSING VALUES v19 (8,9).
MISSING VALUES v20 (8,9).
MISSING VALUES v21 (8,9).
MISSING VALUES v22 (8,9).
MISSING VALUES v23 (8,9).
MISSING VALUES v24 (8,9).
MISSING VALUES v25 (8,9).
MISSING VALUES v26 (8,9).
MISSING VALUES v27 (8,9).
MISSING VALUES v28 (9,0).
MISSING VALUES v29 (9,0).
MISSING VALUES v30 (9,0).
MISSING VALUES v31 (8,9).
MISSING VALUES v32 (8,9 THRU HIGHEST).
MISSING VALUES v33 (8,9 THRU HIGHEST).
MISSING VALUES v34 (8,9 THRU HIGHEST).
MISSING VALUES v35 (8,9 THRU HIGHEST).
MISSING VALUES v36 (8,9).
MISSING VALUES v37 (8,9).
MISSING VALUES v38 (999).
MISSING VALUES v39 (99).
MISSING VALUES v40 (8,9 THRU HIGHEST).
MISSING VALUES v41 (8,9 THRU HIGHEST).
MISSING VALUES v42 (8,9 THRU HIGHEST).
MISSING VALUES v43 (8,0).
MISSING VALUES v44 (999).
MISSING VALUES v45 (999).
MISSING VALUES v46 (8,9).
MISSING VALUES v47 (8,9).
MISSING VALUES v48 (8,9).
MISSING VALUES v49 (8,9).
MISSING VALUES v50 (8,9).
MISSING VALUES v51 (8,9).
MISSING VALUES v52 (8,9).
MISSING VALUES v53 (8,9).
MISSING VALUES v54 (8,9).
MISSING VALUES v55 (8,9).
MISSING VALUES v56 (8,9).
MISSING VALUES v57 (8,9).
MISSING VALUES v58 (8,9).
MISSING VALUES v59 (8,9).
MISSING VALUES v60 (8,9).
MISSING VALUES v61 (8,9).
MISSING VALUES v62 (8,9).
MISSING VALUES v63 (8,9).
MISSING VALUES v64 (8,9).
MISSING VALUES v65 (8,9).
MISSING VALUES sex (9).
MISSING VALUES age (99).
MISSING VALUES marital (9).
MISSING VALUES cohab (9).
MISSING VALUES educyrs (0,97 THRU HIGHEST).
MISSING VALUES degree (9).
MISSING VALUES es_degr (97,98 THRU HIGHEST).
MISSING VALUES wrkst (0,98 THRU HIGHEST).
MISSING VALUES wrkhrs (0,97 THRU HIGHEST).
MISSING VALUES isco88 (0,9996 THRU HIGHEST).
MISSING VALUES wrktype (0,9).
MISSING VALUES nemploy (0,9997 THRU HIGHEST).
MISSING VALUES wrksup (0,7 THRU HIGHEST).
MISSING VALUES union (0,8 THRU HIGHEST).
MISSING VALUES spwrkst (0,97 THRU HIGHEST).
MISSING VALUES spisco88 (0,9996 THRU HIGHEST).
MISSING VALUES spwrktyp (0,9).
MISSING VALUES hompop (0,99).
MISSING VALUES hhcycle (0,99).
MISSING VALUES party_lr (0,8 THRU HIGHEST).
MISSING VALUES vote_le (0,9).
MISSING VALUES relig (998,999).
MISSING VALUES religgrp (98,99).
MISSING VALUES attend (97,98 THRU HIGHEST).
MISSING VALUES topbot (99).
MISSING VALUES urbrural (0,9).
MISSING VALUES mode (0,99).

FREQUENCIES VARIABLES=dk1 v4 dk1 v4 dk5 v3 dk6 v6 dk7 v7 dk8 v8 dk9 v9 dk10 v10 dk11 v11 dk12 v12 dk13 v13 dk14 v14 dk15 v15 dk16 v16 dk17 v17 dk18 v18 dk19 v19 dk20 v20 dk21 v21 dk22 v22 dk23 v23 dk24 v24 dk25 v25 dk26 v26 dk27 v27 dk28 v28 dk29 v29 dk30 v30 dk31 v31 dk32 v32 dk33 v33 dk34 v34 dk35 v35 dk36 v36 dk37 v37 dk39 v38 dk40 v39 dk41 v40 dk42 v41 dk43 v42 dk44 v43 dk46 v44 dk48 v45 dk49 v46 dk50 v47 dk51 v48 dk52 v49 dk53 v50 dk54 v51 dk55 v52 dk56 v53 dk57 v54 dk58 v55 dk60 v56 dk61 v57 dk62 v58 dk63 v59 dk64 v60 dk65 v61 dk66 v62 dk67 v63 dk68 v64 dk69 v65
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=SEX dk111 AGE dk112 MARITAL dk116 dk117 COHAB dk118
EDUCYRS dk125 dk124 DEGREE dk121 dk123 DK_DEGR WRKST dk126 WRKHRS dk132
WRKSUP dk133 WRKTYPE dk134 NEMPLOY dk136 dk135 UNION dk144 SPWRKST dk138
SPWRKTYP dk143 dk132 DK_RINC dk155 DK_INC dk156 HOMPOP dk119 HHCYCLE dk119 dk120
PARTY_LR dk152 DK_PRTY dk152 VOTE_LE dk151 ATTEND dk147 RELIG dk145 RELIGGRP
TOPBOT dk148 DK_REG DK_SIZE dk150 URBRURAL dk149 MODE
  /ORDER=ANALYSIS.
