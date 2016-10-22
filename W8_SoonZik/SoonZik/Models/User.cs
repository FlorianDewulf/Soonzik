using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml.Media.Imaging;


namespace SoonZik.Models
{
    public class User
    {
        public int id { get; set; }
        public string email { get; set; }
        public string salt { get; set; }
        public string fname { get; set; }
        public string lname { get; set; }
        public string username { get; set; }
        public Address address { get; set; }
        public string phoneNumber { get; set; }
        public string birthday { get; set; }
        public DateTimeOffset birthday_dt { get; set; }
        public string description { get; set; }
        public string background { get; set; }
        public string language { get; set; }
        public string image { get; set; }
        public List<User> friends { get; set; }
        public List<User> follows { get; set; }
        public List<User> followers { get; set; }
    }
}
