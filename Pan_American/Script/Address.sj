//USEUNIT excelUtilities                                                                                                                                                                                                                             
//USEUNIT utilities

/// Script file: Address 
/// Last update: May 8   
function MDIDirecciones_clickByCoordinates(rootWindow, name)
{  /// USES FIXED COORDINATES  
   switch (name)
   { 
      case "city": { var x = 156; var y = 251;} break;
      case "estado": { var x = 445; var y = 248;} break;
      case "pais": { var x = 463; var y = 285;} break;
      case "zipcode": { var x = 457; var y = 170;} break;
   }
   rootWindow.Click(x, y);
}
function validateAddressFields(rootWindow, name, value)
{  
   MDIDirecciones_clickByCoordinates(rootWindow, name);
   var text = rootWindow.Window("Edit", "", 1).Text;
   // Project.Variables.stringResult = Project.Variables.stringResult + ";" + text;
   var result = fuzzyCompare(value, text); 
   if (result != ZERO )
      Log.Error("Address Mismatch. " + name + ": " + text + "     Expected:" + value);
   return result;
}

function MDIDirecciones_selectCity(rootWindow, value)
{
   rootWindow.Window("ui60Viewcore_W32", "", 4).Click(); // City viewer
//   if((aqString.Compare(value,"coronel",false)) == 0)
//   {
    var tmp = selectGriditemByNameWithDownCount("CIUDADES / MUNICIPIOS", 1, value); 
//   }
//   else
//   {
//   var tmp = selectGriditemByName("CIUDADES / MUNICIPIOS", 1, value);
//   }
   rootWindow.Window("Edit", "", 1).Keys("![Tab]"); // tab back to Ciudad
   var addressinfo = rootWindow.Window("Edit", "", 1).Text;
   if ( validateAddressFields(rootWindow, "city", value) == ZERO)
   { Log.Checkpoint("MDIDirecciones_selectCity: " + addressinfo + "=" + value);}
   else
   { Log.Error("MDIDirecciones_selectCity: " + addressinfo + "=/=" + value);}
}

function MDIDirecciones_selectZipcode(rootWindow, value)
{
   rootWindow.Window("ui60Viewcore_W32", "", 1).Click(); //8, 12); 
   // Potential Dialog: Value list has no records
   var popupMSG = MENSAJE_FORMS("Lista de valores no tiene registros", 0, "OK", 0);
   if ( popupMSG != NEGATIVE)
   { Log.Error("No Zipcode values. Expected: " + value); return NEGATIVE;}
   
   var tmp = selectGriditemByName("Zip Code", 1, value);
      
   var text = rootWindow.Window("Edit", "", 1).Text;
   if ( aqString.Compare(value, text, false) != ZERO )
   { 
     if ( aqString.Compare(value, "0" + text, false) != ZERO )
     { Log.Error ("Mismatch. ZipCode: " + text + " Expected:" + value);}
     else
     { Log.Warning("Missing leading zero. ZipCode: " + text + " Expected:" + value); }
     return ZERO;
   }
   return POSITIVE;
}

function MDIDirecciones_setZipcode(rootWindow, value)
{
   MDIDirecciones_clickByCoordinates(rootWindow, "zipcode");
   rootWindow.Window("Edit", "", 1).SetText(value);
   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
}

function MDIDirecciones_AddressByCity(rootWindow)
{
   MDIDirecciones_selectCity(rootWindow, Project.Variables.excel_city); 
   validateAddressFields(rootWindow, "estado", Project.Variables.excel_estado);
   validateAddressFields(rootWindow, "pais", Project.Variables.excel_pais);
   MDIDirecciones_selectZipcode(rootWindow, Project.Variables.excel_zipCode);
   // Log.Message(Project.Variables.stringResult);
}
  
function MDIDirecciones_AddressByZipcode(rootWindow)
{
   MDIDirecciones_setZipcode(rootWindow, Project.Variables.excel_zipCode);
   validateAddressFields(rootWindow, "city", Project.Variables.excel_city); 
   validateAddressFields(rootWindow, "estado", Project.Variables.excel_estado);
   validateAddressFields(rootWindow, "pais", Project.Variables.excel_pais);
   validateAddressFields(rootWindow, "zipcode", Project.Variables.excel_zipCode);
   // Log.Message(Project.Variables.stringResult);
}

