//USEUNIT excelUtilities
//USEUNIT navigateMainWindow
//USEUNIT utilities
//USEUNIT Address
//USEUNIT MDISolicitudes
//USEUNIT MedicalQuestions
//USEUNIT policySection
//USEUNIT paymentSection

/// Script file: Tests   
/// Last update: May 8    

function configTRACE()
{ 
   addProjectVariable("TRACE", "boolean", false); // true);
}

function initTestEnvironment()
{
  configTRACE();
  var ifrun60 = Sys.FindChild("Name", "Process(\"ifrun60*)");
  if(!ifrun60.Exists) { return true;}
  Log.Error("Saludecore is running. Please Remove all instances of Sys.Process(\"ifrun60...");
  return false;     
}

function readUserCredentials() { readConfigFile("credentials");}

function logon_failure()
{
  Log.Error("Logon Failure. Please check userid and Password in Saludecore Config.");
  var popupMSG = MENSAJE_LOGON("Logon", 0, "Cancel", 1);
  if ( popupMSG != NEGATIVE) {return;}
  Sys.Process("ifrun60").UIAObject("Oracle_Forms_Runtime").Close();
}



function logon()
{ 
  var loopCount = 10;
  var loopIndex =1;
  var user, password;
  
  readSaludcoreConfig();
  updateMainMenuData();
  readMainMenuData();
  
  Sys.Keys("[Hold][Win]r[Release]");
  aqUtils.Delay(500);
  Sys.Keys(Project.Variables.saludcoreExecutable + "[Enter]");
  
  addProjectVariable("phrasekey", "string", "mohy60lq2");  //key for encrypting  
  //If the value is not actually encrypted use the already decripted value for both username and password             
  try 
  {//calling the dot net dll for decryption of user and password
  password = dotNET.CryptoSolution.clsQuickCrypto.Decrypt(Project.Variables.phrasekey, Project.Variables.password);
  user = dotNET.CryptoSolution.clsQuickCrypto.Decrypt(Project.Variables.phrasekey, Project.Variables.username);
  }
  catch (e) {password = Project.Variables.password; user = Project.Variables.username;}
  
  aqUtils.Delay(400);
  
  /*
  Log.Enabled = false;
  var SecurityWarning = Sys.Process("explorer").Dialog("Open File - Security Warning");
  Log.Enabled = true;
  if (SecurityWarning.Exists) {SecurityWarning.Button("Run").ClickButton();}
  else { Log.Warning("No Security Warning");}
  */
  
  var logonfields = Sys.Process("ifrun60").Dialog("Logon").Window("ui60Drawn_W32", "", 1);
  if (!logonfields.Exists)
  { Log.Error("Fatal error."); return false;}
  logonfields.Window("Edit", "", 1).Keys(user); logonfields.Window("Edit", "", 1).Keys("[Tab]");
  logonfields.Window("Edit", "", 1).Keys(password); logonfields.Window("Edit", "", 1).Keys("[Enter]");
  var popupMSG = MENSAJE_FORMS("Logon denied", 0, "OK", 0);
  if ( popupMSG == NEGATIVE) { return true}; 
  logon_failure();
  return false;
}

function seleccionarCompanias()
{  
    var name = "Seleccionar Compañias";
    var rootWindow  = Sys.Process("ifrun60").Dialog(name);
    if (!rootWindow.Client(name).Exists) { return NEGATIVE;}
    return selectGriditemByName(name, 0, Project.Variables.countryCode);
}

function populatePersonalInfo(pvrow)
{  
    if (!checkPV("personalInfo" , pvrow)) { return;} 
    var pvcol = 1; // first column is for rowflag
    

    
    var MDIClientes = getMDIWindow(determineForm(),"Mantenimiento De Clientes");
    rootWindow = MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
    
    //Relation
    var rel = Project.Variables.personalInfo(pvcol++, pvrow);
    if(rel == 'Asegurado')
      Project.Variables.Asegurado = true;
    else
      Project.Variables.Asegurado = false;
      
    
    rootWindow.Window("ComboBox", "", 8).Button("Open").Click();
    selectComboBoxItem(rel);
    rootWindow.Window("ComboBox", "", 8).Keys("[Tab]");
     
    
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");   
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");   
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
    
    // firstname
    //rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    Sys.Keys(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    
    
    Sys.Keys("[Tab]"); 
    var z =Project.Variables.personalInfo(pvcol, pvrow);
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    
    Sys.Keys("[Tab]"); 
    
    // lastname 
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    
    Sys.Keys("[Tab]"); 
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    
    Sys.Keys("[Tab]"); 
    
    // DOB
    var w =Project.Variables.personalInfo(pvcol, pvrow);
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    aqUtils.Delay(500);
    
    var sexcol = pvcol; pvcol++;
    var relationcol = pvcol; pvcol++; // Parentesco ... after height
    
    // marital status
    rootWindow.Window("ComboBox", "", 7).Button("Open").Click();
    selectComboBoxItem(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    
    var sex = Project.Variables.personalInfo(sexcol, pvrow);
    if (aqString.Find(sex, "M") != NEGATIVE) rootWindow.RadioButton("Masculino").Click();
    else 
    if (aqString.Find(sex, "F") != NEGATIVE) rootWindow.RadioButton("Femenino").Click();
    
    // weight
    var wtcol = pvcol; pvcol++;  
    rootWindow.Window("ComboBox", "", 6).Button("Open").Click(); //weighttype
    selectComboBoxItem(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;    
    rootWindow.Window("ComboBox", "", 6).Keys("![Tab]"); // backtrack
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(wtcol, pvrow));
    
    // height
    var ht1col = pvcol; pvcol++;
    var ht2col = pvcol; pvcol++;
    rootWindow.Window("ComboBox", "", 5).Button("Open").Click(); //heighttype
    selectComboBoxItem(Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
    rootWindow.Window("ComboBox", "", 5).Keys("![Tab]"); // backtrack
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(ht2col, pvrow));
    rootWindow.Window("Edit", "", 1).Keys("![Tab]"); // backtrack
    rootWindow.Window("Edit", "", 1).SetText(Project.Variables.personalInfo(ht1col, pvrow));
    
    // relationship
    if(rel == 'Asegurado')
      selectByClickitem(MDIClientes.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4),Project.Variables.personalInfo(relationcol, pvrow), "");
    
    var professionalSports = pvcol; pvcol++;
    if ( aqString.Compare(Project.Variables.personalInfo(professionalSports, pvrow), "n", false) == 0)
    { rootWindow.RadioButton("No").ClickButton();}
    else
    { rootWindow.RadioButton("Si").ClickButton();}
    if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "***** Completed. Section:Informacion Personal");
}

