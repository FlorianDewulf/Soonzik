using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class BattleViewModel : ViewModelBase
    {
        #region ctor

        public BattleViewModel()
        {
            SelectedCommand = new RelayCommand(SelectedCommandExecute);
            ListBattles = new ObservableCollection<Battle>();
            LoadBattle();
        }

        #endregion

        #region Attribute

        private Battle _selectedBattle;

        public Battle SelectedBattle
        {
            get { return _selectedBattle; }
            set
            {
                _selectedBattle = value;
                RaisePropertyChanged("SelectedBattle");
            }
        }

        private ObservableCollection<Battle> _listBattles;

        public ObservableCollection<Battle> ListBattles
        {
            get { return _listBattles; }
            set
            {
                _listBattles = value;
                RaisePropertyChanged("ListBattles");
            }
        }

        public ICommand SelectedCommand;

        #endregion

        #region Method

        private void SelectedCommandExecute()
        {
            BattleDetailViewModel.CurrentBattle = SelectedBattle;
            GlobalMenuControl.SetChildren(new BattleDetailView());
        }

        private void LoadBattle()
        {
            var request = new HttpRequestGet();
            var listBattle = request.GetListObject(new List<Battle>(), "battles");
            listBattle.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<Battle>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                item.artist_one.image = "http://soonzikapi.herokuapp.com/assets/usersImage/avatars/" +
                                                        item.artist_one.image;
                                item.artist_two.image = "http://soonzikapi.herokuapp.com/assets/usersImage/avatars/" +
                                                        item.artist_two.image;
                                ListBattles.Add(item);
                            });
                    }
                }
            });
        }

        #endregion
    }
}