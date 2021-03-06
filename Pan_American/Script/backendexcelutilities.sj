//USEUNIT backend_VALIDATION_POLICY
//USEUNIT excelUtilities
//USEUNIT navigateMainWindow
//USEUNIT Tests
//USEUNIT utilities
//REMOVE MDISolicitudes

/// Script file: backendexcelutilities
/// Last update: May 8

function populateform()
{
// Populates the main form, after the policy number has been entered
// with the policy number entered, click the "flashlight" control to have policy information populated into the form
   clickPopulate = ("Consultar");
   saludecoreToolbar(clickPopulate);
}

function writebackendsrvr_policynum () //REMOVE
{ //this function will write the policy number into the interface
 //invoke application and drive to the policy page
  //open the application and drive to the appropriate dialog 
  // initTestEnvironment();
  // if(!logon()){ return;}
  // MantenimientosMenu("Mantenimiento De Solicitudes"); //"retreiveSolicitudesPage");
  MDISolicitudes_PolicyNumber(Project.Variables.backend_policynum3); // MDISolicitudes_setPolicyNumber();
}

function readbackendexcelPolicy()
{
// Reads all the excel data from the "VALIDATION_POLICY" spreadsheet
   var backendfilepath
   var excelObject
   
   //file path
   backendfilepath = ("C:\\Documents and Settings\\U00165\\My Documents\\TestComplete 8 Projects\\backendserver");
   //path + filename
   fileName = (backendfilepath+"\\PALPortalDataout.xls");
   //create excel object
   excelObject = DDT.ExcelDriver(fileName, "VALIDATION_POLICY");
     
  //step through the spreadsheet   
   while (! excelObject.EOF())
   {
      col = 1;
      //get data from spreadsheet (Sheet - VALIDATION_POLICY)
      var policy_num = excelObject.Value(col++);
      var plan_type = excelObject.Value(col++);  //"plan" in spreadsheet
      var effective_date = excelObject.Value(col++); //requested effective date in spreadsheet
      var premium = excelObject.Value(col++); //premium_amount in spreadsheet - 01/31/2012 we do not have access to the premium amount at this time in either Saludcore or the portal so no further work is required for now
      var payment = excelObject.Value(col++); //payment_mode in 
      var policy_type = excelObject.Value(col++);  //policy_number_type in spreadsheet
      //sometimes the spreadsheet from PAl Portal does not give a policy number, in this case the variable policy_num will be null so need to handle this 
      if (policy_num == null && ! excelObject.EOF())
         {
         excelObject.Next();
         continue;
         }
      //policy_num is grabbed from spreadsheet as "double"  need to convert to string            
      policy_num = aqConvert.VarToStr(policy_num);  //convert the policy number to a string - easier for validation
       
         
      //store data in project variables for verification with data in Saludcore
      addProjectVariable("excel_policynum", "string", policy_num);
      addProjectVariable("excel_plan", "string", plan_type);
      addProjectVariable("excel_effective_date", "string", effective_date); // used to be "date"
      addProjectVariable("excel_premium", "string", premium);
      addProjectVariable("excel_payment", "string", payment);
      addProjectVariable("excel_policy_type", "string", policy_type);
        
      parsepolicynum();
      // writebackendsrvr_policynum();
      MantenimientosMenu("Mantenimiento De Pólizas");
      retreivePolicydata(Project.Variables.backend_policynum3);  
      
      populateform();   // Click the Consultar control to pull all policy data to the form from the db
      getEffective_date ();
      paymentMode = getPaymentMode();
      getPlanType();    //getting the plan type from the Saludcore to validate with spreadsheet
      compare_excel_vs_Saludcore(paymentMode);   //this function compares all the data between the spreasheet data from the Portal to Saludcore data pulled with the policy number from the spreadsheet (PalPortalDataout)
      exitApplication();
      
            
      excelObject.Next();
      
    }  
      DDT.CloseDriver(excelObject.Name);
}

function parsepolicynum()
{
  //remove first four values
  var StartPos = 0;
  var sLength = 3;
  var Res = aqString.Remove(Project.Variables.excel_policynum, StartPos, sLength);
  //store 3rd edit box value in project variable
  addProjectVariable("backend_policynum3", "string", Res);
  Log.Message(Res);  
}
 
