using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdminApi.Services
{
    public interface ILoggingService
    {
        public Task Invoke(HttpContext context);
    }

    public class LoggingService : ILoggingService
    {
        private readonly RequestDelegate _next;
        private readonly ILogger _logger;

        public LoggingService(RequestDelegate next, ILoggerFactory loggerFactory)
        {
            _next = next;
            _logger = loggerFactory.CreateLogger<LoggingService>();
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            finally
            {
                _logger.LogInformation(
                        "Request {method} {url} => {statusCode}",
                        context.Request?.Method,
                        context.Request?.Path.Value,
                        context.Response?.StatusCode
                    );
            }
        }
    }
}
