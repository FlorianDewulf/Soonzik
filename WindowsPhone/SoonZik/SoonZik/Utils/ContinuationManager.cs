using Windows.ApplicationModel.Activation;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.ViewModel;

namespace SoonZik.Helpers
{
    public class ContinuationManager
    {
        public void ContinueWith(IActivatedEventArgs args)
        {
            var frame = (Frame) Window.Current.Content;
            if (frame == null)
                return;

            switch (args.Kind)
            {
                case ActivationKind.PickFileContinuation:
                    break;
                case ActivationKind.PickFolderContinuation:
                    break;
                case ActivationKind.PickSaveFileContinuation:
                    break;
                case ActivationKind.WebAuthenticationBrokerContinuation:
                    var continuator = new ConnexionViewModel();
                    continuator.ContinueWithWebAuthenticationBroker((WebAuthenticationBrokerContinuationEventArgs) args);
                    break;
                default:
                    break;
            }
        }
    }

    internal interface IWebAuthenticationBrokerContinuable
    {
        void ContinueWithWebAuthenticationBroker(WebAuthenticationBrokerContinuationEventArgs args);
    }
}