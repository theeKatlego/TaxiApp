using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using MediatR;
using Namela.Data;

namespace Namela.Domain.Features.Taxis
{
    public class FindTaxiQuery: IRequest<FindTaxiResultsDto>
    {
        public Guid TaxiVersionIndependentId { get; set; }
    }
    
    public class FindTaxiHandler:IRequestHandler<FindTaxiQuery, FindTaxiResultsDto>
    {
        private readonly Context _Context;
        private readonly IMapper _Mapper;

        public FindTaxiHandler(Context context, IMapper mapper)
        {
            _Context = context;
            _Mapper = mapper;
        }
        
        public Task<FindTaxiResultsDto> Handle(FindTaxiQuery request, CancellationToken cancellationToken)
        {
            var taxiLocation = _Context.TaxiLocations
                .OrderBy(l => l.Date)
                .FirstOrDefault();

            var dto = _Mapper.Map<FindTaxiResultsDto>(taxiLocation);
            
            return Task.FromResult(dto);
        }
    }
    
    public class FindTaxiResultsDto
    {
        public Guid Id { get; set; }
        public GeoCoordinatesDto GeoCoordinates { get; set; }
        public DateTimeOffset Date { get; set; }
        public Guid TaxiVersionIndependentId { get; set; }
    }

    public class GeoCoordinatesDto
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
