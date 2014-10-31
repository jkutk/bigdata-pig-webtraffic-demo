rawlogs = LOAD '/user/hue/web-traffic/original/2009-11-19.json'
     USING JsonLoader('count:int, timestamp:long, from:chararray, to:chararray');
DESCRIBE rawlogs;
filledlogs = FOREACH rawlogs
     GENERATE $0, $1, (($2 IS NULL OR $2 == '') ? 'undefined' : $2) AS from, $3;
DESCRIBE filledlogs;
groupedlogs = GROUP filledlogs BY from;
DESCRIBE groupedlogs;
flattenedlogs = FOREACH groupedlogs
     GENERATE FLATTEN(group) AS from, COUNT(filledlogs);
DESCRIBE flattenedlogs;
filteredlogs = FILTER flattenedlogs BY $1 >= 500;
DESCRIBE filteredlogs;
orderedlogs = ORDER filteredlogs BY $1 DESC;
DESCRIBE orderedlogs;
DUMP orderedlogs;
-- logoutput = LIMIT countedlogs 10;
-- DUMP logoutput;
-- fromgroup = GROUP rawlogs BY from;
-- DESCRIBE fromgroup;
-- displayoutput = LIMIT fromgroup 10;
-- DUMP displayoutput;
