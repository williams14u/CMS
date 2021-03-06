﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRM.Model
{
    public class Ticket : ITicket
    {
        public long TicketId { get; set; }
        public long TicketNo { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public Int64 ProductId { get; set; }
        public Int64 ComponentId { get; set; }
        public string ComponentName { get; set; }
        public long VersionId { get; set; }
        public string Version { get; set; }
        public int Status { get; set; }
        public long CompanyId { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public Int64 CreatedBy { get; set; }
        public string UserName { get; set; }
        public DateTime DateFixed { get; set; }
        public DateTime DateClosed { get; set; }
        public string CompanyName { get; set; }
        public string ProductName { get; set; }
        public string Assignee { get; set; }
        public int TicketTypeId { get; set; }
        public int SeviorityId { get; set; }
        public int PriorityId { get; set; }

        public bool Validate()
        {
            if (Title == null || Title.Trim() == "") throw new Exception("Title is empty");
            if (ProductId == 0) throw new Exception("Inavlid product id");
            //if (CreatedBy == 0) throw new Exception("Invalid Ticket: Unauthenticated user");
            return true;
        }
              

    }


       
   
    public class TicketType
    {
        public string Type { get; set; }
        public int Id { get; set; }
    }
    public class Priority
    {
        public string PriorityName { get; set; }
        public int Id { get; set; }
    }
    public class Seviority
    {
        public string SeviorityName { get; set; }
        public int Id { get; set; }
    }

   
}
