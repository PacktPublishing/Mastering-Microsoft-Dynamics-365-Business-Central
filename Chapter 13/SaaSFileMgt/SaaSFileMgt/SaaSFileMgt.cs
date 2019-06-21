using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Net.Http.Headers;

namespace SaaSFileMgt
{
    public static class SaaSFileMgt
    {
        static string BLOBStorageConnectionString = "DefaultEndpointsProtocol=https;AccountName=d365bcfilestorage;AccountKey=ryHNJnObz3sy90OH4cvpZ2IgzaC+JR4ptuGfnz8AAIIzGIF2c/dkTf2QZIDTQQE77SUE2hbhcH8U4SbOhRqKMA==;EndpointSuffix=core.windows.net";

        [FunctionName("UploadFile")]
        public static async Task<IActionResult> Upload(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);

            string base64String = data.base64;
            string fileName = data.fileName;
            string fileType = data.fileType;
            string fileExt = data.fileExt;
            Uri uri = await UploadBlobAsync(base64String, fileName, fileType, fileExt);            

            return fileName != null
                ? (ActionResult)new OkObjectResult($"File {fileName} stored. URI = {uri}")
                : new BadRequestObjectResult("Error on input parameter (object)");
        }

        [FunctionName("DownloadFile")]
        public static async Task<IActionResult> Download(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            try
            {
                string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
                dynamic data = JsonConvert.DeserializeObject(requestBody);

                string url = data.url;
                string contentType = data.fileType;
                string fileName = data.fileName;
                byte[] x = await DownloadBlobAsync(url, fileName);

                //Returns the Base64 string of the retrieved file
                return (ActionResult)new OkObjectResult($"{Convert.ToBase64String(x)}");
           
                //This returns the file content directly (no base 64)
                //return new FileContentResult(x, contentType);
            }
            catch(Exception ex)
            {
                log.LogInformation("Bad input request: " + ex.Message);
                return new BadRequestObjectResult("Error on input parameter (object): " + ex.Message);
            }
        }

        [FunctionName("ListFiles")]
        public static async Task<IActionResult> Dir(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);

            var URIfileList = await ListBlobAsync();

            string json = JsonConvert.SerializeObject(URIfileList);

            return URIfileList != null
                ? (ActionResult)new OkObjectResult($"{json}")
                : new BadRequestObjectResult("Bad request.");
        }

            #region BLOB STORAGE MANAGEMENT

            public static async Task<Uri> UploadBlobAsync(string base64String, string fileName, string fileType, string fileExtension)
        {            
            string contentType = fileType;            
            byte[] fileBytes = Convert.FromBase64String(base64String);

            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(BLOBStorageConnectionString);
            CloudBlobClient client = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = client.GetContainerReference("d365bcfiles");

            await container.CreateIfNotExistsAsync(
              BlobContainerPublicAccessType.Blob,
              new BlobRequestOptions(),
              new OperationContext());
            CloudBlockBlob blob = container.GetBlockBlobReference(fileName);
            blob.Properties.ContentType = contentType;

            using (Stream stream = new MemoryStream(fileBytes, 0, fileBytes.Length))
            {
                await blob.UploadFromStreamAsync(stream).ConfigureAwait(false);
            }

            return blob.Uri;
        }

        public static async Task<byte[]> DownloadBlobAsync(string url, string fileName)
        {

            CloudStorageAccount storageAccount =
              CloudStorageAccount.Parse(BLOBStorageConnectionString);  //Storage account connection string
            CloudBlobClient client = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = client.GetContainerReference("d365bcfiles");  //Container name

            CloudBlockBlob blob = container.GetBlockBlobReference(fileName);
            await blob.FetchAttributesAsync();
            long fileByteLength = blob.Properties.Length;
            byte[] fileContent = new byte[fileByteLength];
            for (int i = 0; i < fileByteLength; i++)
            {
                fileContent[i] = 0x20;
            }
            await blob.DownloadToByteArrayAsync(fileContent, 0);
            return fileContent;

        }

        public static async Task<List<Uri>> ListBlobAsync()
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(BLOBStorageConnectionString);

            CloudBlobClient client = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = client.GetContainerReference("d365bcfiles");

            List<Uri> URIFileList = new List<Uri>();

            BlobContinuationToken blobContinuationToken = null;
            do
            {
                var resultSegment = await container.ListBlobsSegmentedAsync(prefix: null,
                                                                            useFlatBlobListing: true,
                                                                            blobListingDetails: BlobListingDetails.None,
                                                                            maxResults: null,
                                                                            currentToken: blobContinuationToken,
                                                                            options: null,
                                                                            operationContext: null);
                // Get the value of the continuation token returned by the listing call.
                blobContinuationToken = resultSegment.ContinuationToken;
                foreach (IListBlobItem item in resultSegment.Results)
                {
                    URIFileList.Add(item.Uri);
                }
            } while (blobContinuationToken != null); // Loop while the continuation token is not null.

            return URIFileList;
        }

        

        #endregion

    }
}
