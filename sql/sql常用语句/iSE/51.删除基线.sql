 declare @blID  int;
 set @blID=17626;
 delete from specMS_SpecListAttachment where listID=@blID and fileType=1 or listID in (select listID from specMS_SpecList where blID =@blID ) and fileType=0;
       delete from specMS_SpecFileList where listID in (select listID from specMS_SpecList where blID=@blID );
       delete from specMS_SpecEntryChangeRel where blID=@blID;
       delete from specMS_SpecBaseLineLabel where blID=@blID;
       delete from specMS_EntrySrcProperty where blID=@blID;
       
       delete from SpecMS_BaselineProductRel where ListBlid=@blID
       delete from specMS_SpecModuleBLRel where blID=@blID;
       delete from specMS_StandardSupport where blID=@blID;
       delete from specMS_TabRefBaseLine  where blID=@blID;
       delete from specMS_TabRefBaseLine where listID in (select listID from specMS_SpecList where blID=@blID );
       delete from specMS_TemplateSpecBLRel where blID=@blID;
       delete from specMS_SpecModuleBLRel where blID=@blID;
       delete from specMS_EntryDepend where blID=@blID;
       
       delete FROM dbo.specMS_ProColContent WHERE blEntryID IN (SELECT blEntryID FROM dbo.specMS_SpecBLEntryRel WHERE blID =@blID);
       delete FROM dbo.specMS_ProductColumn WHERE BlId =@blID;
       
       delete from specMS_SpecListExtColData where blEntryID in (select blEntryID from specMS_SpecBLEntryRel where blID=@blID );
       delete from specMS_SpecListExtColData where blID=@blID;
      
        delete from sepcMS_SpecListTabGroup where  blId =@blID;
       delete from specMS_SpecListTabExtCol where extColID in ( select extColID from specMS_SpecListExtCol where listID in (select listID from specMS_SpecList where blID=@blID ) );
       delete from specMS_SpecListExtCol where listID in (select listID from specMS_SpecList where blID=@blID ) ;
       
       delete from sepcMS_SpecListExtColGroup where tabID in (select tabID from specMS_SpecListTab where listID in (select listID from specMS_SpecList where blID=@blID ));
       delete from specMS_SpecListTab where listID in (select listID from specMS_SpecList where blID=@blID );
       
       delete from specMS_SpecBLEntryRel where blID=@blID;
       delete from specMS_SpecList where blID=@blID ;
      delete from specMS_SpecBaseLine where blID=@blID;
       delete from specMS_ModifyRefEntry where blID=@blID;
       delete from specMS_EntryParam where blID=@blID;