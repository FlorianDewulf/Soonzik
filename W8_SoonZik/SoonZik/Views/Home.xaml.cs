using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using SoonZik.Tools;
using SoonZik.ViewModels;

using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class Home : Page
    {
        public Home()
        {
            this.InitializeComponent();
            DataContext = new HomeViewModel();
            if (Singleton.Instance.Current_user.username != null)
                hello_tb.Text = "Bonjour " + Singleton.Instance.Current_user.username;
        }

        // NAV
        private void news_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(NewsView));
        }

        private void explorer_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Explorer));
        }

        private void concert_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Concert));
        }

        private void battle_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Battle));
        }

        //private void shop_btn_Click(object sender, RoutedEventArgs e)
        //{
        //    this.Frame.Navigate(typeof(Shop));
        //}

        private void listenings_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Listenings));
        }

        private void audio_player_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(music_player));
        }

        private void sign_out_Click(object sender, RoutedEventArgs e)
        {
            //Singleton.Instance.secureKey = null;
            //Singleton.Instance.compare_date.AddMinutes(10);
            this.Frame.GoBack();
        }

        private void profil_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(UserEditProfile));
        }

        private void disco_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Discotheque));
        }

        private void community_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Community));
        }

        // Clic in list
        private void News_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.News)e.ClickedItem);
            this.Frame.Navigate(typeof(NewsDetails), item);
        }

        private void Music_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Album)e.ClickedItem);
            this.Frame.Navigate(typeof(Album), item);
        }

        private void Community_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.User)e.ClickedItem);
            this.Frame.Navigate(typeof(User), item);
        }
        private void pack_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Pack)e.ClickedItem);
            this.Frame.Navigate(typeof(Pack), item);
        }

        private void news_grid_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.News)e.ClickedItem);
            this.Frame.Navigate(typeof(NewsDetails), item);
        }

        private void feedback_txt_Tapped(object sender, TappedRoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Feedback));
        }

        // END
    }
}
