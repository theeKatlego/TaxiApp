using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Namela.Data.Models.Events
{
    public class EventEntity// todo: inherit MediatR INotification
    {
        [Key]
        public long Id { get; private set; }

        /// <summary>
        /// The person who performed the action, or the person who the action was performed for
        /// </summary>
        public string UserEmail { get; private set;}

        /// <summary>
        /// If an application performed an action for a user, the name of the application
        /// </summary>
        public string ActingApplicationName { get; private set;}

        public DateTimeOffset Timestamp { get; private set;}

        public string EventName { get; private set;}

        public string ModelType { get; private set;}

        public Guid ModelId { get; private set;}

        public string Message { get; private set;}

        public int? Version { get; private set;}

        public Guid? ModelVersionIndependentId { get; private set; }

        public Guid? SetId { get; private set;}

        public Guid? CollectionId { get; private set;}

        public Guid? SourceCollectionId { get; private set;}

        public EventEntity(Event e, string userEmail, string actingApplicationName)
        {
            Timestamp = e.Timestamp;
            EventName = e.EventName;
            ModelType = e.ModelType;
            ModelId = e.ModelId;
            ModelVersionIndependentId = e.ModelVersionIndependentId;
            Version = e.Version;
            SetId = e.SetId;
            CollectionId = e.CollectionId;
            SourceCollectionId = e.SourceCollectionId;
            Message = e.Message;

            UserEmail = userEmail;
            ActingApplicationName = actingApplicationName;
        }

        public EventEntity()
        {
        }

        public EventEntity SetUserInfo(IEnumerable<User> users)
        {
            // https://emailregex.com/ but without the ^ and $ - email can be anywhere in the message
            var regex = new Regex(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"); 
            var match = regex.Match(Message);
            if (match.Success)
            {
                var email = match.Value;
                var user = users.FirstOrDefault(u => string.Equals(u.Email, email, StringComparison.InvariantCultureIgnoreCase));
                if (user != null)
                    Message = Message.Replace(email, user.Name);
            }

            return this;
        }
    }
}
