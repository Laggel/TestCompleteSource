//USEUNIT utilities

/// Script File: excelUtilities
/// Last update: May 8


function closeExcelObject(excelObject) {DDT.CloseDriver(excelObject.Name);}
function projectSpreadsheets()
{
   //var localpath = aqFileSystem.GetFolderInfo("..").ParentFolder.Path + "Spreadsheets";
   var localpath = aqFileSystem.GetFolderInfo("..").Path + "\\Spreadsheets";
   
   if (Project.Variables.VariableExists("path")) 
   { if (fuzzyCompare(Project.Variables.path, "") != NEGATIVE) addProjectVariable("path", "string", localpath);}
   else {addProjectVariable("path", "string", localpath);}
   
   return  Project.Variables.path;
}

function projectStores(file)
{
   var path = aqFileSystem.GetFolderInfo("..").Path + "\\Pan_American\\Stores\\Files\\" + file;
   return  path;
}

function openPanamConfig(tab)
{  
   var fileName = projectSpreadsheets() + "\\02_Suscripcion.xls";
   //var fileName = projectSpreadsheets() + "\\pan_american_config.xls"; 
   Log.Message("1- Abre el archivo: "+fileName);
   
   return DDT.ExcelDriver(fileName, tab);
}

function openMainMenuConfig(tab)
{  
   //var fileName = projectSpreadsheets() + "\\main_menu_config.xls"; 
   //var fileName = Files.FileNameByName("main_menu_config.xls");
   var fileName = projectStores("main_menu_config.xls");
   return DDT.ExcelDriver(fileName, tab);
}

function openPanamClaims(tab)
{  
   var fileName = projectSpreadsheets() + "\\03_Claims.xls"; 
   return DDT.ExcelDriver(fileName, tab);
}
   
function openPanamValidation(tab)
{  
   var fileName = projectSpreadsheets() + "\\pan_american_validation.xls";
   return DDT.ExcelDriver(fileName, tab);
}

function readMainMenuData()//(firstColumn, treeItem, itemNumber)
{
    var startCol = 0; //FIXED LIMIT for number of rows
    var myfields = new Array("Nombre", "PrimerClic", "SegundoClic");
    var pvname = "mainMenuInfo"; 
    
    var rowcount = 0;
    
    addProjectVariableTable(pvname, myfields);
    var excelObject = openMainMenuConfig("main_menu_config");
    
    while ((!excelObject.EOF()))  
    {
          var colCount = populatePVMainMenu(excelObject,startCol, myfields.length, pvname); 
          rowcount++;
          excelObject.Next();
    }
    
    DDT.CloseDriver(excelObject.Name);
}

function readSaludcoreConfig()
{
   //fileName = Files.FileNameByName("saludcore_config_xls");
   fileName = projectSpreadsheets() + "\\01_Ambiente.xlsm";
   excelObject = DDT.ExcelDriver(fileName, "credentials", true);
   
   while  (! excelObject.EOF())
   {
      col = 0;
      addProjectVariable("username", "string", excelObject.Value(col++)); 
      addProjectVariable("password", "string", excelObject.Value(col++)); 
      addProjectVariable("path", "string", excelObject.Value(col++));
      addProjectVariable("saludcoreExecutable", "string", excelObject.Value(col++));
      addProjectVariable("countryCode", "string", excelObject.Value(col++));
      addProjectVariable("ambiente", "string", excelObject.Value(col++));
      addProjectVariable("polizas", "string", excelObject.Value(col++));
      addProjectVariable("pais", "string", excelObject.Value(col++));
      excelObject.Next();
   }
   DDT.CloseDriver(excelObject.Name);
   Log.Message("Running Tests on " + Project.Variables.saludcoreExecutable + " for Country Code " +  Project.Variables.countryCode);
   Log.Message("Config file: " + Project.Variables.path);
}

function determineNumberOfClaimDataRows(tab,tcNumber)
{
   var excelObject = openPanamClaims(tab);
   var count = 0; 
      
   while (! excelObject.EOF())
   {
       testcaseNumber = excelObject.Value(0);
        if   (testcaseNumber == tcNumber) {count++;}
        excelObject.Next();
   }
   DDT.CloseDriver(excelObject.Name);
   return count; 
}

