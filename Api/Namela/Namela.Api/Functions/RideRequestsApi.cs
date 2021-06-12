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
        private const string _BaseRoute = "Requests";

        public Request(IMediator mediator)
        {
            _Mediator = mediator;
        }

        [FunctionName("CreateRequests")]
        public async Task<Guid> RequestRide(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = _BaseRoute)]
            RequestCommand command,
            ILogger log
            ) =>
            await _Mediator.Send(command);

        [FunctionName("GetRideRequest")]
        public async Task<RideRequestDto> GetRideRequest(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = _BaseRoute + "/{versionIndependentId}")]
            GetByVersionIndependentIdCommand command,
            ILogger log
            ) =>
            await _Mediator.Send(command);

        [FunctionName("UpdateRideRequest")]
        public async Task<Unit> UpdateRideRequest(
            [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = _BaseRoute + "/{versionIndependentId}")]
            UpdateRideRequestCommand rideRequestCommand,
            ILogger log
            ) =>
            await _Mediator.Send(rideRequestCommand);
    }
}
