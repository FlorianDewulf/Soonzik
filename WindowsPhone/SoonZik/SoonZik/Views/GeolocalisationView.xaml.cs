using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;
using SoonZik.ViewModel;

// Pour en savoir plus sur le modèle d’élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkID=390556

namespace SoonZik.Views
{
    /// <summary>
    ///     Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class GeolocalisationView : Page
    {
        public GeolocalisationView()
        {
            InitializeComponent();
        }

        /// <summary>
        ///     Invoqué lorsque cette page est sur le point d'être affichée dans un frame.
        /// </summary>
        /// <param name="e">
        ///     Données d'événement décrivant la manière dont l'utilisateur a accédé à cette page.
        ///     Ce paramètre est généralement utilisé pour configurer la page.
        /// </param>
        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
        }

        private void TwoRadioButton_OnClick(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GeolocalisationViewModel;
            if (vm != null) vm.TwoChecked.Execute(null);
        }

        private void FiveRadioButton_OnClick(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GeolocalisationViewModel;
            if (vm != null) vm.FiveChecked.Execute(null);
        }

        private void TenRadioButton_OnClick(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GeolocalisationViewModel;
            if (vm != null) vm.TenChecked.Execute(null);
        }

        private void TwentyRadioButton_OnClick(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GeolocalisationViewModel;
            if (vm != null) vm.TwentyChecked.Execute(null);
        }

        private void UIElement_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var vm = DataContext as GeolocalisationViewModel;
            if (vm != null) vm.UserTappedCommand.Execute(null);
        }
        
        private void ConcertGrid_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var vm = DataContext as GeolocalisationViewModel;
            if (vm != null) vm.ConcertTappedCommand.Execute(null);
        }
    }
}