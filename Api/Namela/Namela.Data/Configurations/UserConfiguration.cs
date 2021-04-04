using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Namela.Data.Models;

namespace Namela.Data.Configurations
{
    public class UserConfiguration : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            builder.HasKey(x => x.Id);
            //builder.HasPartitionKey(a => a.PartitionKey); Current version seems to have issues with partition key. Using version 3.1 because latest version of Azure functions skd is 3.
            builder.ToContainer("users");
            builder.HasNoDiscriminator();
        }
    }
}
