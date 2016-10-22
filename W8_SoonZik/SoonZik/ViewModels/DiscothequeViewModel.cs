using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.ViewModels;
using SoonZik.Tools;
using System.Collections.ObjectModel;
using SoonZik.Models;
using Windows.UI.Popups;
using SoonZik.ViewModels.Command;
using System.Windows.Input;
using System.ComponentModel;
namespace SoonZik.ViewModels
{
    class DiscothequeViewModel : INotifyPropertyChanged
    {
        private MusicOwnByUser _music_own;
        public MusicOwnByUser music_own
        {
            get { return _music_own; }
            set
            {
                _music_own = value;
                OnPropertyChanged("music_own");
            }
        }

        public ObservableCollection<Album> album_list { get; set; }
        //public ObservableCollection<Music> music_list { get; set; }
        //public ObservableCollection<Pack> pack_list { get; set; }


        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public DiscothequeViewModel()
        {
            load_disco();
        }

        async void load_disco()
        {
            Exception exception = null;

            //music_list = new ObservableCollection<Music>();
            //pack_list = new ObservableCollection<Pack>();
            album_list = new ObservableCollection<Album>();

            music_own = new MusicOwnByUser();

            try
            {
                music_own = (MusicOwnByUser)await Http_get.get_object(new MusicOwnByUser(), "/users/getmusics?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));

                foreach (var item in music_own.albums)
                {
                    item.image = Singleton.Instance.url + "/assets/albums/" + item.image;
                    album_list.Add(item);
                }

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération de la discothèque").ShowAsync();
        }
    }
}
