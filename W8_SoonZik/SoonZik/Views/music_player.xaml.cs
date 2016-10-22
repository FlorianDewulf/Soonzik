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
using Windows.Media.Playlists;
using Windows.Storage;
using Windows.Storage.Pickers;
using SoonZik;
using SoonZik.ViewModels;
using SoonZik.Tools;


// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class music_player : Page
    {
        public music_player()
        {
            this.InitializeComponent();
            DataContext = new PlayerViewModel();

            // ListView
            album_list_lv.Visibility = Visibility.Collapsed;
            track_list_lv.Visibility = Visibility.Collapsed;
            playlist_update_lv.Visibility = Visibility.Collapsed;

            // Text & TB
            playlist_name_tb.Visibility = Visibility.Collapsed;
            playlist_name_update_tb.Visibility = Visibility.Collapsed;
            album_list_txt.Visibility = Visibility.Collapsed;
            tracklist_txt.Visibility = Visibility.Collapsed;
            playlist_list_txt.Visibility = Visibility.Collapsed;
            playlist_name_txt.Visibility = Visibility.Collapsed;

            // Add and remove from list btn
            add_to_playlist_update_btn.Visibility = Visibility.Collapsed;
            delete_from_playlist_update_btn.Visibility = Visibility.Collapsed;
            cancel_btn.Visibility = Visibility.Collapsed;


            // Create and update btn
            update_playlist_btn.Visibility = Visibility.Collapsed;
            create_playlist_btn.Visibility = Visibility.Collapsed;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }




        // CREATE BTN
        void new_playlist_btn_Click(object sender, RoutedEventArgs e)
        {
            // ListView
            album_list_lv.Visibility = Visibility.Visible;
            track_list_lv.Visibility = Visibility.Visible;
            playlist_update_lv.Visibility = Visibility.Visible;

            // Text & TB
            playlist_name_tb.Visibility = Visibility.Visible;
            album_list_txt.Visibility = Visibility.Visible;
            tracklist_txt.Visibility = Visibility.Visible;
            playlist_list_txt.Visibility = Visibility.Visible;
            playlist_name_txt.Visibility = Visibility.Visible;
            playlist_name_update_tb.Visibility = Visibility.Collapsed;


            // Add and remove from list btn
            add_to_playlist_update_btn.Visibility = Visibility.Visible;
            delete_from_playlist_update_btn.Visibility = Visibility.Visible;
            cancel_btn.Visibility = Visibility.Visible;


            create_playlist_btn.Visibility = Visibility.Visible;
            update_playlist_btn.Visibility = Visibility.Collapsed;

        }

        // DONE CREATING BTN
        private void create_playlist_btn_Click(object sender, RoutedEventArgs e)
        {
            // ListView
            album_list_lv.Visibility = Visibility.Collapsed;
            track_list_lv.Visibility = Visibility.Collapsed;
            playlist_update_lv.Visibility = Visibility.Collapsed;

            // Text & TB
            playlist_name_tb.Visibility = Visibility.Collapsed;
            album_list_txt.Visibility = Visibility.Collapsed;
            tracklist_txt.Visibility = Visibility.Collapsed;
            playlist_list_txt.Visibility = Visibility.Collapsed;
            playlist_name_update_tb.Visibility = Visibility.Collapsed;
            playlist_name_txt.Visibility = Visibility.Collapsed;




            // Add and remove from list btn
            add_to_playlist_update_btn.Visibility = Visibility.Collapsed;
            delete_from_playlist_update_btn.Visibility = Visibility.Collapsed;
            cancel_btn.Visibility = Visibility.Collapsed;


            create_playlist_btn.Visibility = Visibility.Collapsed;
            update_playlist_btn.Visibility = Visibility.Collapsed;

        }


        // EDIT
        private void edit_playlist_btn_Click(object sender, RoutedEventArgs e)
        {
            // ListView
            album_list_lv.Visibility = Visibility.Visible;
            track_list_lv.Visibility = Visibility.Visible;
            playlist_update_lv.Visibility = Visibility.Visible;

            // Text & TB
            playlist_name_update_tb.Visibility = Visibility.Visible;
            playlist_name_txt.Visibility = Visibility.Visible;


            //
            // Visibility on button and textbox et c'est tout :)
            //
            album_list_txt.Visibility = Visibility.Visible;
            tracklist_txt.Visibility = Visibility.Visible;
            playlist_list_txt.Visibility = Visibility.Visible;



            // Add and remove from list btn
            add_to_playlist_update_btn.Visibility = Visibility.Visible;
            delete_from_playlist_update_btn.Visibility = Visibility.Visible;
            cancel_btn.Visibility = Visibility.Visible;


            update_playlist_btn.Visibility = Visibility.Visible;
            create_playlist_btn.Visibility = Visibility.Collapsed;

        }

        private void update_playlist_btn_Click(object sender, RoutedEventArgs e)
        {
            // ListView
            album_list_lv.Visibility = Visibility.Collapsed;
            track_list_lv.Visibility = Visibility.Collapsed;
            playlist_update_lv.Visibility = Visibility.Collapsed;

            // Text & TB
            playlist_name_update_tb.Visibility = Visibility.Collapsed;
            playlist_name_tb.Visibility = Visibility.Collapsed;
            album_list_txt.Visibility = Visibility.Collapsed;
            tracklist_txt.Visibility = Visibility.Collapsed;
            playlist_list_txt.Visibility = Visibility.Collapsed;
            playlist_name_txt.Visibility = Visibility.Collapsed;


            // Add and remove from list btn
            add_to_playlist_update_btn.Visibility = Visibility.Collapsed;
            delete_from_playlist_update_btn.Visibility = Visibility.Collapsed;
            cancel_btn.Visibility = Visibility.Collapsed;

            update_playlist_btn.Visibility = Visibility.Collapsed;
            create_playlist_btn.Visibility = Visibility.Collapsed;

        }

        private async void playlist_tracklist_player_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (Singleton.Instance.selected_music != null)
                media.Source = new Uri(Singleton.Instance.url + "/musics/get/"
                    + Singleton.Instance.selected_music.id.ToString()
                    + "?user_id=" + Singleton.Instance.Current_user.id.ToString()
                    + "&secureKey=" + await SoonZik.Tools.Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()), UriKind.RelativeOrAbsolute);
     //           media.Source = new Uri(Singleton.Instance.url + "/musics/get/"
     //+ Singleton.Instance.selected_music.id.ToString(), UriKind.RelativeOrAbsolute);
        }

        private void cancel_btn_Click(object sender, RoutedEventArgs e)
        {
            album_list_lv.Visibility = Visibility.Collapsed;
            track_list_lv.Visibility = Visibility.Collapsed;
            playlist_update_lv.Visibility = Visibility.Collapsed;

            // Text & TB
            playlist_name_tb.Visibility = Visibility.Collapsed;
            playlist_name_update_tb.Visibility = Visibility.Collapsed;
            album_list_txt.Visibility = Visibility.Collapsed;
            tracklist_txt.Visibility = Visibility.Collapsed;
            playlist_list_txt.Visibility = Visibility.Collapsed;
            playlist_name_txt.Visibility = Visibility.Collapsed;

            // Add and remove from list btn
            add_to_playlist_update_btn.Visibility = Visibility.Collapsed;
            delete_from_playlist_update_btn.Visibility = Visibility.Collapsed;

            // Create and update and cancel btn
            update_playlist_btn.Visibility = Visibility.Collapsed;
            create_playlist_btn.Visibility = Visibility.Collapsed;
            cancel_btn.Visibility = Visibility.Collapsed;
        }
    }
}
