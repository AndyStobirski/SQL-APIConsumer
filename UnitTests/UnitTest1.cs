using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SQLAPI_Consumer;
using System.IO;

namespace UnitTests
{
    [TestClass]
    public class UnitTest1
    {
        //Insert KEY here
        private string key => "";

        [TestMethod]
        public void Test_UfnTFGM_Get()
        {
            System.Data.SqlTypes.SqlString output = Functions.UfnTFGM_Get("https://api.tfgm.com/odata/Metrolinks", key, null, null, null, null, null, null, null);

            File.WriteAllText("foo.txt", output.ToString());

            Console.WriteLine(output);
        }
    }
}
