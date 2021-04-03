using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Namela.Domain.Models.Bases;

namespace Namela.Domain.Models.Events
{
    /// <summary>
    /// Represents a domain event. occurs when a model is changed.
    /// </summary>
    public abstract class Event
    {
        // Required properties
        public string EventName { get; }

        public DateTimeOffset Timestamp { get; }

        public string ModelType { get; }

        public Guid ModelId { get; }

        public string Message { get; }

        // Optional properties
        public Guid? ModelVersionIndependentId { get; protected set; }

        public int? Version { get; protected set; }

        public Guid? SetId { get; protected set; }

        public Guid? CollectionId { get; protected set; }

        public Guid? SourceCollectionId { get; protected set; }

        protected Event(DateTimeOffset timestamp,
                        Model model,
                        string message)
        {
            EventName = GetType().Name;
            Timestamp = timestamp;
            ModelType = model.GetType().Name;
            ModelId = model.Id;
            Message = message;
        }

        protected Event(DateTimeOffset timestamp,
                        VersionedModel model,
                        string message) : this(timestamp, model as Model, message)
        {
            ModelVersionIndependentId = model.VersionIndependentId;
            Version = model.Version;
        }
    }
}
