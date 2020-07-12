create or replace 
PROCEDURE PR_MONTHEND_CRIB_DATA (strprocessdate in date ,PR_LASTUPTIME IN VARCHAR2,  FLAG OUT VARCHAR2)
IS
   --strprocessdate   DATE;
BEGIN
   --strprocessdate := '31-Aug-2013';



 --SELECT TO_CHAR( A.syd_prevdate,'DD-MON-YYYY') FROM CORPINFO.TBLBRANCHES B ,
 --CORPINFO.TBLSYSTEMDATE A WHERE (A.SYD_BRNCODE = B.BRN_CODE AND UPPER(A.SYD_BRNCODE) = UPPER('HO'))
 --Consumer

   UPDATE corrsql.tbl_crib_header
      SET cribh_dt_preparation = strprocessdate,
          cribh_report_date = strprocessdate,
          cribh_report_time = TO_CHAR (SYSDATE, 'HHMISS')
    WHERE cribh_nature_data = '001';

   INSERT INTO leaseinfo.tbl_con_cribfacility
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribfacility a);

   DELETE FROM corrsql.tbl_con_cribfacility;

   INSERT INTO leaseinfo.tbl_con_cribfacility_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribfacility_error a);

   DELETE FROM corrsql.tbl_con_cribfacility_error;

   INSERT INTO corrsql.tbl_con_cribfacility
      SELECT UNIQUE ('CNCF'), (u.ucm_provid), (NULL),
                    (SUBSTR (c.con_no, 0, 2)), (NULL), (c.con_no), (NULL),
                    (NULL), (c.con_manualno), (NULL),
                    (CASE
                        WHEN c.con_execdate > po.pro_date
                           THEN TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (c.con_execdate, 'DD-MON-YYYY')
                     END
                    ),
                    (TRUNC (NVL (c.con_contamt, 0), 0)), (NULL), ('LKR'),
                    (NVL2 (j.jcl_appno, '002', '001')), (p.prd_cribcode),
                    (NVL (s.ssc_cribocde, '09:01:001')), (c.con_period),
                    (TRUNC (NVL (c.CON_GROSSRNTAMT, 0), 0)),
                    (DECODE (c.con_rntfreq, 'M', '005', 'ERR')),
                    (CASE
                        WHEN po.pro_date > rec.rec_date
                           THEN TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (  (  NVL (d.dls_fucap, 0)
                                       + NVL (d.dls_fuint, 0)
                                       + NVL (d.dls_futax, 0)
                                       + NVL (d.dls_futax1, 0)
                                       + NVL (d.dls_arrcap, 0)
                                       + NVL (d.dls_arrint, 0)
                                       + NVL (d.dls_arrtax, 0)
                                       + NVL (d.dls_arrtax1, 0)
                                       + NVL (d.dls_othout, 0)
                                       + NVL (d.dls_odiout, 0)
                                      )
                                    - NVL (d.dls_overpay, 0),
                                    0
                                   )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (d.dls_fuint, 0), 0)
                            )
                    ),
                    (DECODE (DECODE (clo.clo_ctptype,
                                     '2', 0,
                                     TRUNC (NVL (arr.arr_amt, 0), 0)
                                    ),
                             0, 0,
                             NVL (TRUNC (  TO_DATE (strprocessdate)
                                         - TO_DATE (rec.rec_date),
                                         0
                                        ),
                                  0
                                 )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (arr.arr_amt, 0), 0)
                            )
                    ),
                    (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ),
                    (CASE
                        WHEN rec.rec_date > clo.clo_date
                           THEN TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '3', TO_CHAR (clo.clo_date, 'DD-MON-YYYY'),
                             NULL
                            )
                    ),
                    (NULL),
                    (DECODE (clo.clo_ctptype,
                             '3', NULL,
                             TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                            )
                    ),
                    (DECODE (c.con_sts, 'L', '001', NULL)), (NULL), (NULL),
                    (CASE
                        WHEN NVL (gr.secvalue, 0) > NVL (c.con_contamt, 0)
                           THEN '001'
                        WHEN NVL (gr.secvalue, 0) = NVL (c.con_contamt, 0)
                           THEN '002'
                        WHEN NVL (gr.secvalue, 0) < NVL (c.con_contamt, 0)
                           THEN '003'
                        ELSE '999'
                     END
                    ),
                    ('001'), ('001'), (NULL)
               FROM corpinfo.tblusercompany u,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbljoinclient j,
                    corpinfo.tblclientmain cli,
                    corpinfo.tblsubsector s,
                    glinfo.tbldailysummary d,
                    corpinfo.tblproduct p,
                    leaseinfo.tblpurchaseorder po,
                    (SELECT   c.clo_oldconno, MAX (c.clo_date) clo_date,
                              NVL (MAX (c.clo_ctptype), 1) clo_ctptype
                         FROM leaseinfo.tblclosure c
                        WHERE c.clo_date IS NOT NULL
                     GROUP BY c.clo_oldconno
                       HAVING MAX (TO_DATE (c.clo_date)) <= strprocessdate) clo,
                    (SELECT   a.fsd_conno, MAX (a.fsd_secval) secvalue
                         FROM corpinfo.tblfacsecdetails a
                     GROUP BY a.fsd_conno) gr/*,
                    (SELECT   p.pro_conno, MIN (TO_DATE (p.pro_date))
                                                                     pro_date
                         FROM leaseinfo.tblpurchaseorder p
                     GROUP BY p.pro_conno
                       HAVING MIN (TO_DATE (p.pro_date)) <= strprocessdate) po*/,
                    (SELECT   a.dfc_conno, SUM (NVL (dfc_balamt, 0)) arr_amt
                         FROM glinfo.tblduefromclient a
                        WHERE dfc_duedte <= strprocessdate AND dfc_balamt > 0
                     GROUP BY a.dfc_conno) arr,
                    (SELECT   a.rsm_conno, MAX (a.rsm_stlddate) rec_date
                         FROM glinfo.tblreceiptssettlement a
                        WHERE a.rsm_stlddate < strprocessdate
                     GROUP BY a.rsm_conno) rec
              WHERE cli.clm_code = c.con_clmcode
                AND c.con_appno = j.jcl_appno(+)
                AND SUBSTR (cli.clm_seccode, 4, 3) = s.ssc_code(+)
                AND SUBSTR (cli.clm_seccode, 1, 3) = s.ssc_seccode(+)
                AND c.con_no = d.dls_conno(+)
                AND c.con_no = po.pro_conno(+)
                AND c.con_no = clo.clo_oldconno(+)
                AND c.con_no = gr.fsd_conno(+)
                AND c.con_no = arr.dfc_conno(+)
                AND c.con_no = rec.rsm_conno(+)
                AND SUBSTR (c.con_no, 3, 2) = p.prd_code
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND cli.clm_cori = 1
                AND c.con_date <= strprocessdate
                AND c.con_execdate <= strprocessdate
                AND po.pro_date IS NOT NULL
                /* AND NVL (c.con_freezdate, strprocessdate) >=      TRUNC (TO_DATE (strprocessdate), 'MM')*/ 
                 and  c.con_no not in (select strldb_contractno from trn_ldb_legaldebtor)
