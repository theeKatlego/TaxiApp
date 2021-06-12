using Namela.Data.Models.Bases;
using Namela.Data.Models.Enums;

namespace Namela.Data.Models
{
    public class Taxi : VersionedModel
    {
        public string Registration { get; private set; }
        public string Vin { get; private set; }
        public string Make { get; private set; }
        public string Model { get; private set; }
        public string Color { get; private set; }
        public User Driver { get; private set; }
        public Profile Profile { get; private set; }

        private Taxi() { }

        private Taxi(
            string registration,
            string vin,
            string make,
            string model,
            string color,
            User driver,
            Taxi previousVersion = null
            )
        {
            Registration = registration;
            Vin = vin;
            Make = make;
            Model = model;
            Color = color;
            Driver = driver;
            Profile = new Profile(ProfileState.Created, ProfileState.Created.ToString());
        }

        public Taxi(
            string registration,
            string vin,
            string make,
            string model,
            string color,
            User driver
            )
            : this(
                registration: registration,
                vin: vin,
                make: make,
                model: model,
                color: color,
                driver: driver,
                previousVersion: null
            ) { }
    }
}
