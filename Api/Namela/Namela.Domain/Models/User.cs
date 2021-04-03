using System;
using System.Collections.Generic;
using System.Text;
using Namela.Domain.Models.Bases;

namespace Namela.Domain.Models
{
    public class User: VersionedModel
    {
        public string Email { get; }
        public string Name { get; }

        public User(string email, string name)
        {
            Email = email.ToLowerInvariant();
            Name = name;
        }
    }
}
