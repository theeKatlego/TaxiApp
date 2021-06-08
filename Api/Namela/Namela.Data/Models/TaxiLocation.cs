using System;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class TaxiLocation: Model
    {
        public GeoCoordinates GeoCoordinates { get; private set; }
        public DateTimeOffset Date { get; set; }
        public Guid TaxiVersionIndependentId { get; private set; }

        public TaxiLocation(GeoCoordinates geoCoordinates, DateTimeOffset date, Guid taxiVersionIndependentId)
        {
            GeoCoordinates = geoCoordinates;
            Date = date;
            TaxiVersionIndependentId = taxiVersionIndependentId;
        }
    }
}
