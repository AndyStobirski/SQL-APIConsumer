using Microsoft.SqlServer.Server;
using System.Data;

namespace SQLAPI_Consumer
{
    /// <summary>
    /// Utility used for return result set to SQL.
    /// </summary>
    public  static class Helper
    {
        /// <summary>
        /// Static method used to send and specific value as a result.
        /// </summary>
        /// <param name="ColumnName">Name of column showed in SQL Result set.</param>
        /// <param name="Value">Value to be sent.</param>
        public static void SendResultValue(string ColumnName, string Value)
        {
            SqlDataRecord Record = new SqlDataRecord(new SqlMetaData[] { new SqlMetaData(ColumnName, SqlDbType.VarChar, SqlMetaData.Max) });

            SqlContext.Pipe.SendResultsStart(Record);

            if (SqlContext.Pipe.IsSendingResults)
            {
                Record.SetValues(Value);

                SqlContext.Pipe.SendResultsRow(Record);

                SqlContext.Pipe.SendResultsEnd();
            }
        }
    }
}