//this function will get the data from the spreadsheet for validation of addresses (sheet VALIDATION_ADDRESS)
function getAddress_Info()
{   
   var backendfilepath
   var excelObject
   
   //file path
   backendfilepath = ("C:\\Documents and Settings\\U00165\\My Documents\\TestComplete 8 Projects\\backendserver");
   //path + filename
   fileName = (backendfilepath+"\\PALPortalDataout.xls");
   //create excel object
   excelObject = DDT.ExcelDriver(fileName, "VALIDATION_ADDRESS");
 /*  var Excel = Sys.OleObject("Excel.Application");
  Excel.Workbooks.Open(fileName);

  var RowCount = Excel.ActiveSheet.UsedRange.Rows.Count;
  var ColumnCount = Excel.ActiveSheet.UsedRange.Columns.Count;    */
   


  while (! excelObject.EOF())  
  
   {
      col = 1;
      //get data from spreadsheet (sheet VALIDATION_ADDRESS)
      var home_address = excelObject.Value(col++);
      var home_address2 = excelObject.Value(col++);
      var country = excelObject.Value(col++);  
      var state = excelObject.Value(col++); 
      var city = excelObject.Value(col++); 
      var zipcode = excelObject.Value(col++);  
      var home_phone = excelObject.Value(col++);  
      var mobile_phone = excelObject.Value(col++);
      var work_phone = excelObject.Value(col++);
      var fax_phone = excelObject.Value(col++);
      var email = excelObject.Value(col++);
      //var home_address2 = aqString.Unquote(home_address2);     
      //put data into an array for varification with data from Saludcore
      indexlist = new Array(home_address,country, state, city, zipcode, home_phone, mobile_phone, work_phone, fax_phone, email); 
      Log.Message(indexlist[0]+ " " + indexlist[1]+ " " + indexlist[2]+ " " + indexlist[3]+ " " + indexlist[4] + " " + indexlist[5]+ " " + indexlist[6]+ " " + indexlist[7]+ " " + indexlist[8]+ " " + indexlist[9]);      
      excelObject.Next();
   }
   //Excel.Quit();
   DDT.CloseDriver(excelObject.Name);
}

//get data for dependants from spreasheet (VALIDATION_APPLICANTS)
function dependant_data()
{

var fileName, excelObject, count;
         
   // fileName = Files.FileNameByName("pan_american_config_xls");
      //file path
   backendfilepath = ("C:\\Documents and Settings\\U00165\\My Documents\\TestComplete 8 Projects\\backendserver");
   //path + filename
   fileName = (backendfilepath+"\\PALPortalDataout.xls");
   //create excel object
   excelObject = DDT.ExcelDriver(fileName, "VALIDATION_APPLICANTS");
    
    //get the number of records in the spreadsheet
    count = 0;
    while (! excelObject.EOF())    //loop through the sheet until there are no more records
    {
       testcaseNumber = excelObject.Value(1);
       count++;
       excelObject.Next();    //this clicks through the the rows in the sheet
    }
      
   DDT.CloseDriver(excelObject.Name);
   count = count - 1;// when reading the excel sheet it counts the title  row as a record so i subtract 1 here for now untile i figure out a better way to fix this
   addProjectVariable("excel_num_records", "integer", count);
   Log.Message(Project.Variables.excel_num_records);
   
     
   //get the first name, then 2nd, 3rd and 4th into a variable for each, then concatinate them into a single variable 
   //for verification with the name taken from the application form
   excelObject = DDT.ExcelDriver(fileName, "VALIDATION_APPLICANTS"); 
   //use for loop to get data into separate varibales (for i = 1, start at first column, until i is greater or == to the number of records <excel_num_records> i++ increment each pass through
   for (i = 1;i<= Project.Variables.excel_num_records;i++)
  
   {
      col = 1;
    
      firstName = excelObject.Value(col++);
      secondName = excelObject.Value(col++);
      thirdName = excelObject.Value(col++);
      fourthName = excelObject.Value(col++);
      DOB = excelObject.Value(col++);
      relationShip = excelObject.Value(col++);
     
       
      fullName = (firstName + " " + secondName + " " + thirdName + " " + fourthName);
      addProjectVariable("excel_fullName" + aqConvert.IntToStr(i) , "string", fullName);
      addProjectVariable("excel_bDate", "date", DOB);
      addProjectVariable("excel_relationShip", "string", relationShip);
     
      //addProjectVariable("excel_bDate" + aqConvert.IntToStr(i), "string", DOB);
      //addProjectVariable ("excel_relationShip" + aqConvert.IntToStr(i), "string", relationShip);
      Log.Message( Project.Variables.VariableByName("excel_fullName"+ aqConvert.IntToStr(i)));
      //Log.Message(Project.Variables.VariableByName("excel_fullName");
      Log.Message(Project.Variables.excel_bDate  );
      Log.Message(Project.Variables.excel_relationShip);
    
    
      excelObject.Next();
    
     
   } 
   
   
   DDT.CloseDriver(excelObject.Name);
}  