function readRateTable(age, deductible, region, product, rateCycle)
{
    var fileName, excelObject, rateTableRegion, rateTableProduct, rateTableDeductible, rateTableAge, value;
     
    region = aqString.ToUpper(region);
    product = aqString.ToUpper(product);
    commaPosition = aqString.Find(deductible, ","); 
    if (commaPosition > 0) 
        deductible = aqString.Concat(aqString.SubString(deductible, 0, commaPosition), aqString.SubString(deductible, commaPosition + 1, aqString.GetLength(deductible))); 
    
    fileName = projectSpreadsheets() + "\\Rate_Table_all_modes_v20110310_xls.xls";
    excelObject = DDT.ExcelDriver(fileName, "Rate Table");
    
    while  (! excelObject.EOF())
    {
          
         rateTableRegion = excelObject.Value(0);
         rateTableProduct = excelObject.Value(1);
         rateTableDeductible = excelObject.Value(2);
         rateTableAge = excelObject.Value(3);
         //strip quotes
         rateTableAge = aqString.Unquote(rateTableAge);
         if (  (rateTableRegion == null) ||  (rateTableProduct == null) || (rateTableDeductible == null) || (rateTableAge == null))
            excelObject.Next(); 
         else
         if ((aqString.Find(rateTableRegion, region) < 0) || (aqString.Find(rateTableProduct, product) < 0) ||   
           (aqString.Find(rateTableDeductible, deductible) < 0) ||  (rateTableAge != age))
            excelObject.Next();  
         else
         {    
           switch (rateCycle)
           {
             case "Anual": value = excelObject.Value(4); break;
             case "Semestral": value = excelObject.Value(5); break;
             case "Trimestral": value = excelObject.Value(6); break;
             case "Mensual": value = excelObject.Value(7); break;
             default: Log.Error("Invalid rate cycle: " +  rateCycle);
           }
           break;
       }
    }
    DDT.CloseDriver(excelObject.Name);
    return value;   
}

function readNewBusinessData() 
{
    var file = "newBusiness";
    if (Project.Variables.Automatic == "SI")
    {
      file = "Automatic";
    }
    var excelObject = openPanamConfig(file);
    
    var row = 0;     
    while  ((! excelObject.EOF()) && ( row == 0) )
    { 
      var col = 0;
      var testcaseNumber = excelObject.Value(col++);
      var prueba = Project.Variables.tcNum;
      if (testcaseNumber == Project.Variables.tcNum)
      { 
         var ExecuteNewBusiness = excelObject.Value(col++);
         //if (aqString.Compare(ExecuteNewBusiness, "Y", false) == 0)
         return excelObject;
      }
      excelObject.Next();
    }
    DDT.CloseDriver(excelObject.Name);
    return null;   
}

function readMedicalConfig(tab, startCol, columnCount, pvname, maxrows)
{
    var rowcount = 0; var excelObject = openPanamConfig(tab);
    while ((!excelObject.EOF()) && (rowcount < maxrows))  
    {
        testcaseNumber = excelObject.Value(0); 
        // var questionLetter = excelObject.Value(1);
        if ((rowcount > 0) && (testcaseNumber !=  Project.Variables.tcNum)) 
        {  break;  // exit the while loop 
        }
        if (testcaseNumber ==  Project.Variables.tcNum)
        //  && (( question == "NA") || (aqString.Find(questionLetter, question) != NEGATIVE)))
        { var colCount = populatePV(excelObject,startCol, columnCount, pvname); rowcount++;}
        excelObject.Next();
    }
    DDT.CloseDriver(excelObject.Name); 
    return rowcount;        
}


function determineDependentNumber()
{
    var excelObject = openPanamConfig("dependents");
    var count = 0;
    while (! excelObject.EOF())
    {
       testcaseNumber = excelObject.Value(0);
       if (testcaseNumber == Project.Variables.tcNum) count++;
       excelObject.Next(); 
    }
   DDT.CloseDriver(excelObject.Name);
   return count; 
}

function readDependents()
{
    var excelObject = openPanamConfig("dependents");
    var breakout = false;
    var rows = 0;
    while (! excelObject.EOF())
    {
       testcaseNumber = excelObject.Value(0);
       if (testcaseNumber == Project.Variables.tcNum) { populatePV_personalInfo(excelObject, 1, false); rows++;}
       if ((testcaseNumber != Project.Variables.tcNum) && (rows > 0)) break;  // end of pertinent rows
       excelObject.Next();
    } 
   DDT.CloseDriver(excelObject.Name);
}

