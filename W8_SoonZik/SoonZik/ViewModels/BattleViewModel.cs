using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;


namespace SoonZik.ViewModels
{
    class BattleViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<Battle> battlelist { get; set; }

        //private Battle _selected_battle;

        public Battle selected_battle { get; set; }
        //{
        //    get { return _selected_battle; }
        //    set
        //    {
        //        _selected_battle = value;
        //        OnPropertyChanged("selected_battle");
        //    }
        //}

        private Visibility _btn_visibility;
        public Visibility btn_visibility
        {
            get { return _btn_visibility; }
            set
            {
                _btn_visibility = value;
                OnPropertyChanged("btn_visibility");
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

        public BattleViewModel()
        {
            load_battle();
        }

        async void load_battle()
        {
            Exception exception = null;
            battlelist = new ObservableCollection<Battle>();

            try
            {
                var battles = (List<Battle>)await Http_get.get_object(new List<Battle>(), "battles");

                foreach (var item in battles)
                {
                    item.do_vote_one = new RelayCommand(vote_a1);
                    item.do_vote_two = new RelayCommand(vote_a2);

                    //if (item.votes.Any())
                    //{

                    //    // GET RESULT
                    //    first_artist_in_vote = item.votes[0].artist_id;
                    //    if (item.artist_one.id == item.votes[0].artist_id)
                    //    {
                    //        item.artist_one_result = get_result_first_artist_in_votes(item.votes);
                    //        item.artist_two_result = 100 - item.artist_one_result;
                    //    }
                    //    else
                    //        item.artist_two_result = get_result_first_artist_in_votes(item.votes);

                    //    // SET VISIBILITY

                    //}
                    //add_result_to_battle(item);

                    //battlelist.Add(item);
                    battlelist.Add(add_result_to_battle(item));
                }
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des battles").ShowAsync();
        }

        public void vote_a1()
        {
            vote(selected_battle.artist_one.id);
        }

        public void vote_a2()
        {
            vote(selected_battle.artist_two.id);
        }

        public async void vote(int id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&artist_id=" + id.ToString() +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("battles/" + selected_battle.id.ToString() + "/vote", post_data);
                var json = JObject.Parse(response).SelectToken("code");

                // Debug. 200 = success
                if (json.ToString() == "200" || json.ToString() == "201")
                {
                    await new MessageDialog("Le vote a été comptabilisé").ShowAsync();

                    // SET NEW VOTE
                    Vote new_vote = new Vote();
                    new_vote.user_id = Singleton.Instance.Current_user.id;
                    new_vote.artist_id = id;
                    selected_battle.votes.Add(new_vote);


                    battlelist[battlelist.IndexOf(selected_battle)].result_visibility = Visibility.Visible;
                    battlelist[battlelist.IndexOf(selected_battle)].btn_visibility = Visibility.Collapsed;
                    battlelist[battlelist.IndexOf(selected_battle)].votes.Add(new_vote);

                }
                else
                    await new MessageDialog("Erreur lors du vote").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors du vote").ShowAsync();
        }

        public Battle add_result_to_battle(Battle item)
        {

            int first_artist_in_vote; // To get the first artist that appears in votes...

            // SET VISIBILITY

            //if (item.votes.Any(x => x.user_id == Singleton.Instance.Current_user.id))
            //{
            //    item.btn_visibility = Visibility.Collapsed;
            //    item.result_visibility = Visibility.Visible;
            //}
            //else
            //{
            //    item.btn_visibility = Visibility.Visible;
            //    item.result_visibility = Visibility.Collapsed;
            //}

            // GET RESULT
            if (item.votes.Any())
            {
                first_artist_in_vote = item.votes[0].artist_id;

                if (item.artist_one.id == item.votes[0].artist_id) // if first artist in vote = artist_one
                {
                    item.artist_one_result = get_result_for_the_first_artist_in_votes(item.votes);
                    item.artist_two_result = 100 - item.artist_one_result;
                }
                else
                {
                    item.artist_two_result = get_result_for_the_first_artist_in_votes(item.votes);
                    item.artist_one_result = 100 - item.artist_two_result;
                }
            }
            return item;
        }

        public int get_result_for_the_first_artist_in_votes(List<Vote> votes)
        {
            int artist_selected; // First artist_id in votes;
            int number_of_vote_for_artist_selected;

            if (votes.Any())
            {
                artist_selected = votes[0].artist_id;
                number_of_vote_for_artist_selected = votes.Count(x => x.artist_id == artist_selected);

                return (number_of_vote_for_artist_selected * 100) / votes.Count(); // Calcul percentage
            }

            return 0;
        }
    }
}
