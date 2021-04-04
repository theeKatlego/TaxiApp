using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Azure.Storage;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Specialized;
using Azure.Storage.Sas;
using Namela.Domain.Infrastructure;

namespace Namela.Infrastructure
{
    public class NamelaStorage: INamelaStorage
    {
        private readonly BlobContainerClient _ProfilePhotosContainer;
        private readonly StorageSharedKeyCredential _StorageSharedKeyCredential;

        public NamelaStorage(string connectionString)
        {
            _ProfilePhotosContainer = new BlobContainerClient(connectionString, "profile-photos");

            _StorageSharedKeyCredential = new StorageSharedKeyCredential(
                GetKeyValueFromConnectionString("AccountName", connectionString),
                GetKeyValueFromConnectionString("AccountKey", connectionString)
            );
        }

        public Task CreateAsync()
        {
            var containers = new[]
            {
                _ProfilePhotosContainer,
            };

            return Task.WhenAll(containers.Select(q => q.CreateIfNotExistsAsync()));
        }

        private string GetBlobUrl(BlobBaseClient blob)
        {
            // https://docs.microsoft.com/en-us/azure/storage/blobs/storage-secure-access-application
            // Set the expiry time and permissions for the blob.
            // In this case, the start time is specified as a few minutes in the past, to mitigate clock skew.
            // The shared access signature will be valid immediately.
            var sasBuilder = new BlobSasBuilder
            {
                BlobContainerName = blob.BlobContainerName,
                StartsOn = DateTimeOffset.UtcNow.AddDays(-5),
                ExpiresOn = DateTimeOffset.UtcNow.AddHours(1),
                Resource = "b",
                BlobName = blob.Name
            };

            sasBuilder.SetPermissions(BlobSasPermissions.Read);

            var sasToken = sasBuilder.ToSasQueryParameters(_StorageSharedKeyCredential);

            return $"{blob.Uri.AbsoluteUri}?{sasToken}";
        }

        private string GetKeyValueFromConnectionString(string key, string connectionString)
        {
            IDictionary<string, string> settings = new Dictionary<string, string>();
            var splitConnectionString = connectionString.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);

            foreach (var nameValue in splitConnectionString)
            {
                var splitNameValue = nameValue.Split(new char[] { '=' }, 2);
                settings.Add(splitNameValue[0], splitNameValue[1]);
            }

            return settings[key];
        }
    }
}
