USE SUSDB
SELECT C.FullDomainName AS Fqdn,C.LastSyncTime, C.LastSyncResult, C.LastReportedStatusTime ,TG.Name AS [GroupName], VU.KnowledgebaseArticle AS KB, VU.SecurityBulletin, VU.DefaultTitle, VU.InstallationImpact, VU.PublicationState, VU.MsrcSeverity, VU.ArrivalDate AS [Imported_Arrival_Date], VU.CreationDate, VU.IsDeclined, VU.IsWsusInfrastructureUpdate, U.IsPublic, VUA.Action, VUA.AdministratorName, VUA.CreationDate AS [DeploymentTime],
       'State' = CASE 
	   WHEN UP.SummarizationState = 0 THEN 'Unknown' 
       WHEN UP.SummarizationState = 1 THEN 'Not Applicable' 
       WHEN UP.SummarizationState = 2 THEN 'Not Installed'  
       WHEN UP.SummarizationState = 3 THEN 'Downloaded'
       WHEN UP.SummarizationState = 4 THEN 'Installed'
       WHEN UP.SummarizationState = 5 THEN 'Failed'
	   WHEN UP.SummarizationState = 6 THEN 'Installed Pending Reboot'
       END

FROM tbComputerTarget C
INNER JOIN tbUpdateStatusPerComputer UP ON C.TargetID = UP.TargetID
INNER JOIN tbUpdate U ON UP.LocalUpdateID = U.LocalUpdateID
INNER JOIN [PUBLIC_VIEWS].[vUpdate] VU ON U.UpdateID = VU.UpdateId
INNER JOIN [PUBLIC_VIEWS].[vUpdateApproval] VUA ON VU.UpdateId = VUA.UpdateId
INNER JOIN tbTargetInTargetGroup TIG ON C.TargetID = TIG.TargetID
INNER JOIN tbTargetGroup TG ON TIG.TargetGroupID = TG.TargetGroupID
