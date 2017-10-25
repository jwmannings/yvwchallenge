	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *,
DATEDIFF(quarter,CAST([Construction Date (YYYYMMDD)] as date),[Event Date]) AS months_break
INTO [yvwchallenge].[dbo].[yvwdataframe_firstbreak_modded]
FROM (SELECT CAST(wod.[Asset ID] AS VARCHAR(25)) AS [Asset ID]
                      ,ROW_NUMBER() OVER(PARTITION BY cast(wod.[Asset ID] as varchar) ORDER BY cast([Event Date] as date)) AS count
                      ,CONVERT(TIME,[Event time]) AS [Event Time]
                      ,CONVERT(DATE,[Event Date],101) AS [Event Date]
                      ,[Class Structure]
                      ,[Class Structure ID]
                      ,pm.[Material]
                      ,CONVERT(INT,pm.[Nominal Size (mm)]) as [Nominal Size (mm)]
                      ,sc.[Soil Class]
                      ,sc.[Soil Description]
                      ,gc.[Grant Description]
                      ,TRY_CONVERT(INT,CASE WHEN pd.[Pipe Inside Diameter (mm)] IS NULL
                           THEN pda.[Pipe Inside Diameter (mm)]
                           else pd.[Pipe Inside Diameter (mm)]
                           END) AS [Pipe Inside Diameter (mm)]
                      ,CASE WHEN pd.[Pipe Material] is null
                           THEN pda.[Pipe Material]
                           ELSE pd.[Pipe Material]
                           END AS [Pipe Material]
                      ,CASE WHEN pd.[Pipe Shape] is null
                           THEN pda.[Pipe Shape]
                           ELSE pd.[Pipe Shape]
                           END AS [Pipe Shape]
                      ,CONVERT(DATE,CASE WHEN pd.[Construction Date (YYYYMMDD)] is null
                           THEN pda.[Construction Date (YYYYMMDD)]
                           ELSE pd.[Construction Date (YYYYMMDD)]
                           END,112) AS [Construction Date (YYYYMMDD)]
                      ,CASE WHEN pd.[Pipe Lining] is null   
                           THEN pda.[Pipe Lining]
                           ELSE pd.[Pipe Lining]
                           END AS [Pipe Lining]
                      ,CONVERT(DATE,NULLIF(CASE WHEN pd.[Date Insulated] is null
                           THEN pda.[Date Insulated]
                           ELSE pd.[Date Insulated]
                           END,''),112) AS [Date Insulated]
                      ,CASE WHEN pd.[Tapping Status] is null
                           THEN pda.[Tapping Status]
                           ELSE pd.[Tapping Status]
                           END AS [Tapping Status]
                      ,CASE WHEN pd.[Road Name] is null
                           THEN pda.[Road Name]
                           ELSE pd.[Road Name]
                           END AS [Road Name]
                      ,CASE WHEN pd.[Road Type] is null
                           THEN pda.[Road Type]
                           ELSE pd.[Road Type]
                           END AS [Road Type]
                      ,CONVERT(DECIMAL(10,4),CASE WHEN pd.[Pipe Length (m)] is null
                           THEN pda.[Pipe Length (m)]
                           ELSE pd.[Pipe Length (m)]
                           END) AS [Pipe Length (m)]
                      ,CASE WHEN pd.[Pipe Status] is null
                           THEN pda.[Pipe Status]
                           ELSE pd.[Pipe Status]
                           END AS [Pipe Status]
                      ,CONVERT(DECIMAL(11,4),NULLIF(CASE WHEN pd.[Height Start of Pipe (meters above sea level)] is null
                           THEN pda.[Height Start of Pipe (meters above sea level)]
                           ELSE pd.[Height Start of Pipe (meters above sea level)]
                           END,'')) AS [Height Start of Pipe (meters above sea level)]
                      ,CONVERT(DECIMAL(11,4),NULLIF(CASE WHEN pd.[Height End of Pipe (meters above sea level)] is null
                           THEN pda.[Height End of Pipe (meters above sea level)]
                           ELSE pd.[Height End of Pipe (meters above sea level)]
                           END,'')) AS [Height End of Pipe (meters above sea level)]
                      ,CONVERT(DECIMAL(11,8),CASE WHEN pd.[Latitude Start of Pipe] is null
                           THEN pda.[Latitude Start of Pipe]
                           ELSE pd.[Latitude Start of Pipe]
                           END) AS [Latitude Start of Pipe]
                      ,CONVERT(DECIMAL(11,8),CASE WHEN pd.[Lattitude End of Pipe] is null
                           THEN pda.[Lattitude End of Pipe]
                           ELSE pd.[Lattitude End of Pipe]
                           END) AS [Lattitude End of Pipe]
                      ,CONVERT(DECIMAL(11,8),CASE WHEN pd.[Longitude Start of Pipe] is null
                           THEN pda.[Longitude Start of Pipe]
                           ELSE pd.[Longitude Start of Pipe]
                           END) AS [Longitude Start of Pipe]
                      ,CONVERT(DECIMAL(11,8),CASE WHEN pd.[Longitude End of Pipe] is null
                           THEN pda.[Longitude End of Pipe]
                           ELSE pd.[Longitude End of Pipe]
                           END) AS [Longitude End of Pipe]
                      ,CASE WHEN pd.[Distribution Zone ID] is null
                           THEN pda.[Distribution Zone ID]
                           ELSE pd.[Distribution Zone ID]
                           END AS [Distribution Zone ID]
                      ,CASE WHEN pd.[Water Quality Zone ID] is null
                           THEN pda.[Water Quality Zone ID]
                           ELSE pd.[Water Quality Zone ID]
                           END AS [Water Quality Zone ID]
                      --,wz.[Class Name]
                      --,wz.[Distribution Zone Name PR - pressure reduced PB - pressure boosted]
                      --,wz.[YVW Identifier]
                      --,wz.[Top Water Level]
                      ,[Description]
                      ,[Failure Code]
                      ,[Failure Description]
                      ,[Job Plan]
                      ,[Job Plan Number]
                      ,[Service Location Id]
                      ,[Formatted Address]
                      ,[City]
                      ,[Post Code]
                      ,CONVERT(DECIMAL(11,8),NULLIF([Latitude],'')) AS [Latitude]
                      ,CONVERT(DECIMAL(11,8),NULLIF([Longitude],'')) AS [Longitude]
               FROM [yvwchallenge].[dbo].[Work_Order_Specification_Data] wod
               left join [yvwchallenge].[dbo].[Pipe_Material_And_Soil_Data] pm on wod.[Asset ID] = pm.[Asset ID]
               left join [yvwchallenge].[dbo].[Pipe_Data_Active] pd on wod.[Asset ID] = pd.[Asset ID]
               left join [yvwchallenge].[dbo].[Pipe_Data_Abandoned] pda on wod.[Asset ID] = pda.[Asset ID]
               left join [yvwchallenge].[dbo].[Grant_Code_Data] gc on pm.[Grant Code (see Grant Code Data tab)] = gc.[Grant Code]
               left join [yvwchallenge].[dbo].[Soil_Class_Data] sc on gc.[Soil Class (see Soil Class Data tab)] = sc.[Soil Class]
               --left join [yvwchallenge].[dbo].[Water_Zone_Data] wz on pda.[Water Quality Zone ID] = wz.[Distribution Zone ID]
 
  ) cc
  where count = 1
  AND DATEDIFF(MONTH,CAST([Construction Date (YYYYMMDD)] as date),[Event Date]) IS NOT NULL
  AND CAST([Construction Date (YYYYMMDD)] as date) > '01/01/1995'
  AND CAST([Construction Date (YYYYMMDD)] as date) < CONVERT(DATE,[Event Date],101)
  AND cc.[Asset ID] IS NOT NULL
  AND cc.[Construction Date (YYYYMMDD)] IS NOT NULL
  AND cc.[Nominal Size (mm)] IS NOT NULL
  AND cc.[Event Date] IS NOT NULL
  AND cc.[Post Code] IS NOT NULL
  AND cc.[Height End of Pipe (meters above sea level)] IS NOT NULL
  AND cc.[Height Start of Pipe (meters above sea level)] IS NOT NULL