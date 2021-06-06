using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Namela.Domain.Features.Rides;

namespace Namela.Api.Functions
{
    public class Request
    {
        private readonly IMediator _Mediator;

        public Request(IMediator mediator)
        {
            _Mediator = mediator;
        }

        [FunctionName("Requests")]
        public async Task<Guid> RequestRide(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)]
            RequestCommand command,
            ILogger log
            ) =>
            await _Mediator.Send(command);

        [FunctionName("Requests/{id}")]
        public async Task<RideRequestDto> GetRideRequest(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)]
            GetByVersionIndependentIdCommand command,
            ILogger log
            ) =>
            await _Mediator.Send(command);

        [FunctionName("Requests/{id}")]
        public async Task<RideRequestDto> UpdateRideRequest(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = null)]
            UpdateRideRequestCommand rideRequestCommand,
            ILogger log
            ) =>
            await _Mediator.Send(rideRequestCommand);
    }
}
