using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Namela.Data;
using Namela.Domain.Infrastructure;
using Newtonsoft.Json;

namespace Namela.Api.Infrastructure
{
    public class Create
    {
        private readonly Context _Context;
        private readonly INamelaQueues _Queues;
        private readonly INamelaStorage _Storage;

        public Create(Context context, INamelaQueues queues, INamelaStorage storage)
        {
            _Context = context;
            _Queues = queues;
            _Storage = storage;
        }
        
        [FunctionName("Create")]
        public async Task<IActionResult> RunAsync(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)]
            HttpRequest req,
            ILogger log
            )
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            await _Queues.CreateAsync();
            await _Storage.CreateAsync();
            await _Context.CreateDatabaseAsync();

            return new OkObjectResult("Infrastructure created.");
        }
    }
}
