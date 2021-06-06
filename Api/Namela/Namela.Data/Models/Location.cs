using System;

namespace Namela.Data.Models
{
    public class Location
    {
        public GeoCoordinates GeoCoordinates { get; set; }
        public DateTimeOffset Date { get; set; }
        //todo: add prop for tracked item- user, taxi... 
    }
}
