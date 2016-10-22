using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Address
    {
        public string id { get; set; }
        public string numberStreet { get; set; }
        public string street { get; set; }
        public string city { get; set; }
        public string country { get; set; }
        public string zipcode { get; set; }
        public string complement { get; set; }
        
        // Just used to geocode
        public string lat { get; set; }
        public string lng { get; set; }

        public double latt { get; set; }
        public double lngg { get; set; }
    }
}
