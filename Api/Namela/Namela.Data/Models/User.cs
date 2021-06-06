using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Namela.Data.Models.Bases;

namespace Namela.Data.Models
{
    public class User : VersionedModel
    {
        public string Username { get; private set; }
        public string Email { get; private set; }
        public string Name { get; private set; }

        public User() { }

        private User(
            string username,
            string email,
            string name,
            User previousVersion = null
            )
            : base(previousVersion)
        {
            Username = username;
            Email = email;
            Name = name;
        }

        public User(string username, string email, string name)
            : this(username: username, email: email, name: name, previousVersion:null) { }
    }
}