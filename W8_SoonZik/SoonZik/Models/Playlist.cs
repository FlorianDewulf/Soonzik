using System;
using System.Collections.Generic;
using SoonZik;
using Windows.Media.Playlists;
using Windows.Storage;
using Windows.Storage.Pickers;
using Windows.UI.Xaml;

namespace SoonZik.Models
{
    public class Playlist
    {
        public int id { get; set; }
        public string name { get; set; }
        public List<Music> musics { get; set; }
        public User user { get; set; }


    }
}
