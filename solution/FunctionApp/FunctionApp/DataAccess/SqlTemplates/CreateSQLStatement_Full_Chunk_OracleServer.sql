﻿SELECT * FROM {tableSchema}.{tableName} WHERE CAST({chunkField} AS LONG) %  <batchcount> = <item> -1. 