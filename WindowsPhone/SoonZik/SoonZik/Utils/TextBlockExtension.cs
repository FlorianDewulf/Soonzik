using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Documents;
using Windows.UI.Xaml.Media;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.ViewModel;
using SoonZik.Views;

namespace SoonZik.Utils
{
    public class TextBlockExtension
    {
        public static string GetFormattedText(DependencyObject obj)
        {
            return (string) obj.GetValue(FormattedTextProperty);
        }

        public static void SetFormattedText(DependencyObject obj, string value)
        {
            obj.SetValue(FormattedTextProperty, value);
        }

        private static void link_Click(Hyperlink sender, HyperlinkClickEventArgs args)
        {
            var run = sender.Inlines.FirstOrDefault() as Run;
            if (run != null)
            {
                var user = run.Text;
                if (user != string.Empty)
                {
                    string finalUser = null;
                    for (var i = 1; i < user.Length; i++)
                        finalUser += user[i];
                    var request = new HttpRequestGet();
                    request.FindUser(new List<User>(), finalUser).ContinueWith(delegate(Task<object> tmp)
                    {
                        var res = tmp.Result as List<User>;
                        if (res != null && res[0].groups.Count != 0)
                        {
                            if (res[0].groups[0].name.Equals("Artist"))
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        ProfilArtisteViewModel.TheUser = res[0];
                                        GlobalMenuControl.SetChildren(new ProfilArtiste());
                                    });
                            }
                        }
                        else if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    ProfilFriendViewModel.UserFromButton = res[0];
                                    GlobalMenuControl.SetChildren(new ProfilFriendView());
                                });
                        }
                    });
                }
            }
        }

        public static readonly DependencyProperty FormattedTextProperty =
            DependencyProperty.Register("FormattedText", typeof (string), typeof (TextBlockExtension),
                new PropertyMetadata(string.Empty, (sender, e) =>
                {
                    var text = e.NewValue as string;
                    var textBl = sender as TextBlock;
                    if (textBl != null)
                    {
                        textBl.Inlines.Clear();
                        var regx = new Regex(@"(@[^\s]+)", RegexOptions.IgnoreCase);
                        var str = regx.Split(text);
                        for (var i = 0; i < str.Length; i++)
                            if (i%2 == 0)
                                textBl.Inlines.Add(new Run {Text = str[i]});
                            else
                            {
                                //char[] test = new char[str[i].Length];
                                // str[i].CopyTo(1, test, str[i].Length, test.Length);
                                var link = new Hyperlink
                                {
                                    Foreground = Application.Current.Resources["PhoneAccentBrush"] as SolidColorBrush
                                };
                                link.Inlines.Add(new Run {Text = str[i]});
                                link.Click += link_Click;
                                textBl.Inlines.Add(link);
                            }
                    }
                }));
    }
}