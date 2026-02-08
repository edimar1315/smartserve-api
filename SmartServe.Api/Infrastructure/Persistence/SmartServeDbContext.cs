using Microsoft.EntityFrameworkCore;
using SmartServe.Api.Domain.Entities;

namespace SmartServe.Api.Infrastructure.Persistence;

/// <summary>
/// Entity Framework Core DbContext para SmartServe
/// </summary>
public class SmartServeDbContext : DbContext
{
    public SmartServeDbContext(DbContextOptions<SmartServeDbContext> options) : base(options)
    {
    }

    // DbSets
    public DbSet<User> Users => Set<User>();
    public DbSet<Professional> Professionals => Set<Professional>();
    public DbSet<Client> Clients => Set<Client>();
    public DbSet<Specialization> Specializations => Set<Specialization>();
    public DbSet<ProfessionalSpecialization> ProfessionalSpecializations => Set<ProfessionalSpecialization>();
    public DbSet<ServiceRequest> ServiceRequests => Set<ServiceRequest>();
    public DbSet<Proposal> Proposals => Set<Proposal>();
    public DbSet<Payment> Payments => Set<Payment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configuração da herança TPH (Table Per Hierarchy)
        modelBuilder.Entity<User>()
            .HasDiscriminator<string>("UserType")
            .HasValue<Professional>("Professional")
            .HasValue<Client>("Client");

        // User
        modelBuilder.Entity<User>()
            .HasKey(u => u.Id);

        modelBuilder.Entity<User>()
            .Property(u => u.Id)
            .ValueGeneratedNever();

        // Professional
        modelBuilder.Entity<Professional>()
            .HasMany(p => p.Specializations)
            .WithOne(ps => ps.Professional)
            .HasForeignKey(ps => ps.ProfessionalId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Professional>()
            .HasMany(p => p.ProposalsCreated)
            .WithOne(sr => sr.Professional)
            .HasForeignKey(p => p.ProfessionalId)
            .OnDelete(DeleteBehavior.SetNull);

        // Client
        modelBuilder.Entity<Client>()
            .HasMany(c => c.ServiceRequests)
            .WithOne(sr => sr.Client)
            .HasForeignKey(sr => sr.ClientId)
            .OnDelete(DeleteBehavior.Cascade);

        // Specialization
        modelBuilder.Entity<Specialization>()
            .HasKey(s => s.Id);

        modelBuilder.Entity<Specialization>()
            .Property(s => s.Id)
            .ValueGeneratedNever();

        // ProfessionalSpecialization
        modelBuilder.Entity<ProfessionalSpecialization>()
            .HasKey(ps => ps.Id);

        modelBuilder.Entity<ProfessionalSpecialization>()
            .Property(ps => ps.Id)
            .ValueGeneratedNever();

        modelBuilder.Entity<ProfessionalSpecialization>()
            .HasOne(ps => ps.Professional)
            .WithMany(p => p.Specializations)
            .HasForeignKey(ps => ps.ProfessionalId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<ProfessionalSpecialization>()
            .HasOne(ps => ps.Specialization)
            .WithMany(s => s.Professionals)
            .HasForeignKey(ps => ps.SpecializationId)
            .OnDelete(DeleteBehavior.Cascade);

        // ServiceRequest
        modelBuilder.Entity<ServiceRequest>()
            .HasKey(sr => sr.Id);

        modelBuilder.Entity<ServiceRequest>()
            .Property(sr => sr.Id)
            .ValueGeneratedNever();

        modelBuilder.Entity<ServiceRequest>()
            .HasOne(sr => sr.Client)
            .WithMany(c => c.ServiceRequests)
            .HasForeignKey(sr => sr.ClientId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<ServiceRequest>()
            .HasOne(sr => sr.Specialization)
            .WithMany()
            .HasForeignKey(sr => sr.SpecializationId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<ServiceRequest>()
            .HasMany(sr => sr.Proposals)
            .WithOne(p => p.ServiceRequest)
            .HasForeignKey(p => p.ServiceRequestId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<ServiceRequest>()
            .HasMany(sr => sr.Payments)
            .WithOne(pay => pay.ServiceRequest)
            .HasForeignKey(pay => pay.ServiceRequestId)
            .OnDelete(DeleteBehavior.Cascade);

        // Proposal
        modelBuilder.Entity<Proposal>()
            .HasKey(p => p.Id);

        modelBuilder.Entity<Proposal>()
            .Property(p => p.Id)
            .ValueGeneratedNever();

        modelBuilder.Entity<Proposal>()
            .HasOne(p => p.ServiceRequest)
            .WithMany(sr => sr.Proposals)
            .HasForeignKey(p => p.ServiceRequestId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Proposal>()
            .HasOne(p => p.Professional)
            .WithMany()
            .HasForeignKey(p => p.ProfessionalId)
            .OnDelete(DeleteBehavior.Cascade);

        // Payment
        modelBuilder.Entity<Payment>()
            .HasKey(pay => pay.Id);

        modelBuilder.Entity<Payment>()
            .Property(pay => pay.Id)
            .ValueGeneratedNever();

        modelBuilder.Entity<Payment>()
            .HasOne(pay => pay.ServiceRequest)
            .WithMany(sr => sr.Payments)
            .HasForeignKey(pay => pay.ServiceRequestId)
            .OnDelete(DeleteBehavior.Cascade);

        // Índices para performance
        modelBuilder.Entity<Professional>()
            .HasIndex(p => p.Email)
            .IsUnique();

        modelBuilder.Entity<Client>()
            .HasIndex(c => c.Email)
            .IsUnique();

        modelBuilder.Entity<ServiceRequest>()
            .HasIndex(sr => sr.Status);

        modelBuilder.Entity<Proposal>()
            .HasIndex(p => new { p.ServiceRequestId, p.ProfessionalId })
            .IsUnique();

        modelBuilder.Entity<Payment>()
            .HasIndex(pay => pay.Status);
    }
}
