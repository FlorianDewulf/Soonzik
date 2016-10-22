using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Comment
    {
        public int id { get; set; }
        public int author_id {get; set;}
        public string content { get; set; }
        public User user { get; set; }
        public DateTime create_at { get; set; }
    }
}
