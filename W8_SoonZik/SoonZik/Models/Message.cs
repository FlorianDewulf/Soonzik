using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    class Message
    {
            public int id { get; set; }
            public string msg { get; set; }
            public int user_id { get; set; }
            public int dest_id { get; set; }
            public string name { get; set; }
    }
}