function validateAddress(keyfield)
{  
   var MDIDirecciones = getMDIWindow(determineForm(),"Mantenimiento de Direcciones"); 
   var rootWindow = MDIDirecciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   var excelObject = openPanamConfig("address");
   while  (! excelObject.EOF()) 
   { 
      
      var col = 7
        addProjectVariable("excel_zipCode", "string", excelObject.Value(col++));
        addProjectVariable("excel_city", "string", excelObject.Value(col++));
        addProjectVariable("excel_pais" , "string", excelObject.Value(col++)); 
        addProjectVariable("excel_estado", "string", excelObject.Value(col++));
        var str = Project.Variables.excel_city + ":" + Project.Variables.excel_estado + ":" + 
            Project.Variables.excel_pais + ":" + Project.Variables.excel_zipCode;
            
        if ( str == ":::") break; // end of input data
        Log.Message("validateAddress:" + str);
        switch (keyfield)
        {
           case "city": MDIDirecciones_AddressByCity(rootWindow); break;
           case "zipcode": MDIDirecciones_AddressByZipcode(rootWindow); break;
           default: {Log.Error("Validate Address. Invalid keyfield:" + keyfield);}
        }
        excelObject.Next(); 
   }
   DDT.CloseDriver(excelObject.Name);
}

function populateAddressInfo()
{
    
    var pvrow = getUnusedPVRow("addressInfo"); if (pvrow == NEGATIVE) { return;}
    var pvcol = 1; // first column is for rowflag
    
    var MDIDirecciones = getMDIWindow(determineForm(),"Mantenimiento de Direcciones");
    var rootWindow = MDIDirecciones.Window("ui60Drawn_W32", "", 1); //.Window("ui60Drawn_W32", "", 3);
    
    // homeAddress
    rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).SetText(Project.Variables.addressInfo(pvcol, pvrow)); pvcol++; 
    rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]"); 

    // numero
    var numero = Project.Variables.addressInfo(pvcol, pvrow); pvcol++;
    if ( aqString.Find(numero, "-1") == NEGATIVE)
      rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys(numero);
    rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");

    // edificio
    var edificio = Project.Variables.addressInfo(pvcol, pvrow); pvcol++;
    if ( aqString.Find(edificio, "n/a") == NEGATIVE)
       rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys(edificio);
    rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
    
    // apartNo
    var aprtno = Project.Variables.addressInfo(pvcol, pvrow); pvcol++;
    if ( aqString.Find(aprtno, "-1") == NEGATIVE)
        rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys(aprtno);
        
    // tipoDirreccion
    // TODO...Handle dialog: Cliente ya tiene una direccion asociada al tipo de direccion elegido
    rootWindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 2).Button("Open").Click();
    selectComboBoxItem(Project.Variables.addressInfo(pvcol, pvrow)); pvcol++;
    rootWindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 2).Keys("[Tab]");
    
    // Potential dialog: Customer has an address associated with the type of direction chosen
    var popupMSG = MENSAJE_DE_ERROR("Cliente ya tiene una direccion asociada al tipo de direccion elegido", 0, "OK", 0);
    if ( popupMSG != NEGATIVE)
    { 
       Project.Variables.addressInfo(pvcol, pvrow) = "Correspondencia";
       Log.Warning("Replacing with: " +  Project.Variables.addressInfo(pvcol, pvrow));
       rootWindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 2).Button("Open").Click();
       selectComboBoxItem(Project.Variables.addressInfo(pvcol, pvrow));
    }
    
    // zipCode
    var zipcode = Project.Variables.addressInfo(pvcol, pvrow); pvcol++;
    if ( aqString.Find(zipcode, "-1") == NEGATIVE)
       rootWindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys(zipcode);
    
    // City
   MDIDirecciones_selectCity(rootWindow.Window("ui60Drawn_W32", "", 3), Project.Variables.addressInfo(pvcol, pvrow)); pvcol++;
    
