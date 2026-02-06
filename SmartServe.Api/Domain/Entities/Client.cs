namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Cliente que solicita serviços
/// </summary>
public class Client : User
{
    public string CPF { get; set; } = string.Empty;
    
    public string CreditCardToken { get; set; } = string.Empty;
    
    public string BillingAddress { get; set; } = string.Empty;
    
    public string BillingZipCode { get; set; } = string.Empty;
    
    public decimal TotalSpent { get; set; } = 0;
    
    public decimal CreditBalance { get; set; } = 0;
    
    public double? Latitude { get; set; }
    
    public double? Longitude { get; set; }
    
    // Relacionamentos
    public ICollection<ServiceRequest> ServiceRequests { get; set; } = new List<ServiceRequest>();
}