---reshedulement

                 union
               SELECT UNIQUE ('CNCF'), (u.ucm_provid), (NULL),
                    (SUBSTR (c.con_no, 0, 2)), (NULL), (c.con_no), (NULL),
                    (NULL), (c.con_manualno), (NULL),
                    (CASE
                        WHEN c.con_execdate > nvl(po.pro_date,c.con_execdate)
                           THEN TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (c.con_execdate, 'DD-MON-YYYY')
                     END
                    ),
                    (TRUNC (NVL (c.con_contamt, 0), 0)), (NULL), ('LKR'),
                    (NVL2 (j.jcl_appno, '002', '001')), (p.prd_cribcode),
                    (NVL (s.ssc_cribocde, '09:01:001')), (c.con_period),
                    (TRUNC (NVL (c.CON_GROSSRNTAMT, 0), 0)),
                    (DECODE (c.con_rntfreq, 'M', '005', 'ERR')),
                    (CASE
                        WHEN  nvl(po.pro_date,c.con_execdate) > rec.rec_date
                           THEN TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (nvl(po.pro_date,c.con_execdate), 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (  (  NVL (d.dls_fucap, 0)
                                       + NVL (d.dls_fuint, 0)
                                       + NVL (d.dls_futax, 0)
                                       + NVL (d.dls_futax1, 0)
                                       + NVL (d.dls_arrcap, 0)
                                       + NVL (d.dls_arrint, 0)
                                       + NVL (d.dls_arrtax, 0)
                                       + NVL (d.dls_arrtax1, 0)
                                       + NVL (d.dls_othout, 0)
                                       + NVL (d.dls_odiout, 0)
                                      )
                                    - NVL (d.dls_overpay, 0),
                                    0
                                   )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (d.dls_fuint, 0), 0)
                            )
                    ),
                    (DECODE (DECODE (clo.clo_ctptype,
                                     '2', 0,
                                     TRUNC (NVL (arr.arr_amt, 0), 0)
                                    ),
                             0, 0,
                             NVL (TRUNC (  TO_DATE (strprocessdate)
                                         - TO_DATE (rec.rec_date),
                                         0
                                        ),
                                  0
                                 )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (arr.arr_amt, 0), 0)
                            )
                    ),
                    (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ),
                    (CASE
                        WHEN rec.rec_date > clo.clo_date
                           THEN TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '3', TO_CHAR (clo.clo_date, 'DD-MON-YYYY'),
                             NULL
                            )
                    ),
                    (NULL),
                    (DECODE (clo.clo_ctptype,
                             '3', NULL,
                             TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                            )
                    ),
                    (DECODE (c.con_sts, 'L', '001', NULL)), (NULL), (NULL),
                    (CASE
                        WHEN NVL (gr.secvalue, 0) > NVL (c.con_contamt, 0)
                           THEN '001'
                        WHEN NVL (gr.secvalue, 0) = NVL (c.con_contamt, 0)
                           THEN '002'
                        WHEN NVL (gr.secvalue, 0) < NVL (c.con_contamt, 0)
                           THEN '003'
                        ELSE '999'
                     END
                    ),
                    ('001'), ('001'), (NULL)
               FROM corpinfo.tblusercompany u,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbljoinclient j,
                    corpinfo.tblclientmain cli,
                    corpinfo.tblsubsector s,
                    glinfo.tbldailysummary d,
                    corpinfo.tblproduct p,
                    leaseinfo.tblpurchaseorder po,
                    (SELECT   c.clo_oldconno, MAX (c.clo_date) clo_date,
                              NVL (MAX (c.clo_ctptype), 1) clo_ctptype
                         FROM leaseinfo.tblclosure c
                        WHERE c.clo_date IS NOT NULL
                     GROUP BY c.clo_oldconno
                       HAVING MAX (TO_DATE (c.clo_date)) <= strprocessdate) clo,
                    (SELECT   a.fsd_conno, MAX (a.fsd_secval) secvalue
                         FROM corpinfo.tblfacsecdetails a
                     GROUP BY a.fsd_conno) gr/*,
                    (SELECT   p.pro_conno, MIN (TO_DATE (p.pro_date))
                                                                     pro_date
                         FROM leaseinfo.tblpurchaseorder p
                     GROUP BY p.pro_conno
                       HAVING MIN (TO_DATE (p.pro_date)) <= strprocessdate) po*/,
                    (SELECT   a.dfc_conno, SUM (NVL (dfc_balamt, 0)) arr_amt
                         FROM glinfo.tblduefromclient a
                        WHERE dfc_duedte <= strprocessdate AND dfc_balamt > 0
                     GROUP BY a.dfc_conno) arr,
                    (SELECT   a.rsm_conno, MAX (a.rsm_stlddate) rec_date
                         FROM glinfo.tblreceiptssettlement a
                        WHERE a.rsm_stlddate < strprocessdate
                     GROUP BY a.rsm_conno) rec
              WHERE cli.clm_code = c.con_clmcode
                AND c.con_appno = j.jcl_appno(+)
                AND SUBSTR (cli.clm_seccode, 4, 3) = s.ssc_code(+)
                AND SUBSTR (cli.clm_seccode, 1, 3) = s.ssc_seccode(+)
                AND c.con_no = d.dls_conno(+)
                AND c.con_no = po.pro_conno(+)
                AND c.con_no = clo.clo_oldconno(+)
                AND c.con_no = gr.fsd_conno(+)
                AND c.con_no = arr.dfc_conno(+)
                AND c.con_no = rec.rsm_conno(+)
                AND SUBSTR (c.con_no, 3, 2) = p.prd_code
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND cli.clm_cori = 1
                AND c.con_date <= strprocessdate
                AND c.con_execdate <= strprocessdate and  substr(c.con_no,13,1)=1
               --legal
                union

                 SELECT UNIQUE ('CNCF'), (u.ucm_provid), (NULL),
                    (SUBSTR (c.con_no, 0, 2)), (NULL), (c.con_no), (NULL),
                    (NULL), (c.con_manualno), (NULL),
                    (CASE
                        WHEN c.con_execdate > po.pro_date
                           THEN TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (c.con_execdate, 'DD-MON-YYYY')
                     END
                    ),
                    (TRUNC (NVL (c.con_contamt, 0), 0)), (NULL), ('LKR'),
                    (NVL2 (j.jcl_appno, '002', '001')), (p.prd_cribcode),
                    (NVL (s.ssc_cribocde, '09:01:001')), (c.con_period),
                    (TRUNC (NVL (c.CON_GROSSRNTAMT, 0), 0)),
                    (DECODE (c.con_rntfreq, 'M', '005', 'ERR')),
                    (CASE
                        WHEN po.pro_date > rec.rec_date
                           THEN TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (  (  NVL (d.dls_fucap, 0)
                                       + NVL (d.dls_fuint, 0)
                                       + NVL (d.dls_futax, 0)
                                       + NVL (d.dls_futax1, 0)
                                       + NVL (d.dls_arrcap, 0)
                                       + NVL (d.dls_arrint, 0)
                                       + NVL (d.dls_arrtax, 0)
                                       + NVL (d.dls_arrtax1, 0)
                                       + NVL (d.dls_othout, 0)
                                       + NVL (d.dls_odiout, 0)
                                      )
                                    - NVL (d.dls_overpay, 0),
                                    0
                                   )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (d.dls_fuint, 0), 0)
                            )
                    ),
                    (DECODE (DECODE (clo.clo_ctptype,
                                     '2', 0,
                                     TRUNC (NVL (arr.arr_amt, 0), 0)
                                    ),
                             0, 0,
                             NVL (TRUNC (  TO_DATE (strprocessdate)
                                         - TO_DATE (rec.rec_date),
                                         0
                                        ),
                                  0
                                 )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (arr.arr_amt, 0), 0)
                            )
                    ),
                    (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '002',
                                          '9', '002',
                                          '3', '002',
                                          '2', '002'
                                         )
                            )
                    ),
                    (CASE
                        WHEN rec.rec_date > clo.clo_date
                           THEN TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '3', TO_CHAR (clo.clo_date, 'DD-MON-YYYY'),
                             NULL
                            )
                    ),
                    (NULL),
                    (DECODE (clo.clo_ctptype,
                             '3', NULL,
                             TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                            )
                    ),
                    (DECODE (c.con_sts, 'L', '001', NULL)), (NULL), (NULL),
                    (CASE
                        WHEN NVL (gr.secvalue, 0) > NVL (c.con_contamt, 0)
                           THEN '001'
                        WHEN NVL (gr.secvalue, 0) = NVL (c.con_contamt, 0)
                           THEN '002'
                        WHEN NVL (gr.secvalue, 0) < NVL (c.con_contamt, 0)
                           THEN '003'
                        ELSE '999'
                     END
                    ),
                    ('001'), ('001'), (NULL)
               FROM corpinfo.tblusercompany u,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbljoinclient j,
                    corpinfo.tblclientmain cli,
                    corpinfo.tblsubsector s,
                    glinfo.tbldailysummary d,
                    corpinfo.tblproduct p,
                    leaseinfo.tblpurchaseorder po,
                    (SELECT   c.clo_oldconno, MAX (c.clo_date) clo_date,
                              NVL (MAX (c.clo_ctptype), 1) clo_ctptype
                         FROM leaseinfo.tblclosure c
                        WHERE c.clo_date IS NOT NULL
                     GROUP BY c.clo_oldconno
                       HAVING MAX (TO_DATE (c.clo_date)) <= strprocessdate) clo,
                    (SELECT   a.fsd_conno, MAX (a.fsd_secval) secvalue
                         FROM corpinfo.tblfacsecdetails a
                     GROUP BY a.fsd_conno) gr/*,
                    (SELECT   p.pro_conno, MIN (TO_DATE (p.pro_date))
                                                                     pro_date
                         FROM leaseinfo.tblpurchaseorder p
                     GROUP BY p.pro_conno
                       HAVING MIN (TO_DATE (p.pro_date)) <= strprocessdate) po*/,
                    (SELECT   a.dfc_conno, SUM (NVL (dfc_balamt, 0)) arr_amt
                         FROM glinfo.tblduefromclient a
                        WHERE dfc_duedte <= strprocessdate AND dfc_balamt > 0
                     GROUP BY a.dfc_conno) arr,
                    (SELECT   a.rsm_conno, MAX (a.rsm_stlddate) rec_date
                         FROM glinfo.tblreceiptssettlement a
                        WHERE a.rsm_stlddate < strprocessdate
                     GROUP BY a.rsm_conno) rec,trn_ldb_legaldebtor u
                     ,
                     (SELECT b.strldb_contractno, a.dfc_lglconno,
       sum(a.dfc_dueamt),
       sum(a.dfc_balamt)
  FROM glinfo.tblduefromlgdebtor a,trn_ldb_legaldebtor b
  where a.dfc_lglconno=b.strldb_referenceno and dfc_balamt >0
  group by  b.strldb_contractno, a.dfc_lglconno)dd

              WHERE cli.clm_code = c.con_clmcode
                and c.con_no= u.strldb_contractno and dd.strldb_contractno=u.strldb_contractno
                AND c.con_appno = j.jcl_appno(+)
                AND SUBSTR (cli.clm_seccode, 4, 3) = s.ssc_code(+)
                AND SUBSTR (cli.clm_seccode, 1, 3) = s.ssc_seccode(+)
                AND c.con_no = d.dls_conno(+)
                AND c.con_no = po.pro_conno(+)
                AND c.con_no = clo.clo_oldconno(+)
                AND c.con_no = gr.fsd_conno(+)
                AND c.con_no = arr.dfc_conno(+)
                AND c.con_no = rec.rsm_conno(+)
                AND SUBSTR (c.con_no, 3, 2) = p.prd_code
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
              --  AND cli.clm_cori = 1
                AND c.con_date <= strprocessdate
                AND c.con_execdate <= strprocessdate
                AND po.pro_date IS NOT NULL;







