using System;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class RiderLocation: Model
    {
        public GeoCoordinates GeoCoordinates { get; private set; }
        public DateTimeOffset Date { get; set; }
        public Guid UserVersionIndependentId { get; private set; }

        private RiderLocation() { }

        public RiderLocation(GeoCoordinates geoCoordinates, DateTimeOffset date, Guid userVersionIndependentId)
        {
            GeoCoordinates = geoCoordinates;
            Date = date;
            UserVersionIndependentId = userVersionIndependentId;
        }
    }
}
