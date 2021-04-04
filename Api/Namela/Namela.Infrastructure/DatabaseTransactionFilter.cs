using Microsoft.Azure.WebJobs.Host;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Namela.Data;

namespace Namela.Infrastructure
{
    public class DatabaseTransactionFilter: IFunctionInvocationFilter, IFunctionExceptionFilter
    {
        private readonly Context _Context;
        
        public DatabaseTransactionFilter(Context context)
        {
            _Context = context;
        }

        public Task OnExecutingAsync(FunctionExecutingContext executingContext, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }

        public async Task OnExecutedAsync(FunctionExecutedContext executedContext, CancellationToken cancellationToken)
        {
            var request = executedContext.Arguments.SingleOrDefault(arg => arg.Key == "req").Value as HttpRequest;
            var isGetRequest = request?.HttpContext.Request.Method == "GET";

            if (!isGetRequest)
                await _Context.SaveChangesAsync(cancellationToken);
        }

        public async Task OnExceptionAsync(FunctionExceptionContext exceptionContext, CancellationToken cancellationToken)
        {
            await _Context.DisposeAsync();
        }
    }
}
