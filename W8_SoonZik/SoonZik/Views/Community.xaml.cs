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
using SoonZik.Views;
using SoonZik.ViewModels;

// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class Community : Page
    {
        public Community()
        {
            this.InitializeComponent();
            DataContext = new TweetViewModel();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void user_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.User)e.ClickedItem);
            this.Frame.Navigate(typeof(User), item);
        }
        //private void concert_btn_Click(object sender, RoutedEventArgs e)
        //{
        //    this.Frame.Navigate(typeof(Concert));
        //}

        //private void battle_btn_Click(object sender, RoutedEventArgs e)
        //{
        //    this.Frame.Navigate(typeof(Battle));
        //}

        //private void follow_btn_Click(object sender, RoutedEventArgs e)
        //{
        //    this.Frame.Navigate(typeof(follow));
        //}

    }
}
