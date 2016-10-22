using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    class Search
    {
        public List<User> artist { get; set; }
        public List<User> user { get; set; }
        public List<Music> music { get; set; }
        public List<Album> album { get; set; }
        public List<Pack> pack { get; set; }
    }
}
