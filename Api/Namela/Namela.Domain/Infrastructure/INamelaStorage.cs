using System.Threading.Tasks;

namespace Namela.Domain.Infrastructure
{
    public interface INamelaStorage
    {
        Task CreateAsync();
    }
}
