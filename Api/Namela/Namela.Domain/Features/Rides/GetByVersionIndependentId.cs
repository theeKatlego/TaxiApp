using System;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using FluentValidation;
using MediatR;
using Namela.Data;
using Namela.Data.Models;
using Namela.Domain.Extensions;

namespace Namela.Domain.Features.Rides
{
    public class GetByVersionIndependentIdCommand: IRequest<RideRequestDto>
    {
        public Guid VersionIndependentId { get; private set; }
        
        public GetByVersionIndependentIdCommand(Guid versionIndependentId)
        {
            VersionIndependentId = versionIndependentId;
        }
    }
    
    public class GetByVersionIndependentIdValidator: AbstractValidator<GetByVersionIndependentIdCommand>
    {
        public GetByVersionIndependentIdValidator(Context context)
        {
            CascadeMode = CascadeMode.Continue;

            RuleFor(cmd => cmd.VersionIndependentId)
                .Must(versionIndependentId => context.RideRequests.LatestVersion(versionIndependentId) != null)
                .WithMessage(command => $"Could not find ride request with viid '{command.VersionIndependentId}'.");
        }
    }
    
    public class GetByVersionIndependentIdHandler: IRequestHandler<GetByVersionIndependentIdCommand, RideRequestDto>
    {
        private readonly Context _Context;
        private readonly IMapper _Mapper;

        public GetByVersionIndependentIdHandler(Context context, IMapper mapper)
        {
            _Context = context;
            _Mapper = mapper;
        }
        
        public Task<RideRequestDto> Handle(GetByVersionIndependentIdCommand request, CancellationToken cancellationToken)
        {
            var rideRequest = _Context.RideRequests.LatestVersion(request.VersionIndependentId);
            var dto = _Mapper.Map<RideRequestDto>(rideRequest);
            return Task.FromResult(dto);
        }
    }
    
    public class RideRequestDto
    {
        public GeoCoordinates PickUpLocation { get; set; }
        public GeoCoordinates Destination { get; set; }
        public User Requester { get; set; }
        public RideRequestStatus Status { get; set; }
    }
}
