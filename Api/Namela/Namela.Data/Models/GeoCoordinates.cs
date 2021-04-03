using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class GeoCoordinates: Model
    {
        public double Latitude { get; private set; }
        public double Longitude { get; private set; }

        public GeoCoordinates() { }

        public GeoCoordinates(double longitude, double latitude)
        {
            Longitude = longitude;
            Latitude = latitude;
        }
    }
}
