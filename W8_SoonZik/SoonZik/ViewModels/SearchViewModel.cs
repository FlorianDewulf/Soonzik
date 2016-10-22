using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
using System.Windows.Input;
using Windows.UI.Popups;
using System.Net;
using SoonZik.Common;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml;

namespace SoonZik.ViewModels
{
    class SearchViewModel
    {
        public Search search_result { get; set; }
        public string search_value { get; set; }

        public ICommand do_search
        {
            get;
            private set;
        }

        public SearchViewModel()
        {
            do_search = new RelayCommand(search);
        }

        public async void search()
        {
            var search_result = (Search)await Http_get.get_search_result(new Search(), "search?query=" + WebUtility.UrlEncode(search_value));
            if (search_result != null)
            {
                ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Search), search_result);
            }
        }
    }
}