function determineAddressNumber()
{
   var excelObject = openPanamConfig("address");
   var count = 0;
   while (! excelObject.EOF())
   {
        var testcaseNumber = excelObject.Value(0);
        if (testcaseNumber ==  Project.Variables.tcNum) count++;
        excelObject.Next();
   }
   DDT.CloseDriver(excelObject.Name);
   return count; 
}

function  addProjectVariableTable(pvname, columnnames)
{
   if (Project.Variables.VariableExists(pvname)){ Project.Variables.RemoveVariable(pvname);}
   Project.Variables.AddVariable(pvname, "table");
   for (var i=0; i < columnnames.length; i++)
   {Project.Variables.VariableByName(pvname).AddColumn(columnnames[i]);}
   return Project.Variables.VariableByName(pvname).ColumnCount;
}

function addProjectVariableRow(pvname)
{ // Add a new row and initialize it with values from arrayofvalues.
   var rowcount = Project.Variables.VariableByName(pvname).RowCount;
   Project.Variables.VariableByName(pvname).RowCount = rowcount + 1; 
   return rowcount;     
}

function logProjectVariableTable(pvname, pvrow)
{ 
   if (!Project.Variables.VariableExists(pvname))
   { Log.Message("Project Variable not found. " + pvname);return NEGATIVE;} 
   
   var colcount = Project.Variables.VariableByName(pvname).ColumnCount;
   var str = pvname;
   for (var c=0; c < colcount; c++)
   { str = str + "|" + Project.Variables.VariableByName(pvname).ColumnName(c);}
   Log.Message("Input Data Columns:" + str);
      
   var rowcount = Project.Variables.VariableByName(pvname).RowCount;  
   if (rowcount == 0) { Log.Message("No data columns. Project variable: " + pvname); return rowcount;}
   
   if (pvrow == -1) { var startrow = 0;} else { var startrow = pvrow; rowcount = pvrow + 1;}
   for (var r=startrow ; r < rowcount; r++)
   {  var str = ""; for (var c=0; c < colcount; c++)
      { str = str + ";" + Project.Variables.VariableByName(pvname)(c,r);}
      Log.Message("Input Data Row:" + IntToStr(r) + ":" + str);
   }
   return rowcount;     
}

function checkPV (pvname, pvrow)
{
   var result = (pvrow < Project.Variables.personalInfo.RowCount);
   if (result) 
      logProjectVariableTable(pvname, pvrow);
   else
      Log.Error("No data for row: " + pvrow + " PV:" + pvname); 
   return result;
}
    
////////// *****  Functions to store  Input Data into memory (i.e. project variables)


function populatePV(excelObject,startCol, columnCount, pvname)
{
   var pvrow = addProjectVariableRow(pvname);
   var colCount = Project.Variables.VariableByName(pvname).ColumnCount;
   if (colCount > columnCount) { colCount = columnCount;}
   // first column is reserved for rowflag; rowflag = row number.
   // rowflag on the first row indicates the next available row. rowflag = -row number if the data have been used to populate test objects
   Project.Variables.VariableByName(pvname)(0,pvrow) = pvrow;
   for (var pvcol = 1; pvcol < colCount; pvcol++)
   { 
     var valor = excelObject.Value(startCol + pvcol - 1);
     
     if (pvname == "personalInfo" && pvcol == 4 && valor != null)
     {
        valor = "TC "+valor;
        var pos = aqString.Find(valor, "ofac", 0, false);
        if (pos > 0)
          valor = aqString.SubString(valor, pos+5, 200);
     }
         
     Log.Message(pvname+" ("+pvcol+","+pvrow + ") Valor: " + valor);
     
     Project.Variables.VariableByName(pvname)(pvcol, pvrow) = valor;
     if (Project.Variables.VariableByName(pvname)(pvcol, pvrow) == null)
      { 
        Log.Message("Blank");
        Project.Variables.VariableByName(pvname)(pvcol, pvrow) = " ";
      }
   }
   //logProjectVariableTable(pvname);
   return colCount                         
} 

