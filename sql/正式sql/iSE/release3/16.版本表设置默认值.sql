update  specMS_SpecDataIDSet   set  BaseVersionType=0,IsMerge=0,isSync=1;
UPDATE specMS_SpecDataIDSet  SET isSync=0  WHERE srcID LIKE 'PR99%' OR SRCID LIKE 'PB99%';