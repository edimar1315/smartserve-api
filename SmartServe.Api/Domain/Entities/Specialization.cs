namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Especialidade / Tipo de serviço (ex: Encanamento, Eletricista, etc)
/// </summary>
public class Specialization
{
    public Guid Id { get; set; } = Guid.NewGuid();
    
    public string Name { get; set; } = string.Empty;
    
    public string Description { get; set; } = string.Empty;
    
    public string Category { get; set; } = string.Empty;
    
    public decimal AveragePrice { get; set; } = 0;
    
    public bool IsActive { get; set; } = true;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Relacionamentos
    public ICollection<ProfessionalSpecialization> Professionals { get; set; } = new List<ProfessionalSpecialization>();
}

