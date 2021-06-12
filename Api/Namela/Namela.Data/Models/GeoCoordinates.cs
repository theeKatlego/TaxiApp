using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class GeoCoordinates: Model
    {
        public double Latitude { get; private set; }
        public double Longitude { get; private set; }

        private GeoCoordinates() { }

        public GeoCoordinates(double longitude, double latitude)
        {
            Longitude = longitude;
            Latitude = latitude;
        }

        public double DistanceToInKilometers(GeoCoordinates otherPoint)
        {
            if ((Math.Abs(this.Latitude - otherPoint.Latitude) < 0) && (Math.Abs(this.Longitude - otherPoint.Longitude) < 0))
                return 0;

            var theta = this.Longitude - otherPoint.Longitude;
            var distance = Math.Sin(DegreesToRadian(this.Latitude)) * Math.Sin(DegreesToRadian(otherPoint.Latitude)) + Math.Cos(DegreesToRadian(this.Latitude)) * Math.Cos(DegreesToRadian(otherPoint.Latitude)) * Math.Cos(DegreesToRadian(theta));
            distance = Math.Acos(distance);
            distance = RadiansToDegrees(distance);
            distance = distance * 60 * 1.1515 * 1.609344;
            return distance;
        }

        /// <summary>
        /// Converts decimal degrees to radians
        /// </summary>
        /// <param name="degrees"></param>
        /// <returns></returns>
        private double DegreesToRadian(double degrees)
        {
            return (degrees * Math.PI / 180.0);
        }

        /// <summary>
        /// Converts radians to decimal degrees
        /// </summary>
        /// <param name="radians"></param>
        /// <returns></returns>
        private double RadiansToDegrees(double radians)
        {
            return (radians / Math.PI * 180.0);
        }
    }
}
