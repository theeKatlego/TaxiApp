using System;
using System.IO;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Namela.Domain.Features.Rides;
using Newtonsoft.Json;

namespace Namela.Api.Rides
{
    public class Request
    {
        private readonly IMediator _Mediator;

        public Request(IMediator mediator)
        {
            _Mediator = mediator;
        }

        [FunctionName("Request")]
        public async Task<IActionResult> RunAsync(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)]
            HttpRequest req,
            ILogger log
            )
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var data = await new StreamReader(req.Body).ReadToEndAsync();
            
            var command = JsonConvert.DeserializeObject<RequestCommand>(data);
            await _Mediator.Send(command);

            return new OkObjectResult("Ride requested.");
        }
    }
}
