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
using SoonZik.ViewModels;

// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class Connection : Page
    {
        public Connection()
        {
            this.InitializeComponent();
            DataContext = new ConnectionViewModel();
        }

        private void signup_txt_SelectionChanged(object sender, TappedRoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Signup));
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var item = new SoonZik.Models.Pack();
            item.id = 1;
            this.Frame.Navigate(typeof(Pack), item);
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Feedback));

        }

        private void feedback_txt_Tapped(object sender, TappedRoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Feedback));
        }
    }
}
