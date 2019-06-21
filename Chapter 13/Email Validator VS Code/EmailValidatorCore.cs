using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace PACKT.Function
{
    public static class EmailValidatorCore
    {
        [FunctionName("EmailValidatorCore")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string email = req.Query["email"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            email = email ?? data?.email;

            //Validating the email address
            EmailValidationResult jsonResponse = new EmailValidationResult();
            jsonResponse.Email = email;
            jsonResponse.Valid = IsEmailValid(email);
            string json = JsonConvert.SerializeObject(jsonResponse);


            return email != null
                ? (ActionResult)new OkObjectResult($"{json}")
                : new BadRequestObjectResult("Please pass a email parameter on the query string or in the request body");
        }

        static bool IsEmailValid(string emailaddress)
        {
            try
            {
                System.Net.Mail.MailAddress m = new System.Net.Mail.MailAddress(emailaddress);
                return true;
            }
            catch (FormatException)
            {
                return false;
            }
        }
    }

    public class EmailValidationResult
    {
        public string Email { get; set; }
        public bool Valid { get; set; }
    }
}
