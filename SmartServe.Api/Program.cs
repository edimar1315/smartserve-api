using Microsoft.EntityFrameworkCore;
using SmartServe.Api.Infrastructure.Persistence;
using SmartServe.Api.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "SmartServe API",
        Version = "v1",
        Description = "Plataforma SaaS de matching inteligente entre profissionais e clientes"
    });
});

// PostgreSQL Connection
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? "Host=localhost;Port=5432;Database=smartserve_db;Username=smartserve_user;Password=smartserve_password_dev";

builder.Services.AddDbContext<SmartServeDbContext>(options =>
    options.UseNpgsql(connectionString)
);

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

// Logging
builder.Logging.AddConsole();
builder.Logging.AddDebug();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowAll");

// Custom Middleware
app.UseMiddleware<ExceptionHandlingMiddleware>();
app.UseMiddleware<RequestLoggingMiddleware>();

app.MapControllers();

// Health Check
app.MapGet("/api/health", () =>
    new { status = "healthy", timestamp = DateTime.UtcNow })
    .WithName("Health");

app.Run();

