using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class ListeningViewModel
    {
        public ObservableCollection<Listening> listening_list { get; set; }

        public ListeningViewModel()
        {
            load_listening();
        }

        async void load_listening()
        {
            Exception exception = null;
            listening_list = new ObservableCollection<Listening>();

            try
            {
                var listenings = (List<Listening>)await Http_get.get_object(new List<Listening>(), "listenings");

                foreach (var item in listenings)
                {
                    listening_list.Add(item);
                }

            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
                await new MessageDialog("Erreur de chargement de la fonctionnalité listening").ShowAsync();
        }
    }
}
