  drop table BOM_PATH_FAB_RPT_SNP; 
  
  create table BOM_PATH_FAB_RPT_SNP
  ( 
  RPT_DT             DATE                       DEFAULT trunc(sysdate ),
  END_PART_NUM       VARCHAR2(40 CHAR),
  PDCD_MFG_PART_NUM  VARCHAR2(40 CHAR),
  PDCD_item_type_cd     VARCHAR2(20 char), --changed 
  LVL_NUM            INTEGER,
  FAB_PART_NUM       VARCHAR2(40 CHAR),
  BOM_QTY_PER        NUMBER,
  YIELD              NUMBER(15,4),
  GDPW               NUMBER(15),
  END_NODES_FLG      VARCHAR2(1 BYTE),
  S_PART             VARCHAR2(40 BYTE),
  CMPNT_PART         VARCHAR2(40 BYTE),
  COUNTER            INTEGER,
  ROW_TYPE           VARCHAR2(100 CHAR),
  ROW_SOURCE         VARCHAR2(300 CHAR)         DEFAULT   'DBCPY_GRP : BOM PATH RPT',
  SOURCE_DT          DATE                       DEFAULT sysdate, 
  DS_ID                  NUMBER
  ) 
TABLESPACE FRMDATA_DATA
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
 
PARTITION BY LIST (DS_ID)
(  
  PARTITION P1 VALUES (1)
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE FRMDATA_DATA
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               ),  
  PARTITION P2 VALUES (2)
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE FRMDATA_DATA
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               ),  
  PARTITION P3 VALUES (3)
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE FRMDATA_DATA
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          8M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               )
)
NOLOGGING
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

grant select on BOM_PATH_FAB_RPT_SNP to scmrptdata, scmrptdata_rev, scmrptuser, psguser; 

create SYNONYM BOM_PATH_FAB_RPT_SNP_TR for BOM_PATH_FAB_RPT_SNP; -- for partition truncating dbutil.prctruncatetable

-- snap, dbcpy , dataset mgmt, metric (optional), -- not covered by tool archive_grp, stats, handshake entries?? 
 
Insert into FRMDATA.SNAP_GRP
   (GRP_ID, GRP_NM, ACTIVE_YN, METRIC_GRP_NM, DBCOPY_GRP_NM, 
    FRESH_LIMIT_HRS, WAIT_LIMIT_HRS, LAST_GOOD_DT, REUSE_LIMIT_HRS, UPDT_DT, 
    UPDT_RSN_DSCR )
 Values
   (8, 'BOM_PATH_RPT', 'Y', 'BOM_PATH_RPT', 'BOM_PATH_RPT', 
    40, 0.5,  sysdate, 74, sysdate,     'ESP_OP_Reporting' );
COMMIT;

 
 --snp dtl with handshake table nm referenced 
Insert into FRMDATA.SNAP_TBL_DTL
   (GRP_ID, SRC_SCHEMA_NM, SRC_TBL_NM, SRC_DBLINK, ACTIVE_YN, 
    HANDSHAKE_SCHEMA_NM, HANDSHAKE_TBL_NM, PROVDR_SNM, TRANSPORT_MECHANISM_DSCR, TRANSPORT_TIMING_DSCR, 
    DELTA_FILTER_HRS, TBL_DSCR, UPDT_DT, UPDT_RSN_DSCR )
 Values
   (8, 'SCMDATA', 'BOM_PATH_FAB_RPT', 'SCMDEV', 'Y', 
    'SCMDATA', 'RPT_LOAD_MASTER_VW', 'SCMPROD', 'DBCPY', 'DAILY', 
    0, 'ESP-OP/BOM_PATH_REPORT', sysdate, 'ESP_OP_Reporting');
COMMIT;


--dbcpy 

Insert into FRMDATA.DBCPY_GRP
   (GRP_ID, GRP_NM, ENTERPRISE, ACTIVE_YN, UPDT_DT, 
    UPDT_RSN_DSCR )
 Values
   (8, 'BOM_PATH_RPT', 'NONE', 'Y', sysdate,     'ESP_OP_Reporting');
