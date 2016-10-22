using SoonZik.Tools;
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
    public sealed partial class MusicOwn : Page
    {
        public MusicOwn()
        {
            this.InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            SoonZik.Models.Music elem = e.Parameter as SoonZik.Models.Music;
            DataContext = new MusicViewModel(elem.id);
            media.Source = new Uri("http://api.lvh.me:3000/musics/get/" + elem.id.ToString() + "?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + Singleton.Instance.secureKey , UriKind.RelativeOrAbsolute);
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

    }
}
