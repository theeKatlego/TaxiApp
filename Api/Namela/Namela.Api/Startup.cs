using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.DependencyInjection;
using Namela.Infrastructure;
using Namela.Infrastructure.DependencyInjection;
using Namela.Api;
using Namela.Domain.Features.Rides;

[assembly: FunctionsStartup(typeof(Startup))]
namespace Namela.Api
{
    public class Startup: FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            var configuration = builder.GetContext().Configuration;

            var storageConnectionString = configuration["StorageConnectionString"];
            var cosmosDbEndpointUri = configuration["CosmosDbEndpointUri"];
            var cosmosDbPrimaryKey = configuration["CosmosDbPrimaryKey"];
            var applicationAssembly = typeof(RequestCommand).Assembly;

            builder.Services.AddTransient<IFunctionFilter, DatabaseTransactionFilter>();

            builder.Services.AddApplication(applicationAssembly);

            builder.Services.AddInfrastructure(
                storageConnectionString: storageConnectionString,
                cosmosDbEndpointUri: cosmosDbEndpointUri,
                cosmosDbPrimaryKey: cosmosDbPrimaryKey
            );
        }
    }
}