COMMIT;

Insert into FRMDATA.DBCPY_DTL
   (GRP_ID, SEQ_NUM, SRC_SCHEMA_NM, SRC_TBL_NM, SRC_DBLINK, 
    DES_SCHEMA_NM, DES_TBL_NM, ACTIVE_YN, TRUNC_YN,TRUNC_SYN_NM,  COLUMN_LIST_FROM, 
    DELETE_ROWS,   UPDT_DT, UPDT_RSN_DSCR )
 Values
   (8, 1, 'SCMDATA', 'BOM_PATH_FAB_RPT', 'SCMDEV', 
    'FRMDATA', 'BOM_PATH_FAB_RPT_SNP', 'Y', 'N', 'BOM_PATH_FAB_RPT_SNP_TR', 'B',   --syn nm for trunc partition 
    1000000,  sysdate, 'ESP/OP-Reporting'     );
COMMIT;

-- dbcpy history table 
Insert into FRMDATA.DBCPY_DTL
   (GRP_ID, SEQ_NUM, SRC_SCHEMA_NM, SRC_TBL_NM,  
    DES_SCHEMA_NM, DES_TBL_NM, ACTIVE_YN, TBL_FILTER, COLUMN_LIST_FROM, 
    DELETE_ROWS,   UPDT_DT, UPDT_RSN_DSCR )
 Values
   (8, 2, 'SCMRPTDATA', 'BOM_PATH_FAB_RPT',  
    'SCMRPTDATA', 'BOM_PATH_FAB_RPT_HIST', 'Y', 'trim(to_char(rpt_dt,''DAY'')) = ''SUNDAY'' and rpt_dt =(select rpt_dt from scmrptdata.bom_path_fab_rpt where rownum=1)',  'B', 
    1000000,  sysdate, 'ESP/OP-Reporting'     )
COMMIT;


-- dataset mgmt , partitioned consideration 
Insert into FRMDATA.DATASET_MGMT -- snp
   (SCHEMA_NM, TABLE_NM, PARTITION_YN, DATASET_COPIES, CURR_DS_ID, 
    PUBLISH_DATE, ENTERPRISE, UPDT_DT, UPDT_RSN_DSCR )
 Values
   ('FRMDATA', 'BOM_PATH_FAB_RPT_SNP', 'Y', 3, 1,     null, 'NONE', sysdate, 'ESP/OP-Reporting');
COMMIT;

-- STATs  

 
Insert into FRMDATA.STATS_GRP
   (GRP_NM, SCHEMA_NM, TBL_NM, ACTIVE_YN, LAST_RUN_DT, 
    UPDT_DT, UPDT_RSN_DSCR )
 Values
   ('SNAP', 'FRMDATA', 'BOM_PATH_FAB_RPT_SNP', 'Y', null, 
    sysdate, 'ESP/OP-Reporting' );
COMMIT;

 
 

-- archive grp --  
 
Insert into FRMDATA.ARCHIVE_GRP
   (ARCH_ID, ARCH_TYPE,   SCHEMA_NM, tbl_NM, ARCHIVE_CRITERIA, 
    ACTIVE_FLG, RETENTION_PERIOD_IN_DAYS, RETENTION_COMMENTS, RETENTION_COLUMN, ORIG_RETENTION_PERIOD_IN_DAYS, 
   UPDT_RSN_DSCR )
 Values
   (3, 'TABLE',  'SCMRPTDATA', 'BOM_PATH_FAB_RPT_HIST', 'RETENTION', 
    'Y', 180, 'Retain 180 days of data on retention column', 'RPT_DT',180,  'ESP/OP-Reporting');
COMMIT;

  


--testing and validate results 

 -- exec dbcpy.copy_dataset('BOM_PATH_RPT') 
 -- exec frmdata.snap.run('BOM_PATH_RPT') ; 
 -- select * from dbcpy_log where grp_id=8 order by strt_dt DESC
 -- select *from scmrptdata.BOM_PATH_FAB_RPT -- snp_Vw 