function populatePVMainMenu(excelObject,startCol, columnCount, pvname)
{
   var pvrow = addProjectVariableRow(pvname, "", false);
   var colCount = Project.Variables.VariableByName(pvname).ColumnCount;
   if (colCount > columnCount) {colCount = columnCount;}
   for (var pvcol = 0; pvcol < colCount; pvcol++)
   { 
   var valorExcel = excelObject.Value(startCol + pvcol);
   valorExcel = aqString.Trim(valorExcel, aqString.stAll);
   Project.Variables.VariableByName(pvname)(pvcol, pvrow) = valorExcel;
   }
   logProjectVariableTable(pvname);
   return colCount                         
}

function populatePV_personalInfo(excelObject, startCol, primaryApplicant)
{
   var myfields = new Array("rowflag","relation", "firstName", "secondname", "lastName","secondlastname", "DOB", "Sex", 
                            "Parentesco", "MaritalStatus", 
                            "weightAmount", "weightType", "heightunit1", "heightunit2", "HeightType", "Sports", "makeBeneficiery");
   var pvname = "personalInfo"; 
   // var columnCount = addProjectVariableTable(pvname, myfields);
   if (primaryApplicant) 
   { var columnCount = addProjectVariableTable(pvname, myfields) - 1;}
   else
   { var columnCount = Project.Variables.personalInfo.ColumnCount;}
   
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   
   var pvrow = Project.Variables.personalInfo.RowCount - 1; var pvcol = 5; // DOB
   Project.Variables.personalInfo(pvcol, pvrow) = aqString.Unquote(Project.Variables.personalInfo(pvcol, pvrow));
   if (primaryApplicant) { Project.Variables.personalInfo(columnCount, pvrow) = "n"; } 
   return columnCount - 1;                 
}

function populatePV_NewBusinessAddress(excelObject, startCol)
{
   var myfields = new Array("rowflag", "homeAddress", "numero", "edificio", "apartNo", "tipoDirreccion", 
                            "zipCode", "city", "paperless", "language");
   var pvname = "addressInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);
   
   // var TODO_missingFieldCnt = 1; var TODO_missingField = "ESPAÑOL"; // "INGLES"; 
     
   // var colCount = populatePV(excelObject,startCol, columnCount - TODO_missingFieldCnt, pvname);
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   
   var rows = Project.Variables.VariableByName(pvname).RowCount;
   
   //Actualiza las ciudades cuando las dejan vacias (-1)
   for (var i = 0; i < rows; i++)
   {
      var ciudad = Project.Variables.VariableByName(pvname)(7,i);
      
      if (ciudad == "N/A")
        Project.Variables.VariableByName(pvname)(7,i) = Project.Variables.pais;
   }
   
   if ( colCount < Project.Variables.addressInfo.ColumnCount)
   { 
     var pvrow = Project.Variables.addressInfo.RowCount - 1;
      Project.Variables.addressInfo(colCount, pvrow) = TODO_missingField; // colCount++; 
   }
   return Project.Variables.addressInfo.ColumnCount - 1;                  
} 
 
function populatePV_NewBusinessAdditionalAddress(excelObject, startCol)
{
   var myfields = new Array("rowflag", "additionalAddresses", "Country", "Mailing address", 
                            "EffectiveDate");
   var pvname = "additionalAddressInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);  
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   return Project.Variables.additionalAddressInfo.ColumnCount - 1;                  
}

function populatePV_telephone(excelObject, startCol)
{
   var myfields = new Array("rowflag", "telephone","description");
   var pvname = "telephoneInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);  
   var colCount = populatePV(excelObject,startCol, columnCount, pvname); 
   return Project.Variables.telephoneInfo.ColumnCount - 1;                 
}

function populatePV_addressInfo(excelObject, startCol)
{
   var myfields = new Array("rowflag", "homeAddress", "numero", "edificio", "apartNo", "tipoDirreccion", 
                            "zipCode", "city", "pais", "estado", "paperless", "language");
   var pvname = "addressInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);
   var columnCount = Project.Variables.VariableByName(pvname).ColumnCount;
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   return Project.Variables.addressInfo.ColumnCount - 1;                 
}

