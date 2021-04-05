using Microsoft.Extensions.DependencyInjection;
using Namela.Data;
using Namela.Domain.Infrastructure;

namespace Namela.Infrastructure.DependencyInjection
{
    public static class InfrastructureContainerBuilderExtensions
    {
        public static void AddInfrastructure(
            this IServiceCollection services,
            string storageConnectionString,
            string cosmosDbEndpointUri,
            string cosmosDbPrimaryKey
            )
        {
            services.AddBlobStorage(storageConnectionString);
            services.AddQueues(storageConnectionString);
            services.AddCosmosDb(cosmosDbEndpointUri, cosmosDbPrimaryKey);
        }

        private static void AddBlobStorage(this IServiceCollection services, string connectionString)
        {
            services.AddSingleton<INamelaStorage>(c => new NamelaStorage(connectionString));
        }

        private static void AddQueues(this IServiceCollection services, string connectionString)
        {
            services.AddSingleton<INamelaQueues>(c => new NamelaQueues(connectionString));
        }

        private static void AddCosmosDb(this IServiceCollection services, string cosmosDbEndpointUri, string cosmosDbPrimaryKey)
        {
            services.AddTransient(c => new Context(cosmosDbEndpointUri, cosmosDbPrimaryKey));
        }
    }
}
