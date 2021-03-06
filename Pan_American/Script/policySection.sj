//USEUNIT utilities
//USEUNIT excelUtilities
//USEUNIT navigateMainWindow

/// Script File: policy
/// Last update: May 29
/// Screens: MDI_Policy, "Emision de Polizas"

var MDI_Policy = "Mantenimiento De Pólizas";

function validatePolicyBalance (formBalance, balance)
{
   var expectedBalance = balance;
   if ( aqString.Find(formBalance, balance) == NEGATIVE)
   {  if ((aqString.GetLength(formBalance) != 0) && (aqString.Find(balance, "0") == NEGATIVE))
         expectedBalance = formBalance;
   }
   
   var str = "policy balance amount: " + expectedBalance;
   if (expectedBalance == balance) Log.Checkpoint("Expectedected " + str);
   else Log.Error("Unexpectedected " + str + " Expected:" + balance);
   return expectedBalance;     
}

function DescuentosOCargos(field, value, setorvalidate)
{ // Discounts or Charges
    var MDIPolizas = getMDIWindow(determineForm(), MDI_Policy);
    var buttons = MDIPolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
    switch (field)
    {
       case "Descuento":
       { var button = buttons.RadioButton("Descuento");}
       break;
       case "Exoneración":
       { var button = buttons.RadioButton("Exoneración");}
       break;
       case "Recargo":
       { var button = buttons.RadioButton("Recargo");}
       break;
       case "Porciento":
       { var text = MDIPolizas.Window("Edit", "", 2);}
       default:
       { Log.Error("Unsupported Descuentos O Cargos: " + field);}
    }
}

function MDIEmisionDePolizas_icon_Generar(mdi) // Fileserver icon
{   
    mdi.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 4).Click();
    
    if (Project.Variables.countryCode != 1)
    {
      var popupMSG1 = MENSAJE_FORMS("Este cliente podría estar requiriendo los números tributarios*", 0, "Si", 0);
      // Dialog Are you sure you want to create affiliate and generate the application
      var popupMSG2 = MENSAJE_FORMS("Esta seguro que desea crear afiliados y generar la solicitud", 2, "Si", 0);
      
      // Potential Dialog: Emission process ended successfully
      var tmp3 = handleADialog("Proceso de emision finalizo exitosamente", "Forms", 2, "OK", 0)  
    
      /*
      if (MENSAJE_FORMS("Proceso de Emision Finalizo Exitosamente.", 2, "OK", 0) == NEGATIVE);
        Sys.Keys("O");
      */
      
    }
    else
    {
      // Potential Dialog: Want to create application?
      var popupMSG = MENSAJE_FORMS("esta seguro de querer generar las solicitudes seleccionadas", 0, "Si", 0);
      // Potential Dialog: Emission process ended successfully
      var popupMSG1 = MENSAJE_FORMS("Proceso de emision finalizo exitosamente", 2, "OK", 0);
    }

    if(handleADialog("Proceso*", "Forms", 2, "OK", 0) == NEGATIVE) { return getMDIWindow(determineForm(),"Emision de Polizas"); } // probably another window
    return getMDIWindow(determineForm(),"Emision de Polizas");
}

function test_MDIEmisionDePolizas_icon_Generar()
{ // var mdi = getMDIWindow(determineForm(),"Emision de Polizas");
  // var mdi2 = MDIEmisionDePolizas_icon_Generar(mdi);
  // Log.Message(mdi2.FullName);
  var popupMSG = MENSAJE_FORMS("solicitudes deben de llevar por lo menos un intermediario principal (c/u).", 0, "OK", 0); //0 or 2?
    
    // Desired dialog: emission process ended successfully 
    var popupMSG = MENSAJE_FORMS("proceso de emision finalizo exitosamente", 2, "OK", 0);
}

function retreivePolicydata(policynumber)
{
   // if(!goToMain()) { Log.Message("TODO .... in retreivePolicydata"); return;}
   // MantenimientosMenu("Mantenimiento De Pólizas");
   var policyinfo = policyInfoFromPolizas("PolicyNum", policynumber);
   var MDIPolizas = icon_Asegurados(MDI_Policy);
   var rootWindow = MDIPolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1);
   parent = rootWindow.Parent;
   x = rootWindow.Left + rootWindow.Width/2;
   y = rootWindow.Top + rootWindow.Height/2;
   parent.Click(58, 302);
   MDIPolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
   count = aqConvert.StrToInt( rootWindow.Text);
   parent.Click(x, y);
  // rootWindow.Keys("[Tab]");     
  // rootWindow.Keys("[Tab]"); 
  // rootWindow.Window("Edit", "", 1).Keys("[Tab]");  
  // rootWindow.Keys("[Tab]");  
   codigo = rootWindow.Text;
   addProjectVariable("codigo", "string", codigo);
}

