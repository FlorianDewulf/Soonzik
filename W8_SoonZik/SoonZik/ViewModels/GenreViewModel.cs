using Newtonsoft.Json.Linq;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    public class GenreViewModel : INotifyPropertyChanged
    {
        private Genre _genre;
        public Genre genre
        {
            get { return _genre; }
            set
            {
                _genre = value;
                OnPropertyChanged("genre");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public GenreViewModel(int id)
        {
            load_genre(id);
        }

        async public void load_genre(int id)
        {
            Exception exception = null;
            var request = new Http_get();

            try
            {
                genre = await Http_get.get_genre_by_id(id);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des genres").ShowAsync();
        }
    }
}