function populateClientInfo(applicantIdx)
{
   populatePersonalInfo(applicantIdx);
   if (applicantIdx > 0) return; // we do not need address for dependents
   var MDIDirecciones = MDICliente_icon_Dirrecion();
   dirrecion();
   TelephoneInfo();    
}

function newBusiness()
{  
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "newBusiness" + Project.Variables.tcNum); 
   var MDIClientes = getMDIWindow(determineForm(), "Mantenimiento De Clientes");
   var rootWindow = MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   if (!rootWindow.Exists) 
   { Log.Error("Did not enter New Business"); return;}
   
   rootWindow.Window("ComboBox", "", 9).Button("Open").Click();
   
   selectComboBoxItem("Persona");
   rootWindow.Window("ComboBox", "", 9).Keys("[Tab]");
   
   rootWindow.Window("ComboBox", "", 8).Keys("[Tab]");
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");   
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");   
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
   //rootWindow.Window("ui60Viewcore_W32", "", 1).Click();
 
   //Sys.Process("ifrun60").Dialog("Calendar").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Cancel").Click();
   rootWindow.Window("Edit", "", 1).Keys("01/24/2013");
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
}




function activateManDeClientes()
{
   var salform  = SaludcoreForm();
   var MDIClientes = getMDIWindow(salform, "Mantenimiento De Clientes");
   if (!MDIClientes.TitleBar(0).Exists)
   { salform.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Click();}
}
function addDependents() 
{
   activateManDeClientes(); 
   var error = "No dependents for test " + Project.Variables.tcNum;
   
   if (!ifQ("dependentsQ")) { Log.Warning(error); return;} 
   readDependents();
   Project.Variables.personalInfo(0,0) = 0; // reset rowflag to add dependents 
   var dependentCount = Project.Variables.personalInfo.RowCount - 1;
   // determineDependentNumber(); if (dependentCount <= 0) { Log.Error(error); return;}
   
   MDICliente_RelacionDeDependiente(true);  // Add dependent, red and yellow pencil icon
   var MDIDependientes = getMDIWindow(determineForm(), "Dependientes"); 
   MDIDependientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys(dependentCount);
   MDIDependientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Aceptar").Click();
   
   for (var dependentNum = 1; dependentNum<= dependentCount; dependentNum++)
   {
      activateManDeClientes(); saludecoreToolbar("Insertar");
      // Potential dialog: must type or delete the record
      var popupMSG = MENSAJE_DE_ERROR("debe digitar o eliminar el registro", 0, "OK", 0);
      
      
      var MDIClientes = getMDIWindow(determineForm(), "Mantenimiento De Clientes");
      MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
      MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
      MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
      MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
      
      var pvrow = getUnusedPVRow("personalInfo"); 
      populateClientInfo(dependentNum);
      saludecoreToolbar("Grabar"); //Save
      // Client exist...Want to recreate it?
      var popupMSG = MENSAJE_DE_ALERTA("cliente con el apelido...Desea Crearlo de nuevo?", 0, "Si", 0); 
      // Expected dialog: Do you want to save changes?
      // var popupMSG = MENSAJE_FORMS("Do you want to save changes?", 0, "Yes", 0);
      // Expected dialog: Modifications have been recorded
      var popupMSG = MENSAJE_INFORMATIVO("Modificaciones Han Sido Grabadas", 0, "OK", 0);
       
      // var popupMSG = MENSAJE_DE_ALERTA("Esta seguro que desea crear afiliados y generar la solicitud", 0, "Si", 0); 
         
   }
}

