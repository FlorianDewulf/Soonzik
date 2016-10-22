using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Ambiance
    {
        public int id { get; set; }
        public string name { get; set; }
        public List<Music> musics { get; set; }
    }
}
