namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Proposta de um profissional para uma solicitação de serviço
/// </summary>
public class Proposal
{
    public Guid Id { get; set; } = Guid.NewGuid();
    
    public Guid ServiceRequestId { get; set; }
    
    public Guid ProfessionalId { get; set; }
    
    public decimal ProposedPrice { get; set; } = 0;
    
    public string Message { get; set; } = string.Empty;
    
    public int EstimatedDays { get; set; } = 1;
    
    public string Status { get; set; } = "PENDING"; // PENDING, ACCEPTED, REJECTED, CANCELLED
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }
    
    // Relacionamentos
    public ServiceRequest ServiceRequest { get; set; } = null!;
    
    public Professional Professional { get; set; } = null!;
}

