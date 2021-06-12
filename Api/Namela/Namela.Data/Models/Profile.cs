using Namela.Data.Models.Bases;
using Namela.Data.Models.Enums;

namespace Namela.Data.Models
{
    public class Profile: VersionedModel
    {
        public ProfileState State { get; private set; }
        public string CommentOnState { get; private set; }

        private Profile() { }

        public Profile(ProfileState state, string commentOnState)
        {
            State = state;
            CommentOnState = commentOnState;
        }
    }
}
