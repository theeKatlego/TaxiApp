using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class RideRequest: VersionedModel
    {
        public GeoCoordinates PickUpLocation { get; set; }
        public GeoCoordinates Destination { get; set; }
        public User Requester { get; set; }
    }
}
