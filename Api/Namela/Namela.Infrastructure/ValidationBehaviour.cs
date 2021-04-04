using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using MediatR;

namespace Namela.Infrastructure
{
    /// <summary>
    /// Validates the incoming request
    /// </summary>
    public class ValidationBehaviour<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    {
        private readonly IEnumerable<IValidator<TRequest>> _Validators;

        public ValidationBehaviour(IEnumerable<IValidator<TRequest>> validators)
        {
            _Validators = validators;
        }

        public Task<TResponse> Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate<TResponse> next)
        {
            var validationErrors = _Validators
                .Select(v => v.Validate(request))
                .SelectMany(vr => vr.Errors)
                .Where(vf => vf != null)
                .ToList();

            if (validationErrors.Any())
                throw new ValidationException(validationErrors);

            return next();
        }
    }
}
