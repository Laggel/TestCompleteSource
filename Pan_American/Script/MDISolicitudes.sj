//USEUNIT utilities

/// Script file: MDISolicitudes
/// Last update: May 8   

function MDISolicitudes_Banner(mdi)
{ return mdi.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2);}

function MDISolicitudes_Comentarios(ui60Drawn_W32_3)
{ return ui60Drawn_W32_3.Window("Edit", "", 2);}

function MDISolicitudes_ComentariosScrollbar(ui60Drawn_W32_3)
{ return ui60Drawn_W32_3.Window("ScrollBar", "", 1);}

function MDISolicitudes_RadioButton(ui60Drawn_W32_3, label, action)
{  // action: "Si" or "No"
   if ((action != "Si") && (action != "No"))
   { Log.Error("Unsupported action. " + action + " for MDISolicitudes RadioButton " + label); return null;}
   
   switch(label)
   {
      case "PaperlessOption": { return ui60Drawn_W32_3.RadioButton(action);} break;
      case "DebitoAutomatico": { return ui60Drawn_W32_3.RadioButton(action, 2);} break;         
      case "Automatico": { return ui60Drawn_W32_3.RadioButton(action, 3);} break;
      case "prorata": { return ui60Drawn_W32_3.RadioButton(action, 4);} break; 
      case "Vencimiento": { return ui60Drawn_W32_3.RadioButton(action, 5);} break;  
      default: { Log.Error("Unsupported  MDISolicitudes RadioButton:" + label); return null;}
   }
}

function MDISolicitudes_windowButton(ui60Drawn_W32_3, label)   
{
   switch(label)
   {
      case "Continuidad": { return ui60Drawn_W32_3.Window("Button", " ", 1);}; break;
      case "PeriodDeEspera": { return ui60Drawn_W32_3.Window("Button", " ", 2);}; break;
      case "Rec.Doc.Originales": { return ui60Drawn_W32_3.Window("Button", " ", 3);}; break;
      // case "UnvisiobleOnScreen": { return ui60Drawn_W32_3.Window("Button", " ", 17);}; break;  
      default: { Log.Error("Unsupported  MDISolicitudes WindowButton:" + label); return null;}
   }
} 

function MDISolicitudes_ComboBox(ui60Drawn_W32_3, label)   
{
   switch(label)
   {
      case "ViaDeSolicitud": { return ui60Drawn_W32_3.Window("ComboBox", "", 1);}; break;
      case "EnviarDocumenoA": { return ui60Drawn_W32_3.Window("ComboBox", "", 2);}; break;
      case "IdiomaDocumento": { return ui60Drawn_W32_3.Window("ComboBox", "", 3);}; break;
      case "FormaDePago": { return ui60Drawn_W32_3.Window("ComboBox", "", 4);}; break;  
      default: { Log.Error("Unsupported  MDISolicitudes ComboBox:" + label); return null;}
   }
}

function MDISolicitudes_Viewcore(ui60Drawn_W32_3, label)   
{
   switch(label)
   {
      case "Rec.Doc.Originales": { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 1);}; break;
      case "EstadoDeCuenta": // icon: magnifier on yellow envelope
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 2);}; break; 
      case "CorreosYTelefonos": // icon: envelopes
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 3);}; break; 
      case "CorreoElectronico": // email
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 4);}; break; 
      case "Correspondencias": // icon: blue and whilte papers
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 5);}; break; 
      case "Notas": // icon: notes
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 6);}; break; 
      case "Aseguarados": // icon_Aseguarados
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 7);}; break; 
      case "CalcularPrima": // icon: calculator
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 8);}; break; 
      case "Opcionales": // icon: plus in circle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 9);}; break; 
      case "Planes": // icon_planes ... black book
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 10);}; break;
      case "Agentes": // icon man in the navy suit
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 11);}; break;
      case "ImprimirCuadro": // icon: print
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 12);}; break; 
      case "TarjetasDeCredito": // icon: blue and green postcards
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 13);}; break; 
      case "TarjetasCreditoPulldownHandle": // a.k.a CuentaBancaria PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 14);}; break; 
      case "EstatusPulldownHandle": // policy status PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 15);}; break; 
      case "Sub_RamoPulldownHandle": // Sub_Ramo PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 16);}; break; 
      case "MetodoDePagoPulldownHandle": // Payment method PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 17);}; break; 
      case "ImpuestoPulldownHandle": // Taxes PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 18);}; break; 
      case "SubsidiariaPulldownHandle": // Subsidiaria PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 19);}; break; 
      case "ClienteNombrePulldownHandle": // Client Name PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 20);}; break;
      case "ClienteCodigoPulldownHandle": // Client Code PulldownHandle
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 21);}; break; 
      case "CrearCliente": // icon: CrearCliente faceless man
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 22);}; break; 
      case "Enmienda": // icon: Enmienda green book with a question mark?
      { return ui60Drawn_W32_3.Window("ui60Viewcore_W32", "", 23);}; break;  
      default: { Log.Error("Unsupported  MDISolicitudes PulldownHandle:" + label); return null;}
   }
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
      default: { Log.Error("Unknown MDIname for icon_Asegurados: " + MDIname);}
   }            
}

   // get the effective date for the new policy
