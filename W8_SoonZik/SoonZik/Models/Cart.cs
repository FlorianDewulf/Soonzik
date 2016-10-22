using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    class Cart
    {
        public int id { get; set; }
        public List<Music> musics { get; set; }
        public List<Album> albums { get; set; }
    }
}
