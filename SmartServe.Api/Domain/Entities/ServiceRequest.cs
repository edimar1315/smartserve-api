namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Requisição de serviço feita por um cliente
/// </summary>
public class ServiceRequest
{
    public Guid Id { get; set; } = Guid.NewGuid();
    
    public Guid ClientId { get; set; }
    
    public Guid SpecializationId { get; set; }
    
    public string Title { get; set; } = string.Empty;
    
    public string Description { get; set; } = string.Empty;
    
    public string Address { get; set; } = string.Empty;
    
    public string ZipCode { get; set; } = string.Empty;
    
    public double? Latitude { get; set; }
    
    public double? Longitude { get; set; }
    
    public decimal BudgetMin { get; set; } = 0;
    
    public decimal BudgetMax { get; set; } = 0;
    
    public DateTime PreferredDate { get; set; }
    
    public string Status { get; set; } = "PENDING"; // PENDING, IN_PROGRESS, COMPLETED, CANCELLED
    
    public int ProposalCount { get; set; } = 0;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? CompletedAt { get; set; }
    
    // Relacionamentos
    public Client Client { get; set; } = null!;
    
    public Specialization Specialization { get; set; } = null!;
    
    public ICollection<Proposal> Proposals { get; set; } = new List<Proposal>();
    
    public ICollection<Payment> Payments { get; set; } = new List<Payment>();
}

