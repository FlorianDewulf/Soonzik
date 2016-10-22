using System;
using System.Windows;
using System.Windows.Controls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SonnZik.Streaming.HttpWebRequest;
using SonnZik.Streaming.HttpWebRequest.Poco;
using SoonZik.Streaming.Properties;

namespace SoonZik.Streaming.View
{
    /// <summary>
    /// Logique d'interaction pour Connexion.xaml
    /// </summary>
    public partial class Connexion : UserControl
    {
        #region Attribute
        private string _username { get; set; }
        private string _password { get; set; }
        private bool _checked { get; set; }
        #endregion

        #region ctor
        public Connexion()
        {
            InitializeComponent();
            UserNameTecBox.Text = Settings.Default["Username"].ToString();
            PassWordTextBox.Password = Settings.Default["Password"].ToString();
            RememberMe.IsChecked = (bool) Settings.Default["Checked"];
        }

        #endregion

        #region Method
        private void ConnexionButton_OnClick(object sender, RoutedEventArgs e)
        {
            //_username = UserNameTecBox.Text;
            //_password = PassWordTextBox.Password;
            _username = "artist_one@gmail.com";
            _password = "azertyuiop";

            if (_username != String.Empty && _password != String.Empty)
            {
                MakeConnexion();
                if (_checked)
                {
                    Settings.Default["Username"] = _username;
                    Settings.Default["Password"] = _password;
                    Settings.Default["Checked"] = _checked;
                    Settings.Default.Save();
                }
                else
                {
                    Settings.Default["Username"] = "";
                    Settings.Default["Password"] = "";
                    Settings.Default["Checked"] = _checked;
                    Settings.Default.Save();
                }
            }
            else
            {
                MessageBoxResult result = MessageBox.Show("Veuillez renseigner les champs", "Erreur");
            }
        }

        private async void MakeConnexion()
        {
            try
            {
                var connec = new HttpWebRequestPost();
                await connec.ConnexionSimple(_username, _password);
                var res = connec.Received;
                GetUser(res);
                MainWindow.ConnectionWindow.Close();

            }
            catch
            {
                MessageBox.Show("Erreur de connexion", "Erreur");
                return;
            }
        }

        private void GetUser(string res)
        {
            if (res != null)
            {
                try
                {
                    var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                    Singleton.Singleton.Instance().TheArtiste =
                        JsonConvert.DeserializeObject(stringJson, typeof(User)) as User;
                }
                catch (Exception e)
                {
                    var result = MessageBox.Show("Erreur de connexion", "Erreur");
                }
            }
        }
        #endregion

        private void ToggleButton_OnChecked(object sender, RoutedEventArgs e)
        {
            _checked = true;
        }

        private void ToggleButton_OnUnchecked(object sender, RoutedEventArgs e)
        {
            _checked = false;
        }
    }
}
