
/****** Object:  StoredProcedure [dbo].[spCreateProduct]    Script Date: 7/7/2016 11:04:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[spCreateProduct]
@ProductName varchar(200),
@CompanyId bigint,
@Status int
as
begin
  insert into Products(ProductName,CompanyId,Status) values(@ProductName,@CompanyId,@Status)
end;