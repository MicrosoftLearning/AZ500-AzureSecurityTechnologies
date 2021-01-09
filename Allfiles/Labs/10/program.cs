 using System;
 using System.Collections.Generic;
 using System.Linq;
 using System.Text;
 using System.Threading.Tasks;
 using System.Data;
 using System.Data.SqlClient;
 using Microsoft.IdentityModel.Clients.ActiveDirectory;
 using Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVaultProvider;
 namespace AlwaysEncryptedConsoleAKVApp
 {
 class Program
 {
     // Update this line with your Medical database connection string from the Azure portal.
     static string connectionString = @"<connection string noted earlier>";
     static string clientId = @"<client id noted earlier>";
     static string clientSecret = "<key value noted earlier>";
     static void Main(string[] args)
     {
         InitializeAzureKeyVaultProvider();
         Console.WriteLine("Signed in as: " + _clientCredential.ClientId);
         Console.WriteLine("Original connection string copied from the Azure portal:");
         Console.WriteLine(connectionString);
         // Create a SqlConnectionStringBuilder.
         SqlConnectionStringBuilder connStringBuilder =
             new SqlConnectionStringBuilder(connectionString);
         // Enable Always Encrypted for the connection.
         // This is the only change specific to Always Encrypted
         connStringBuilder.ColumnEncryptionSetting =
             SqlConnectionColumnEncryptionSetting.Enabled;
         Console.WriteLine(Environment.NewLine + "Updated connection string with Always Encrypted enabled:");
         Console.WriteLine(connStringBuilder.ConnectionString);
         // Update the connection string with a password supplied at runtime.
         Console.WriteLine(Environment.NewLine + "Enter server password:");
         connStringBuilder.Password = Console.ReadLine();
         // Assign the updated connection string to our global variable.
         connectionString = connStringBuilder.ConnectionString;
         // Delete all records to restart this demo app.
         ResetPatientsTable();
         // Add sample data to the Patients table.
         Console.Write(Environment.NewLine + "Adding sample patient data to the database...");
         InsertPatient(new Patient()
         {
             SSN = "999-99-0001",
             FirstName = "Orlando",
             LastName = "Gee",
             BirthDate = DateTime.Parse("01/04/1964")
         });
         InsertPatient(new Patient()
         {
             SSN = "999-99-0002",
             FirstName = "Keith",
             LastName = "Harris",
             BirthDate = DateTime.Parse("06/20/1977")
         });
         InsertPatient(new Patient()
         {
             SSN = "999-99-0003",
             FirstName = "Donna",
             LastName = "Carreras",
             BirthDate = DateTime.Parse("02/09/1973")
         });
         InsertPatient(new Patient()
         {
             SSN = "999-99-0004",
             FirstName = "Janet",
             LastName = "Gates",
             BirthDate = DateTime.Parse("08/31/1985")
         });
         InsertPatient(new Patient()
         {
             SSN = "999-99-0005",
             FirstName = "Lucy",
             LastName = "Harrington",
             BirthDate = DateTime.Parse("05/06/1993")
         });
         // Fetch and display all patients.
         Console.WriteLine(Environment.NewLine + "All the records currently in the Patients table:");
         foreach (Patient patient in SelectAllPatients())
         {
             Console.WriteLine(patient.FirstName + " " + patient.LastName + "\tSSN: " + patient.SSN + "\tBirthdate: " + patient.BirthDate);
         }
         // Get patients by SSN.
         Console.WriteLine(Environment.NewLine + "Now lets locate records by searching the encrypted SSN column.");
         string ssn;
         // This very simple validation only checks that the user entered 11 characters.
         // In production be sure to check all user input and use the best validation for your specific application.
         do
         {
             Console.WriteLine("Please enter a valid SSN (ex. 999-99-0003):");
             ssn = Console.ReadLine();
         } while (ssn.Length != 11);
         // The example allows duplicate SSN entries so we will return all records
         // that match the provided value and store the results in selectedPatients.
         Patient selectedPatient = SelectPatientBySSN(ssn);
         // Check if any records were returned and display our query results.
         if (selectedPatient != null)
         {
             Console.WriteLine("Patient found with SSN = " + ssn);
             Console.WriteLine(selectedPatient.FirstName + " " + selectedPatient.LastName + "\tSSN: "
                 + selectedPatient.SSN + "\tBirthdate: " + selectedPatient.BirthDate);
         }
         else
         {
             Console.WriteLine("No patients found with SSN = " + ssn);
         }
         Console.WriteLine("Press Enter to exit...");
         Console.ReadLine();
     }
     private static ClientCredential _clientCredential;

     static void InitializeAzureKeyVaultProvider()
     {
         _clientCredential = new ClientCredential(clientId, clientSecret);
         SqlColumnEncryptionAzureKeyVaultProvider azureKeyVaultProvider =
         new SqlColumnEncryptionAzureKeyVaultProvider(GetToken);
         Dictionary<string, SqlColumnEncryptionKeyStoreProvider> providers =
         new Dictionary<string, SqlColumnEncryptionKeyStoreProvider>();
         providers.Add(SqlColumnEncryptionAzureKeyVaultProvider.ProviderName, azureKeyVaultProvider);
         SqlConnection.RegisterColumnEncryptionKeyStoreProviders(providers);
     }

     public async static Task<string> GetToken(string authority, string resource, string scope)
     {
         var authContext = new AuthenticationContext(authority);
         AuthenticationResult result = await authContext.AcquireTokenAsync(resource, _clientCredential);
         if (result == null)
             throw new InvalidOperationException("Failed to obtain the access token");
         return result.AccessToken;
     }
     static int InsertPatient(Patient newPatient)
     {
         int returnValue = 0;
         string sqlCmdText = @"INSERT INTO [dbo].[Patients] ([SSN], [FirstName], [LastName], [BirthDate]) VALUES (@SSN, @FirstName, @LastName, @BirthDate);";
         SqlCommand sqlCmd = new SqlCommand(sqlCmdText);

         SqlParameter paramSSN = new SqlParameter(@"@SSN", newPatient.SSN);
         paramSSN.DbType = DbType.AnsiStringFixedLength;
         paramSSN.Direction = ParameterDirection.Input;
         paramSSN.Size = 11;
         SqlParameter paramFirstName = new SqlParameter(@"@FirstName", newPatient.FirstName);
         paramFirstName.DbType = DbType.String;
         paramFirstName.Direction = ParameterDirection.Input;
         SqlParameter paramLastName = new SqlParameter(@"@LastName", newPatient.LastName);
         paramLastName.DbType = DbType.String;
         paramLastName.Direction = ParameterDirection.Input;
         SqlParameter paramBirthDate = new SqlParameter(@"@BirthDate", newPatient.BirthDate);
         paramBirthDate.SqlDbType = SqlDbType.Date;
         paramBirthDate.Direction = ParameterDirection.Input;
         sqlCmd.Parameters.Add(paramSSN);
         sqlCmd.Parameters.Add(paramFirstName);
         sqlCmd.Parameters.Add(paramLastName);
         sqlCmd.Parameters.Add(paramBirthDate);
         using (sqlCmd.Connection = new SqlConnection(connectionString))
         {
             try
             {
                 sqlCmd.Connection.Open();
                 sqlCmd.ExecuteNonQuery();
             }
             catch (Exception ex)
             {
                 returnValue = 1;
                 Console.WriteLine("The following error was encountered: ");
                 Console.WriteLine(ex.Message);
                 Console.WriteLine(Environment.NewLine + "Press Enter key to exit");
                 Console.ReadLine();
                 Environment.Exit(0);
             }
         }
         return returnValue;
     }
     static List<Patient> SelectAllPatients()
     {
         List<Patient> patients = new List<Patient>();
         SqlCommand sqlCmd = new SqlCommand(
         "SELECT [SSN], [FirstName], [LastName], [BirthDate] FROM [dbo].[Patients]",
             new SqlConnection(connectionString));
         using (sqlCmd.Connection = new SqlConnection(connectionString))
         {
             try
             {
                 sqlCmd.Connection.Open();
                 SqlDataReader reader = sqlCmd.ExecuteReader();
                 if (reader.HasRows)
                 {
                     while (reader.Read())
                     {
                         patients.Add(new Patient()
                         {
                             SSN = reader[0].ToString(),
                             FirstName = reader[1].ToString(),
                             LastName = reader["LastName"].ToString(),
                             BirthDate = (DateTime)reader["BirthDate"]
                         });
                     }
                 }
             }
             catch (Exception ex)
             {
                 throw;
             }
         }
         return patients;
     }

     static Patient SelectPatientBySSN(string ssn)
     {
         Patient patient = new Patient();
         SqlCommand sqlCmd = new SqlCommand(
             "SELECT [SSN], [FirstName], [LastName], [BirthDate] FROM [dbo].[Patients] WHERE [SSN]=@SSN",
             new SqlConnection(connectionString));
         SqlParameter paramSSN = new SqlParameter(@"@SSN", ssn);
         paramSSN.DbType = DbType.AnsiStringFixedLength;
         paramSSN.Direction = ParameterDirection.Input;
         paramSSN.Size = 11;
         sqlCmd.Parameters.Add(paramSSN);
         using (sqlCmd.Connection = new SqlConnection(connectionString))
         {
             try
             {
                 sqlCmd.Connection.Open();
                 SqlDataReader reader = sqlCmd.ExecuteReader();
                 if (reader.HasRows)
                 {
                     while (reader.Read())
                     {
                         patient = new Patient()
                         {
                             SSN = reader[0].ToString(),
                             FirstName = reader[1].ToString(),
                             LastName = reader["LastName"].ToString(),
                             BirthDate = (DateTime)reader["BirthDate"]
                         };
                     }
                 }
                 else
                 {
                     patient = null;
                 }
             }
             catch (Exception ex)
             {
                 throw;
             }
         }
         return patient;
     }

     // This method simply deletes all records in the Patients table to reset our demo.
     static int ResetPatientsTable()
     {
         int returnValue = 0;
         SqlCommand sqlCmd = new SqlCommand("DELETE FROM Patients");
         using (sqlCmd.Connection = new SqlConnection(connectionString))
         {
             try
             {
                 sqlCmd.Connection.Open();
                 sqlCmd.ExecuteNonQuery();
             }
             catch (Exception ex)
             {
                 returnValue = 1;
             }
         }
         return returnValue;
 }
 }

 class Patient
 {
     public string SSN { get; set; }
     public string FirstName { get; set; }
     public string LastName { get; set; }
     public DateTime BirthDate { get; set; }
 }
}
