using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace D365BCAPIClient
{
    class Program
    {
        static HttpClient client = new HttpClient();
        static string baseURL, user, key;
        static string workingCompanyID;
        static void Main(string[] args)
        {
            GetSettingsParameters();
            RunAsync().GetAwaiter().GetResult();
        }

        static async Task RunAsync()
        {
            client.BaseAddress = new Uri(baseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));

            string userAndPasswordToken =
                Convert.ToBase64String(Encoding.UTF8.GetBytes(user + ":" + key));

            client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization",
                $"Basic {userAndPasswordToken}");

            try
            {                
                //Reads D365BC tenant companies
                await GetCompanies(baseURL);
                //Creates a D365BC customer
                await CreateCustomer(baseURL, workingCompanyID);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            Console.ReadLine();
        }

        static async Task GetCompanies(string baseURL)
        {
            HttpResponseMessage response = await client.GetAsync(baseURL + "/companies");
            JObject companies = JsonConvert.DeserializeObject<JObject>(response.Content.ReadAsStringAsync().Result);
            JObject o = JObject.Parse(companies.ToString());

            foreach (JToken jt in o.Children())
            {
                JProperty jProperty = jt.ToObject<JProperty>();
                string propertyName = jProperty.Name;
                if (propertyName == "value")
                {
                    foreach (JToken jt1 in jProperty.Children())
                    {
                        JArray array = new JArray(jt1.Children());
                        for (int i = 0; i < array.Count; i++)
                        {
                            string companyID = array[i].Value<string>("id");
                            string companyName = array[i].Value<string>("name");
                            Console.WriteLine("Company ID: {0}, Name: {1}", companyID, companyName);
                            if (companyName == "CRONUS IT")
                            {
                                workingCompanyID = companyID;
                            }
                        }
                    }
                }
            }
        }

        static async Task CreateCustomer(string baseURL, string companyID)
        {                        
            JObject customer = new JObject(            
                new JProperty("displayName", "Stefano Demiliani API"),
                new JProperty("type", "Company"),
                new JProperty("email", "demiliani@outlook.com"),
                new JProperty("website", "www.demiliani.com"),
                new JProperty("taxLiable", false),
                new JProperty("currencyId", "00000000-0000-0000-0000-000000000000"),
                new JProperty("currencyCode", "EUR"),
                new JProperty("blocked", " "),
                new JProperty("balance", 0),
                new JProperty("overdueAmount", 0),
                new JProperty("totalSalesExcludingTax", 0),
                new JProperty("address",
                    new JObject(
                        new JProperty("street", "Viale Kennedy 87"),
                        new JProperty("city", "Borgomanero"),
                        new JProperty("state", "Italy"),
                        new JProperty("countryLetterCode", "IT"),
                        new JProperty("postalCode", "IT-28021")
                        )
                   )
            );

            HttpContent httpContent = new StringContent(customer.ToString(), Encoding.UTF8, "application/json");
            HttpResponseMessage response = await client.PostAsync(baseURL + "/companies("+companyID+")/customers", httpContent);
            if (response.Content != null)
            {
                var responseContent = await response.Content.ReadAsStringAsync();
                Console.WriteLine("Response: " + responseContent);
            }
        }

        static void GetSettingsParameters()
        {
            string tenantID = "<YourTenantIDHere>";
            baseURL = "https://api.businesscentral.dynamics.com/v1.0/" + tenantID + "/api/beta";
            user = "<YourUsernameHere>";
            key = "<YourUserWebServiceAccessKeyHere>";
        }
    }
}