function retreiveRegion()
{
    var formObject = determineForm();
    var MDIPolizas = getMDIWindow(formObject, MDI_Policy);
    MDIPolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 5).Click();
    
    var rootwindow = getMDIWindow(formObject, "Region").Window("ui60Drawn_W32", "", 1);
    rootwindow.Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
    region = rootwindow.Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
    addProjectVariable("region", "string", region);
    rootwindow.Window("ui60Drawn_W32", "", 1).Button("Pantalla Anterior").Click();
}

function policyInfoFromPolizas(field, value)
{
    var MDIPolizas = getMDIWindow(determineForm(), MDI_Policy);
    var rootwindow = MDIPolizas.Window("ui60Drawn_W32", "", 1);
    switch (field)
    {
       case "PolicyNum":
       { 
          rootwindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
          rootwindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).SetText(value); // Project.Variables.PolicyNum); //.Keys(Project.Variables.PolicyNum);
          rootwindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[F8]"); // saludecoreToolbar("Consultar");
          // Potential Dialog: Did not find any record
          var popupMSG = MENSAJE_FORMS("No Se Encontro Ningun Registro. PolicyNum:" + Project.Variables.PolicyNum, 0, "OK", 0);
          if(popupMSG >= 0){ return "ERROR";}
          return Project.Variables.PolicyNum;
       }
       break;
       case "PolicyBalance":
       {
          MDIPolizas.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(415, 321);
          var result = rootwindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
          addProjectVariable("policy_policyBalance", "STRING", result);
          return result;
       }
       break;
       case "Codigo":
       {
          MDIPolizas.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(183, 94);
          var result = rootwindow.Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
          addProjectVariable("Codigo", "STRING", result);
          return result;
       }
       break;
       case "PaymentSchedule":
       {
          var buttons = rootwindow.Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 1);
          buttons.Button("Open").Click();
          buttons.Button("Close").Click();
          var result = buttons.Text(0).Value;
          addProjectVariable("PaymentSchedule", "STRING", result);
          return result;
       }
       break;
       case "PolicyData":
       { rootwindow.Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 11).Click();;
          return "PolicyData";
       }
       break;
       defult: { Log.Message("Unsupported field."); return "ERROR";}
    }
 }

 function retreiveAdditionalPolicyData()
 {
    var MDIPlanesPolizasSalud = icon_PolizasSalud();
    MDIPlanesPolizasSalud.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(192, 192);
    var product = MDIPlanesPolizasSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
    Log.Message(" The retreived product is : " + product);
    
   productValue = extractNextString(product, "Pan-American");
   policyValue =  extractNextString(product, "deducible");
   addProjectVariable("Product", "string", productValue);
   addProjectVariable("Deductible", "string",  aqString.SubString(policyValue, 1, aqString.GetLength(policyValue) ));
   
   //formObject.Panel("Workspace").getMDIWindow("Mantenimiento Planes Polizas Salud").TitleBar(0).Button("Close").Click();
   //formObject.Panel("Workspace").getMDIWindow(MDI_Policy).TitleBar(0).Button("Close").Click()
   Sys.Process("ifrun60").Form("Saludcore").Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 12).Click(15, 9);
 }

function icon_PolizasSalud()
{ // clicking on ??? 
    var MDIPolizas = getMDIWindow(determineForm(), MDI_Policy);
    MDIPolizas.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 12).Click();
    return getMDIWindow(determineForm(), "Mantenimiento Planes Polizas Salud");
}

function icon_Asegurados(MDIname) // the blond boy in blue sweater
{ // clicking on Asegurados (= insured person) icon (the blond boy in blue sweater) for beneficiery 
   switch(MDIname)
   {
      case "Mantenimiento De Solicitudes":
         var MDISolicitudes = getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
         MDISolicitudes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 7).Click();
         return getMDIWindow(determineForm(), "Consulta"); //for beneficiery 
      break;
      case MDI_Policy:
         var MDIPolizas = getMDIWindow(determineForm(), MDI_Policy);
         MDIPolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 11).Click();
         aqUtils.Delay(500); Sys.Process("ifrun60").Refresh();
         return getMDIWindow(determineForm(), MDI_Policy);
      break;
      default: { Log.Error("Unknown MDIname for icon_Asegurados: " + MDIname);}
   }            
}

