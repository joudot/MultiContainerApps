using System;
using System.Collections;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using Dapr.Client;
using System.Collections.Generic;

namespace mywebapp.Controllers
{
    public class HomeController : Controller
    {
        private const string WebApiAppId = "juoudot-backend-webapi";
        private readonly DaprClient _daprClient;

        private HttpClient _httpClient;

        public HomeController(DaprClient daprClient)
        {
            _httpClient = new HttpClient();
            _daprClient = daprClient;
        }

        public IActionResult Index()
        {
            ViewData["Container_Version"] = Environment.GetEnvironmentVariables()["CONTAINER_VERSION"] ?? "Unknown";

            return View();
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Error()
        {
            return View();
        }

        public async Task<IActionResult> Quotes()
        {
            try {
               //var response = await _httpClient.GetStringAsync("https://juoudot-backend-webapi.calmwater-c746f390.westeurope.azurecontainerapps.io/api/quotes");
                var response = await _daprClient.InvokeMethodAsync<List<string>>(HttpMethod.Get, WebApiAppId, "api/quotes");
                ViewData["Message"] = string.Join(", ", response); 
            }
            catch(Exception e)
            {
                ViewData["Message"] = $"Error invoking quote service to retrieve quotes. Message: {e.InnerException?.Message ?? e.Message}";
            }
            
            return View();
         }
    }
}