function completePlan()
{
  // var MDIClientes = getMDIWindow(determineForm(), "Mantenimiento De Clientes"); 
  // MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 25).Click();
  var MDICrearAfiliado = icon_ConsultarAfiliado();
  if (!MDICrearAfiliado.TitleBar(0).Exists)
  { Log.Error("Did not Enter Plan window"); return NEGATIVE;}
  
    var rootWindow = MDICrearAfiliado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);

    var pvrow = getUnusedPVRow("planInfo"); 
    if (pvrow == NEGATIVE) { return ZERO; } 
       
    var pvcol = 0; var EffectiveDate = pvcol + 5;
       Sys.Keys("[Tab][Tab]" +  aqString.Unquote(Project.Variables.planInfo(EffectiveDate, pvrow)));
       
    var pvcol = 0; var ContactMeansCol = pvcol + 3;
       rootWindow.Window("ComboBox", "", 2).Button("Open").Click();
       selectComboBoxItem(Project.Variables.planInfo(ContactMeansCol, pvrow));
       
    var insuranceCol = pvcol + 1;
       rootWindow.Window("ui60Viewcore_W32", "", 4).Click();
       var tmp = selectGriditemByName("INTERMEDIARIOS", 1, Project.Variables.planInfo(insuranceCol, pvrow));
       
    var paymentmodeCol = pvcol + 4;
       rootWindow.Window("ComboBox", "", 1).Button("Open").Click();
       selectComboBoxItem(Project.Variables.planInfo(paymentmodeCol, pvrow));
       
    var plancol = pvcol + 2;
    rootWindow.Window("ui60Viewcore_W32", "", 7).Click();   // Datos Solicitud
    // Potential Dialog: Value list has no records
    var popupMSG = MENSAJE_INFORMATIVO("Lista de valores no tiene registros", 0, "OK", 0);
    if ( popupMSG != NEGATIVE)
    { 
       Log.Error("No Plans. Expected: " + Project.Variables.planInfo(plancol, pvrow)); 
       MDICrearAfiliado.TitleBar(0).Button("Close").ClickButton();
       return NEGATIVE;
    }
    var tmp = selectGriditemByName("Plan Grupo Familiar 1", 0, Project.Variables.planInfo(plancol, pvrow));
    rootWindow.Button("Generar").Click();
    
    if (Project.Variables.countryCode != 1)
    {
      var popupMSG1 = MENSAJE_DE_ALERTA("Este cliente podría estar requiriendo los números tributarios*", 0, "Si", 0);
      // Dialog Are you sure you want to create affiliate and generate the application
      var popupMSG = MENSAJE_DE_ALERTA("Esta seguro que desea crear afiliados y generar la solicitud", 2, "Si", 0);
    }
    else
    {
      // Dialog Are you sure you want to create affiliate and generate the application
      var popupMSG = MENSAJE_DE_ALERTA("Esta seguro que desea crear afiliados y generar la solicitud", 0, "Si", 0);
    }
    
    // Dialog Process completed successfully
    //var popupMSG = MENSAJE_INFORMATIVO("Proceso Finalizo Exitosamente.", 0, "OK", 0);
    while (!OK_MENSAJE_INFORMATIVO("Proceso Finalizo Exitosamente."))
    {};
    
    return ZERO;
}

function selectBeneficiery()
{  // determines which dependent must be made a beneficiary
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "selectBeneficiery:" + Project.Variables.tcNum);
   
   var foundEntry = NEGATIVE;
   if (!ifQ("dependentsQ")) return 0;
   
   var pvrow = getUnusedPVRow("personalInfo"); if (pvrow == NEGATIVE) { return foundEntry;}
   var makeBeneficieryCol = Project.Variables.personalInfo.ColumnCount - 1; // last column
   var dependentCount = Project.Variables.personalInfo.RowCount - 1;
   while (pvrow != NEGATIVE)
   {
      if (aqString.Find(Project.Variables.personalInfo(makeBeneficieryCol, pvrow), "y", 0, false) != NEGATIVE)
      {
         var pvcol = 1; 
         var fullName = aqString.Concat(Project.Variables.personalInfo(pvcol, pvrow), " "); pvcol++;
         fullName = aqString.Concat(fullName, Project.Variables.personalInfo(pvcol, pvrow)); pvcol++;
         fullName = aqString.ToUpper(fullName);
         
         var MDIConsulta = getMDIWindow(determineForm(), "Consulta");
         MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
         for (var dependentNum = 1; dependentNum <= dependentCount; dependentNum++)
         {
            MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Down]");
            var formUserName = MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
            if (aqString.Find(formUserName, fullName ) != -1) { return dependentNum;}
         }
        return POSITIVE;
      }
      var pvrow = getUnusedPVRow("personalInfo");
   }
   return foundEntry;
}

