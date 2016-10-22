using System;
using Windows.Networking.Connectivity;

namespace SoonZik.Helpers
{
    public class InternetConnectionChangedEventArgs : EventArgs
    {
        public InternetConnectionChangedEventArgs(bool isConnected)
        {
            IsConnected = isConnected;
        }

        public bool IsConnected { get; private set; }
    }

    public static class Network
    {
        static Network()
        {
            NetworkInformation.NetworkStatusChanged += s =>
            {
                if (InternetConnectionChanged != null)
                {
                    var arg = new InternetConnectionChangedEventArgs(IsConnected);
                    InternetConnectionChanged(null, arg);
                }
            };
        }

        public static bool IsConnected
        {
            get
            {
                var profile = NetworkInformation.GetInternetConnectionProfile();
                var isConnected = (profile != null
                                   && profile.GetNetworkConnectivityLevel() ==
                                   NetworkConnectivityLevel.InternetAccess);
                return isConnected;
            }
        }

        public static event EventHandler<InternetConnectionChangedEventArgs>
            InternetConnectionChanged;
    }
}