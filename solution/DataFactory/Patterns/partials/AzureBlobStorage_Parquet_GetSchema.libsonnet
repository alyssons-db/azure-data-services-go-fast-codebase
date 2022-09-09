function(GFPIR="IRA") 
{
  "dataset": {
    "referenceName": "GDS_AzureBlobStorage_Parquet_" + GFPIR,
    "type": "DatasetReference",
    "parameters": {
      "RelativePath": {
        "value": "@pipeline().parameters.TaskObject.Target.RelativePath",
        "type": "Expression"
      },
      "FileName": {
        "value": "@replace(pipeline().parameters.TaskObject.Target.DataFileName,'.parquet',concat('.chunk_', string(pipeline().parameters.Item),'.parquet'))",
        "type": "Expression"
      },
      "StorageAccountEndpoint": {
        "value": "@pipeline().parameters.TaskObject.Target.StorageAccountName",
        "type": "Expression"
      },
      "StorageAccountContainerName": {
        "value": "@pipeline().parameters.TaskObject.Target.StorageAccountContainer",
        "type": "Expression"
      }
    }
  },
  "fieldList": [
    "structure"
  ],
  "storeSettings": {
    "type": "AzureBlobFSReadSettings",
    "recursive": true
  }
}

