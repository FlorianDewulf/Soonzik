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
using SoonZik.Models;
using SoonZik.ViewModels;
using SoonZik.Tools;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class NewsDetails : Page
    {
        public NewsDetails()
        {
            this.InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            News elem = e.Parameter as News;
            DataContext = new NewsViewModel(elem.id);

            // To get the news id
            //string request_elem = "/news/" + elem.id.ToString();

            //// To get comment list
            //var comments = new CommentViewModel(request_elem);
            //comment_lv.ItemsSource = comments.commentlist;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void send_com_btn_Click(object sender, RoutedEventArgs e)
        {
            //string comment_content = send_com_tb.Text;
            //Post_comment com = new Post_comment(comment_content, "news", news_id_txt.Text);
        }
    }
}