--Subject
   INSERT INTO leaseinfo.tbl_con_cribsubject
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribsubject a);

   DELETE FROM corrsql.tbl_con_cribsubject;

   INSERT INTO leaseinfo.tbl_con_cribsubject_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribsubject_error a);

   DELETE FROM corrsql.tbl_con_cribsubject_error;

   INSERT INTO corrsql.tbl_con_cribsubject
      SELECT UNIQUE sql1.su_segment_id, sql1.su_data_prov_id,
                    sql1.su_data_prov_brn_id, sql1.su_cr_facility_no,
                    sql1.su_sub_id_no, sql1.su_pre_sub_id_no, sql1.su_nic_no,
                    sql1.su_pre_nic_no, sql1.su_citizenship,
                    sql1.su_passport_no, sql1.su_drv_licence_no,
                    sql1.su_sub_salutation, sql1.su_sub_name,
                    sql1.su_pre_sub_name, sql1.su_employment,
                    sql1.su_profession, sql1.su_employer,
                    sql1.su_business_name, sql1.su_busi_reg_no,
                    sql1.su_busi_reg_date, sql1.su_mail_add_l1,
                    sql1.su_mail_add_l2, sql1.su_mail_add_l3,
                    sql1.su_mail_add_city, sql1.su_mail_add_postal,
                    sql1.su_mail_add_district, sql1.su_mail_add_province,
                    sql1.su_mail_add_country, sql1.su_mail_p_add_l1,
                    sql1.su_mail_p_add_l2, sql1.su_mail_p_add_l3,
                    sql1.su_mail_p_add_city, sql1.su_mail_p_add_postal,
                    sql1.su_mail_p_add_district, sql1.su_mail_p_add_province,
                    sql1.su_mail_p_add_country, sql1.su_tel_city_code,
                    sql1.su_home_telephone, sql1.su_mobile_telephone,
                    sql1.su_email_add, sql1.su_birth_date, sql1.su_gender,
                    sql1.su_marital_status, sql1.su_spouse_name
               FROM (SELECT UNIQUE ('CNCS') su_segment_id,
                                   (u.ucm_provid) su_data_prov_id,
                                   (SUBSTR (c.con_no, 0, 2)
                                   ) su_data_prov_brn_id,
                                   (c.con_no) su_cr_facility_no,
                                   (cli.clm_code) su_sub_id_no,
                                   (cli.clm_alclcode) su_pre_sub_id_no,
                                   (cli.clm_idno) su_nic_no,
                                   (NULL) su_pre_nic_no,
                                   (DECODE (REPLACE (UPPER (cli.clm_national),
                                                     ' ',
                                                     ''
                                                    ),
                                            'SRILANKAN', '001',
                                            '002'
                                           )
                                   ) su_citizenship,
                                   (cli.clm_pp_no) su_passport_no,
                                   (cli.clm_drvlno) su_drv_licence_no,
                                   (DECODE (REPLACE (UPPER (cli.clm_cltitle),
                                                     '.',
                                                     ''
                                                    ),
                                            'MR', '001',
                                            'MRS', '002',
                                            'MISS', '003',
                                            'REV', '004',
                                            '999'
                                           )
                                   ) su_sub_salutation,
                                   (cli.clm_initialsfull) su_sub_name,
                                   (NULL) su_pre_sub_name,
                                   (DECODE (REPLACE (UPPER (cli.clm_emplyd),
                                                     ' ',
                                                     ''
                                                    ),
                                            'SALARIED', '001',
                                            'SELFEMPLOYED', '002',
                                            '003'
                                           )
                                   ) su_employment,
                                   (NULL) su_profession, (NULL) su_employer,
                                   (clm_naturbuss) su_business_name,
                                   (clm_corrno) su_busi_reg_no,
                                   (NULL) su_busi_reg_date,
                                   (NVL2 (cli.clm_mailaddline4,
                                          (   cli.clm_mailaddline1
                                           || ' '
                                           || cli.clm_mailaddline2
                                           || ' '
                                           || cli.clm_mailaddline3
                                           || ' '
                                           || cli.clm_mailaddline4
                                          ),
                                          cli.clm_mailaddline1
                                         )
                                   ) su_mail_add_l1,
                                   (NVL2 (cli.clm_mailaddline4,
                                          NULL,
                                          clm_mailaddline2
                                         )
                                   ) su_mail_add_l2,
                                   (NVL2 (cli.clm_mailaddline4,
                                          NULL,
                                          clm_mailaddline3
                                         )
                                   ) su_mail_add_l3,
                                   (NVL2 (cli.clm_mailaddline4,
                                          cli.clm_mailaddline4,
                                          clm_mailaddline3
                                         )
                                   ) su_mail_add_city,
                                   (cli.clm_mailpsccode) su_mail_add_postal,
                                   (dist.dst_cribcode) su_mail_add_district,
                                   (p.prv_cribcode) su_mail_add_province,
                                   ('001') su_mail_add_country,
                                   (NVL2 (cli.clm_permaddline4,
                                          (   cli.clm_permaddline1
                                           || ' '
                                           || cli.clm_permaddline2
                                           || ' '
                                           || cli.clm_permaddline3
                                           || ' '
                                           || cli.clm_permaddline4
                                          ),
                                          cli.clm_permaddline1
                                         )
                                   ) su_mail_p_add_l1,
                                   (NVL2 (cli.clm_permaddline4,
                                          NULL,
                                          cli.clm_permaddline2
                                         )
                                   ) su_mail_p_add_l2,
                                   (NVL2 (cli.clm_permaddline4,
                                          NULL,
                                          cli.clm_permaddline3
                                         )
                                   ) su_mail_p_add_l3,
                                   (NVL2 (cli.clm_permaddline4,
                                          cli.clm_permaddline4,
                                          cli.clm_permaddline3
                                         )
                                   ) su_mail_p_add_city,
                                   (cli.clm_permpsccode
                                   ) su_mail_p_add_postal,
                                   (dist1.dst_cribcode
                                   ) su_mail_p_add_district,
                                   (p1.prv_cribcode) su_mail_p_add_province,
                                   ('001') su_mail_p_add_country,
                                   (NULL) su_tel_city_code,
                                   (cli.clm_hometpno) su_home_telephone,
                                   (cli.clm_mobileno) su_mobile_telephone,
                                   (cli.clm_email) su_email_add,
                                   (cli.clm_brdate) su_birth_date,
                                   (DECODE (UPPER (cli.clm_sex),
                                            'MALE', '001',
                                            'FEMALE', '002'
                                           )
                                   ) su_gender,
                                   (DECODE (UPPER (cli.clm_marists),
                                            'MARRIED', '001',
                                            'SINGLE', '002'
                                           )
                                   ) su_marital_status,
                                   (NULL) su_spouse_name, (0) tflag
                              FROM corpinfo.tblusercompany u,
                                   corpinfo.tblclientmain cli,
                                   leaseinfo.tblcontracts c,
                                   corpinfo.tbldistrict dist,
                                   corpinfo.tbldistrict dist1,
                                   corpinfo.tblprovince p,
                                   corpinfo.tblprovince p1,
                                   corpinfo.tblpostalcode ps,
                                   corpinfo.tblpostalcode ps1,
                                   leaseinfo.tblclosure clo
                             WHERE cli.clm_code = c.con_clmcode
                               AND dist.dst_code(+) = cli.clm_maildstcode
                               AND p.prv_code(+) = cli.clm_mailprvcode
                               AND dist1.dst_code(+) = cli.clm_permdstcode
                               AND p1.prv_code(+) = cli.clm_permprvcode
                               AND ps.psc_prvcode(+) = cli.clm_mailprvcode
                               AND ps.psc_dstcode(+) = cli.clm_maildstcode
                               AND ps.psc_code(+) = cli.clm_mailpsccode
                               AND ps1.psc_prvcode(+) = cli.clm_permprvcode
                               AND ps1.psc_dstcode(+) = cli.clm_permdstcode
                               AND ps1.psc_code(+) = cli.clm_permpsccode
                               AND c.con_no = clo.clo_oldconno(+)
                               AND cli.clm_cori = 1
                               AND (DECODE (c.con_sts,
                                            'A', '001',
                                            'L', '001',
                                            'F', '001',
                                            'T', '008',
                                            'C', DECODE (clo.clo_ctptype,
                                                         '1', '005',
                                                         '9', '009',
                                                         '3', '006',
                                                         '2', '007'
                                                        )
                                           )
                                   ) IS NOT NULL
                               AND c.con_date <= strprocessdate
                               AND c.con_execdate <= strprocessdate
                               AND NOT LENGTH (cli.clm_idno) > 16
                     UNION ALL
                     SELECT UNIQUE ('CNCS') su_segment_id,
                                   (u.ucm_provid) su_data_prov_id,
                                   (SUBSTR (c.con_no, 0, 2)
                                   ) su_data_prov_brn_id,
                                   (c.con_no) su_cr_facility_no,
                                   (cli.clm_code) su_sub_id_no,
                                   (cli.clm_alclcode) su_pre_sub_id_no,
                                   (cli.clm_idno) su_nic_no,
                                   (NULL) su_pre_nic_no,
                                   (DECODE (REPLACE (UPPER (cli.clm_national),
                                                     ' ',
                                                     ''
                                                    ),
                                            'SRILANKAN', '001',
                                            '002'
                                           )
                                   ) su_citizenship,
                                   (cli.clm_pp_no) su_passport_no,
                                   (cli.clm_drvlno) su_drv_licence_no,
                                   (DECODE (REPLACE (UPPER (cli.clm_cltitle),
                                                     '.',
                                                     ''
                                                    ),
                                            'MR', '001',
                                            'MRS', '002',
                                            'MISS', '003',
                                            'REV', '004',
                                            '999'
                                           )
                                   ) su_sub_salutation,
                                   (cli.clm_initialsfull) su_sub_name,
                                   (NULL) su_pre_sub_name,
                                   (DECODE (REPLACE (UPPER (cli.clm_emplyd),
                                                     ' ',
                                                     ''
                                                    ),
                                            'SALARIED', '001',
                                            'SELFEMPLOYED', '002',
                                            '003'
                                           )
                                   ) su_employment,
                                   (NULL) su_profession, (NULL) su_employer,
                                   (clm_naturbuss) su_business_name,
                                   (clm_corrno) su_busi_reg_no,
                                   (NULL) su_busi_reg_date,
                                   (NVL2 (cli.clm_mailaddline4,
                                          (   cli.clm_mailaddline1
                                           || ' '
                                           || cli.clm_mailaddline2
                                           || ' '
                                           || cli.clm_mailaddline3
                                           || ' '
                                           || cli.clm_mailaddline4
                                          ),
                                          cli.clm_mailaddline1
                                         )
                                   ) su_mail_add_l1,
                                   (NVL2 (cli.clm_mailaddline4,
                                          NULL,
                                          clm_mailaddline2
                                         )
                                   ) su_mail_add_l2,
                                   (NVL2 (cli.clm_mailaddline4,
                                          NULL,
                                          clm_mailaddline3
                                         )
                                   ) su_mail_add_l3,
                                   (NVL2 (cli.clm_mailaddline4,
                                          cli.clm_mailaddline4,
                                          clm_mailaddline3
                                         )
                                   ) su_mail_add_city,
                                   (cli.clm_mailpsccode) su_mail_add_postal,
                                   (dist.dst_cribcode) su_mail_add_district,
                                   (p.prv_cribcode) su_mail_add_province,
                                   ('001') su_mail_add_country,
                                   (NVL2 (cli.clm_permaddline4,
                                          (   cli.clm_permaddline1
                                           || ' '
                                           || cli.clm_permaddline2
                                           || ' '
                                           || cli.clm_permaddline3
                                           || ' '
                                           || cli.clm_permaddline4
                                          ),
                                          cli.clm_permaddline1
                                         )
                                   ) su_mail_p_add_l1,
                                   (NVL2 (cli.clm_permaddline4,
                                          NULL,
                                          cli.clm_permaddline2
                                         )
                                   ) su_mail_p_add_l2,
                                   (NVL2 (cli.clm_permaddline4,
                                          NULL,
                                          cli.clm_permaddline3
                                         )
                                   ) su_mail_p_add_l3,
                                   (NVL2 (cli.clm_permaddline4,
                                          cli.clm_permaddline4,
                                          cli.clm_permaddline3
                                         )
                                   ) su_mail_p_add_city,
                                   (cli.clm_permpsccode
                                   ) su_mail_p_add_postal,
                                   (dist1.dst_cribcode
                                   ) su_mail_p_add_district,
                                   (p1.prv_cribcode) su_mail_p_add_province,
                                   ('001') su_mail_p_add_country,
                                   (NULL) su_tel_city_code,
                                   (cli.clm_hometpno) su_home_telephone,
                                   (cli.clm_mobileno) su_mobile_telephone,
                                   (cli.clm_email) su_email_add,
                                   (cli.clm_brdate) su_birth_date,
                                   (DECODE (UPPER (cli.clm_sex),
                                            'MALE', '001',
                                            'FEMALE', '002'
                                           )
                                   ) su_gender,
                                   (DECODE (UPPER (cli.clm_marists),
                                            'MARRIED', '001',
                                            'SINGLE', '002'
                                           )
                                   ) su_marital_status,
                                   (NULL) su_spouse_name, (1) tflag
                              FROM corpinfo.tblusercompany u,
                                   corpinfo.tblclientmain cli,
                                   leaseinfo.tblcontracts c,
                                   corpinfo.tbljoinclient j,
                                   corpinfo.tbldistrict dist,
                                   corpinfo.tbldistrict dist1,
                                   corpinfo.tblprovince p,
                                   corpinfo.tblprovince p1,
                                   corpinfo.tblpostalcode ps,
                                   corpinfo.tblpostalcode ps1,
                                   leaseinfo.tblclosure clo
                             WHERE c.con_appno = j.jcl_appno
                               AND cli.clm_code = j.jcl_joinclient
                               AND dist.dst_code(+) = cli.clm_maildstcode
                               AND p.prv_code(+) = cli.clm_mailprvcode
                               AND dist1.dst_code(+) = cli.clm_permdstcode
                               AND p1.prv_code(+) = cli.clm_permprvcode
                               AND ps.psc_prvcode(+) = cli.clm_mailprvcode
                               AND ps.psc_dstcode(+) = cli.clm_maildstcode
                               AND ps.psc_code(+) = cli.clm_mailpsccode
                               AND ps1.psc_prvcode(+) = cli.clm_permprvcode
                               AND ps1.psc_dstcode(+) = cli.clm_permdstcode
                               AND ps1.psc_code(+) = cli.clm_permpsccode
                               AND c.con_no = clo.clo_oldconno(+)
                               AND cli.clm_cori = 1
                               AND (DECODE (c.con_sts,
                                            'A', '001',
                                            'L', '001',
                                            'F', '001',
                                            'T', '008',
                                            'C', DECODE (clo.clo_ctptype,
                                                         '1', '005',
                                                         '9', '009',
                                                         '3', '006',
                                                         '2', '007'
                                                        )
                                           )
                                   ) IS NOT NULL
                               AND c.con_date <= strprocessdate
                               AND c.con_execdate <= strprocessdate
                               AND NOT LENGTH (cli.clm_idno) > 16) sql1;

   --Security
   INSERT INTO leaseinfo.tbl_con_cribsecurity
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribsecurity a
        WHERE a.sc_nature_of_data = '001');

   DELETE FROM corrsql.tbl_con_cribsecurity
         WHERE sc_nature_of_data = '001';

   INSERT INTO leaseinfo.tbl_con_cribsecurity_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribsecurity_error a
        WHERE a.sc_nature_of_data = '001');

   DELETE FROM corrsql.tbl_con_cribsecurity_error
         WHERE sc_nature_of_data = '001';
