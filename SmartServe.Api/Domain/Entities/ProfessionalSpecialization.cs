namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Relação many-to-many entre Professional e Specialization
/// </summary>
public class ProfessionalSpecialization
{
    public Guid Id { get; set; } = Guid.NewGuid();
    
    public Guid ProfessionalId { get; set; }
    
    public Guid SpecializationId { get; set; }
    
    public decimal HourlyRate { get; set; } = 0;
    
    public int YearsOfExperience { get; set; } = 0;
    
    public string Certification { get; set; } = string.Empty;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Relacionamentos
    public Professional Professional { get; set; } = null!;
    
    public Specialization Specialization { get; set; } = null!;
}