function populatePV_beneficieryInfo(excelObject, startCol)
{
//<I0002> Estefani Del Carmen 31/1/2013 Se agrego el nuevo parametro para que considere la nueva columna de relacion del beneficiario.
   var myfields = new Array("rowflag", "firstName", "lastName", "DOB", "relationbeneficiery");
//</I0002>
   var pvname = "beneficieryInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   var pvrow = Project.Variables.personalInfo.RowCount - 1; var pvcol = 3; // DOB
   Project.Variables.personalInfo(pvcol, pvrow) = aqString.Unquote(Project.Variables.personalInfo(pvcol, pvrow));
   return columnCount - 1;                 
}
  
function populatePV_dependentsQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "Dependents");
   var pvname = "dependentsQ";
   var columnCount = addProjectVariableTable(pvname, myfields);
   return populatePV(excelObject,startCol, columnCount, pvname);
}
  
function populatePV_plan(excelObject, startCol)
{
   var myfields = new Array("rowflag", "insurance", "plan", "ContactMeans", "PaymentMode","EfectiveDate");
   var pvname = "planInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   return columnCount - 1;
}

function populatePV_paymentInfo(excelObject)
{
   var myfields = new Array("rowflag", "FormaDeCobro", "EconomicUnits", "Doc", "Bank", "PorDistribuir", "MontoACobrar");
   ////// Sample data: ..................."CHEQ",         "1",           "99", "1"
   var pvname = "paymentInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);  
   var startCol = 1; var colCount = populatePV(excelObject,startCol, columnCount, pvname);
   return columnCount - 1;
}

////////// *****  Functions for Reading Input Data 
function readAddressData(instance)
{   // Allow for multiple address instances. Retrieve one instance at a time. 
    var excelObject = openPanamConfig("address");
    var foundCount = 0;
    while (! excelObject.EOF())
    {
       testcaseNumber = excelObject.Value(0);
       if (testcaseNumber ==  Project.Variables.tcNum)
       { foundCount++; if (foundCount == instance) { populatePV_addressInfo(excelObject, 2); break;}}
       excelObject.Next();
    }
   DDT.CloseDriver(excelObject.Name);
}

function readPaymentValidation(tab, instance, code)
{
    var excelObject = openPanamValidation(tab);
    while (! excelObject.EOF())  
    {
       testcaseNumber = excelObject.Value(0);
       codeValue = excelObject.Value(1);
       instanceNumber = excelObject.Value(2);
       if  ((testcaseNumber !=  Project.Variables.tcNum) || (instanceNumber !=  instance) || aqString.Find(codeValue, code) < 0)
          excelObject.Next();
       else
       {  var col = 2;
          addProjectVariable("paymentCode", "string", codeValue);
          var value = aqString.Unquote(excelObject.Value(col++)); addProjectVariable("valueAmount", "string", value);
          var value = aqString.Unquote(excelObject.Value(col++)); addProjectVariable("paymentAmount", "string", value); 
          var value = aqString.Unquote(excelObject.Value(col++)); addProjectVariable("input_policyBalance", "string", value);
          break;
       }
    }
    DDT.CloseDriver(excelObject.Name);  
}

function readPaymentCobros()
{
    var excelObject = openPanamConfig("Payment");
    var rows = 0;
    while (! excelObject.EOF())
    {
       testcaseNumber = excelObject.Value(0);
       if (testcaseNumber == Project.Variables.tcNum) { populatePV_paymentInfo(excelObject); rows++;}
       if ((testcaseNumber != Project.Variables.tcNum) && (rows > 0)) break;  // end of pertinent rows
       excelObject.Next();
    } 
   DDT.CloseDriver(excelObject.Name);
}

