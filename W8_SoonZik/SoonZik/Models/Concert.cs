using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Xaml;

namespace SoonZik.Models
{
    public class Concert
    {
        public int id { get; set; }
        public string name { get; set; }
        public User user { get; set; }
        public DateTime planification { get; set; }
        public Address address { get; set; }
        public bool hasLiked { get; set; }
        public int likes { get; set; }
        public string url { get; set; }
        public ICommand do_like { get; set; }
        public ICommand do_unlike { get; set; }
        public Visibility like_btn { get; set; }
        public Visibility unlike_btn { get; set; }
    }
}
