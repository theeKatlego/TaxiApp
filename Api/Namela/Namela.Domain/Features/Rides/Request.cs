using System.Threading;
using System.Threading.Tasks;
using MediatR;

namespace Namela.Domain.Features.Rides
{
    public class RequestCommand: IRequest
    {
        
    }
    
    public class RequestHandler: IRequestHandler<RequestCommand>
    {
        public Task<Unit> Handle(RequestCommand request, CancellationToken cancellationToken)
        {
            throw new System.NotImplementedException();
        }
    }
}
