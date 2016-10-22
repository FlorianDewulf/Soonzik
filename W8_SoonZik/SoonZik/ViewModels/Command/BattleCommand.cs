using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using SoonZik.Models;

namespace SoonZik.ViewModels.Command
{
    class BattleCommand : ICommand
    {
        BattleViewModel _ViewModel;

        public BattleCommand(BattleViewModel ViewModel)
        {
            _ViewModel = ViewModel;
        }

        // ADD & REMOVE to avoid warning ...
        public event EventHandler CanExecuteChanged { add { } remove { } }

        public bool CanExecute(object parameter)
        {
            //if (_ViewModel.new_follow != null)
            //    return true;
            //return false;
            return true;
        }

        public void Execute(object parameter)
        {
            // CommandParameter="1" for command "do_vote_one"
            //if (parameter as string == "1")
            //    _ViewModel.vote(_ViewModel.selected_battle.artist_one.id.ToString());
            //else
            //    _ViewModel.vote(_ViewModel.selected_battle.artist_two.id.ToString());
        }
    }
}
