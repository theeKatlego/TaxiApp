using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public enum RideRequestStatus
    {
        Requested = 1,
        FindingTaxi = 2,
        FoundTaxi = 3,
        FailedToFindTaxi = 4,
        DriverAccepted = 5,
        DriverWaiting = 6,
        DriverCanceled = 7,
        RequesterCanceled = 9,
        RequesterPickedUp = 10,
        Riding = 11,
        Completed = 12
    }

    public class RideRequest : VersionedModel
    {
        public GeoCoordinates PickUpLocation { get; private set; }
        // todo: Katlego (2021/06/12) - Support multiple destinations/stops
        public GeoCoordinates Destination { get; private set; }
        public User Requester { get; private set; }
        public RideRequestStatus Status { get; private set; }

        private RideRequest() { }

        private RideRequest(
            GeoCoordinates pickUpLocation,
            GeoCoordinates destination,
            User requester,
            RideRequestStatus status,
            RideRequest previousVersion = null
            )
        {
            PickUpLocation = pickUpLocation;
            Destination = destination;
            Requester = requester;
            Status = status;
        }

        public RideRequest(
            GeoCoordinates pickUpLocation,
            GeoCoordinates destination,
            User requester
            )
            : this(
                pickUpLocation: pickUpLocation,
                destination: destination,
                requester: requester,
                status: RideRequestStatus.Requested
            ) { }

        public RideRequest UpdateStatus(RideRequestStatus newStatus)
        {
            var updatedRequest = new RideRequest(
                pickUpLocation: PickUpLocation,
                destination: Destination,
                requester: Requester,
                status: newStatus,
                previousVersion: this
            );

            return updatedRequest;
        }
    }
}
