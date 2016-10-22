using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class NotationMusic : UserControl
    {
        public NotationMusic()
        {
            InitializeComponent();
        }

        public static Music SelectMusic { get; set; }

        private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
            var note = 0;
            if (RadioButtonOne.IsChecked != null && RadioButtonOne.IsChecked.Value)
                note = 1;
            else if (RadioButtonTwo.IsChecked != null && RadioButtonTwo.IsChecked.Value)
                note = 2;
            else if (RadioButtonThree.IsChecked != null && RadioButtonThree.IsChecked.Value)
                note = 3;
            else if (RadioButtonFour.IsChecked != null && RadioButtonFour.IsChecked.Value)
                note = 4;
            else if (RadioButtonFive.IsChecked != null && RadioButtonFive.IsChecked.Value)
                note = 5;

            var request2 = new HttpRequestPost();

            ValidateKey.GetValideKey();
            var res = request2.SetRate(SelectMusic, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser.id.ToString(), note);
            res.ContinueWith(delegate(Task<string> tmp)
            {
                if (tmp.Result != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { AlbumViewModel.RatePopup.IsOpen = false; });
                }
            });
        }
    }
}