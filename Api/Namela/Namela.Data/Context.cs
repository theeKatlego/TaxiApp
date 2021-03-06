﻿using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Namela.Data.Configurations;
using Namela.Data.Models;

namespace Namela.Data
{
    public class Context : DbContext
    {
        private readonly string _CosmosDbEndpointUri;
        private readonly string _CosmosDbPrimaryKey;
        private const string _DatabaseName = "namela";

        public DbSet<User> Users { get; set; }
        public DbSet<Taxi> Taxis { get; set; }
        public DbSet<TaxiLocation> TaxiLocations { get; set; }
        public DbSet<RideRequest> RideRequests { get; set; }
        public DbSet<RiderLocation> RiderLocations { get; set; }
        
        public Context(string cosmosDbEndpointUri, string cosmosDbPrimaryKey)
        {
            _CosmosDbEndpointUri = cosmosDbEndpointUri;
            _CosmosDbPrimaryKey = cosmosDbPrimaryKey;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseCosmos(_CosmosDbEndpointUri, _CosmosDbPrimaryKey, _DatabaseName);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(UserConfiguration).Assembly);
        }

        public async Task CreateDatabaseAsync()
        {
            await Database.GetCosmosClient().CreateDatabaseIfNotExistsAsync(_DatabaseName);
        }
    }
}
