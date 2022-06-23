CREATE VIEW dbo.vw_StudentDailyAttendance
AS
SELECT 
    RefId,
    StudentPersonalRefId,
    SchoolInfoRefId,
    Date,
    SchoolYear,
    DayValue,
    CAST(JSON_VALUE(AttendanceCode, '$.Code') AS VARCHAR(3)) AS AttendanceCode,
    AttendanceStatus,
    TimeIn,
    TimeOut,
    AttendanceNote
FROM OPENROWSET(
BULK 'samples/sif/StudentDailyAttendance/StudentDailyAttendance/Snapshot/StudentDailyAttendance/**',
DATA_SOURCE ='sif_eds',
FORMAT='PARQUET'
)
WITH(
    RefId VARCHAR(50),
    AttendanceCode VARCHAR(MAX),
    StudentPersonalRefId VARCHAR(50),
    SchoolInfoRefId VARCHAR(50),
    Date VARCHAR(10),
    SchoolYear VARCHAR(4),
    DayValue VARCHAR(50),
    AttendanceStatus VARCHAR(10),
    TimeIn VARCHAR(8),
    TimeOut VARCHAR(8),
    AttendanceNote VARCHAR(MAX)   
) AS SDA

-- SELECT * FROM dbo.vw_StudentDailyAttendance