using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    class Notification
    {
        public int id { get; set; }
        public int user_id { get; set; }
        public string notif_type { get; set; }
        public int from_user_id { get; set; }
        public bool read { get; set; }
        public string link { get; set; }
    }
}
