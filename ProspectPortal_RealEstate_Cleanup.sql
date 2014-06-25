

declare @pprcols varchar(max)
declare @pprkcols varchar(max)
declare @allcols varchar(max)

select @pprcols = ISNULL(@pprcols + ', ','') + QUOTENAME(ic.COLUMN_NAME) 
	 from cms_Ohio.INFORMATION_SCHEMA.COLUMNS ic 
	 where  ic.TABLE_NAME = 'ProspectPortal_RealEstate'
		and ic.COLUMN_NAME NOT IN ('id','databankid','geo','created','updated','lastimportdate','updatedby','createdby')

select @pprkcols = ISNULL(@pprkcols + ', ','') + QUOTENAME(ic.COLUMN_NAME) 
	 from cms_OhioKentico.INFORMATION_SCHEMA.COLUMNS ic 
	 where  ic.TABLE_NAME = 'ProspectPortal_RealEstate'
		and ic.COLUMN_NAME NOT IN ('id','databankid','brokercellphone','geo2','FeaturedLabel','ccid','geo','created','updated','lastimportdate','updatedby','createdby')

--the attempt to build a result set of "matched" records from the ground up did not go as well as planned
select @allcols = '[status],[type],[name],[description],[parcelid],[address1],[city],[county],
					[state],[zip],[lat],[streetview],[previoustenant],[currentprevioususe],[businesspark],[featured],[buildingsize],[sitesize],[available],[contiguous],
					[divisiblefrom], [ceilingmin], [ceilingmax], [forsale], [forlease], [leasetype], [leasecost], [saleprice], [pricepersf], [dockhigh],
					[drivein], [parking], [parkingratio], [divisible], [zoning], [sprinklered], [loadbearing], [multitenant], [yearbuilt], [shovelready]'

--select @allcols = '[status],[type],[name],[description],[zip],[address1],[buildingtype],[lat]'

--select * from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = '' and ppr.name = 'Brooksedge - 241 WSR'

--exec('select ' + @allcols + '
--	    from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = '''' and ppr.zip = ''45044'' 	    
--	  except select ' + @allcols + '
--		from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = '''' and pprk.zip = ''45044''')

--exec('select ' + @allcols + '
--	    from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = '''' and pprk.zip = ''45044'' 	    
--	  except select ' + @allcols + '
--		from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = '''' and ppr.zip = ''45044''')
		
--exec('select ' + @allcols + '
--	    from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = '''' and pprk.zip = ''45044'' 	    
--	  intersect select ' + @allcols + '
--		from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = '''' and ppr.zip = ''45044''')		



exec ('select COUNT(name) as countset,' + @allcols + ' from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = ''''
	   group by ' + @allcols + ' having COUNT(name) > 1 order by countset desc ')
	   

--exec ('select COUNT(*) as countset,' + @allcols + ' from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = ''''
--	   group by ' + @allcols + ' having COUNT(*) > 1 order by countset desc ')	   

exec('select ' + @pprcols + '
	    from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = ''''	    
	  except select ' + @pprcols + '
		from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = ''''')

exec('select ' + @pprkcols + '
	    from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = '''' 	    
	  except select ' + @pprkcols + '
		from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = ''''')
		
exec('select ' + @allcols + '
	    from cms_OhioKentico.dbo.ProspectPortal_RealEstate pprk where pprk.databankid = ''''	    
	  intersect select ' + @allcols + '
		from cms_Ohio.dbo.ProspectPortal_RealEstate ppr where ppr.databankid = ''''')	