-- Modified By Modular4 Solution to Commonize all security code according to the CRIB Requirment 
   INSERT INTO corrsql.tbl_con_cribsecurity
      SELECT UNIQUE ('CNSS'), (u.ucm_provid), (SUBSTR (c.con_no, 0, 2)),
                    (c.con_no),
                    (SELECT Z.SEC_CRIB_CODE FROM CORPINFO.TBLSECURITYTYPE Z WHERE Z.SEC_CODE = f.fsd_seccode),
                    ('002'), (TO_CHAR (f.fsd_lastupdate, 'DD-MON-YYYY')),
                    (f.fsd_serno), (e.eqd_regno),
                    (NVL2 (e.eqd_regno, '003', '999')), (e.eqd_chassno),
                    (NVL2 (e.eqd_chassno, '004', '999')), (e.eqd_engno),
                    (NVL2 (e.eqd_engno, '005', '999')), (mk.mak_desc),
                    (md.mdl_desc), ('001')
               FROM corpinfo.tblusercompany u,
                    leaseinfo.tblcontracts c,
                    corpinfo.tblclientmain cli,
                    corpinfo.tblfacsecdetails f,
                    leaseinfo.tblclosure clo,
                    leaseinfo.tblequipmentdetails e,
                    leaseinfo.tbltrialequipment te,
                    leaseinfo.tblmake mk,
                    leaseinfo.tblmodel md
              WHERE c.con_clmcode = cli.clm_code
                AND c.con_no = f.fsd_conno
                AND c.con_no = clo.clo_oldconno(+)
                AND c.con_no = e.eqd_conno
                AND f.fsd_conno = te.teq_conno
                AND te.teq_eqttype = mk.mak_eqttype
                AND te.teq_make = mk.mak_code
                AND te.teq_eqttype = md.mdl_eqttype
                AND te.teq_model = md.mdl_code
                AND f.fsd_seccode != 'PGRE'
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND cli.clm_cori = 1
                AND c.con_date <= strprocessdate
                AND c.con_execdate <= strprocessdate ;

   --Gurrentor
   INSERT INTO leaseinfo.tbl_con_cribguarantor
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribguarantor a
        WHERE a.ga_nature_of_data = '001');

   DELETE FROM corrsql.tbl_con_cribguarantor
         WHERE ga_nature_of_data = '001';

   INSERT INTO leaseinfo.tbl_con_cribguarantor_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribguarantor_error a
        WHERE a.ga_nature_of_data = '001');

   DELETE FROM corrsql.tbl_con_cribguarantor_error
         WHERE ga_nature_of_data = '001';

   INSERT INTO corrsql.tbl_con_cribguarantor
      SELECT UNIQUE ('CNGS'), (u.ucm_provid), (SUBSTR (c.con_no, 0, 2)),
                    (c.con_no), (cli.clm_code), (cli.clm_alclcode),
                    (DECODE (cli.clm_cori, '1', '002', '2', '001')),
                    (DECODE (cli.clm_cori, '1', cli.clm_idno, NULL)), (NULL),
                    (DECODE (REPLACE (UPPER (cli.clm_national), ' ', ''),
                             'SRILANKAN', '001',
                             '002'
                            )
                    ),
                    (cli.clm_pp_no), (cli.clm_drvlno),
                    (DECODE (REPLACE (UPPER (cli.clm_cltitle), '.', ''),
                             'MR', '001',
                             'MRS', '002',
                             'MISS', '003',
                             'REV', '004',
                             '999'
                            )
                    ),
                    (cli.clm_initialsfull), (NULL), (cli.clm_brdate),
                    (DECODE (UPPER (cli.clm_sex),
                             'MALE', '001',
                             'FEMALE', '002'
                            )
                    ),
                    (DECODE (UPPER (cli.clm_marists),
                             'MARRIED', '001',
                             'SINGLE', '002'
                            )
                    ),
                    (REPLACE (DECODE (cli.clm_cori, '2', cli.clm_idno, ' '),
                              ' ',
                              ''
                             )
                    ),
                    (NULL), (cli.clm_taxregno),
                    (DECODE (cli.clm_cori, '2', cli.clm_name, NULL)), (NULL),
                    (NULL),
                    (NVL2 (cli.clm_mailaddline4,
                           (   cli.clm_mailaddline1
                            || ' '
                            || cli.clm_mailaddline2
                            || ' '
                            || cli.clm_mailaddline3
                            || ' '
                            || cli.clm_mailaddline4
                           ),
                           cli.clm_permaddline1
                          )
                    ),
                    (NVL2 (cli.clm_mailaddline4, NULL, cli.clm_mailaddline2)
                    ),
                    (NVL2 (cli.clm_mailaddline4, NULL, cli.clm_mailaddline3)
                    ),
                    (NVL2 (cli.clm_mailaddline4,
                           cli.clm_mailaddline4,
                           cli.clm_mailaddline3
                          )
                    ),
                    (cli.clm_mailpsccode), (dist.dst_cribcode),
                    (p.prv_cribcode), ('001'),
                    (NVL2 (cli.clm_permaddline4,
                           (   cli.clm_permaddline1
                            || ' '
                            || cli.clm_permaddline2
                            || ' '
                            || cli.clm_permaddline3
                            || ' '
                            || cli.clm_permaddline4
                           ),
                           cli.clm_permaddline1
                          )
                    ),
                    (NVL2 (cli.clm_permaddline4, NULL, cli.clm_permaddline2)
                    ),
                    (NVL2 (cli.clm_permaddline4, NULL, cli.clm_permaddline3)
                    ),
                    (NVL2 (cli.clm_permaddline4,
                           cli.clm_permaddline4,
                           cli.clm_permaddline3
                          )
                    ),
                    (cli.clm_permpsccode), (dist1.dst_cribcode),
                    (p1.prv_cribcode), ('001'), (NULL), (cli.clm_hometpno),
                    (cli.clm_mobileno), (cli.clm_faxno), (cli.clm_email),
                    (NULL), ('001')
               FROM corpinfo.tblusercompany u,
                    corpinfo.tblfacsecdetails g,
                    corpinfo.tblclientmain cli,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbldistrict dist,
                    corpinfo.tbldistrict dist1,
                    corpinfo.tblprovince p,
                    corpinfo.tblprovince p1,
                    corpinfo.tblpostalcode ps,
                    corpinfo.tblpostalcode ps1
              WHERE g.fsd_clmcode = c.con_clmcode
                AND c.con_appno = g.fsd_appno
                AND cli.clm_code = g.fsd_gurcode
                AND TO_NUMBER (dist.dst_code(+)) =
                                               TO_NUMBER (cli.clm_maildstcode)
                AND TO_NUMBER (p.prv_code(+)) =
                                               TO_NUMBER (cli.clm_mailprvcode)
                AND TO_NUMBER (dist1.dst_code(+)) =
                                               TO_NUMBER (cli.clm_permdstcode)
                AND TO_NUMBER (p1.prv_code(+)) =
                                               TO_NUMBER (cli.clm_permprvcode)
                AND TO_NUMBER (ps.psc_prvcode(+)) =
                                               TO_NUMBER (cli.clm_mailprvcode)
                AND TO_NUMBER (ps.psc_dstcode(+)) =
                                               TO_NUMBER (cli.clm_maildstcode)
                AND TO_NUMBER (ps.psc_code(+)) =
                                               TO_NUMBER (cli.clm_mailpsccode)
                AND TO_NUMBER (ps1.psc_prvcode(+)) =
                                               TO_NUMBER (cli.clm_permprvcode)
                AND TO_NUMBER (ps1.psc_dstcode(+)) =
                                               TO_NUMBER (cli.clm_permdstcode)
                AND TO_NUMBER (ps1.psc_code(+)) =
                                               TO_NUMBER (cli.clm_permpsccode)
                AND UPPER (g.fsd_seccode) = 'PGRE'
                AND g.fsd_gurcode IS NOT NULL
                AND cli.clm_cori = 1
                AND c.con_date <= strprocessdate
                AND c.con_execdate <= strprocessdate;

   --Update Trailer
   UPDATE corrsql.tbl_crib_trailer
      SET cribt_num_cr_facility = '0'
    WHERE cribt_nature_data = '001';