/*
    if (Project.Variables.addressInfo.ColumnName(pvcol) != "paperless") 
    { 
      pvcol = pvcol + 2;
    } // junmp over pais and estado*/
    // paperless
    var paperless = Project.Variables.addressInfo(pvcol, pvrow); pvcol++;
    if (aqString.Find(paperless, "n") == NEGATIVE)
        rootWindow.Window("ui60Drawn_W32", "", 3).RadioButton("SI").Click();
    else
        rootWindow.Window("ui60Drawn_W32", "", 3).RadioButton("NO").Click(); 
         
    //language
    selectByClickitem ( rootWindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 1), Project.Variables.addressInfo(pvcol, pvrow), ""); 
}          

function dirrecion ()
{  
   var MDIDirecciones = getMDIWindow(determineForm(),"Mantenimiento de Direcciones");   
     populateAddressInfo(); 
     saludecoreToolbar("Grabar");  // record or save      
     var popupMSG = MENSAJE_INFORMATIVO("Grabar From dirrecion", 0, "OK", 0); 
     aqUtils.Delay(500);
     
     var pvrow = getUnusedPVRow("additionalAddressInfo"); 
     if (pvrow == NEGATIVE) 
     { closeMDIWindow(MDIDirecciones, 1); aqUtils.Delay(400); return;}
     
     var pvcol = 1; // first column is for rowflag 
     if ( aqString.Compare(Project.Variables.additionalAddressInfo(pvcol, pvrow), "n", false) != 0)
     {
         numAddresses = determineAddressNumber();
         if (  numAddresses > 0)
         {
            closeMDIWindow(MDIDirecciones, 1); //.TitleBar(0).Button("Close").Click();
            var MDIDirecciones = MDICliente_icon_Dirrecion();
            for ( var addressNum = 1; addressNum <= numAddresses; addressNum++)
            {
                readAddressData(addressNum);
                saludecoreToolbar("Insertar");
                aqUtils.Delay(1000);
                populateAddressInfo(); 
                saludecoreToolbar("Grabar"); 
                var popupMSG = MENSAJE_INFORMATIVO("From dirrecion2", 0, "OK", 0); 
            }
         }
         else
           Log.Error("Expecting to see additonal address data for test " + Project.Variables.tcNum);
     }
     closeMDIWindow(MDIDirecciones, 1);
     aqUtils.Delay(400);
}


function TelephoneInfo()
{
   var pvrow = getUnusedPVRow("telephoneInfo"); if (pvrow == NEGATIVE) { return;}
    var pvcol = 1; // first column is for rowflag
     
   var MDITelefonos = MDICliente_icon_Telefono(); 
   var rootWindow = MDITelefonos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   //.Window("ComboBox", "", 8).Button("Open")
   rootWindow.Window("ComboBox", "", 8).Button("Open").Click();
   rootWindow.Window("ComboBox", "", 8).Button("Close").Click();  
   rootWindow.Window("ComboBox", "", 8).Keys("![Tab]");
   rootWindow.Window("Edit", "", 1).Keys("![Tab]");
   
   rootWindow.Window("Edit", "", 1).Keys(Project.Variables.telephoneInfo(pvcol, pvrow)); pvcol++;
   rootWindow.Window("ComboBox", "", 3).Button("Open").Click();
   rootWindow.Window("ComboBox", "", 3).Button("Close").Click(); 
   rootWindow.Window("ComboBox", "", 3).Keys("[Tab]"); 
   rootWindow.Window("Edit", "", 1).Keys(Project.Variables.telephoneInfo(pvcol, pvrow)); pvcol++; 
   aqUtils.Delay(400);
   saludecoreToolbar("Grabar");  
   var popupMSG = MENSAJE_INFORMATIVO("TelephoneInfo", 0, "OK", 0);
   closeMDIWindow(MDITelefonos,1);
}

/// Test Stubs
function test_zipcodeTest () 
{ var test = "zipcode";
  // var test = "city";
  // addressValidationTests(test);
  // var MDIDirecciones = MDICliente_icon_Dirrecion();
  validateAddress(test); 
}
