using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public enum UserType
    {
        Rider = 1,
        Driver = 2,
        Support = 99,
        Admin = 100
    }
    
    public class User : VersionedModel
    {
        public const string DefaultPartitionKey = "users";
        public string PartitionKey => DefaultPartitionKey; // todo: Katlego (2021/06/13) Put all items in the different partition
        public string Username { get; private set; }
        public string Email { get; private set; }
        public string Name { get; private set; }
        public Profile Profile { get; private set; }
        public UserType Type { get; private set; }

        private User() { }

        private User(
            string username,
            string email,
            string name,
            Profile profile,
            UserType type,
            User previousVersion = null
            )
            : base(previousVersion)
        {
            Username = username;
            Email = email;
            Name = name;
            Profile = profile;
            Type = type;
        }

        public User(
            string username,
            string email,
            string name,
            Profile profile,
            UserType type
            )
            : this(
                username: username,
                email: email,
                name: name,
                profile: profile,
                type: type,
                previousVersion: null
            ) { }
    }
}