function readClaim()
{
   var excelObject = openPanamClaims("claim");
   var count = 0;
   while (! excelObject.EOF())
   {
       testcaseNumber = excelObject.Value(0);
        if   (testcaseNumber != Project.Variables.tcNum) {excelObject.Next();}
        else
        {
           col = 1;
           addProjectVariable("executeClaim", "string", excelObject.Value(col++));
//           addProjectVariable("plan", "string", excelObject.Value(col++));  
           
           // dilip: 09/05/2012
           addProjectVariable("poliza","string", excelObject.Value(col++));
           addProjectVariable("asegurado","string", excelObject.Value(col++));
           //
           
           addProjectVariable("tipoCoberturaFlag", "string", excelObject.Value(col++));
           addProjectVariable("fechaServico", "string", excelObject.Value(col++));
           
           // dilip: 09/05/2012
           addProjectVariable("modoDeCaptura","string", excelObject.Value(col++));
           //
           
           addProjectVariable("tipoReclamante", "string", excelObject.Value(col++));
           
           //dilip: 09/05/2012
           addProjectVariable("afiliadoMedicos","string", excelObject.Value(col++));
           addProjectVariable("categoriasMedicos","string", excelObject.Value(col++));
           addProjectVariable("repricingNetwork","string", excelObject.Value(col++));
           //
           
           addProjectVariable("formaDePago", "string", excelObject.Value(col++));
           
           // dilip: 09/05/2012
           addProjectVariable("facturaNumber","string", excelObject.Value(col++));
           //
           
           addProjectVariable("tipoServicio", "string", excelObject.Value(col++));
           
           // dilip: 09/05/2012
           addProjectVariable("tipoInsalacion", "string", excelObject.Value(col++));
           addProjectVariable("afiliadosMedicosInsta","string", excelObject.Value(col++));
           //
           
           addProjectVariable("listaDeTipo", "string", excelObject.Value(col++));
           addProjectVariable("diagnosticCodeFlag", "string", excelObject.Value(col++));
          // addProjectVariable("listaDeCoberturas", "string", excelObject.Value(10));
          // addProjectVariable("descripicionDeServicio", "string", excelObject.Value(11));
          // addProjectVariable("claimAmount", "string", excelObject.Value(12));
           addProjectVariable("qualityCode", "string", excelObject.Value(col++));  
           addProjectVariable("examineService", "string", excelObject.Value(col++));
           addProjectVariable("expectedEstatus", "string", excelObject.Value(col++));   
           addProjectVariable("expectedRazon", "string", excelObject.Value(col++)); 
           addProjectVariable("expectedRazonAfterProcessing", "string", excelObject.Value(col++));
           addProjectVariable("expectedMontoAPagar", "string", excelObject.Value(15)); 
           addProjectVariable("gruposCoberturar", "string", excelObject.Value(col++));    
           addProjectVariable("cerrarParaPago", "string", excelObject.Value(col++));       
           break;
        }
    }
   DDT.CloseDriver(excelObject.Name);
}

function readServiceClaim()
{
   var excelObject = openPanamClaims("servicePlan");
   var count = 0
   while (! excelObject.EOF())
   {
       testcaseNumber = excelObject.Value(0);
        if   (testcaseNumber != Project.Variables.tcNum) {excelObject.Next();}
        else
        {
           addProjectVariable("servicePlan", "string", excelObject.Value(1));  
 //          addProjectVariable("tipo", "string", excelObject.Value(2));
 //          addProjectVariable("tipoReclamante", "string", excelObject.Value(3));
           break;
        }
    }
   DDT.CloseDriver(excelObject.Name);
}

function readQualityControl()
{
   var excelObject = openPanamClaims("quality");
   while (! excelObject.EOF())
   {
      testcaseNumber = excelObject.Value(0);
      if   (testcaseNumber != Project.Variables.tcNum) {excelObject.Next();}
      else
      {
        addProjectVariable("estatus", "string", excelObject.Value(1));  
        addProjectVariable("reasonEstatus", "string", excelObject.Value(2));
        break;
      }
    }
    DDT.CloseDriver(excelObject.Name);
}

function readDiagnosticCode(instance)
{
   var excelObject = openPanamClaims("diagnostics");
   var count = 0;    
   while (! excelObject.EOF())
   {
       testcaseNumber = excelObject.Value(0);
        if (testcaseNumber != Project.Variables.tcNum) {excelObject.Next();}
        else
        {  count++;
           if (count != instance) {excelObject.Next();} 
           else
           {
              value = aqString.Unquote(excelObject.Value(1));
              addProjectVariable("diagnosticCode" , "string", value);
              break;
           }
        }
    }
   DDT.CloseDriver(excelObject.Name); 
}

