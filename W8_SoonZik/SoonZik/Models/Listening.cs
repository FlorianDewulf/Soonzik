using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    class Listening
    {
        public int id { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
        public User user { get; set; }
        public Music music { get; set; }
    }
}
