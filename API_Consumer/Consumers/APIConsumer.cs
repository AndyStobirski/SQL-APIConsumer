
using System;
using System.IO;
using System.Net;

namespace SQLAPI_Consumer
{
    /// <summary>
    /// This class will be used for consume API using the URL provided.
    /// Only GET is supported.
    /// </summary>
    public static class APIConsumer
    {
        /// <summary>
        /// Fixed Context type supported.
        /// </summary>
        private const string CONTENTTYPE = "application/json; charset=utf-8";

        /// <summary>
        /// Fixed string for GET method
        /// </summary>
        private const string GET_WebMethod = "GET";

        private static readonly string[] ParameterKeys = { "$expand", "$select", "$filter", "$orderby", "$top", "$skip", "$count" };

        /// <summary>
        /// Request GET Method to the URL API provided.
        /// </summary>
        /// <param name="url">API URL</param>
        /// <param name="OcpApimSubscriptionKey">Ocp Apim Subscription Key</param>
        /// <param name=""parameters"></param>
        /// <returns>String Api result</returns>
        public static string GETMethod(string url, string OcpApimSubscriptionKey, string[] ParameterValues)
        {
            string ContentResult = string.Empty;
            try
            {
                string parameters = string.Empty;

                for (int ctr = 0; ctr < ParameterKeys.Length; ctr++)
                {
                    if (ParameterValues[ctr] != null)
                    {
                        parameters +=
                            (string.IsNullOrEmpty(parameters) ? "?" : "&")
                            + string.Format("{0}={1}", ParameterKeys[ctr], ParameterValues[ctr]);
                    }
                }

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + parameters);

                request.ContentType = CONTENTTYPE;
                request.Method = GET_WebMethod;

                if (!String.IsNullOrEmpty(OcpApimSubscriptionKey))
                    request.Headers.Add("Ocp-Apim-Subscription-Key", OcpApimSubscriptionKey);

                var httpResponse = (HttpWebResponse)request.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    var result = streamReader.ReadToEnd();
                    ContentResult = result;
                }
            }
            catch (Exception ex)
            {
                ContentResult = ex.Message.ToString();
                throw ex;
            }

            return ContentResult;
        }
    }
}