function readTipoCorberturaCode(instance)
{
    var fileName, excelObject, breakOUT, count;
         
    //fileName = Files.FileNameByName("pan_american_claims_xls");
//    fileName = projectSpreadsheets() + "\\pan_american_claims_Test.xls";
//    excelObject = DDT.ExcelDriver(fileName, "TipoCobertura");
    excelObject = openPanamClaims("TipoCobertura"); 
    breakout = false;
    count = 0;
    
    while (! excelObject.EOF())
    {
       testcaseNumber = excelObject.Value(0);
        if   (testcaseNumber != Project.Variables.tcNum)
          excelObject.Next();
        else
        {
           count++
           if (count != instance)
             excelObject.Next();
           else
           {
              value = aqString.Unquote(excelObject.Value(1));
              addProjectVariable("tipo" , "string", value);
              
              var x = excelObject.Value(2);
              var y = excelObject.Value(3);
              
              addProjectVariable("coberturarDeSaludFlag" , "string", excelObject.Value(2));
              addProjectVariable("coberturarDeSaludTest" , "string", excelObject.Value(3));
              break;
           }
        }
    }
      
   DDT.CloseDriver(excelObject.Name); 
   
}

function readCoberturarDeSaludCode(instance)
{
    var fileName, excelObject, breakOUT, count;
     
    //fileName = Files.FileNameByName("pan_american_claims_xls");
//    fileName = projectSpreadsheets() + "\\pan_american_claims.xls";
//    excelObject = DDT.ExcelDriver(fileName, "coberturasDeSalud");
    excelObject = openPanamClaims("coberturasDeSalud");
    breakout = false;
    count = 0;
    
    while (! excelObject.EOF())
    {
       testcaseNumber = excelObject.Value(0);
        if   (testcaseNumber != Project.Variables.coberturarDeSaludTest)
          excelObject.Next();
        else
        {
           count++
           if (count != instance)
             excelObject.Next();
           else
           {
              //value = aqString.Unquote(excelObject.Value(1));
              addProjectVariable("lugarDeServicio", "string", aqString.Unquote(excelObject.Value(1)));
              addProjectVariable("tipoProc", "string", excelObject.Value(2));
              addProjectVariable("listaDeCoberturas", "string", aqString.Unquote(excelObject.Value(3)));
              
              addProjectVariable("descripicionDeServicio", "string", excelObject.Value(4));
              addProjectVariable("tipoRecl", "string", excelObject.Value(5)); 
              addProjectVariable("reclamante", "string", excelObject.Value(6)); 
              addProjectVariable("frec", "string", excelObject.Value(7)); 
              addProjectVariable("claimAmount", "string", excelObject.Value(8));
              addProjectVariable("negociacion", "string", excelObject.Value(9));
              addProjectVariable("negociacionType", "string", excelObject.Value(10));
              
              addProjectVariable("descuento", "string", excelObject.Value(11));
              addProjectVariable("descuentoType", "string", excelObject.Value(12));
               
              addProjectVariable("montoGlosa", "string", excelObject.Value(13)); 
              addProjectVariable("montoElegible", "string", excelObject.Value(14));
              addProjectVariable("expectedMontoAPagar", "string", excelObject.Value(15));
              addProjectVariable("valores","string",excelObject.Value(16)); 
              break;
           }
        }
    }
      
   DDT.CloseDriver(excelObject.Name); 
   
}

function readTestList() 
{
   var myfields = new Array("rowflag", "Test", "Execute", "TestType");
   var pvname = "TestList"; 
   var columnCount = addProjectVariableTable(pvname, myfields);
   var excelObject = openPanamConfig("TestList");
   while  (! excelObject.EOF())
   {  var col = 0;
      var testcaseNumber = excelObject.Value(col++);
      if ((Project.Variables.tcNum == "") || (testcaseNumber == Project.Variables.tcNum))
      { 
         var execute = excelObject.Value(col++);
         if (execute == null)
          break;
         
         if (aqString.Compare(execute, "Y", false) == 0)
            var colCount = populatePV(excelObject,0, columnCount, pvname);
         if (Project.Variables.tcNum != "") break; // exit the reading loop
      }
      excelObject.Next();
    }
    DDT.CloseDriver(excelObject.Name);
    return Project.Variables.TestList.RowCount;  
}

function test_path()
{ var localpath = aqFileSystem.GetFolderInfo("..").ParentFolder.Path + "Spreadsheets"; Log.Message(localpath);}