function selectApprovePolicyCheckBox(boxNum)
{ Sys.Process("ifrun60").UIAObject("Oracle_Forms_Runtime").Panel("Workspace").Emision_de_Polizas.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(579, (167 + (boxNum *20)));}

function MDIEmisionDePolizas_selectCheckbox(row) 
{
   var maxrows = 4; // FIXED VALUE
   if ((row < 0) || (row > 4)) { return -1;}
   var MDIEmisionDePolizas = getMDIWindow(determineForm(),"Emision de Polizas");
   var rootwindow = MDIEmisionDePolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   rootwindow.Window("Button", " ", (maxrows - (row - 1))).Click();
   // Potential dialog: This field can not be modified   
   var popupMSG = MENSAJE_FORMS("este campo no puede ser modificado", 0, "OK", 0);
   return (popupMSG == NEGATIVE);                    
}

function test_validatePolicyStatusReason()
{ var policyState = ""; return validatePolicyStatusReason(policyState);} 

function validatePolicy(pulldownindex, textvalue, menuname, logMenuItems)
{  // used to get value. Now we have to select from the pulldown menu  
   var MDIPoliza = getMDIWindow(determineForm(), MDI_Policy);
   var rootwindow = MDIPoliza.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   var pulldownhandle = rootwindow.Window("ui60Viewcore_W32", "", pulldownindex);
   var top = pulldownhandle.Top + Math.round(pulldownhandle.Height / 2);
   var left = pulldownhandle.Left + pulldownhandle.Width + 10; 
   
   var downcount = 0;  var prevText = ""; var text = textvalue; 
   var popupMSG = NEGATIVE; 
   while (prevText != text )
   {  // codigo indexed pulldown menu, keep selecting until the desired value is found.
      pulldownhandle.Click(); 
      if (downcount == 0) 
      { // Potential dialog: This field can not be modified   
         var popupMSG = MENSAJE_FORMS("este campo no puede ser modificado", 0, "OK", 0);
      }  
      if (popupMSG == NEGATIVE) { var tmp = selectGriditemByName(menuname, downcount, textvalue);}
      var rootwindow = MDIPoliza.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3); 
      var codigo = rootwindow.Window("Edit", "", 1).wText;
      rootwindow.Click(left,top);
      text = rootwindow.Window("Edit", "", 1).Text; 
      if (aqString.Find(text, textvalue) != -1)
      { Log.Message("Match. Validate Policy: " + codigo + " " + text); return true;}
      if (logMenuItems)
      { Log.Message("validatePolicy:" + menuname + " " + InttoStr(downcount) + " " + codigo + " " + text);}
      downcount++;
   }
   Log.Error("Mismatch. Validate Policy: " + textvalue + " for " + menuname); 
   return false;
}

function validatePolicyVersion(policyVersion)
{
   var MDI = getMDIWindow(determineForm(), MDI_Policy);
   MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 2).Button("Open").Click();
   MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 2).Button("Close").Click();
   var value = MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 2).Text(0).Value;
   if (aqString.Find(value, policyVersion) != -1)
   { Log.Message("Correct policy version: " + policyVersion);}
   else
   { Log.Error("Invliad policy version: " + value + " expected: " + policyVersion);}
}

function getBalanceDeLaPoliza()
{
   //var MDIPoliza = 
   var PagoSection = getMDIWindow(determineForm(), MDI_Policy).Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3); 
   PagoSection.Click(403, 321); // HARDCODED COORDINATES  Balance de la Poliza
   balanceDeLaPoliza = PagoSection.Window("Edit", "", 1).Text;
   addProjectVariable("policy_policyBalance", "string", balanceDeLaPoliza);
   return  balanceDeLaPoliza;  //changed from string to integer Mina: changed back to string
}

function MDIPoliza_policyNumber(policynumber)
{ 
  var MDIPoliza = getMDIWindow(determineForm(), MDI_Policy);
  MDIPoliza.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32").Window("ui60Viewcore_W32", "", 9).Click(13, 9);
  MDIPoliza.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(98, 89);
  var pnumobj = MDIPoliza.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1);
  if (policynumber != "") { pnumobj.SetText(policynumber); return;}
  var policynum = pnumobj.Text();
  if (policynum == policynumber) { Log.Checkpoint("Match. MDIPoliza_policyNumber: " + policynum); return;}
  Log.Warning("Mismatch. MDIPoliza_policyNumber: " + policynum + " Expected: " + policynumber);
}

function test_MDIPoliza_policyNumber()
{ MDIPoliza_policyNumber("800195");}

/// Test Stubs