function getEffective_date ()
{
  var MDISolicitudes = getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
  MDISolicitudes.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(203, 300);;
  date = (MDISolicitudes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text);
  addProjectVariable("effective_date", "string", date); // used to be "date"
  //Log.Message (Project.Variables.effective_date + " is your requested effective policy date" )

}
// this function will navigate through the application gathering information on the policy such as number of dependants, name, birth date etc... this infor will be compared with data
//from the spreadsheet to ensure data integrity between web interface and the database and that the information can be pulled accurately into the client app
function getdependants_form_info ()
{
  //===== this section will get number of dependants and store it to a project variable
  //open dependants window
  var MDI = getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
  MDI.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 11).Click(20, 26);
  //get number of dependants
  MDI.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(67, 305); //select control that displays number of dependants
  //store number of dependant records in project variable
  addProjectVariable("backend_num_dependants", "string",(MDI.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text));
  //===== section end***
  
  // this section will get the first name on the form and store to porject variable
  MDI.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Click(214, 155);
  // get the names
  form_name = (MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text);
  addProjectVariable("backend_form_name", "String", form_name );
  Log.Message(Project.Variables.backend_form_name);
   //===== section end***
  // this section will get the birthdate of the first person in the list
  //got to the dependant information page and get birth date
  MDI.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).DblClick(214, 155);
  var MDIp1 = getMDIWindow(determineForm(), "Mantenimiento Asegurado");
  MDIp1.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 1).Click(65, 169); 
  birth_date = (MDIp1.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text);
  addProjectVariable("backend_form_date", "string", birth_date); 
}


//this fucntion will get the plan type from Saludcore
function getPlanType()
{
  var MDISolicitudes = getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
  var panel = MDISolicitudes.Window("ui60Drawn_W32");
  panel.Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 10).Click(25, 24);
  var panel2 = panel.Window("ui60Drawn_W32", "", 3);
  panel2.Click(229, 220);
  var planType = panel2.Window("Edit", "", 1).Text;
  //need to parse name to remove Pan American
  var StartPos = 0; var sLength = 13; var Res = aqString.Remove(planType, StartPos, sLength);
  //store 3rd edit box value in project variable
  addProjectVariable("planTypeform", "string", Res);
}

function getPaymentMode()
{
  var MDISolicitudes = getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
  var comboBox = MDISolicitudes.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4);
  comboBox.Click(90, 7);
  comboBox.Click(90, 7);
  paymentMode = comboBox.wText;
  return(paymentMode);
}

function MDISolicitudes_PolicyNumber()
{  // set and get or just get policy number
   var MDISolicitudes = getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
   var rootwindow = MDISolicitudes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   rootwindow.Click(99, 88); //FIXED COORDINATES for MDISolicitudes policyNumber  
   var PolicyNum = rootwindow.Window("Edit", "", 1).Text;
   addProjectVariable("PolicyNum", "STRING", PolicyNum);
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "MDISolicitudes_PolicyNumber" + PolicyNum);
}

