using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using FluentValidation;
using MediatR;
using Microsoft.Extensions.DependencyInjection;

namespace Namela.Infrastructure.DependencyInjection
{
    public static class ApplicationContainerBuilderExtensions
    {
        public static void AddApplication(this IServiceCollection services, Assembly applicationAssembly)
        {
            services.AddAutoMapper(applicationAssembly);
            services.AddValidatorsFromAssembly(applicationAssembly);
            services.AddMediatR(applicationAssembly);

            services.AddScoped(typeof(IPipelineBehavior<,>), typeof(ValidationBehaviour<,>));
        }
    }
}
