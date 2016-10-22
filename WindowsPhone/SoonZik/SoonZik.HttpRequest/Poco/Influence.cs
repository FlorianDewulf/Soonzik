using System.Collections.ObjectModel;

namespace SoonZik.HttpRequest.Poco
{
    public class Influence
    {
        public int id { get; set; }
        public string name { get; set; }
        public ObservableCollection<Genre> genres { get; set; }
    }
}