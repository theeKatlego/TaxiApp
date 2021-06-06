using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using MediatR;
using Namela.Data;
using Namela.Data.Models;
using Namela.Domain.Infrastructure;

namespace Namela.Domain.Features.Rides
{
    public class RequestCommand: IRequest<Guid>
    {
        public string Username { get; set; }
        public double PickUpLocationLatitude { get; set; }
        public double PickUpLocationLongitude { get; set; }
        public double DestinationLatitude { get; set; }
        public double DestinationLongitude { get; set; }
    }

    public class RequestValidator : AbstractValidator<RequestCommand>
    {
        public RequestValidator(Context context)
        {
            CascadeMode = CascadeMode.Stop;

            RuleFor(command => command.Username)
                .Must(username => context.Users.Any(user => user.Username == username))
                .WithMessage("User not found.");
        }
    }
    
    public class RequestHandler: IRequestHandler<RequestCommand, Guid>
    {
        private readonly Context _Context;
        private readonly INamelaQueues _Queues;

        public RequestHandler(Context context, INamelaQueues queues)
        {
            _Context = context;
            _Queues = queues;
        }

        public async Task<Guid> Handle(RequestCommand request, CancellationToken cancellationToken)
        {
            var user = _Context.Users.Single(u => u.Username == request.Username);

            var pickUpLocation = new GeoCoordinates(
                longitude: request.PickUpLocationLongitude,
                latitude: request.PickUpLocationLatitude
            );
            var destination = new GeoCoordinates(
                longitude: request.DestinationLongitude,
                latitude: request.DestinationLatitude
            );

            var rideRequest = new RideRequest(
                pickUpLocation: pickUpLocation,
                destination: destination,
                requester: user
            );

            await _Context.RideRequests.AddAsync(rideRequest, cancellationToken);
            await _Queues.SendRideRequest(rideRequest.Id);

            return rideRequest.VersionIndependentId;
        }
    }
}
