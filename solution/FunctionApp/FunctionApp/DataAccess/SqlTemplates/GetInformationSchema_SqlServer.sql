﻿SELECT DISTINCT
	c.ORDINAL_POSITION,
	c.COLUMN_NAME, 
	c.DATA_TYPE,
	IS_NULLABLE = cast(case when c.IS_NULLABLE = 'Yes' then 1 else 0 END as bit), 
	c.NUMERIC_PRECISION, 
	c.CHARACTER_MAXIMUM_LENGTH, 
	c.NUMERIC_SCALE,  
	ac.is_identity IS_IDENTITY,
	ac.is_computed IS_COMPUTED,
	KEY_COLUMN = cast(CASE WHEN kcu.TABLE_NAME IS NULL THEN 0 ELSE 1 END as bit),
	PKEY_COLUMN = cast(CASE WHEN tc.TABLE_NAME IS NULL THEN 0 ELSE 1 END as bit)
FROM INFORMATION_SCHEMA.COLUMNS c with (NOLOCK)
INNER JOIN sys.all_columns ac with (NOLOCK) ON object_id(QUOTENAME(c.TABLE_SCHEMA)+'.'+QUOTENAME(c.TABLE_NAME)) = ac.object_id and ac.name = c.COLUMN_NAME
LEFT OUTER join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu with (NOLOCK) ON c.TABLE_CATALOG = kcu.TABLE_CATALOG and c.TABLE_SCHEMA = kcu.TABLE_SCHEMA AND c.TABLE_NAME = kcu.TABLE_NAME and c.COLUMN_NAME = kcu.COLUMN_NAME 
LEFT OUTER join 
	(SELECT Col.TABLE_CATALOG, Col.TABLE_SCHEMA, Col.TABLE_NAME, Col.COLUMN_NAME
	from 
		INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab with (NOLOCK), 
		INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col with (NOLOCK) 
	WHERE 
		Col.Constraint_Name = Tab.Constraint_Name
		AND Col.Table_Name = Tab.Table_Name
		AND Tab.Constraint_Type = 'PRIMARY KEY') tc
	ON c.TABLE_CATALOG = tc.TABLE_CATALOG and c.TABLE_SCHEMA = tc.TABLE_SCHEMA and c.TABLE_NAME = tc.TABLE_NAME and c.COLUMN_NAME = tc.COLUMN_NAME
WHERE c.TABLE_NAME = '{tableName}' AND c.TABLE_SCHEMA = '{tableSchema}' 