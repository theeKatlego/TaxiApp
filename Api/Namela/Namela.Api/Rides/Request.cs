using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Namela.Domain.Features.Rides;
using Newtonsoft.Json;
using System.Linq;
using System.Threading;

namespace Namela.Api.Rides
{
    public class Request
    {
        private readonly IMediator _Mediator;

        public Request(IMediator mediator)
        {
            _Mediator = mediator;
        }

        [FunctionName("Request")]
        public async Task<IActionResult> RunAsync(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)]
            RequestCommand command,
            ILogger log
            )
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            await _Mediator.Send(command);

            return new OkObjectResult("Ride requested.");
        }

        [FunctionName("Test")]
        public async Task<HttpResponseMessage> Test(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)]
            RequestCommand command,
            ILogger log
            )
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var response = new HttpResponseMessage();
            var content = new PushStreamContent(new Action<Stream, HttpContent, TransportContext>(WriteContent), "application/json");

            response.Headers.TransferEncodingChunked = true;
            response.Content = content;



            var video = new VideoStream();

            response.Content = new PushStreamContent(video.WriteToStream, "application/json");

            return response;
        }

        [FunctionName("Strings")]
        public async Task<IEnumerable<TestModel>> GetStrings(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)]
            RequestCommand command,
            ILogger log
        )
        { 
            return GetStringsFor(10000);
        }

        private static readonly Random random = new Random();
        private IEnumerable<TestModel> GetStringsFor(int amount)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            
            while (amount-- > 0)
            {
                var model = new TestModel
                {
                    Alias = $"{amount}",
                    Name = new string(Enumerable.Repeat(chars, random.Next(10)).Select(s => s[random.Next(s.Length)]).ToArray())
                };
                Thread.Sleep(TimeSpan.FromSeconds(0.25));
                yield return model;
            }
        }

        public static void WriteContent(Stream stream, HttpContent content, TransportContext context)
        {
            using (var sw = new StreamWriter(stream))
            {
                sw.WriteLineAsync($"{DateTime.Now} Hello subscriber").Wait();
                sw.FlushAsync().Wait();
            }
        }
    }

    public class TestModel
    {
        public string Name { get; set; }
        public string Alias { get; set; }
    }

    public class VideoStream
    {
        public async void WriteToStream(Stream outputStream, HttpContent content, TransportContext context)
        {
            try
            {
                var buffer = new byte[65536];

                var length = 65536;
                var bytesRead = 1;

                while (length > 0 && bytesRead > 0)
                {
                    bytesRead++;
                    await outputStream.WriteAsync(buffer, 0, bytesRead);
                    length -= bytesRead;
                }
            }
            catch (Exception ex)
            {
                return;
            }
            finally
            {
                outputStream.Close();
            }
        }
    }
}
