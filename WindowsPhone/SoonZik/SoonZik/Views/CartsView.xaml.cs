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
    public sealed partial class CartsView : Page
    {
        public CartsView()
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

        private void DeleteItem_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var vm = DataContext as CartsViewModel;
            if (vm != null)
                vm.DeleteCommand.Execute(null);
        }
    }
}