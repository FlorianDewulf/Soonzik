using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Newstexts
    {
        public int id { get; set; }
        public int news_id { get; set; }
        public string title { get; set; }
        public string content { get; set; }
        public string language { get; set; }
    }
}
