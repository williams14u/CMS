

/****** Object:  StoredProcedure [dbo].[spGetTickets]    Script Date: 7/5/2016 10:27:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spGetTickets]
@CompanyName varchar(200),
@StartIndex bigint,
@EndIndex bigint
as
begin

select * from (
select TicketNo,CompanyName,ProductName,ComponentName,Version,Title,Name as Assignee, tickets.DateCreated,
rank() over(order by tickets.ticketid) as R
from Companies 
inner join tickets on tickets.CompanyId=Companies.CompanyId
inner join products  p on tickets.ProductId=p.ProductId
inner join components c on tickets.ComponentId=c.componentid
left join TicketAssignees ta on tickets.TicketId=ta.TicketId
left join SupportMembers sm on ta.AssignedTo=sm.Id
where CompanyName like @CompanyName+'%') T where t.R between @StartIndex and @EndIndex;
end;