function beneficierySection()
{  if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "beneficiery:" + Project.Variables.tcNum); 
   var MDIConsulta = icon_Asegurados("Mantenimiento De Solicitudes"); 
   if (!MDIConsulta.Visible) { Log.Error("Not visible. " + MDIConsulta.FullName); return;} 
   
  //Check if we need to change the beneficiery?
  var rowidx = selectBeneficiery();
  if (rowidx == NEGATIVE) 
  { Log.Message("No dependent is selected as beneficiary."); /*return;*/}
  
  var MDIBeneficiarios = icon_ConsultarABeneficiario(rowidx);
  if ( MDIBeneficiarios == null && rowidx == POSITIVE ) // if (foundEntry)
  {
      // Esta seguro que desea convertir al dependeiente en beneficiario
      var popupMSG = MENSAJE_DE_ALERTA("Are you sure you want to convert to a beneficiery dependeiente", 0, "Si", 1);
      aqUtils.Delay(100); // to prevent race conditions for responding to the 2nd alert.
      // Proceso de conversion termino exitosamente. Desea grabar los resultados?
      var popupMSG = MENSAJE_DE_ALERTA("Conversion process finished successfully. To record the results?;", 2, "Si", 1);  
      // Datos Guardados 
      var popupMSG = MENSAJE_INFORMATIVO("Save Data", 0,"OK", 1);
      // closeMDIWindow(MDIConsulta, 1);
      return;
  }
  
  MDIBeneficiarios = icon_ConsultarABeneficiario(0);
  // non-dependent beneficiaries
   var rootWindow = MDIBeneficiarios.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3); 
   rootWindow.Window("ComboBox", "", 1).Button("Open").Click(); // Parentesco box
   selectFirstComboBoxItem(); // TODO did we read this from input?
   aqUtils.Delay(400);
   
   var pvrow = getUnusedPVRow("beneficieryInfo"); if (pvrow == NEGATIVE) { return;}
   var pvcol = 1; // first column is for rowflag   
   rootWindow.Window("ComboBox", "", 1).Click();
   rootWindow.Window("ComboBox", "", 1).Keys("![Tab]");
   
   //<I0002> Estefani Del Carmen 31/01/2013 Se agrego esta variable para que tomara en cuenta la relacion del beneficiario, segun lo introducido en el excel.
   var pvcol = 4;
   var relacion = Project.Variables.beneficieryInfo(pvcol, pvrow);
   //</I0002>
      
   pvcol--; // DOB
   rootWindow.Keys(Project.Variables.beneficieryInfo(pvcol, pvrow)); pvcol--;    
   rootWindow.Window("Edit", "", 1).Keys("![Tab]"); // backtrack
   rootWindow.Window("Edit", "", 1).Keys("![Tab]"); 
   rootWindow.Keys(Project.Variables.beneficieryInfo(pvcol, pvrow)); pvcol--;    
   rootWindow.Window("Edit", "", 1).Keys("![Tab]"); // backtrack
   rootWindow.Keys("![Tab]");
   rootWindow.Keys(Project.Variables.beneficieryInfo(pvcol, pvrow)); pvcol--;    
   rootWindow.Window("Edit", "", 1).Keys("![Tab]"); 
   rootWindow.Window("ComboBox", "", 1).Button("Open").Click();
  
   //<I0002> Estefani Del Carmen 31/01/2013 Se modifico para que abarque la lista completa de parentezcos.
   selectByClickitem(rootWindow.Window("ComboBox", "", 1),relacion, ""); 
   //</I0002?
   
   //selectComboBoxItem("Hijastra"); // TODO must read this from input? 
   saludecoreToolbar("Grabar"); //Save
   var popupMSG = MENSAJE_INFORMATIVO("beneficiery", 0, "OK", 0);
   closeMDIWindow(MDIBeneficiarios,1); //MDIConsulta.TitleBar(0).Button("Close").Click();
  // saludecoreToolbar("Salir");   
}


function approvePolicy()
{
    MDISolicitudes_PolicyNumber();
    var MDIConsulta = icon_Asegurados("Mantenimiento De Solicitudes"); 
    if (!MDIConsulta.Visible) 
    { Log.Error("Not visible. " + MDIConsulta.FullName); return;}
    
    var MDIEmisionDePolizas = MDIConsulta_icon_Generar(MDIConsulta) // Fileserver icon
    
    var HARDCODED_Value = 1; 
    if (!MDIEmisionDePolizas_selectCheckbox(HARDCODED_Value))
    { 
       if(!goToMain()) { Log.Message("TODO .... goToMain from approvePolicy");} 
       return;
    }
       
    var mdi = MDIEmisionDePolizas_icon_Generar(MDIEmisionDePolizas) // Fileserver icon
       // Potential Dialog: Requests must carry at least one intermediary (c / u).
       var popupMSG = MENSAJE_FORMS("solicitudes deben de llevar por lo menos un intermediario principal (c/u).", 2, "OK", 0); 
       // Desired dialog: emission process ended successfully 
       var popupMSG = MENSAJE_FORMS("Proceso de emision finalizo exitosamente", 2, "OK", 0);

    if(!goToMain()) { Log.Message("TODO .... in approvePolicy"); return;}
     /*
     MantenimientosMenu("Mantenimiento De Pólizas");
     var policynum = policyInfoFromPolizas("PolicyNum", Project.Variables.PolicyNum);
     if (policynum == "ERROR") 
    { 
       if(!goToMain()) { Log.Message("TODO .... in approvePolicy");} 
       return;
    }
     var tmpbool = validatePolicy(19, "PENDIENTE DE PAGO", "Estatus", true); // 19 for policy status
     /// validatePolicyStatus("PENDIENTE DE PAGO"); 
     validatePolicyVersion("Suspension");
     */
}

function openCloseBeneficiarios()
{
    if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "openCloseBeneficiarios, Consulta, Mantenimiento Beneficiarios"); 
    var MDIBeneficiarios = icon_ConsultarABeneficiario(true);
    if ( MDIBeneficiarios != null ) { closeMDIWindow(MDIBeneficiarios, 1); } 
}
 
