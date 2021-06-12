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
    public class AddTaxiCommand: IRequest
    {
        public string Registration { get; private set; }
        public string Vin { get; private set; }
        public string Make { get; private set; }
        public string Model { get; private set; }
        public string Color { get; private set; }
        public Guid DriverVersionIndependentId { get; private set; }

        public AddTaxiCommand(
            string registration,
            string vin,
            string make,
            string model,
            string color,
            Guid driverVersionIndependentId
            )
        {
            Registration = registration;
            Vin = vin;
            Make = make;
            Model = model;
            Color = color;
            DriverVersionIndependentId = driverVersionIndependentId;
        }
    }
    
    public class AddTaxiValidator: AbstractValidator<AddTaxiCommand>
    {
        public AddTaxiValidator(Context context)
        {
            CascadeMode = CascadeMode.Stop;
            
            RuleFor(cmd => cmd.Registration)
                .Must(registration => !context.Taxis.Any(t => t.Registration == registration))
                .WithMessage(cmd => $"Registration '{cmd.Registration}' already used.");
            RuleFor(cmd => cmd.Vin)
                .Must(vin => !context.Taxis.Any(t => t.Registration == vin))
                .WithMessage(cmd => $"Vin '{cmd.Vin}' already used.");
            RuleFor(cmd => cmd.DriverVersionIndependentId)
                .Must(driverId => !context.Users.Any(u => u.VersionIndependentId == driverId && u.Type == UserType.Driver))
                .WithMessage(cmd => $"Driver not found.");
        }
    }
    
    public class AddTaxiHandler: IRequestHandler<AddTaxiCommand>
    {
        private readonly Context _Context;

        public AddTaxiHandler(Context context)
        {
            _Context = context;
        }
        
        public Task<Unit> Handle(AddTaxiCommand request, CancellationToken cancellationToken)
        {
            var driver = _Context.Users.LatestVersion(request.DriverVersionIndependentId);
            
            var taxi = new Taxi(request.Registration, request.Vin, request.Make, request.Model, request.Color, driver);

            _Context.Taxis.Add(taxi);
            
            return Unit.Task;
        }
    }
}
