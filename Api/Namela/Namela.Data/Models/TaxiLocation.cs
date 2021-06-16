using System;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class TaxiLocation: Model
    {
        public string PartitionKey => CreatePartitionKey();
        public GeoCoordinates GeoCoordinates { get; private set; }
        public DateTimeOffset Date { get; set; }
        public Guid TaxiVersionIndependentId { get; private set; }

        private TaxiLocation() { }

        public TaxiLocation(GeoCoordinates geoCoordinates, DateTimeOffset date, Guid taxiVersionIndependentId)
        {
            GeoCoordinates = geoCoordinates;
            Date = date;
            TaxiVersionIndependentId = taxiVersionIndependentId;
        }

        private string CreatePartitionKey()
        {
            var utcNow = DateTimeOffset.UtcNow;
            var sixtySeconds = TimeSpan.FromSeconds(60);

            return new DateTime((utcNow.Ticks + sixtySeconds.Ticks - 1) / sixtySeconds.Ticks * sixtySeconds.Ticks).ToString();
        }
    }
}