function RAICheckbox(RAIbuttons, maxrows, row, value)
{  // Button Orders: realizado , ex/NA, Pendiante 
    var pos = aqString.Find(value, "y", 0, false);
    var idx = maxrows * ( 2 - pos) + row
    var button = RAIbuttons.Window("Button", " ", idx);
    if (!button.Enabled) { return -1;}
    if (pos != -1) { button.Click();}
    return row;
}
 
function test_RequisitosDeAfiliados()
{  RequisitosDeAfiliados( getMDIWindow(determineForm(), "Mantenimiento De"));}

function RequisitosDeAfiliados(MDIRequisitos)
{
    var maxrows = 6; //FIXED LIMIT for number of rows
    var rootwindow = MDIRequisitos.Window("ui60Drawn_W32", "", 1);
    var RAIbuttons = rootwindow.Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
	
    var row = maxrows; 
    var RAIvalue = "nyn";  //TODO....  
    while (row > 0)
    {  
        var tipo = rootwindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", row).wText;
        var regExp = / /g; if (tipo.replace(regExp,"") == "")
        { row = -1;}
        else
        { // Button Orders: realizado , ex/NA, Pendiante 
          var pos = aqString.Find(RAIvalue, "y", 0, false);
          var button = RAIbuttons.Window("Button", " ", maxrows * ( 2 - pos) + row);
          if (!button.Enabled) { row = -1;} else { if (pos != -1) { button.Click();}}
        }
        row--; 
    }
    MDIRequisitos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Pantalla Anterior").Click();
    // Expected dialog: Do you want to save changes?
    var tmp = handleADialog("Do you want to save changes?", "Forms", 0, "Yes", 0);
    // Expected dialog: Modifications have been recorded      
    var tmp = handleADialog("Modificaciones Han Sido Grabadas", "Forms", 2, "OK", 0);
    // var tmp = handleADialog("requestAdditionalInformation", "Forms", 0, "Yes", 0);
}


function RequisitosDeAfiliados2(MDIRequisitos)
{
    var maxrows = 6; //FIXED LIMIT for number of rows
    var rootwindow = MDIRequisitos.Window("ui60Drawn_W32", "", 1);
    var RAIbuttons = rootwindow.Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
	  
    //MDIRequisitos.TitleBar(0).Button("Maximize").Click();
    //Sys.Process("ifrun60").Form("Aplicacion de Seguros de Salud").Panel("Workspace").MDIWindow("Mantenimiento de Requisitos de Afiliados").TitleBar(0).Button("Maximize").Click();
    
    var row = maxrows; 
    var RAIvalue = "nyn";  //TODO....  
    while (row > 0)
    {          
        var tipo = rootwindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", row).wText;
        
        /*
        var regExp = / /g; if (tipo.replace(regExp,"") == "")
        { row = -1;}
        else
        { // Button Orders: realizado , ex/NA, Pendiante 
        */
          var pos = aqString.Find(RAIvalue, "y", 0, false);
          var button = RAIbuttons.Window("Button", " ", maxrows * ( 2 - pos) + row);
          if (!button.Enabled) { row = -1;} else { if (pos != -1) { button.Click();}}
        //}
        row--; 
    }
    MDIRequisitos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Pantalla Anterior").Click();
    // Expected dialog: Do you want to save changes?
    var tmp = handleADialog("Do you want to save changes?", "Forms", 0, "Yes", 0);
    // Expected dialog: Modifications have been recorded      
    var tmp = handleADialog("Modificaciones Han Sido Grabadas", "Forms", 2, "OK", 0);
    // var tmp = handleADialog("requestAdditionalInformation", "Forms", 0, "Yes", 0);
}

function requestAdditionalInformation()
{
    var maxrows = 6; //FIXED LIMIT for number of rows
    var MDIRequisitos = MDIConsulta_icon_Requisitos();
    if (!MDIRequisitos.Visible) { Log.Error("Not visible. " + MDIRequisitos.FullName); return;}
    
    var rootwindow = MDIRequisitos.Window("ui60Drawn_W32", "", 1);
    var RAIbuttons = rootwindow.Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
    
    var row = maxrows; 
    var RAIvalue = "nyn";  //TODO....  
    while (row > 0)
    {  // Button Orders: realizado , ex/NA, Pendiante 
       var pos = aqString.Find(value, "y", 0, false);
       var button = RAIbuttons.Window("Button", " ", maxrows * ( 2 - pos) + row);
       if (!button.Enabled) { row = -1;} else { if (pos != -1) { button.Click();}}
       row--; 
    }
       
    MDIRequisitos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Pantalla Anterior").Click();
    // Expected dialog: Do you want to save changes?
    var popupMSG = MENSAJE_FORMS("Do you want to save changes?", 0, "Yes", 0);
    // Expected dialog: Modifications have been recorded      
    var popupMSG = MENSAJE_FORMS("Modificaciones Han Sido Grabadas", 2, "OK", 0);
 }

 
// Mantenimiento Asegurado
function MDIAsegurado_icon_CoberturasDeVida()
// Used to be called icon_RequisitosDelAsegurado
{ // The Open book icon
   var MDIAsegurado = getMDIWindow(determineForm(),"Mantenimiento Asegurado");
   // MDIAsegurad.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ComboBox", "", 8).Button("Open").Click();
   MDIAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 8).Click();
   return  getMDIWindow(determineForm(),"Mantenimiento de"); // Mantenimiento de Requisitos de Afiliados
}

