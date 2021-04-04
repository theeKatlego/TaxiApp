using System;
using System.Threading;
using System.Threading.Tasks;

namespace Namela.Domain.Infrastructure
{
    public interface INamelaQueues
    {
        Task CreateAsync();

        Task SendRideRequest(Guid id);
    }
}
