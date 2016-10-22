using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class News
    {
        public int id { get; set; }
        public string title { get; set; }
        public string content { get; set; }
        public bool hasLiked { get; set; }
        public int likes { get; set; }
        public User user { get; set; }
        //public List<Newstexts> newstexts { get; set; }
        public List<Attachments> attachments { get; set; }
        public string image { get; set; }
        public DateTime created_at { get; set; }
        //public DateTime date { get; set; }
    }
}