function setUnderwriter()
{
    var ifrun60 = Sys.FindChild("Name", "Process(\"ifrun60*)");
    if(!ifrun60.Exists) 
    { 
      Log.Error("Saludecore is not running. Application exited with error. Restarting Saludcore");
      return false; 
    }
    var MDIConsulta = getMDIWindow(determineForm(),"Consulta");
    MDIConsulta.Window("ui60Drawn_W32").Window("ui60Drawn_W32").DblClick(132, 100); // clicked on the primary applicant...

    var MDIAsegurado = getMDIWindow(determineForm(),"Mantenimiento Asegurado");
    // Click on Estatus field for "Aprobado Underwriter" 
    // MDIAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ComboBox", "", 7).ClickItem("Aprobado Underwriter"); //Button("Open").Click();
    selectByClickitem(MDIAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ComboBox", "", 7), "Aprobado Underwriter", "");
    // Potential Dialog: Can not update the status. Exite information pending   
    var popupMSG = MENSAJE_DE_ERROR("No Se Puede Actualizar el estatus. Exite information pendiente", 0, "OK", 0);
    if ( popupMSG != NEGATIVE)
    { Log.Error("requestAdditionalInformation has not worked."); 
    requestAdditionalInformation_MDIAsegurado();} // return false;}
   
    // status reason (a.k.a Motivo)
    MDIAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 25).Click();
    selectFirstGridItem("Lista de*");
    closeMDIWindow(MDIAsegurado, 1);
    var popupMSG = MENSAJE_FORMS("setUnderwriter", 0, "Yes", 1); 
    var popupMSG = MENSAJE_INFORMATIVO("setUnderwriter", 0, "OK", 1); 
    // Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
    return true;
 }

 function CompleteApplication()
 {
    var ifrun60 = Sys.FindChild("Name", "Process(\"ifrun60*)");
    if(!ifrun60.Exists) 
    { 
      Log.Error("Saludecore is not running. Application exited with error. Restarting Saludcore");
      return NEGATIVE; 
    }
    if (Project.Variables.requireAdditionalData != "n") 
    {
     RequisitosDeAfiliados(MDIConsulta_icon_Requisitos()); // requestAdditionalInformation();
    }
    if (!setUnderwriter()) { return false;}
    var MDISolicitudes = icon_PantalaAnterior(); // back track from Consulta to "Mantenimiento De Solicitudes"         
    approvePolicy();
    return true;
 }

function companiaParaDepositarElCheque(rootWindow)
{ // Company to deposit the check
    rootWindow.Window("ComboBox", "", 1).Keys("[Tab]"); // Estado
    // var formObject = determineForm();
    var companiaFields = getMDIWindow(determineForm(), "").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2); 
    // formObject.Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2);
    // Fields: Company which to deposit the check   and  description of the economic unit 
    companiaFields.Window("Edit", "", 1).Keys("[Tab]");
    companiaFields.Window("Edit", "", 1).Keys("1");
    companiaFields.Window("Edit", "", 1).Keys("[Tab]");
}
 
 function test_buscarPorPoliza()
 {
    // var formObject = determineForm();
    var rootWindow = getMDIWindow(determineForm(), "").Window("ui60Drawn_W32");
    // formObject.Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32");
   // var rootWindow2 = formObject.Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2)
   var num = 1; var policynum = "000001"; 
   buscarPorPoliza(rootWindow.Window("ui60Drawn_W32", "", num), policynum);
    companiaParaDepositarElCheque(rootWindow.Window("ui60Drawn_W32", "", 2));
}
 
function populatePV_NewBusiness(excelObject)
{ 
          var col = 2; // starting column on input spreadsheet. col=1 is for the execute flag.
          var colcount = populatePV_personalInfo(excelObject, col, true); 
          col = col + colcount;
   
          var colcount = populatePV_NewBusinessAddress(excelObject,col); 
          col = col + colcount;
          
          var colcount = populatePV_NewBusinessAdditionalAddress(excelObject,col); 
          col = col + colcount;
          
          var colcount = populatePV_telephone(excelObject,col);
          col = col + colcount;
          
          var colcount = populatePV_plan(excelObject,col);   
          col = col + colcount; 
          // addProjectVariable("insurance"+Project.Variables.tcNum , "string", excelObject.Value(col++)); 
          // addProjectVariable("plan"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          // addProjectVariable("contactMethod"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          // addProjectVariable("paymentMode"+Project.Variables.tcNum , "string", excelObject.Value(col++));
            
          populatePV_examenesMedicosQ(excelObject,col); col++; 
          // addProjectVariable("examenesMedicos"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          populatePV_condicionesMedicasQ(excelObject,col); col++; 
          // addProjectVariable("condicionesMedicas"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          populatePV_medicamentosQ(excelObject,col); col++; 
          // addProjectVariable("medicamentos"+ Project.Variables.tcNum , "string", excelObject.Value(col++));
          populatePV_habitosQ(excelObject,col); col++; 
          // addProjectVariable("habitos"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          populatePV_historialFamiliarQ(excelObject,col); col++;                     
          // addProjectVariable("historialFamiliar"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          populatePV_medicoFamiliaQ(excelObject,col); col++;                     
          // addProjectVariable("medioFamila"+Project.Variables.tcNum , "string", excelObject.Value(col++));
       
          populatePV_additionalMedicalQ(excelObject,col); col++;          
          // addProjectVariable("additionalMedical"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          
          var colcount = populatePV_beneficieryInfo(excelObject, col); 
          col = col + colcount;
          // addProjectVariable("beneficieryFirstName"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          // addProjectVariable("beneficieryLastName"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          // addProjectVariable("beneficieryDOB"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          
          Log.Message("Dependents "+excelObject.Value(col));
          populatePV_dependentsQ(excelObject,col); //col++;
          // addProjectVariable("dependents"+Project.Variables.tcNum , "string", excelObject.Value(col++));
          col++;
          addProjectVariable("submitPolicy", "string", excelObject.Value(col));
          Log.Message("submitPolicy "+excelObject.Value(col));
          
          col++;
          addProjectVariable("payPolicy", "string", excelObject.Value(col));
          Log.Message("payPolicy "+excelObject.Value(col));
          
}

