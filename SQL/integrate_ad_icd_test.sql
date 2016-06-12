-- view admission_segment shows the first admission date for each patient
create view admission_segment as
select a1.AD_ID, a1.ANONID, a1.DOHA, a1.DOHD, a2.DOHA as DOHA_NEXT
from admission as a1 left outer join admission as a2 on a1.ANONID = a2.ANONID 
where STR_TO_DATE(a1.DOHA, '%Y-%m-%d %H:%i:%s')< STR_TO_DATE(a2.DOHA, '%Y-%m-%d %H:%i:%s')
and not exists (select * from admission as a3 where a3.ANONID = a1.ANONID 
					and STR_TO_DATE(a1.DOHA, '%Y-%m-%d %H:%i:%s') < STR_TO_DATE(a3.DOHA , '%Y-%m-%d %H:%i:%s')
                    and STR_TO_DATE(a3.DOHA, '%Y-%m-%d %H:%i:%s') < STR_TO_DATE(a2.DOHA, '%Y-%m-%d %H:%i:%s'));
                    
-- view ad_icd is shows which admission record each icd record belongs to
create view ad_icd as select AD_ID, ad.ANONID, DOHA, DOHD, ICD_ID, CODE, CODEDATE 
from ad_seg as ad join icdcodes as ic on ad.ANONID = ic.ANONID 
where date(STR_TO_DATE(ic.CODEDATE, '%d/%m/%Y')) >= date(STR_TO_DATE(DOHA, '%Y-%m-%d %H:%i:%s')) 
and (DOHA_NEXT is null or date(STR_TO_DATE(ic.CODEDATE, '%d/%m/%Y')) < date(STR_TO_DATE(DOHA_NEXT, '%Y-%m-%d %H:%i:%s')));

-- view ad_test shows which admission record each test record belongs to
create view ad_test as select AD_ID, ad.ANONID, DOHA, DOHD, TEST_ID, TEST, VALUE,RECDATE 
from ad_seg as ad join test as t on ad.ANONID = t.ANONID 
where STR_TO_DATE(t.RECDATE, '%d/%m/%Y %H:%i:%s') >= STR_TO_DATE(DOHA, '%Y-%m-%d %H:%i:%s') 
and (DOHA_NEXT is null or STR_TO_DATE(t.RECDATE, '%d/%m/%Y %H:%i:%s') < STR_TO_DATE(DOHA_NEXT, '%Y-%m-%d %H:%i:%s'));