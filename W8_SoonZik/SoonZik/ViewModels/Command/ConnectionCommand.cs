using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace SoonZik.ViewModels.Command
{
    class ConnectionCommand : ICommand
    {
        private ConnectionViewModel _ViewModel;

        public ConnectionCommand(ConnectionViewModel ViewModel)
        {
            _ViewModel = ViewModel;
        }

        // ADD & REMOVE to avoid warning ...
        public event EventHandler CanExecuteChanged
        {
            add { } remove { } }

        public bool CanExecute(object parameter)
        {
            //return _ViewModel.canUpdate;
            return true;
        }

        public void Execute(object parameter)
        {
            _ViewModel.classic_connection();
        }
    }
}
