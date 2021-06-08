using Namela.Data.Models.Bases;
using Namela.Data.Models.Enums;

namespace Namela.Data.Models
{
    public class Profile: VersionedModel
    {
        public ProfileState State { get; set; }
        public string CommentOnState { get; set; }
    }
}