function newBusinessTest()
{  
   addProjectVariable("requireAdditionalData", "string", "n");
   addProjectVariable("Asegurado", "Boolean", false);
   var excelObject = readNewBusinessData(); if (excelObject == null) { return NEGATIVE;}
   populatePV_NewBusiness(excelObject); closeExcelObject(excelObject);
   
   Log.Message("***** Starting New Business. Test Number: " + Project.Variables.tcNum); 
   if(!goToMain()) { Log.Message("TODO .... in newBusinessTest"); return POSITIVE;}
   MantenimientosMenu("Mantenimiento De Clientes");
   newBusiness();
   populateClientInfo(0); // primary applicant ...including the address and phone info
   
   var rel = Project.Variables.asegurado;
   
   if(rel != "False")
   {
      addDependents();
      
      if (completePlan() == NEGATIVE)
      { if(!goToMain()) { return POSITIVE;} else {return ZERO;}}
   
      Project.Variables.dependentsQ(0,0) = 0; // reset rowflag 
      Project.Variables.personalInfo(0,0) = 1; // reset rowflag to make dependents beneficiaries
   
      Log.Message("Submit " + Project.Variables.VariableByName("submitPolicy") );
      Log.Message("payPolicy " + Project.Variables.VariableByName("payPolicy") );
   
      if (Project.Variables.VariableByName("submitPolicy")!= "n")
      {
        beneficierySection();
   
        var MDIMedica = icon_informacionMedica();
        if (!MDIMedica.Visible) { Log.Error("Not visible. " + MDIMedica.FullName); return POSITIVE;}
        populateMedicalInfo(MDIMedica);
        medicalAdditional1();
     //calculateAge();
     
     if(!CompleteApplication())
     {
       return NEGATIVE;
     }
      }
      
      
      }
   if(!goToMain()) { Log.Message("TODO .... in newBusinessTest"); return POSITIVE;}
   return ZERO;
}

function addressValidationTests(test)
{
    if(!initTestEnvironment()){ return;}
    if(!logon()){ return;}
    if (seleccionarCompanias() == NEGATIVE) { return;}
    if (getTcNum(0) == NEGATIVE) return;
    var excelObject = readNewBusinessData(); if (excelObject == null) { return NEGATIVE;}
    populatePV_NewBusiness(excelObject); closeExcelObject(excelObject); //readNewBusinessData(Project.Variables.tcNum);
    if(!goToMain()) 
    { Log.Message("TODO1 .... in runAddressTests"); return;}
   MantenimientosMenu("Mantenimiento De Clientes");
   newBusiness();
   populatePersonalInfo(0);  // primary applicant
   var MDIDirecciones = MDICliente_icon_Dirrecion();
   populateAddressInfo();
   validateAddress(test);
   if(!goToMain()) 
   { Log.Message("TODO2 .... in runAddressTests"); return;}
   exitApplication();
}

