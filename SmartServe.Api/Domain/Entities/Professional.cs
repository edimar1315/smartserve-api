namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Profissional prestador de serviços
/// </summary>
public class Professional : User
{
    public decimal AverageRating { get; set; } = 5.0m;
    
    public int TotalJobs { get; set; } = 0;
    
    public string CPF { get; set; } = string.Empty;
    
    public string BankAccount { get; set; } = string.Empty;
    
    public string PixKey { get; set; } = string.Empty;
    
    public bool IsVerified { get; set; } = false;
    
    public double? Latitude { get; set; }
    
    public double? Longitude { get; set; }
    
    public DateTime? LastLocationUpdate { get; set; }
    
    // Relacionamentos
    public ICollection<ProfessionalSpecialization> Specializations { get; set; } = new List<ProfessionalSpecialization>();
    
    public ICollection<ServiceRequest> ProposalsCreated { get; set; } = new List<ServiceRequest>();
}

