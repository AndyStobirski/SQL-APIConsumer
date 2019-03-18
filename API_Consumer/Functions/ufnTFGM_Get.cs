using Microsoft.SqlServer.Server;
using SQLAPI_Consumer;
using System;
using System.Data.SqlTypes;

/// <summary>
/// Generic Get Api Consumer thought CLR Proc
/// </summary>
public class Functions
{
    /// <summary>
    /// It's a generic procedure used to consume Api throught GET method.
    /// Returns the result as a varchar(max)
    /// </summary>
    /// <param name="URL">Api GET Method</param>
    /// <param name="OcpApimSubscriptionKey">Ocp Apim Subscription Key</param>
    /// <remarks>
    /// https://stackoverflow.com/questions/356373/how-to-return-an-nvarcharmax-in-a-clr-udf
    /// </remarks>    
    [return: SqlFacet(MaxSize = -1)]
    [SqlFunction]
    public static SqlString UfnTFGM_Get(SqlString URL, SqlString OcpApimSubscriptionKey, SqlString expand, SqlString select, SqlString filter, SqlString orderby, SqlString top, SqlString skip, SqlString count)
    {
        string retval = string.Empty;

        try
        {

            retval = APIConsumer.GETMethod(URL.ToString(), OcpApimSubscriptionKey.ToString(),
                    new string[] {
                        expand.IsNull ? null : expand.ToString()
                        , select.IsNull ? null : select.ToString()
                        , filter.IsNull ? null : filter.ToString()
                        , orderby.IsNull ? null : orderby.ToString()
                        , top.IsNull ? null : top.ToString()
                        , skip.IsNull ? null : skip.ToString()
                        , count.IsNull ? null : count.ToString()
                });

        }
        catch (Exception ex)
        {
            retval =  ex.Message.ToString();
        }

        return retval;
    }

    /// <summary>
    /// It's a generic procedure used to consume Api throught GET method.
    /// Returns the result as a varchar(max)
    /// </summary>
    /// <param name="URL">Api GET Method</param>
    /// <param name="OcpApimSubscriptionKey">Ocp Apim Subscription Key</param>
    /// <remarks>
    /// https://stackoverflow.com/questions/356373/how-to-return-an-nvarcharmax-in-a-clr-udf
    /// </remarks>    
    [return: SqlFacet(MaxSize = -1)]
    [SqlFunction]
    public static SqlString UfnTFGM_GetID(SqlString URL, SqlString OcpApimSubscriptionKey, SqlInt32 id, SqlString select)
    {
        string retval = string.Empty;

        try
        {

            retval = APIConsumer.GETMethod(string.Format("{0}({1})", URL.ToString(),id), OcpApimSubscriptionKey.ToString(),
                    new string[] {
                        null 
                        , select.IsNull ? null : select.ToString()
                        , null
                        , null
                        , null
                        , null
                        , null
                });

        }
        catch (Exception ex)
        {
            retval = ex.Message.ToString();
        }

        return retval;
    }

}

