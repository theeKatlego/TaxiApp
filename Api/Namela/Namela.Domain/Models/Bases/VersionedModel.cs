using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Namela.Domain.Models.Bases
{
    public abstract class VersionedModel : Model
    {
        public Guid VersionIndependentId { get; protected set; }

        public DateTimeOffset VersionStartDate { get; protected set; }

        public DateTimeOffset VersionEndDate { get; protected set; }

        public bool IsLatestVersion { get; protected set; }

        public int Version { get; protected set; }

        protected VersionedModel() {}

        protected VersionedModel(VersionedModel previousVersion)
        {
            if (previousVersion == null)
                SetAsNew();
            else
                SetAsNewVersion(previousVersion);
        }
        
        /// <summary>
        /// Sets all the properties related to versioning.
        /// Call this when you are adding a new entity.
        /// You must set the VersionIndependentId manually if not sending in a VersionIndependentId.
        /// </summary>
        protected void SetAsNew()
        {
            VersionIndependentId = Guid.NewGuid();
            VersionStartDate = DateTimeOffset.UtcNow;
            VersionEndDate = DateTimeOffset.MaxValue;
            IsLatestVersion = true;
            Version = 1;
        }

        /// <summary>
        /// Sets the properties related to versioning.
        /// Call this when you are adding a new version of an existing entity.
        /// </summary>
        /// <param name="previousVersion">The existing entity that will be updated</param>
        public void SetAsNewVersion(VersionedModel previousVersion)
        {
            // Update current version
            previousVersion.SetAsNotLatestVersion();

            // Update new version (this)
            VersionIndependentId = previousVersion.VersionIndependentId;
            VersionStartDate = previousVersion.VersionEndDate;
            VersionEndDate = DateTimeOffset.MaxValue;
            IsLatestVersion = true;
            Version = previousVersion.Version + 1;
        }

        /// <summary>
        /// Sets the properties related to versioning.
        /// Call this when you are deleting an existing entity.
        /// </summary>
        public virtual void SetAsNotLatestVersion()
        {
            VersionEndDate = DateTimeOffset.UtcNow;
            IsLatestVersion = false;
        }
    }
}
