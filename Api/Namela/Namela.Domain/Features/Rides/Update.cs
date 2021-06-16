using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using MediatR;
using Namela.Data;
using Namela.Data.Models;
using Namela.Domain.Extensions;

namespace Namela.Domain.Features.Rides
{
    public class UpdateRideRequestCommand: IRequest
    {
        public Guid VersionIndependentId { get; set; }
        public RideRequestStatus Status { get; set; }
    }
    
    public class UpdateRideRequestValidator: AbstractValidator<UpdateRideRequestCommand>
    {
        public UpdateRideRequestValidator(Context context)
        {
            CascadeMode = CascadeMode.Stop;

            RuleFor(cmd => cmd.Status)
                .IsInEnum();

            RuleFor(cmd => cmd.VersionIndependentId)
                .Must(versionIndependentId => context.RideRequests.LatestVersion(versionIndependentId) != null)
                .WithMessage(command => $"Could not find ride request with viid '{command.VersionIndependentId}'.");
        }
    }
    
    public class UpdateRideRequestHandler: IRequestHandler<UpdateRideRequestCommand>
    {
        private readonly Context _Context;

        public UpdateRideRequestHandler(Context context)
        {
            _Context = context;
        }

        public Task<Unit> Handle(UpdateRideRequestCommand request, CancellationToken cancellationToken)
        {
            var rideRequest = _Context.RideRequests.LatestVersion(request.VersionIndependentId);

            var updatedRequest = rideRequest.UpdateStatus(request.Status);

            _Context.RideRequests.Add(updatedRequest);

            return Unit.Task;
        }
    }
}