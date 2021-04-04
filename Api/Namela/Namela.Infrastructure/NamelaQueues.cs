using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Azure.Storage.Queues;
using Namela.Domain.Infrastructure;

namespace Namela.Infrastructure
{
    public class NamelaQueues: INamelaQueues
    {
        private readonly QueueClient _RideRequestQueue;
        

        public NamelaQueues(string connectionString)
        {
            _RideRequestQueue = new QueueClient(connectionString, "ride-requests");
        }

        public Task CreateAsync()
        {
            var queues = new[]
            {
                _RideRequestQueue,
            };

            return Task.WhenAll(queues.Select(q => q.CreateIfNotExistsAsync()));
        }

        public async Task SendRideRequest(Guid id) => await _RideRequestQueue.SendMessageAsync(id.ToString());
    }
}
