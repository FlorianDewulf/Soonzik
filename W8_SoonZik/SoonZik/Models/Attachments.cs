using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;

namespace SoonZik.Models
{
    public class Attachments
    {
        public int id { get; set; }
        public int file_size { get; set; }
        public string url { get; set; }
        public string content_type { get; set; }
    }
}
