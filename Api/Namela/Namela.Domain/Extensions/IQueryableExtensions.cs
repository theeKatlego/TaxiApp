using System;
using System.Collections.Generic;
using System.Linq;
using Namela.Data.Models.Bases;

namespace Namela.Domain.Extensions
{
    public static class IQueryableExtensions
    {
        /// <summary>
        /// Returns only the latest versions of the entities matching the query.
        /// </summary>
        public static IQueryable<T> LatestVersion<T>(this IQueryable<T> query)
            where T : VersionedModel
        {
            return query.Where(e => e.IsLatestVersion);
        }

        /// <summary>
        /// Returns only the latest versions of the entities matching the query.
        /// </summary>
        public static T LatestVersion<T>(this IQueryable<T> query, Guid versionIndependentId)
            where T : VersionedModel
        {
            return query.SingleOrDefault(e => e.VersionIndependentId == versionIndependentId && e.IsLatestVersion);
        }

        /// <summary>
        /// Returns true if an entity with this VIId exists.
        /// </summary>
        public static bool Exists<T>(this IQueryable<T> query, Guid versionIndependentId)
            where T : VersionedModel
        {
            return query.LatestVersion().Any(e => e.VersionIndependentId == versionIndependentId);
        }

        public static IQueryable<TModel> ApplyPagination<TModel>(this IQueryable<TModel> query, int page, int pageSize)
        {
            return query.Skip((page - 1) * pageSize).Take(pageSize);
        }

        public static IEnumerable<TModel> ApplyPagination<TModel>(this IEnumerable<TModel> query, int page, int pageSize)
        {
            return query.Skip((page - 1) * pageSize).Take(pageSize);
        }
    }
}
