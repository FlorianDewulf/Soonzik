using SoonZik.Tools;
using SoonZik.ViewModels;
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

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class Music : Page
    {
        public Music()
        {
            this.InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            SoonZik.Models.Music elem = e.Parameter as SoonZik.Models.Music;
            DataContext = new MusicViewModel(elem.id);
            media.Source = new Uri("http://api.lvh.me:3000/musics/get/" + elem.id.ToString(), UriKind.RelativeOrAbsolute);

            //music_id.Text = elem.id.ToString();
            ////music_artist.Text = elem.user.username;
            //music_title.Text = elem.title;
            //music_price.Text = Math.Round(elem.price, 3).ToString();
            //music_note.Text = elem.getAverageNote.ToString();
            //music_duration.Text = TimeSpan.FromSeconds(elem.duration).ToString();   


            //string request_elem = "/musics/" + elem.id.ToString();

            //// To get comment list
            //var comments = new CommentViewModel(request_elem);
            //comment_lv.ItemsSource = comments.commentlist;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }


        //private void send_com_btn_Click(object sender, RoutedEventArgs e)
        //{
        //    string comment_content = send_com_tb.Text;
        //    Post_comment com = new Post_comment(comment_content, "musics", music_id.Text);
        //}


    }
}
