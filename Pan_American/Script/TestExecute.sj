//USEUNIT utilities
//USEUNIT excelUtilities
//USEUNIT Tests
//USEUNIT Claims  
//USEUNIT policySection
//USEUNIT paymentSection 
//USEUNIT Address
//USEUNIT backendexcelutilities
//USEUNIT navigateMainWindow
//REMOVE MDISolicitudes

/// Script file: TestExecute
/// Last update: May 8


// Zipcode Tests
function runCityTest() { addressValidationTests("city");}

function runZipcodeTest() { addressValidationTests("zipcode");} 

// New Business Tests

function testType(pvrow)
{  
   var testTypes = new Array("NewBusiness", "Claims", "Backend", "ZipCode", "CityZip");
   
   var test = Project.Variables.TestList(3,pvrow);
   for (var i=0; i < testTypes.length; i++)
   { 
      if (fuzzyCompare(testTypes[i], test) == 0) 
        return i;
   }
   Log.Error("Invalid test type:" + test); return NEGATIVE;
}

/// Main Entries
function runTestSuite()
{
    //Testing ASSEMBLA
    //Testing ASSEMBLA2
    var debugTC = ""; // example: "1", "2", ...
    addProjectVariable("tcNum", "string", debugTC);
    
    if(!initTestEnvironment()){ return;}
    if(!logon()){ return;}
    if(seleccionarCompanias() == NEGATIVE ) { return;}
    
    //Automatica Policies
    if (Project.Variables.polizas > 1)
    {
      addProjectVariable("Automatic", "string", "SI");
      
      Project.Variables.tcNum = 1;
      
      for (i=0;i<Project.Variables.polizas;i++)
      {
        if (newBusinessTest() != NEGATIVE)
        {  
          Log.Message("***** Completed. NewBusiness Population for Test Number: " + Project.Variables.tcNum);
          makepaymenttest();
        }
      }
      
      return;
    }
    else
    {
      addProjectVariable("Automatic", "string", "NO");
    }
    
    //Excell Policies
    if (readTestList() == 0 ) return;
    var pvrow = 0; 
    while (pvrow != NEGATIVE)
    {
       pvrow = getTcNum(NEGATIVE); if (pvrow == NEGATIVE) break;
       var testtypeIdx = testType(pvrow); 
       Log.Checkpoint("Type " + testtypeIdx);
       
       switch (testtypeIdx)
       {
          case NEGATIVE: { } break;
          case 0: // New Business test
          { 
             if (newBusinessTest() != NEGATIVE)
             { 
                Log.Message("***** Completed. NewBusiness Population for Test Number: " + Project.Variables.tcNum);
                makepaymenttest();
             }
             else
             {
             Log.Error("Error in new business test case number: " + Project.Variables.tcNum);
             if(!initTestEnvironment()){ return;}
              if(!logon()){ return;}
              if(seleccionarCompanias() == NEGATIVE ) { return;}
             }
          }
          break;
          case 1: // Claims
          { 
          //makeClaim(Project.Variables.TestList(0,pvrow));}
            processClaims();}
          break;   
          case 2: // Backend Validation
          { makeClaim(Project.Variables.TestList(0,pvrow));}
          break;   
          case 3: // ZipCode test
          { addressValidationTests("zipcode");}
          break;   
          case 4: // City to ZipCode
          { addressValidationTests("city");}
          break;   
          default: { Log.Error("Unimplemented test type."); testtypeIdx = NEGATIVE;}
       } 
       if (testtypeIdx != NEGATIVE) { if(!goToMain()) { break;}}
    }
    exitApplication();
}

/// Test Stubs
function test_runZipcodeTests()
{  if (getTcNum(0) == NEGATIVE) return;
   populatePersonalInfo(0);  // primary applicant 
   zipcodeTests ("city");
   if(!goToMain()) { Log.Message("TODO .... in runTestSuite"); return;}
   exitApplication();
}

function runbackendtests ()
{
   if(!initTestEnvironment()){ return;}
   if(!logon()){ return;}
   addProjectVariable("countryCode", "string", "1"); // for PAL Private Client
   if (seleccionarCompanias() == NEGATIVE) { return;}
   // retreivePolicydata(Project.Variables.PolicyNum
   // MantenimientosMenu("Mantenimiento De Pólizas");
   // addProjectVariable("backend_policynum3", "string", "500882"); 
   // MDIPoliza_policyNumber(Project.Variables.backend_policynum3); // 
   readbackendexcelPolicy(); 
  //getstatus_forminfo();   
  exitApplication();
}

function closeIfrun60()
{
   var ifrun60 = Sys.Process("ifrun60"); var prevIfrun60 = ifrun60.FullName; 
   var kill = (ifrun60.Exists);
   ifrun60.Close(); aqUtils.Delay(100);
   while(kill)
   { 
      var ifrun60 = Sys.FindChild("Name", "Process(\"ifrun60*)");
      if (ifrun60.Exists) 
      { 
         if (ifrun60.FullName == prevIfrun60)
         { 
            Log.Error("***** Fatal Error. Can not close " + prevIfrun60);
            Log.Message("Remove the process from TestComplete Object Browser.");
            return;
         }
         var logon = ifrun60.Dialog("Logon").Window("ui60Drawn_W32").Button("Cancel");
         if(logon.Exists)
         { logon.ClickButton(); aqUtils.Delay(100);}
         else
         {ifrun60.Close();}
      }
   }
}