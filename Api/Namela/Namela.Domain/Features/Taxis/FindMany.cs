using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using MediatR;
using Namela.Data;
using Namela.Data.Models;

namespace Namela.Domain.Features.Taxis
{
    public class FindManyTaxisQuery: IRequest<IEnumerable<FindTaxiResultsDto>>
    {
        public double Radius { get; set; }
        public double LocationLatitude { get; set; }
        public double LocationLongitude { get; set; }
    }
    
    public class FindManyTaxisHandler:IRequestHandler<FindManyTaxisQuery, IEnumerable<FindTaxiResultsDto>>
    {
        private readonly Context _Context;
        private readonly IMapper _Mapper;

        public FindManyTaxisHandler(Context context, IMapper mapper)
        {
            _Context = context;
            _Mapper = mapper;
        }
        
        public Task<IEnumerable<FindTaxiResultsDto>> Handle(FindManyTaxisQuery request, CancellationToken cancellationToken)
        {
            var centerPoint = new GeoCoordinates(longitude: request.LocationLongitude, latitude: request.LocationLatitude);

            var locations = _Context.TaxiLocations
                .Where(
                    l => l.Date > DateTimeOffset.Now.AddSeconds(-60) // Location updates from 60 seconds ago
                        && l.GeoCoordinates.DistanceToInKilometers(centerPoint) <= request.Radius
                )
                .GroupBy(l => l.TaxiVersionIndependentId)
                .Select(x => x.OrderBy(y => y.Date).First())
                .ToList();
            
            var dtos = _Mapper.Map<IEnumerable<FindTaxiResultsDto>>(locations);
            
            return Task.FromResult(dtos);
        }
    }
}
