using SoonZik.ViewModels;
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

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class Explorer : Page
    {
        public Explorer()
        {
            this.InitializeComponent();
            DataContext = new ExplorerViewModel();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void ambiamce_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Ambiance));
        }

        private void genre_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Genre)e.ClickedItem);
            this.Frame.Navigate(typeof(Genre), item);
        }

        private void album_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Album)e.ClickedItem);
            this.Frame.Navigate(typeof(Album), item);
        }

        private void pack_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Pack)e.ClickedItem);
            this.Frame.Navigate(typeof(Pack), item);
        }

        private void artist_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.User)e.ClickedItem);
            this.Frame.Navigate(typeof(Artist), item);
        }

        private void cart_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Cart));
        }

        private void ambiance_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Ambiance)e.ClickedItem);
            this.Frame.Navigate(typeof(Ambiance), item);
        }

        private void music_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Music)e.ClickedItem);
            this.Frame.Navigate(typeof(Music), item);
        }
    }
}
