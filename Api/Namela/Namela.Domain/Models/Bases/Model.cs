﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Namela.Domain.Models.Events;

namespace Namela.Domain.Models.Bases
{
    /// <summary>
    /// Base class for Entity Framework entities
    /// </summary>
    public abstract class Model
    {
        public Guid Id { get; protected set; }

        public bool HasEvents => _Events.Any();

        private readonly List<Event> _Events = new List<Event>();

        protected Model()
        {
            Id = Guid.NewGuid();
        }

        public virtual void ClearIdentity()
        {
            Id = Guid.NewGuid();
        }
        
        public List<Event> GetEvents()
        {
            return new List<Event>(_Events);
        }

        public void ClearEvents()
        {
            _Events.Clear();
        }

        protected void AddEvent(Event ev)
        {
            _Events.Add(ev);
        }

        public override bool Equals(object obj)
        {
            if (obj == null || obj.GetType() != this.GetType())
                return false;

            return ((Model)obj).Id == Id;
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }
}
