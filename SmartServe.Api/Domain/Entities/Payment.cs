namespace SmartServe.Api.Domain.Entities;

/// <summary>
/// Pagamento relacionado a um serviço
/// </summary>
public class Payment
{
    public Guid Id { get; set; } = Guid.NewGuid();
    
    public Guid ServiceRequestId { get; set; }
    
    public decimal Amount { get; set; } = 0;
    
    public string PaymentMethod { get; set; } = string.Empty; // CREDIT_CARD, DEBIT_CARD, PIX, BANK_TRANSFER
    
    public string Status { get; set; } = "PENDING"; // PENDING, COMPLETED, FAILED, REFUNDED
    
    public string TransactionId { get; set; } = string.Empty;
    
    public string ReceiptUrl { get; set; } = string.Empty;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? CompletedAt { get; set; }
    
    // Relacionamentos
    public ServiceRequest ServiceRequest { get; set; } = null!;
}

