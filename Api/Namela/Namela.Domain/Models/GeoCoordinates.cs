using System;
using System.Collections.Generic;
using System.Text;
using Namela.Domain.Models.Bases;

namespace Namela.Domain.Models
{
    public class GeoCoordinates: Model
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
