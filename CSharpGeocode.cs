        static string key = "";
        static string URI => "https://maps.googleapis.com/maps/api/geocode/xml?";

        static string GetPostCode(string pLatLong)
        {
            string requestUri = URI + $"latlng={pLatLong}&key={key}";

            WebRequest request = WebRequest.Create(requestUri);
            WebResponse response = request.GetResponse();

            using (Stream r = response.GetResponseStream())
            {
   
                using (StreamReader reader = new StreamReader(r, Encoding.UTF8))
                {

                    XDocument xdoc = XDocument.Load(reader);


                    XElement pcResult = xdoc.Element("GeocodeResponse").Elements("result").FirstOrDefault
                                 (
                                     e => e.Descendants().First().Name.LocalName.Equals("type")
                                         && e.Descendants().First().Value == "postal_code"
                                 );

                    string post_code = pcResult.Elements("address_component")
                                    .ToList()
                                    .FirstOrDefault(n => n.Value.Contains("postal_code"))
                                    ?.Element("long_name")
                                    .Value;

                    return post_code;
                }
            }
        }