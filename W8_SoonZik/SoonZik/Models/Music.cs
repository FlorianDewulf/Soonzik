using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Music
    {
        public int id { get; set; }
        public string title { get; set; }
        public User user { get; set; }
        public int duration { get; set; }
        public Album album { get; set; }
        public List<Genre> genres { get; set; }
        public List<Description> descriptions { get; set; }
        public double price { get; set; }
        public double getAverageNote { get; set; }
        public string file { get; set; }
        public bool limited { get; set; }
    }
}