--------------------------------**************************************************************----------------------------------------

   --Header Segmen
   UPDATE corrsql.tbl_crib_header
      SET cribh_dt_preparation = strprocessdate,
          cribh_report_date = strprocessdate,
          cribh_report_time = TO_CHAR (SYSDATE, 'HHMISS')
    WHERE cribh_nature_data = '002';

   --Facility Segment
   INSERT INTO leaseinfo.tbl_com_cribfacility
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_com_cribfacility a);

   DELETE FROM corrsql.tbl_com_cribfacility;

   INSERT INTO leaseinfo.tbl_com_cribfacility_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_com_cribfacility_error a);

   DELETE FROM corrsql.tbl_com_cribfacility_error;

   -- Corporate Facility SQL
   INSERT INTO corrsql.tbl_com_cribfacility
      SELECT UNIQUE ('CMCF'), (TO_CHAR (u.ucm_provid)), (NULL),
                    (TO_CHAR (SUBSTR (c.con_no, 0, 2))), (NULL),
                    (TO_CHAR (c.con_no)), (c.con_manualno), (c.con_grcconno),
                    (TRUNC (NVL (g.grc_facamt, 0), 0)),
                    (CASE
                        WHEN c.con_execdate > po.pro_date
                           THEN TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (c.con_execdate, 'DD-MON-YYYY')
                     END
                    ),
                    (TRUNC (NVL (c.con_contamt, 0), 0)), (NULL), ('LKR'),
                    (NVL2 (j.jcl_appno, '002', '001')), (p.prd_cribcode),
                    (TO_CHAR (NVL (s.ssc_cribocde, '09:01:001'))),
                    (c.con_period), (TRUNC (NVL (c.CON_GROSSRNTAMT, 0), 0)),
                    (DECODE (c.con_rntfreq, 'M', '005', 'ERR')),
                    (CASE
                        WHEN po.pro_date > rec.rec_date
                           THEN TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (po.pro_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (  (  NVL (d.dls_fucap, 0)
                                       + NVL (d.dls_fuint, 0)
                                       + NVL (d.dls_futax, 0)
                                       + NVL (d.dls_futax1, 0)
                                       + NVL (d.dls_arrcap, 0)
                                       + NVL (d.dls_arrint, 0)
                                       + NVL (d.dls_arrtax, 0)
                                       + NVL (d.dls_arrtax1, 0)
                                       + NVL (d.dls_othout, 0)
                                       + NVL (d.dls_odiout, 0)
                                      )
                                    - NVL (d.dls_overpay, 0),
                                    0
                                   )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (d.dls_fuint, 0), 0)
                            )
                    ),
                    (DECODE (DECODE (clo.clo_ctptype,
                                     '2', 0,
                                     TRUNC (NVL (arr.arr_amt, 0), 0)
                                    ),
                             0, 0,
                             NVL (TRUNC (  TO_DATE (strprocessdate)
                                         - TO_DATE (rec.rec_date),
                                         0
                                        ),
                                  0
                                 )
                            )
                    ),
                    (DECODE (clo.clo_ctptype,
                             '2', 0,
                             TRUNC (NVL (arr.arr_amt, 0), 0)
                            )
                    ),
                    (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ),
                    (CASE
                        WHEN rec.rec_date > clo.clo_date
                           THEN TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                        ELSE TO_CHAR (rec.rec_date, 'DD-MON-YYYY')
                     END
                    ),
                    (DECODE (clo.clo_ctptype,
                             '3', TO_CHAR (clo.clo_date, 'DD-MON-YYYY'),
                             NULL
                            )
                    ),
                    (NULL),
                    (DECODE (clo.clo_ctptype,
                             '3', NULL,
                             TO_CHAR (clo.clo_date, 'DD-MON-YYYY')
                            )
                    ),
                    (DECODE (c.con_sts, 'L', '001', NULL)), (NULL), (NULL),
                    (CASE
                        WHEN NVL (gr.secvalue, 0) > NVL (c.con_contamt, 0)
                           THEN '001'
                        WHEN NVL (gr.secvalue, 0) = NVL (c.con_contamt, 0)
                           THEN '002'
                        WHEN NVL (gr.secvalue, 0) < NVL (c.con_contamt, 0)
                           THEN '003'
                        ELSE '999'
                     END
                    ),
                    ('002'), ('001'), (NULL)
               FROM corpinfo.tblusercompany u,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbljoinclient j,
                    corpinfo.tblclientmain cli,
                    corpinfo.tblsubsector s,
                    glinfo.tbldailysummary d,
                    leaseinfo.tblclosure clo,
                    leaseinfo.tblgroupcontracts g,
                    corpinfo.tblproduct p,
                    leaseinfo.tblpurchaseorder  po,
                    (SELECT   a.fsd_conno, MAX (a.fsd_secval) secvalue
                         FROM corpinfo.tblfacsecdetails a
                     GROUP BY a.fsd_conno) gr/*,
                    (SELECT   p.pro_conno, MIN (TO_DATE (p.pro_date))
                                                                     pro_date
                         FROM leaseinfo.tblpurchaseorder p
                     GROUP BY p.pro_conno
                       HAVING MIN (TO_DATE (p.pro_date)) <= strprocessdate) po*/,
                    (SELECT   a.dfc_conno, SUM (NVL (dfc_balamt, 0)) arr_amt
                         FROM glinfo.tblduefromclient a
                        WHERE dfc_duedte <= strprocessdate AND dfc_balamt > 0
                     GROUP BY a.dfc_conno) arr,
                    (SELECT   a.rsm_conno, MAX (a.rsm_stlddate) rec_date
                         FROM glinfo.tblreceiptssettlement a
                        WHERE a.rsm_stlddate <= strprocessdate
                     GROUP BY a.rsm_conno) rec
              WHERE cli.clm_code = c.con_clmcode
                AND c.con_appno = j.jcl_appno(+)
                AND SUBSTR (cli.clm_seccode, 4, 3) = s.ssc_code(+)
                AND SUBSTR (cli.clm_seccode, 1, 3) = s.ssc_seccode(+)
                AND c.con_no = d.dls_conno
                AND c.con_no = g.grc_conno(+)
                AND c.con_no = po.pro_conno(+)
                AND c.con_no = clo.clo_oldconno(+)
                AND c.con_no = gr.fsd_conno(+)
                AND c.con_no = arr.dfc_conno(+)
                AND c.con_no = rec.rsm_conno(+)
                AND SUBSTR (c.con_no, 3, 2) = p.prd_code
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND cli.clm_cori = '2'
                AND c.con_execdate <= strprocessdate
                AND c.con_date <= strprocessdate ;
               /* AND NVL (c.con_freezdate, strprocessdate) >=
                                        TRUNC (TO_DATE (strprocessdate), 'MM')*/

