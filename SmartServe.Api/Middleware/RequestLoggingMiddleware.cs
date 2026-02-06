using System.Diagnostics;

namespace SmartServe.Api.Middleware;

/// <summary>
/// Middleware para logging de requisições
/// </summary>
public class RequestLoggingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<RequestLoggingMiddleware> _logger;

    public RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var stopwatch = Stopwatch.StartNew();
        
        var request = context.Request;
        _logger.LogInformation(
            "Request: {Method} {Path} from {RemoteIP}",
            request.Method,
            request.Path,
            context.Connection.RemoteIpAddress);

        try
        {
            await _next(context);
        }
        finally
        {
            stopwatch.Stop();
            _logger.LogInformation(
                "Response: {Method} {Path} - Status: {StatusCode} - Duration: {ElapsedMilliseconds}ms",
                request.Method,
                request.Path,
                context.Response.StatusCode,
                stopwatch.ElapsedMilliseconds);
        }
    }
}

