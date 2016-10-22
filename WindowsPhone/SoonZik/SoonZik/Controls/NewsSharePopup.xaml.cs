using System;
using System.Collections.Generic;
using Windows.UI.Popups;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using SoonZik.HttpRequest.Poco;
using SoonZik.ViewModel;
using Tweetinvi;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class NewsSharePopup : UserControl
    {
        private readonly News _selectedNews;

        public NewsSharePopup(News theNews)
        {
            InitializeComponent();
            _selectedNews = theNews;
        }

        public void FacebookShare_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            try
            {
                var postParams = new
                {
                    name = _selectedNews.newstexts[0].title,
                    caption = _selectedNews.newstexts[0].content,
                    description = TextBoxShare.Text,
                    picture = "http://facebooksdk.net/assets/img/logo75x75.png"
                };
                ShareOnFaceBook(postParams);
            }
            catch (Exception ex)
            {
                var message = ex.Message;
                new MessageDialog("Facebook error").ShowAsync();
                NewsDetailViewModel.SharePopup.IsOpen = false;
            }
        }

        private async void ShareOnFaceBook(object postParams)
        {
            if (Singleton.Singleton.Instance().MyFacebookClient != null)
            {
                try
                {
                    dynamic fbPostTaskResult =
                        await Singleton.Singleton.Instance().MyFacebookClient.PostTaskAsync("/me/feed", postParams);
                    var responseresult = (IDictionary<string, object>) fbPostTaskResult;
                    var SuccessMsg = new MessageDialog("Message posted sucessfully on facebook wall");
                    await SuccessMsg.ShowAsync();
                    NewsDetailViewModel.SharePopup.IsOpen = false;
                }
                catch (Exception ex)
                {
                    var ErrMsg = new MessageDialog("Error Ocuured!" + ex).ShowAsync();
                    NewsDetailViewModel.SharePopup.IsOpen = false;
                }
            }
            else
            {
                var ErrMsg = new MessageDialog("Vous n'etes pas connecter a facebook").ShowAsync();
                NewsDetailViewModel.SharePopup.IsOpen = false;
            }
        }

        public void TwitterShare_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            try
            {
                Tweet.PublishTweet(TextBoxShare.Text + " " + _selectedNews.title + "from @SoonZik");
                var SuccessMsg = new MessageDialog("Message posted sucessfully on Twitter");
                NewsDetailViewModel.SharePopup.IsOpen = false;
            }
            catch (Exception)
            {
                new MessageDialog("not connected on twitter").ShowAsync();
                NewsDetailViewModel.SharePopup.IsOpen = false;
            }
        }

        private void UIElement_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            NewsDetailViewModel.SharePopup.IsOpen = false;
        }
    }
}