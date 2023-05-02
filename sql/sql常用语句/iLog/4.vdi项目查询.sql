WITH    prolst
                                  AS ( SELECT   *
                                       FROM     dbo.ProductInfo with(nolock)
                                       WHERE    ( (( DeleteFlag = 0 AND (invalidType IS NULL OR invalidType ='' OR invalidType=2)) OR (DeleteFlag=0 AND invalidType IS NOT NULL AND invalidType=1 AND CONVERT(NVARCHAR(200),ActualSuspendTime,23) >= '2019/12/9 0:00:00'))
                                            --      OR ( DeleteFlag = 1 AND SuspendTime BETWEEN '2020/1/1 0:00:00' AND '2020/1/31 0:00:00')
                                                    OR ( DeleteFlag = 1 AND '2019-12-09'<SuspendTime And invalidType=2)
                                                  OR ( DeleteFlag = 2 AND (SuspendTime IS NULL OR SuspendTime>'2019-12-09'))
                                                ) --And @date>CreateTime 
                                     AND ProName LIKE '%vdi v%'         
                                       UNION ALL
                                       SELECT   a.*
                                       FROM     dbo.ProductInfo a with(nolock)
                                                INNER JOIN prolst b ON a.Id = b.ParentCode--b.ParentId 这个字段已不能使用
                                       WHERE    (
                                                    ((a.DeleteFlag = 0  AND (a.invalidType IS NULL OR a.invalidType ='' OR a.invalidType=2)) OR (a.DeleteFlag=0 AND a.invalidType IS NOT NULL AND a.invalidType=1 AND CONVERT(NVARCHAR(200),a.ActualSuspendTime,23) >= '2019/12/9 0:00:00'))
                                                   -- OR ( a.DeleteFlag = 1 AND a.SuspendTime BETWEEN '2020/1/1 0:00:00' AND '2020/1/31 0:00:00')
                                                      OR ( a.DeleteFlag = 1 AND '2019-12-09'<a.SuspendTime And a.invalidType=2)
                                                    OR ( a.DeleteFlag = 2 AND (a.SuspendTime IS NULL OR a.SuspendTime>'2019-12-09'))
                                                )
                                                --And @date>a.CreateTime
                                     ),
                                proChil
                                  AS ( SELECT   *
                                       FROM     dbo.ProductInfo with(nolock)
                                       WHERE    ( 
                                                  ((DeleteFlag = 0  AND (invalidType IS NULL OR invalidType ='' OR invalidType=2)) OR (DeleteFlag=0 AND invalidType IS NOT NULL AND invalidType=1 AND CONVERT(NVARCHAR(200),ActualSuspendTime,23) >= '2019/12/9 0:00:00'))
                                                --  OR ( DeleteFlag = 1 AND SuspendTime BETWEEN '2020/1/1 0:00:00' AND '2020/1/31 0:00:00')
                                                    OR ( DeleteFlag = 1 AND '2019-12-09'<SuspendTime And invalidType=2)
                                                  OR ( DeleteFlag = 2 AND (SuspendTime IS NULL OR SuspendTime>'2019-12-09'))
                                                ) 
                                                --And @date>CreateTime
                                                   AND ProName LIKE '%vdi v%'                 
                                       UNION ALL
                                       SELECT   a.*
                                       FROM     dbo.ProductInfo a with(nolock)
                                                INNER JOIN proChil b ON a.ParentCode = b.ProCode
                                        WHERE 	(
                                                    ((a.DeleteFlag = 0 AND (a.invalidType IS NULL OR a.invalidType ='' OR a.invalidType=2)) OR (a.DeleteFlag=0 AND a.invalidType IS NOT NULL AND a.invalidType=1 AND CONVERT(NVARCHAR(200),a.ActualSuspendTime,23)>= '2019/12/9 0:00:00'))
                                                  --  OR ( a.DeleteFlag = 1 AND a.SuspendTime BETWEEN '2020/1/1 0:00:00' AND '2020/1/31 0:00:00')
                                                      OR ( a.DeleteFlag = 1 AND '2019-12-09'<a.SuspendTime And a.invalidType=2)
                                                    OR ( a.DeleteFlag = 2 AND (a.SuspendTime IS NULL OR a.SuspendTime>'2019-12-09'))
                                                )
                                                --And @date>a.CreateTime
                                     ),
                                ALLData
                                  AS ( SELECT DISTINCT
                                                e.*
                                       FROM     ( SELECT    *
                                                  FROM      prolst
                                                  UNION ALL
                                                  SELECT    *
                                                  FROM      proChil
                                                ) e
                                     )
                            SELECT  a.ProID ,
                                    a.ProLevel ,
                                    CASE ISNULL(c.Id, 0)
                                      WHEN 0 THEN a.ProName
                                      ELSE a.ProName
                                           + ' <span style=''color:red''>*</span>'
                                    END ProName ,
                                    a.ProCode ,
                                    a.ParentCode ,
                                    a.Manager ,
                                    a.CC ,
                                    a.CreateTime ,
                                    a.Creator ,
                                    a.Modifier ,
                                    a.ModifyTime ,
                                    a.DeleteFlag ,
                                    a.SuspendType ,
                                    a.SuspendTime ,
                                    a.Id ,
                                    a.ParentId ,
                                    a.SubjectTypeName ,
                                    a.SubjectTypeCode ,
                                    a.RestartFlag ,
                                    a.ActualSuspendTime ,
                                    a.ProjectParentName ,
                                    a.ProjectParentCode ,
                                    a.invalidType
                            FROM    ALLData a
                                    LEFT JOIN ( SELECT  *
                                                FROM    Product_User_Relation d with(nolock)
                                                WHERE   d.UserCode = 'liucaixuan 03806'
                                                        AND d.DeleteFlag = 0
                                              ) c ON c.ProID = a.ProID;    