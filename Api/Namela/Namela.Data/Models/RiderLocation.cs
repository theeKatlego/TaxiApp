using System;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class RiderLocation: Model
    {
        public string PartitionKey => CreatePartitionKey();
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

        private string CreatePartitionKey()
        {
            var utcNow = DateTimeOffset.UtcNow;
            var sixtySeconds = TimeSpan.FromSeconds(60);

            return new DateTime((utcNow.Ticks + sixtySeconds.Ticks - 1) / sixtySeconds.Ticks * sixtySeconds.Ticks).ToString();
        }
    }
}
