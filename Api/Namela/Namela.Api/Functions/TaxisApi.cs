using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MediatR;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Namela.Domain.Features.Taxis;

namespace Namela.Api.Functions
{
    public class Taxis
    {
        private readonly IMediator _Mediator;
        private const string _BaseRoute = "Taxis";

        public Taxis(IMediator mediator)
        {
            _Mediator = mediator;
        }

        [FunctionName("AddTaxi")]
        public async Task<Guid> AddTaxi(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = _BaseRoute)]
            AddTaxiCommand command,
            ILogger log
            ) =>
            await _Mediator.Send(command);

        [FunctionName("FindTaxi")]
        public async Task<FindTaxiResultsDto> FindTaxi(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = _BaseRoute + "/{versionIndependentId}")]
            FindTaxiQuery query,
            ILogger log
            ) =>
            await _Mediator.Send(query);

        [FunctionName("FindTaxis")]
        public async Task<IEnumerable<FindTaxiResultsDto>> FindTaxis(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = _BaseRoute)]
            FindManyTaxisQuery query,
            ILogger log
            ) =>
            await _Mediator.Send(query);
    }
}
