using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class RideRequest : VersionedModel
    {
        public GeoCoordinates PickUpLocation { get; private set; }
        public GeoCoordinates Destination { get; private set; }
        public User Requester { get; private set; }

        private RideRequest() { }

        public RideRequest(
            GeoCoordinates pickUpLocation,
            GeoCoordinates destination,
            User requester
            )
        {
            PickUpLocation = pickUpLocation;
            Destination = destination;
            Requester = requester;
        }
    }
}
