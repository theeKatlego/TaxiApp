using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MediatR;

namespace Namela.Domain.Features.Ride
{
    public class RequestCommand: IRequest
    {
    }

    public class RequestHandler: IRequestHandler<RequestCommand>
    {
        public Task<Unit> Handle(RequestCommand request, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }
    }
}
