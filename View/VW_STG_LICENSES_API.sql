create or replace view TIGERANALYTICSPOC_CLEANSE.HEVOGIJ_STG.VW_STG_LICENSES_API(
	ADDONLICENSEID,
	APPENTITLEMENTID,
	APPENTITLEMENTNUMBER,
	HOSTLICENSEID,
	HOSTENTITLEMENTID,
	HOSTENTITLEMENTNUMBER,
	LICENSEID,
	CLOUDID,
	ADDONKEY,
	ADDONNAME,
	HOSTING,
	LASTUPDATED,
	LICENSETYPE,
	MAINTENANCESTARTDATE,
	MAINTENANCEENDDATE,
	STATUS,
	TIER,
	__HEVO_ID,
	CONTACTDETAILS_COUNTRY,
	CONTACTDETAILS_BILLINGCONTACT_EMAIL,
	CONTACTDETAILS_BILLINGCONTACT_NAME,
	CONTACTDETAILS_TECHNICALCONTACT_EMAIL,
	CONTACTDETAILS_TECHNICALCONTACT_NAME,
	CONTACTDETAILS_COMPANY,
	CONTACTDETAILS_REGION,
	CONTACTDETAILS_BILLINGCONTACT_ADDRESS1,
	CONTACTDETAILS_BILLINGCONTACT_CITY,
	CONTACTDETAILS_BILLINGCONTACT_PHONE,
	CONTACTDETAILS_TECHNICALCONTACT_ADDRESS1,
	CONTACTDETAILS_TECHNICALCONTACT_CITY,
	CONTACTDETAILS_TECHNICALCONTACT_PHONE,
	CONTACTDETAILS_TECHNICALCONTACT_STATE,
	CONTACTDETAILS_TECHNICALCONTACT_POSTCODE,
	CONTACTDETAILS_BILLINGCONTACT_POSTCODE,
	PARTNERDETAILS_BILLINGCONTACT_EMAIL,
	PARTNERDETAILS_BILLINGCONTACT_NAME,
	PARTNERDETAILS_PARTNERNAME,
	PARTNERDETAILS_PARTNERTYPE,
	CONTACTDETAILS_BILLINGCONTACT_STATE,
	__HEVO__INGESTED_AT,
	__HEVO__LOADED_AT,
	CONTACTDETAILS_BILLINGCONTACT_ADDRESS2,
	CONTACTDETAILS_TECHNICALCONTACT_ADDRESS2,
	CMTDETAILS_RELATEDONPREMLICENSE,
	CMTDETAILS_STATUS,
	CLOUDSITEHOSTNAME,
	EXTENDEDSERVERSUPPORT,
	LICENSESOURCETYPE,
	TRANSACTIONACCOUNTID,
	RUN_ID
) as 
WITH LICENSE_RAW AS ( select l.*, ROW_NUMBER() OVER (PARTITION BY IFNULL(APPENTITLEMENTNUMBER,LICENSEID) ORDER BY MAINTENANCEENDDATE ASC, __hevo__ingested_at ASC) AS ROW_NUM
from HEVOGIJ.PUBLIC.LICENSES_API l )
SELECT 	ADDONLICENSEID,
	APPENTITLEMENTID,
	APPENTITLEMENTNUMBER,
	HOSTLICENSEID,
	HOSTENTITLEMENTID,
	HOSTENTITLEMENTNUMBER,
	LICENSEID,
	CLOUDID,
	ADDONKEY,
	ADDONNAME,
	HOSTING,
	LASTUPDATED,
	LICENSETYPE,
	MAINTENANCESTARTDATE,
	MAINTENANCEENDDATE,
	STATUS,
	TIER,
	__HEVO_ID,
	CONTACTDETAILS_COUNTRY,
	CONTACTDETAILS_BILLINGCONTACT_EMAIL,
	CONTACTDETAILS_BILLINGCONTACT_NAME,
	CONTACTDETAILS_TECHNICALCONTACT_EMAIL,
	CONTACTDETAILS_TECHNICALCONTACT_NAME,
	CONTACTDETAILS_COMPANY,
	CONTACTDETAILS_REGION,
	CONTACTDETAILS_BILLINGCONTACT_ADDRESS1,
	CONTACTDETAILS_BILLINGCONTACT_CITY,
	CONTACTDETAILS_BILLINGCONTACT_PHONE,
	CONTACTDETAILS_TECHNICALCONTACT_ADDRESS1,
	CONTACTDETAILS_TECHNICALCONTACT_CITY,
	CONTACTDETAILS_TECHNICALCONTACT_PHONE,
	CONTACTDETAILS_TECHNICALCONTACT_STATE,
	CONTACTDETAILS_TECHNICALCONTACT_POSTCODE,
	CONTACTDETAILS_BILLINGCONTACT_POSTCODE,
	PARTNERDETAILS_BILLINGCONTACT_EMAIL,
	PARTNERDETAILS_BILLINGCONTACT_NAME,
	PARTNERDETAILS_PARTNERNAME,
	PARTNERDETAILS_PARTNERTYPE,
	CONTACTDETAILS_BILLINGCONTACT_STATE,
	__HEVO__INGESTED_AT,
	__HEVO__LOADED_AT,
	CONTACTDETAILS_BILLINGCONTACT_ADDRESS2,
	CONTACTDETAILS_TECHNICALCONTACT_ADDRESS2,
	CMTDETAILS_RELATEDONPREMLICENSE,
	CMTDETAILS_STATUS,
	CLOUDSITEHOSTNAME,
	EXTENDEDSERVERSUPPORT,
	LICENSESOURCETYPE,
	TRANSACTIONACCOUNTID,
	RUN_ID FROM (SELECT IFNULL(APPENTITLEMENTNUMBER,LICENSEID) as SFID, lr.*
FROM HEVOGIJ.PUBLIC.LICENSE_RAW lr
INNER JOIN
(SELECT DISTINCT
IFNULL(APPENTITLEMENTNUMBER,LICENSEID) AS ID, MAX(ROW_NUM) AS MAXROW
FROM HEVOGIJ.PUBLIC.LICENSE_RAW
GROUP BY
IFNULL(APPENTITLEMENTNUMBER,LICENSEID)) x
ON IFNULL(lr.APPENTITLEMENTNUMBER,lr.LICENSEID) = x.ID AND lr.row_num = x.maxrow) WHERE  ADDONNAME!='Dev Info for Jira' AND  TRY_TO_TIMESTAMP(__HEVO__INGESTED_AT::VARCHAR)>=(SELECT IFNULL(MAX(WATER_MARK_VAL),'1900-01-01') FROM TIGERANALYTICSPOC_CLEANSE.PROCESS_CONTROL.LOAD_CONTROL_WATERMARK WHERE TARGET_TBL='STG_LICENSES_API')
;
