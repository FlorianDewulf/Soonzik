using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Pack
    {
        public int id { get; set; }
        public string title { get; set; }
        public double minimal_price { get; set; }
        public string begin_date { get; set; }
        public string end_date { get; set; }
        public List<Album> albums { get; set; }
        public List<Description> descriptions { get; set; }
    }
}