--Subject Segment
   INSERT INTO leaseinfo.tbl_com_cribsubject
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_com_cribsubject a);

   DELETE FROM corrsql.tbl_com_cribsubject;

   INSERT INTO leaseinfo.tbl_com_cribsubject_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_com_cribsubject_error a);

   DELETE FROM corrsql.tbl_com_cribsubject_error;

   INSERT INTO corrsql.tbl_com_cribsubject
      SELECT UNIQUE ('CMCS'), (TO_CHAR (u.ucm_provid)),
                    (TO_CHAR (SUBSTR (c.con_no, 0, 2))),
                    (TO_CHAR (c.con_no)), (cli.clm_code), (cli.clm_alclcode),
                    (cli.clm_idno), (NULL), (NULL), (cli.clm_taxregno),
                    (NVL (TO_CHAR (ct.cmt_cribcode), '999')),
                    (NVL (s.ssc_cribocde, '09:01:001')), (NULL), (NULL),
                    (TO_CHAR (cli.clm_name)), (NULL), (NULL), (NULL),
                    (NVL2 (cli.clm_mailaddline4,
                           (   cli.clm_mailaddline1
                            || ' '
                            || cli.clm_mailaddline2
                            || ' '
                            || cli.clm_mailaddline3
                            || ' '
                            || cli.clm_mailaddline4
                           ),
                           cli.clm_mailaddline1
                          )
                    ),
                    (NVL2 (cli.clm_mailaddline4, NULL, clm_mailaddline2)),
                    (NVL2 (cli.clm_mailaddline4, NULL, clm_mailaddline3)),
                    (NVL2 (cli.clm_mailaddline4,
                           cli.clm_mailaddline4,
                           clm_mailaddline3
                          )
                    ),
                    (cli.clm_mailpsccode), (dist.dst_cribcode),
                    (p.prv_cribcode), ('001'),
                    (NVL2 (cli.clm_permaddline4,
                           (   cli.clm_permaddline1
                            || ' '
                            || cli.clm_permaddline2
                            || ' '
                            || cli.clm_permaddline3
                            || ' '
                            || cli.clm_permaddline4
                           ),
                           cli.clm_permaddline1
                          )
                    ),
                    (NVL2 (cli.clm_permaddline4, NULL, cli.clm_permaddline2)
                    ),
                    (NVL2 (cli.clm_permaddline4, NULL, cli.clm_permaddline3)
                    ),
                    (NVL2 (cli.clm_permaddline4,
                           cli.clm_permaddline4,
                           cli.clm_permaddline3
                          )
                    ),
                    (cli.clm_permpsccode), (dist1.dst_cribcode),
                    (p1.prv_cribcode), ('001'), (NULL), (cli.clm_hometpno),
                    (cli.clm_faxno), (NULL)
               FROM corpinfo.tblusercompany u,
                    corpinfo.tblclientmain cli,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbldistrict dist,
                    corpinfo.tbldistrict dist1,
                    corpinfo.tblprovince p,
                    corpinfo.tblprovince p1,
                    corpinfo.tblpostalcode ps,
                    corpinfo.tblpostalcode ps1,
                    corpinfo.tblcompanytype ct,
                    corpinfo.tblsubsector s,
                    leaseinfo.tblclosure clo
              WHERE cli.clm_code = c.con_clmcode
                AND TO_CHAR (dist.dst_code(+)) = cli.clm_maildstcode
                AND p.prv_code(+) = cli.clm_mailprvcode
                AND dist1.dst_code(+) = cli.clm_permdstcode
                AND p1.prv_code(+) = cli.clm_permprvcode
                AND ps.psc_prvcode(+) = cli.clm_mailprvcode
                AND ps.psc_dstcode(+) = cli.clm_maildstcode
                AND ps.psc_code(+) = cli.clm_mailpsccode
                AND ps1.psc_prvcode(+) = cli.clm_permprvcode
                AND ps1.psc_dstcode(+) = cli.clm_permdstcode
                AND ps1.psc_code(+) = cli.clm_permpsccode
                AND cli.clm_comtype = TO_CHAR (ct.cmt_type(+))
                AND SUBSTR (cli.clm_seccode, 4, 3) = s.ssc_code(+)
                AND SUBSTR (cli.clm_seccode, 1, 3) = s.ssc_seccode(+)
                AND c.con_no = clo.clo_oldconno(+)
                AND cli.clm_cori = '2'
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND c.con_execdate <= strprocessdate
                AND c.con_date <= strprocessdate;

   --Security Segment
   INSERT INTO leaseinfo.tbl_con_cribsecurity
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribsecurity a
        WHERE a.sc_nature_of_data = '002');

   DELETE FROM corrsql.tbl_con_cribsecurity
         WHERE sc_nature_of_data = '002';

   INSERT INTO leaseinfo.tbl_con_cribsecurity_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribsecurity_error a
        WHERE a.sc_nature_of_data = '002');

   DELETE FROM corrsql.tbl_con_cribsecurity_error
         WHERE sc_nature_of_data = '002';
       --Naleen cheking
       --Modified By Modular4 Solution to Commonize all security code according to the CRIB Requirment 
   INSERT INTO corrsql.tbl_con_cribsecurity
      SELECT UNIQUE ('CMSS'), (TO_CHAR (u.ucm_provid)),
                    (TO_CHAR (SUBSTR (c.con_no, 0, 2))),
                    (TO_CHAR (c.con_no)),
                    (SELECT Z.SEC_CRIB_CODE FROM CORPINFO.TBLSECURITYTYPE Z WHERE Z.SEC_CODE = f.fsd_seccode),
                    ('002'), (TO_CHAR (f.fsd_lastupdate, 'DD-MON-YYYY')),
                    (f.fsd_serno), (e.eqd_regno),
                    (NVL2 (e.eqd_regno, '003', '999')), (e.eqd_chassno),
                    (NVL2 (e.eqd_chassno, '004', '999')), (e.eqd_engno),
                    (NVL2 (e.eqd_engno, '005', '999')), (mk.mak_desc),
                    (md.mdl_desc), ('002')
               FROM corpinfo.tblusercompany u,
                    leaseinfo.tblcontracts c,
                    corpinfo.tblclientmain cli,
                    corpinfo.tblfacsecdetails f,
                    leaseinfo.tblclosure clo,
                    leaseinfo.tblequipmentdetails e,
                    leaseinfo.tbltrialequipment te,
                    leaseinfo.tblmake mk,
                    leaseinfo.tblmodel md
              WHERE cli.clm_cori = '2'
                AND c.con_clmcode = cli.clm_code
                AND c.con_no = f.fsd_conno
                AND c.con_no = clo.clo_oldconno(+)
                AND c.con_no = e.eqd_conno
                AND f.fsd_conno = te.teq_conno
                AND te.teq_eqttype = mk.mak_eqttype
                AND te.teq_make = mk.mak_code
                AND te.teq_eqttype = md.mdl_eqttype
                AND te.teq_model = md.mdl_code
                AND f.fsd_seccode != 'PGRE'
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND c.con_execdate <= strprocessdate
                AND c.con_date <= strprocessdate;

   INSERT INTO leaseinfo.tbl_con_cribguarantor
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribguarantor a
        WHERE a.ga_nature_of_data = '002');

   DELETE FROM corrsql.tbl_con_cribguarantor
         WHERE ga_nature_of_data = '002';

   INSERT INTO leaseinfo.tbl_con_cribguarantor_error
      (SELECT a.*, strprocessdate
         FROM corrsql.tbl_con_cribguarantor_error a
        WHERE a.ga_nature_of_data = '002');

   DELETE FROM corrsql.tbl_con_cribguarantor_error
         WHERE ga_nature_of_data = '002';

   INSERT INTO corrsql.tbl_con_cribguarantor
      SELECT UNIQUE ('CMGS'), (TO_CHAR (u.ucm_provid)),
                    (TO_CHAR (SUBSTR (c.con_no, 0, 2))),
                    (TO_CHAR (c.con_no)), (cli.clm_code), (cli.clm_alclcode),
                    (DECODE (TO_CHAR (cli.clm_cori), '1', '002', '2', '001')
                    ),
                    (TO_CHAR (cli.clm_idno)), (NULL),
                    (DECODE (REPLACE (UPPER (cli.clm_national), ' ', ''),
                             'SRILANKAN', '001',
                             '002'
                            )
                    ),
                    (cli.clm_pp_no), (cli.clm_drvlno),
                    (DECODE (REPLACE (UPPER (cli.clm_cltitle), '.', ''),
                             'MR', '001',
                             'MRS', '002',
                             'MISS', '003',
                             'REV', '004',
                             '999'
                            )
                    ),
                    (cli.clm_initialsfull), (NULL), (cli.clm_brdate),
                    (DECODE (UPPER (cli.clm_sex),
                             'MALE', '001',
                             'FEMALE', '002'
                            )
                    ),
                    (DECODE (UPPER (cli.clm_marists),
                             'MARRIED', '001',
                             'SINGLE', '002'
                            )
                    ),
                    (cli.clm_corrno), (NULL), (cli.clm_taxregno),
                    (DECODE (cli.clm_cori, '2', cli.clm_name, NULL)), (NULL),
                    (NULL),
                    (NVL2 (cli.clm_mailaddline4,
                           (   cli.clm_mailaddline1
                            || ' '
                            || cli.clm_mailaddline2
                            || ' '
                            || cli.clm_mailaddline3
                            || ' '
                            || cli.clm_mailaddline4
                           ),
                           cli.clm_permaddline1
                          )
                    ),
                    (NVL2 (cli.clm_mailaddline4, NULL, cli.clm_mailaddline2)
                    ),
                    (NVL2 (cli.clm_mailaddline4, NULL, cli.clm_mailaddline3)
                    ),
                    (NVL2 (cli.clm_mailaddline4,
                           cli.clm_mailaddline4,
                           cli.clm_mailaddline3
                          )
                    ),
                    (cli.clm_mailpsccode), (dist.dst_cribcode),
                    (p.prv_cribcode), ('001'),
                    (NVL2 (cli.clm_permaddline4,
                           (   cli.clm_permaddline1
                            || ' '
                            || cli.clm_permaddline2
                            || ' '
                            || cli.clm_permaddline3
                            || ' '
                            || cli.clm_permaddline4
                           ),
                           cli.clm_permaddline1
                          )
                    ),
                    (NVL2 (cli.clm_permaddline4, NULL, cli.clm_permaddline2)
                    ),
                    (NVL2 (cli.clm_permaddline4, NULL, cli.clm_permaddline3)
                    ),
                    (NVL2 (cli.clm_permaddline4,
                           cli.clm_permaddline4,
                           cli.clm_permaddline3
                          )
                    ),
                    (cli.clm_permpsccode), (dist1.dst_cribcode),
                    (p1.prv_cribcode), ('001'), (NULL), (cli.clm_hometpno),
                    (cli.clm_mobileno), (cli.clm_faxno), (cli.clm_email),
                    (NULL), ('002')
               FROM corpinfo.tblusercompany u,
                    corpinfo.tblclientmain cli,
                    leaseinfo.tblcontracts c,
                    corpinfo.tbldistrict dist,
                    corpinfo.tbldistrict dist1,
                    corpinfo.tblprovince p,
                    corpinfo.tblprovince p1,
                    corpinfo.tblpostalcode ps,
                    corpinfo.tblpostalcode ps1,
                    leaseinfo.tblclosure clo,
                    (SELECT a.fsd_appno, a.fsd_gurcode
                       FROM corpinfo.tblfacsecdetails a,
                            corpinfo.tblclientmain cli
                      WHERE a.fsd_clmcode = cli.clm_code
                        AND UPPER (a.fsd_seccode) = 'PGRE'
                        AND cli.clm_cori = '2'
                        AND a.fsd_gurcode IS NOT NULL
                        AND a.fsd_conno IS NOT NULL) g
              WHERE c.con_appno = g.fsd_appno
                AND cli.clm_code = g.fsd_gurcode
                AND dist.dst_code(+) = cli.clm_maildstcode
                AND p.prv_code(+) = cli.clm_mailprvcode
                AND dist1.dst_code(+) = cli.clm_permdstcode
                AND p1.prv_code(+) = cli.clm_permprvcode
                AND ps.psc_prvcode(+) = cli.clm_mailprvcode
                AND ps.psc_dstcode(+) = cli.clm_maildstcode
                AND ps.psc_code(+) = cli.clm_mailpsccode
                AND ps1.psc_prvcode(+) = cli.clm_permprvcode
                AND ps1.psc_dstcode(+) = cli.clm_permdstcode
                AND ps1.psc_code(+) = cli.clm_permpsccode
                AND c.con_no = clo.clo_oldconno(+)
                AND (DECODE (c.con_sts,
                             'A', '001',
                             'L', '001',
                             'F', '001',
                             'T', '008',
                             'C', DECODE (clo.clo_ctptype,
                                          '1', '005',
                                          '9', '009',
                                          '3', '006',
                                          '2', '007'
                                         )
                            )
                    ) IS NOT NULL
                AND c.con_execdate <= strprocessdate
                AND c.con_date <= strprocessdate;

   UPDATE corrsql.tbl_crib_trailer
      SET cribt_num_cr_facility = '0'
    WHERE cribt_nature_data = '002';



   -- COMMIT;
  -- flag := 'Successful';
--EXCEPTION
 --  WHEN OTHERS
 --  THEN
   --   flag := 'Oracle Error';
    --  ROLLBACK;
END;