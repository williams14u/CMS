﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRM.Model
{
    public interface ICompany
    {
        int CompanyId { get; set; }
        string Name { get; set; }
        bool Validate();

    }
}
