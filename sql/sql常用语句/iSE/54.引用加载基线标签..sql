select label.specLblID as SpecLblid,label.blLabel as BlLabel,
                                    label.blID as Blid,pbl.blID as PblId,pbl.lTitle as PbaseLine,
                                    label.createTime as CreateTime,employee.Name + ' ' +employee.Code as CreateBy,
                                    label.description as Description 
                                    from specMS_SpecModuleBLRel rel with(nolock) ,
                                    specMS_TabRefBaseLine ref with(nolock),
                                    specMS_SpecBaseLine bl with(nolock) 
                                    left join specMS_SpecBaseLine pbl with(nolock) on bl.preBlId = pbl.blID,
                                    specMS_SpecBaseLineLabel label with(nolock)
                                    left join Sync_Employee employee with(nolock) on label.createBy = employee.Code
                                    where rel.blID = ref.blID and ref.status = 2 
                                    and ref.listblID = bl.blID and bl.status = 1 and   (bl.DeleteFlag is null  or bl.deleteFlag=0)
                                    and ref.listblID = label.blID and 
                                    rel.smID=11429
                                    order by label.blID desc