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

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class Signup : Page
    {
        public Signup()
        {
            this.InitializeComponent();
            DataContext = new SignupViewModel();
            date_picker.MaxYear = DateTime.Now.AddYears(-13);
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void signup_btn_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
