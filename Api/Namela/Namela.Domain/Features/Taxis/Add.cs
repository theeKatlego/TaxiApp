using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using MediatR;
using Namela.Data;
using Namela.Data.Models;
using Namela.Domain.Extensions;

namespace Namela.Domain.Features.Taxis
{
    public class AddTaxiCommand: IRequest<Guid>
    {
        public string Registration { get; set; }
        public string Vin { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public string Color { get; set; }
        public Guid DriverVersionIndependentId { get; set; }
    }
    
    public class AddTaxiValidator: AbstractValidator<AddTaxiCommand>
    {
        public AddTaxiValidator(Context context)
        {
            CascadeMode = CascadeMode.Stop;
            
            RuleFor(cmd => cmd.Registration)
                .NotNull()
                .NotEmpty()
                .Must(registration => context.Taxis.LatestVersion().Where(t => t.Registration == registration) == null)
                .WithMessage(cmd => $"Registration '{cmd.Registration}' already used.");
            RuleFor(cmd => cmd.Vin)
                .NotNull()
                .NotEmpty()
                .Must(vin => context.Taxis.LatestVersion().Where(t => t.Registration == vin) == null)
                .WithMessage(cmd => $"Vin '{cmd.Vin}' already used.");
            RuleFor(cmd => cmd.DriverVersionIndependentId)
                .NotNull()
                .NotEmpty()
                .Must(driverId => context.Users.LatestVersion().Where(u => u.VersionIndependentId == driverId && u.Type == UserType.Driver) == null)
                .WithMessage(cmd => $"Driver not found.");
        }
    }
    
    public class AddTaxiHandler: IRequestHandler<AddTaxiCommand, Guid>
    {
        private readonly Context _Context;

        public AddTaxiHandler(Context context)
        {
            _Context = context;
        }
        
        public Task<Guid> Handle(AddTaxiCommand request, CancellationToken cancellationToken)
        {
            var driver = _Context.Users.LatestVersion(request.DriverVersionIndependentId);
            
            var taxi = new Taxi(request.Registration, request.Vin, request.Make, request.Model, request.Color, driver);

            _Context.Taxis.Add(taxi);
            
            return Task.FromResult(taxi.VersionIndependentId);
        }
    }
}
