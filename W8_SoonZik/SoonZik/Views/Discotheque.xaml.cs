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
    public sealed partial class Discotheque : Page
    {
        public Discotheque()
        {
            this.InitializeComponent();
            DataContext = new DiscothequeViewModel();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void album_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Album)e.ClickedItem);
            this.Frame.Navigate(typeof(AlbumOwn), item);
        }

        private void pack_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Pack)e.ClickedItem);
            this.Frame.Navigate(typeof(PackOwn), item);
        }

        private void music_list_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Music)e.ClickedItem);
            this.Frame.Navigate(typeof(MusicOwn), item);
        }
    }
}
