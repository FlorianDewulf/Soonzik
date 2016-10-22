using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Genre
    {
        public int id { get; set; }
        public string style_name { get; set; }
        public string color_name { get; set; }
        public string color_hexa { get; set; }
        public List<Influence> influences { get; set; }
        public List<Music> musics { get; set; }
        public List<Description> descriptions { get; set; }
    }
}