function zipcodeValidationTest()   
{
   if(!goToMain()) { Log.Message("TODO .... in zipcodeValidationTest"); return;}
    MantenimientosMenu("Mantenimiento De Clientes");
    newBusiness();
    populatePersonalInfo(0);  // primary applicant 
    var MDIDirecciones = MDICliente_icon_Dirrecion();
    populateAddressInfo();     
   
    // Start the test...
    var excelObject = openPanamConfig("address");  
    //determine number of records in the address tab
    numRecords = determineAddressNumber();
    addProjectVariable("numRecords", "integer",numRecords);      
    
    var rootWindow = MDIDirecciones.Window("ui60Drawn_W32", "", 1); //.Window("ui60Drawn_W32", "", 3)
    
    //until the end of file is reached, test zipcodes in spreadsheet
    for (i = 1;i<= numRecords;i++) 
    {
        //get the data from the spreadsheet            
        col = 6
        addProjectVariable("excel_zipCode", "string", excelObject.Value(col++));
        addProjectVariable("excel_city", "string", excelObject.Value(col++));
        addProjectVariable("excel_pais" , "string", excelObject.Value(col++)); //this is labelled as Pais on the address dialog, which translates to "parent"
        addProjectVariable("excel_estado", "string", excelObject.Value(col++)); //estado means state
        
        //these four functions are in zipcodeUtilities
        selectZip_EditBox();  //in zipcodeUtilities - puts in new zipcod and saves to database
        selectCity_EditBox(); // gets the City from the app after new zip is entered
        selectEstado_EditBox(); // gets the state from the app after new zip entered
        selectPais_EditBox();  //gets country from the app after new zip is entered
        
        //compare the data from the app with the data in the spreadsheet, log message match or error dont match
               
        // aqString.Find(Project.Variables.excel_city, Project.Variables.form_city, 0, false);
 
        if (aqString.Find(Project.Variables.excel_city, Project.Variables.form_city, 0, false)> -1)
          Log.Message("Excel = " + Project.Variables.excel_city + " Saludcore = " + Project.Variables.form_city);
        else
          Log.Error("Records do not match, Saludcore = "+ Project.Variables.form_city + " Excel = " + Project.Variables.excel_city);
        //
        // aqString.Find(Project.Variables.excel_estado, Project.Variables.form_estado, 0, false);
 
        if (aqString.Find(Project.Variables.excel_estado, Project.Variables.form_estado, 0, false)> -1)
          Log.Message("Excel = " + Project.Variables.excel_estado + " Saludcore = " + Project.Variables.form_estado);
        else
          Log.Error("Records do not match, Saludcore = "+ Project.Variables.form_estado + " Excel = " + Project.Variables.excel_estado);
       
        // aqString.Find(Project.Variables.excel_pais, Project.Variables.form_pais, 0, false);
 
        if (aqString.Find(Project.Variables.excel_pais, Project.Variables.form_pais, 0, false)> -1)
          Log.Message("Excel = " + Project.Variables.excel_pais + " Saludcore = " + Project.Variables.form_pais);
        else
          Log.Error("Records do not match, Saludcore = "+ Project.Variables.form_pais + " Excel = " + Project.Variables.excel_pais);
        
        excelObject.Next(); 
   }
   
   DDT.CloseDriver(excelObject.Name); 
}

/// Exit Functions

function logout() { MenuPrincipal("Salir");}

function exitApplication() { if (goToMain()) logout();} 

function MDICliente_Exit()
{  
   MDICliente_RelacionDeDependiente(false); // Erase dependents to be able to exit. 
   exitApplication();
}

function MDIPolizas_Exit(quit)
{
   var mdi = getMDIWindow(determineForm(), MDI_Policy);
   mdi.TitleBar(0).Button("Close").ClickButton(); 
   if (quit) exitApplication();
}

function MDIDirecciones_Exit()
{
   var MDIDirecciones = getMDIWindow(determineForm(),"Mantenimiento de Direcciones");
   MDIDirecciones.TitleBar(0).Button("Close").ClickButton();
   // Potential dialog: field value can not be null
   var popupMSG = MENSAJE_DE_ERROR("valor del campo no puede ser nulo", 0, "OK", 0);
   var popupMSG = MENSAJE_FORMS("Close this form?", 0, "Yes", 0);
   var tmp = goToMain();
}





/// Test Stubs

function getEditText(obj)
{
   var edit = obj.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1);
   var text = aqConvert.VarToStr(edit.Value);
   Log.Message("Text=" + text + " Left=" + IntTostr(edit.Left) + " Top=" + IntTostr(edit.Top) + 
    " OI=" + edit.ObjectIdentifier + " Id=" + edit.Id + " Idx=" + edit.Index + " Hndl=" + edit.Handle);
   return text; 
}

function clickTab(obj, FWorBK)
{
   var panel = obj.Window("ui60Drawn_W32", "", 3);
   var edit = panel.Window("Edit", "", 1);
   if (FWorBK) { edit.Keys("[Tab]");} else { edit.Keys("![Tab]");}
}

function navigateByTabing(MDIname, tabcount, FWorBK)
{
   var mdi = getMDIWindow(determineForm(), MDIname);
   var obj = mdi.Window("ui60Drawn_W32", "", 1);
   for (var tabcnt = 0; tabcnt < tabcount; tabcnt++)
   {  var text = getEditText(obj); clickTab(obj, FWorBK);}
}

function clickOnEdit(editobj)
{
   var top = editobj.Top + Math.round(editobj.Height / 2); 
   var left = editobj.Left + Math.round(editobj.Width / 2);
   editobj.Click(left,top);
}


function Test2()
{
  Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Crear Afiliado").TitleBar(0).Button("Close").ClickButton();
}

function Test1()
{
  var ifrun60;
  var form;
  var MDIWindow;
  var button;
  var menuItem;
  var panel;
  ifrun60 = Sys.Process("ifrun60");
  form = ifrun60.Form("Saludcore");
  MDIWindow = form.Panel("Workspace").MDIWindow("Forma Generadora de Reportes Excel");
  button = MDIWindow.TitleBar(0).Button("Close");
  button.ClickButton();
  button.ClickButton();
  menuItem = form.MenuBar("Application").MenuItem("Action");
  menuItem.Click();
  panel = MDIWindow.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3);
  panel.Click(389, 36);
  panel.Drag(316, 37, 343, 2);
  panel.Click(286, 18);
  menuItem.Click();
  ifrun60.Popup("Action").MenuItem("Exit").Click();
  Sys.Process("Explorer").Window("Shell_TrayWnd").Window("ReBarWindow32").Panel("Running Applications").ToolBar("Running Applications").Button("TestComplete - D:\\Saludecore_TestComplete\\Pan_American_May24\\Pan_American.pjs").ClickButton();
}