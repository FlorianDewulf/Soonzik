using System;

namespace SoonZik.Utils
{
    public interface INavigationService
    {
        void Navigate(Type sourcePageType);
        void Navigate(Type sourcePageType, object parameter);
        void GoBack();
    }
}