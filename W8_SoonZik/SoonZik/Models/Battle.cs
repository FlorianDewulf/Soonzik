using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Xaml;

namespace SoonZik.Models
{
    public class Battle
    {
        public int id { get; set; }
        public DateTime date_begin { get; set; }
        public DateTime date_end { get; set; }
        public User artist_one { get; set; }
        public User artist_two { get; set; }
        public List<Vote> votes { get; set; }

        public int artist_one_result { get; set; }
        public int artist_two_result { get; set; }

        // FOR XAML
        public ICommand do_vote_one { get; set; }
        public ICommand do_vote_two { get; set; }
        public Visibility btn_visibility { get; set; }
        public Visibility result_visibility { get; set; }
        //public Visibility artist_two_result_visibility { get; set; }
    }

    //public class Vote
    //{
    //    public int id { get; set; }
    //    public int user_id { get; set; }
    //    //public int battle_id { get; set; }
    //    public int artist_id { get; set; }
    //}
}