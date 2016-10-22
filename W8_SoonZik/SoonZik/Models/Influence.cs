using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Influence
    {
        public int id { get; set; }
        public string name { get; set; }
        public List<Genre> genres { get; set; }
    }
}
