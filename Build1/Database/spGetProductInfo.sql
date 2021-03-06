
/****** Object:  StoredProcedure [dbo].[spGetProductInfo]    Script Date: 7/7/2016 11:03:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[spGetProductInfo]
@ProductId bigint
as
begin

select p.ProductId,ProductName,Version,p.CompanyId
from Products p
inner join Companies c on c.CompanyId=p.ProductId
inner join ProductVersions pv on pv.ProductId=p.ProductId
where p.ProductId=@ProductId
end;