using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using System.Collections.ObjectModel;


namespace SoonZik.Tools
{
    class Get_coment
    {
        public static ObservableCollection<Comment> commentlist { get; set; }

        async static public Task<ObservableCollection<Comment>> load_coments(string elem)
        {
            commentlist = new ObservableCollection<Comment>();
            elem += "/comments";

            var comments = (List<Comment>)await Http_get.get_object(new List<Comment>(), elem);

            foreach (var item in comments)
                commentlist.Add(item);
            return commentlist;
        }
    }
}
