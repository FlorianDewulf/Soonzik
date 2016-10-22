using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;
using SoonZik.ViewModel;

// Pour en savoir plus sur le modèle d’élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkID=390556

namespace SoonZik.Views
{
    /// <summary>
    ///     Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class AlbumView : Page
    {
        private bool PlayTapped;

        public AlbumView()
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

        private void PlayImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            PlayTapped = true;
            var vm = DataContext as AlbumViewModel;
            if (vm != null) vm.PlayCommand.Execute(null);
        }

        private void UIElement_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            if (!PlayTapped)
            {
                var senderElement = sender as FrameworkElement;
                var flyoutBase = FlyoutBase.GetAttachedFlyout(senderElement);

                flyoutBase.ShowAt(senderElement);
            }
            PlayTapped = false;
        }

        private void ItemPlaylist_OnTapped(object sender, RoutedEventArgs routedEventArgs)
        {
            var vm = DataContext as AlbumViewModel;
            if (vm != null) vm.AddToPlaylist.Execute(null);
        }

        private void ItemCart_OnTapped(object sender, RoutedEventArgs routedEventArgs)
        {
            var vm = DataContext as AlbumViewModel;
            if (vm != null) vm.AddToCart.Execute(null);
        }

        private void NotationMusic_OnClick(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as AlbumViewModel;
            if (vm != null) vm.RateMusic.Execute(null);
        }

        private void LikeImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var vm = DataContext as AlbumViewModel;
            if (vm != null) vm.LikeCommand.Execute(null);
        }
    }
}