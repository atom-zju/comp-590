-- these codes are just for statistic inspection of the ad_icd and ad_test

-- for ad_test:

select count(*) from admission where AD_ID not in (select distinct AD_ID from ad_test);

select count(distinct ANONID) from admission where ANONID not in (select distinct ANONID from ad_test);

select count(distinct TEST_ID) from test where TEST_ID not in (select distinct TEST_ID from ad_test);

select count(*) from test as t where STR_TO_DATE(RECDATE, '%d/%m/%Y %H:%i:%s') < (select DateOHA from first_ad_date as f where f.ANONID = t.ANONID);

select count(*) from test where ANONID in (select distinct ANONID from test where ANONID not in (select distinct ANONID from admission));

-- for ad_icd:

select count(*) from admission where AD_ID not in (select distinct AD_ID from ad_icd);

select count(distinct ANONID) from admission where ANONID not in (select distinct ANONID from ad_icd);

select count(distinct ICD_ID) from icdcodes where ICD_ID not in (select distinct ICD_ID from ad_icd);

select count(*) from icdcodes as ic where STR_TO_DATE(ic.CODEDATE, '%d/%m/%Y') < (select DateOHA from first_ad_date as f where f.ANONID = ic.ANONID);

select count(*) from icdcodes where ANONID in (select distinct ANONID from icdcodes where ANONID not in (select distinct ANONID from admission));