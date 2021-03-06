/// Script File: utilities
/// Last update: May 8   

// Test results
var NEGATIVE = -1; // not found or not applicable, ...
var POSITIVE = 1; // found or applicable but not meeting all requirements...
var ZERO = 0; // = OK, found or applicable and meets all expectations...

function  addProjectVariable(name, type, value)
{
     if (!Project.Variables.VariableExists(name)) {Project.Variables.AddVariable(name, type);}
     if (aqString.Find(type, "table") == NEGATIVE)  
     { Project.Variables.VariableByName(name) = value;}  
}

function getUnusedPVRow(pvname)
{
   var nextrow = Project.Variables.VariableByName(pvname)(0, 0);
   if ( nextrow == -1) { return nextrow;} // no available row
   if (nextrow >= Project.Variables.VariableByName(pvname).RowCount) 
   { Project.Variables.VariableByName(pvname)(0, 0) = -1; return -1; }
   Project.Variables.VariableByName(pvname)(0, 0)++; 
   return nextrow;                       
}

function getTcNum(idx)
{  // idx = NEGATIVE returns the next unused testcase key. idx != NEGATIVE returns the specified testcase key
   var pvrow = NEGATIVE; var pvname = "TestList"; 
   if (!Project.Variables.VariableExists(pvname)) 
      { addProjectVariable("tcNum", "string", IntToStr(idx)); return pvrow;}
   if (idx == NEGATIVE) 
   {  var pvrow = getUnusedPVRow(pvname); if (pvrow == NEGATIVE) { return pvrow;}}
   else
   {  var pvrow = Project.Variables.TestList.RowCount - 1;
      while (pvrow != NEGATIVE)
      { if (Project.Variables.TestList(0,pvrow) == IntToStr(idx)) break; pvrow--;}
      if (pvrow == NEGATIVE) { Log.Error("Not Found. Test Index: " + idx); return pvrow;}
   }  
   addProjectVariable("tcNum", "string", Project.Variables.TestList(1,pvrow));
   return pvrow;
}

function ifQ(pvname)
{ 
   var pvrow = getUnusedPVRow(pvname); if (pvrow == NEGATIVE) { return;}
   var pvcol = 1; // first column is for rowflag
   return ( aqString.Find(Project.Variables.VariableByName(pvname)(1,pvrow), "y", 0, false) != NEGATIVE)
}


function fuzzyCompare (str, target)
{
   var spanishAccents = new Array("á", "é", "í", "ó", "ú", "É", "¿", "¡", "ª", "º", "ñ", "Ñ");
   var replaceWith    = new Array("a", "e", "i", "o", "u", "E", "?", "i", "a", "o", "n", "N");
   // remove all spaces
   var regExp = / /g; var str1 = target.replace(regExp,"");  var str2 = str.replace(regExp,"");
   for (var i=0; i < spanishAccents.length; i++)    
   {
      str1 = aqString.Replace(str1, spanishAccents[i], replaceWith[i], false);
      str2 = aqString.Replace(str2, spanishAccents[i], replaceWith[i], false); 
   }
   return aqString.Compare(str1, str2, false);
}

function FindAqaqStringListItem(list, item, seperator)
{ 
  aqString.ListSeparator = seperator;
  var listCount = aqString.GetListLength(list);
  for (var Idx = 0; Idx < listCount; Idx++)
  { if (aqString.Compare(aqString.GetListItem(list, Idx), item, true) == 0) { return Idx;}} 
  return -1;
}

function determinNumberofRows()
{
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "determinNumberofRows");
   var MDI = getMDIWindow(determineForm(), "Restricciones por");
   var rootWindow = MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   var buttons = rootWindow.FindAllChildren("Caption", "....");
   buttons = (new VBArray(buttons)).toArray();
   return buttons.length;
}

function determinNumberofCheckBoxes()
{
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "determinNumberofCheckBoxes");
   var MDI = getMDIWindow(determineForm(), "Restricciones por");
   var rootWindow = MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   var buttons = rootWindow.FindAllChildren("ObjectType", "CheckBox");
   buttons = (new VBArray(buttons)).toArray();
   // Log.Message(buttons.length)
   return buttons;
}

function selectFirstComboBoxItem()
{ Sys.Process("ifrun60").Window("ComboLBox", "", 1).SelectItem(0);}
  

function selectComboBoxItem(item)
{  var box = Sys.Process("ifrun60").Window("ComboLBox", "", 1);
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + box.wItemList); //_listComboBoxItems(box);
   box.ListItem(item).Click();
}
 
function selectFromComboLBox(boxlabel, item)
{  var box = Sys.Process("ifrun60").Window("ComboLBox", "", 1);
   // if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + boxlabel + ":" + box.wItemList);
   // var itemidx = FindAqaqStringListItem(box.wItemList, item, "|");
   // if (itemidx < 0) 
   // { Log.Error("List item not found. " + item); return false;}  
   // box.wItem = itemidx;
   // box.Click();
   // return true;
   box.ListItem(item).Click();
   //box.wItemList(item).Click();
}
function testselectComboBoxItem()
{ var language = "ESPAÑOL"; selectComboBoxItem(language); }


function TRACE_listComboBoxItems(box)
{
   var items = box.FindAllChildren("Name", "ListItem(*", 1);
   items = (new VBArray(items)).toArray();
   for (var i = 0; i < items.length; i++)
   { if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "FullName: " + items[i].FullName + "\r\n" + "Text: " + items[i].wText);}
}

function DateToday(daysToAdd)
{ //input parm is an integer (pos or neg)
  var todayDate = aqDateTime.Today();
  return aqDateTime.AddDays(todayDate, daysToAdd);
}

function calculateAge(dob)
{ 
    birthYear = aqDateTime.GetYear(dob);
    currentYear = aqDateTime.GetYear(aqDateTime.Today());
    return currentYear - birthYear;
}
      
function selectMunicipisoGrid(itemNumber)
{
  var wnd;
    wnd = Sys.Process("ifrun60").UIAObject("CIUDADES_MUNICIPIOS").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
    xcoord = wnd.Width/2; 
    wnd.Click(xcoord, ((itemNumber + 1) * 13));   
    Sys.Process("ifrun60").UIAObject("CIUDADES_MUNICIPIOS").Window("ui60Drawn_W32", "", 1).UIAObject("OK").Click();
}
   
function selectGridItem(itemNumber)
{
  var wnd, xcoord;
  wnd = Sys.Process("ifrun60").Dialog("Seleccionar Compañias").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
  xcoord = wnd.Width/2;
  wnd.Click(xcoord, ((itemNumber + 1) * 9));
  Sys.Process("ifrun60").Dialog("Seleccionar Compañias").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
}

function selectINTERMEDIARIOSGrid(itemNumber)
{
  var wnd;
    wnd = Sys.Process("ifrun60").UIAObject("INTERMEDIARIOS").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
    xcoord = wnd.Width/2; 
    wnd.Click(xcoord, ((itemNumber + 1) * 13));   
    Sys.Process("ifrun60").UIAObject("INTERMEDIARIOS").Window("ui60Drawn_W32", "", 1).UIAObject("OK").Click();
}

function selectGriditemByName(gridName, downCount, value)
{
   var localcount = 0;// RESULT_NEGATIVE;
   var wnd = Sys.Process("ifrun60").Dialog(gridName+"*").Window("ui60Drawn_W32");
   if (!wnd.Exists) { return localcount;}
   wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys('[Tab][Tab][Tab][Tab]![Home][Delete]%'+value+'%[Enter]');//Posicionarse en el campo de busqueda
   //wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys(value);
   while (localcount <downCount-1)
   {
      wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys("[Down]"); 
      localcount++;
   } 
   wnd.Button("OK").Click();
   return localcount;//RESULT_POSITIVE;
}

function selectGriditemByName2(gridName, downCount, value)
{
   var localcount = NEGATIVE;
   var wnd = Sys.Process("ifrun60").Dialog(gridName+"*").Window("ui60Drawn_W32");
   if (!wnd.Exists) { return localcount;}
   
   wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys(value);
   while (localcount <downCount)
   {
      //wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys("[Down]"); 
      localcount++;
   } 
   Sys.Keys("[Enter]");
   //wnd.Button("OK").Click();
   return localcount;
}

function selectGriditemByNameWithDownCount(gridName, downCount, value)
{
   var localcount = NEGATIVE;
   var wnd = Sys.Process("ifrun60").Dialog(gridName).Window("ui60Drawn_W32");
   if (!wnd.Exists) { return localcount;}
   
   wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys(value);
   while (localcount <downCount)
   {
      wnd.Window("ui60Viewcore_W32").Window("ui60Drawn_W32").Keys("[Down]"); 
      localcount++;
   } 
   wnd.Button("OK").Click();
   return localcount;
}


function selectFirstGridItem(gridName)
{ Sys.Process("ifrun60").Dialog(gridName).Window("ui60Drawn_W32", "", 1).Button("OK").Click();}

function selectFirstGridItemByFind(gridName, NotfoundSeverity)
{  
    if (NotfoundSeverity <= 0 ) {Log.Enabled = false;}
   var grid = Sys.Process("ifrun60").FindChild("Name", "Dialog(" + gridName + "*)", 1);
   Log.Enabled = true;
   if (!grid.Exists) 
   { switch (NotfoundSeverity)
     { 
       case  0: Log.Warning("Missing grid. " + gridName); break;
       case  1: Log.Error("Missing grid. " + gridName); break;
     }
     return false;
   }
   //Sys.Keys("[Enter]");
   grid.Window("ui60Drawn_W32", "", 1).Button("OK").Click();
   return true;
}

function exitForm(form)
{
   var rootWindow = form.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1);
   rootWindow.Window("ui60Viewcore_W32", "", 3).Click();  // "Salir": // Exit or Check out  
}
         
function saludecoreToolbar(buttonName)
{
   var rootWindow;
   var formObject = determineForm();
   // Saludecore Tool Bar
   rootWindow = formObject.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1);
   switch (buttonName)
   {
      case "Salir": // Exit or Check out
         rootWindow.Window("ui60Viewcore_W32", "", 3).Click();
         break;
      case "Imprimer": // Print?
          rootWindow.Window("ui60Viewcore_W32", "", 11).Click();
         break;
      case "Grabar": // Record or Save
         // rootWindow.Window("ui60Viewcore_W32", "", 12).HoverMouse();
          rootWindow.Window("ui60Viewcore_W32", "", 12).Click();
         break;
      case "Consultar": // See? mic-looking button
          rootWindow.Window("ui60Viewcore_W32", "", 9).Click();
         break;
      case "Insertar": // Insert
          rootWindow.Window("ui60Viewcore_W32", "", 8).Click();
         break;
      case "Borrar": // Delete or clear form
        rootWindow.Window("ui60Viewcore_W32", "", 7).Click();
         break;
      case "Anterior": // Previous
          rootWindow.Window("ui60Viewcore_W32", "", 1).Click();
         break;
      case "Proximo": // Next
          rootWindow.Window("ui60Viewcore_W32", "", 2).Click();
         break;
      case "LimpiarPantal": // Pantal clean
          rootWindow.Window("ui60Viewcore_W32", "", 10).Click();
         break;
      case "LimpiarRegist":  // Signup Clean
          rootWindow.Window("ui60Viewcore_W32", "", 6).Click();
         break;
      case "Editar": // Edit
          rootWindow.Window("ui60Viewcore_W32", "", 5).Click();
         break;
      case "Ayuda": // Help
          rootWindow.Window("ui60Viewcore_W32", "", 4).Click();
         break; 
   }
}
    
function dialog_Error(text, action, expected)
{  // returns -1 if not found, 1 if found the dialog and responded to, 0 if found a dialog but could not respond to 
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "Dialog Error:" + text);
   if ( expected <= 0 ) {Log.Enabled = false;}
   var dialog = Sys.Process("ifrun60").FindChild("Name", "Dialog(\"Error\")");
   Log.Enabled = true;   
   if (!dialog.Exists)
   { if( expected > 0 ) {Log.Error("Missing dialog. Error:" + text);} return -1;}
   if( expected < 0 ) { Log.Error("Unexpected dialog. " + dialog.FullName);}
   var button = dialog.Window("ui60Drawn_W32", "", 1).Button(action);
   if (!button.Exists) { Log.Error("Button not found. dialog:" + dialog.FullName + " action:" + action);}
   if (button.Visible) { button.ClickButton(); return 1;}
   Log.Error("Button not visible. dialog:" + button.FullName + " Closing the dialog."); 
   var closebutton = dialog.TitleBar(0).Button("Close");
   if (closebutton.Exists) { closebutton.SetFocus(); closebutton.Click();}
   return 0;
}

function OK_MENSAJE_INFORMATIVO(name)
{ if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "Dialog MENSAJE INFORMATIVO: " + name); 
  var wnd =  Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Window("ui60Drawn_W32", "", 1).Button("OK");
  if (wnd.Exists) 
  {
    wnd.Click();
    return true;
  }
  
  return false;  
}

function handleADialog(text, name, instance, action, expected)
{  // returns -1 if not found, 1 if found the dialog and responded to, 0 if found a dialog but could not respond to 
   if ( expected <= 0 ) {Log.Enabled = false;}
   if (instance > 0)
   { var dialogname = "Dialog(\"" + name + "\", " + IntToStr(instance) + ")";}
   else
   { var dialogname = "Dialog(\"" + name + "\")";}
   var dialog = Sys.Process("ifrun60").FindChild("Name", dialogname, 1);
   Log.Enabled = true;   
   if (!dialog.Exists)
   { 
      if( expected == POSITIVE ) {Log.Error("Missing dialog. " + text);}
      if( expected == NEGATIVE ) { Log.Error("Unexpected dialog. " + dialog.FullName);}
      return NEGATIVE;
   } 
   
   var button = dialog.Window("ui60Drawn_W32", "", 1).Button(action);
   if (!button.Exists) 
   { Log.Error("Button not found. dialog:" + dialog.FullName + " action:" + action); 
     var act = aqString.SubString(action,0,1);
     Sys.Keys(act);
   }
   
   if (button.Visible) 
   { 
      button.ClickButton();
      Log.Message("Dialog: " + name + " Clicked:" + action + " for: " + text);
      return POSITIVE;
   }
   
   Log.Error("Button not visible. dialog:" + text + ". Closing the dialog."); 
   var closebutton = dialog.TitleBar(0).Button("Close");
   if (closebutton.Exists) { closebutton.SetFocus(); closebutton.Click();}
   return ZERO;
}

function MENSAJE_TITULO(text, instance, action, expected)
{ return handleADialog(text, "TITULO", instance, action, expected);}

function MENSAJE_AVISO(text, instance, action, expected)
{ return handleADialog(text, "Aviso", instance, action, expected);}

function MENSAJE_ALERTA(text, instance, action, expected)
{ return handleADialog(text, "Alerta", instance, action, expected);}

function MENSAJE_DE_ALERTA(text, instance, action, expected)
{ return handleADialog(text, "MENSAJE DE ALERTA", instance, action, expected);}

function MENSAJE_DE_ERROR(text, instance, action, expected)
{ return handleADialog(text, "MENSAJE DE ERROR", instance, action, expected);}

function MENSAJE_ERROR(text, instance, action, expected)
{ return handleADialog(text, "Error", instance, action, expected);}

function MENSAJE_INFORMATIVO(text, instance, action, expected)
{ return handleADialog(text, "MENSAJE INFORMATIVO", instance, action, expected);}

function MENSAJE_PRECAUCION(text, instance, action, expected)
{ return handleADialog(text, "PRECAUCION", instance, action, expected);}

function MENSAJE_FORMS(text, instance, action, expected)
{ return handleADialog(text, "Forms", instance, action, expected);}

function MENSAJE_LOGON(text, instance, action, expected)
{ return handleADialog(text, "Logon", instance, action, expected);}

function determineForm(formname)
{  var form = Sys.Process("ifrun60").FindChild("name", "Form*"); return form;}

function SaludcoreForm()
{ return Sys.Process("ifrun60").Form("Saludcore"); }

function clickPaymentButton(buttonName)
{
    var formObject = determineForm();
    var rootWindow = formObject.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1);
    
    switch (buttonName)
    {
    
       case "salvando": // Saving
          rootWindow.Window("ui60Viewcore_W32", "", 18).Click();
          break;
       case "imprimir":  // Print
          rootWindow.Window("ui60Viewcore_W32", "", 17).Click();
          break;
       case "limpiar_forma": // Clean form
          rootWindow.Window("ui60Viewcore_W32", "", 16).Click();
          break;
       case "cancelar_todo": // Cancell all
          rootWindow.Window("ui60Viewcore_W32", "", 15).Click();
          break;
       case "buscar": // Search
          rootWindow.Window("ui60Viewcore_W32", "", 14).Click();
          break;
       case "insetar_registro": // Insert log
          rootWindow.Window("ui60Viewcore_W32", "", 13).Click();
          break;
       case "borrar_registro": // Delete log
          rootWindow.Window("ui60Viewcore_W32", "", 12).Click();
          break;
       case "limpiar_registro":  // print log
          rootWindow.Window("ui60Viewcore_W32", "", 11).Click();
          break;
       case "bloque_anterior": // Previous block
          rootWindow.Window("ui60Viewcore_W32", "", 10).Click();
          break;
       case "registro_anterior": // previous record
          rootWindow.Window("ui60Viewcore_W32", "", 9).Click();
          break;
       case "siguiente_registro": // next record
          rootWindow.Window("ui60Viewcore_W32", "", 8).Click();
          break;
       case "siguiente_bloque":  // next block
          rootWindow.Window("ui60Viewcore_W32", "", 7).Click();
          break;
       case "lista_de_valores": // list of values
          rootWindow.Window("ui60Viewcore_W32", "", 6).Click();
          break;
       case "editar_campo": // Edit field
          rootWindow.Window("ui60Viewcore_W32", "", 5).Click();
          break;
       case "menu_principal": // Main menu
          rootWindow.Window("ui60Viewcore_W32", "", 4).Click();
          break;
       case "calculadora": // Calculator
          rootWindow.Window("ui60Viewcore_W32", "", 3).Click();
          break;
       case "ayuda": // Help
          rootWindow.Window("ui60Viewcore_W32", "", 2).Click();
          break;
       case "salir": // Exit
          rootWindow.Window("ui60Viewcore_W32", "", 1).Click();
          break;
    }
}

function clickPlanButton(buttonName)
{ var MDI = getMDIWindow(determineForm(), "Saludcore");
  var rootWindow = MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootWindow.Button(buttonName).Click();
}

function clickComprobacionDerechosButton(buttonName)
{ var MDI = getMDIWindow(determineForm(),"Comprobacion Derechos");
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button(buttonName).Click();
}

function clickOpcionesRadioButton(buttonName)
{ var MDI = getMDIWindow(determineForm(), "OPCIONES");
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).RadioButton(buttonName).Click();
}

function clickOpcionesButton(buttonName)
{ var MDI = getMDIWindow(determineForm(), "OPCIONES");
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button(buttonName).Click();
}

function clickMantenimientoDeReclamaciones(buttonName)
{ var MDI = getMDIWindow(determineForm(), "Mantenimiento De Reclamaciones");
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button(buttonName).Click();
}

function clickDiagnosticEnReporteButton(buttonName)
{ var MDI = getMDIWindow(determineForm(), "Diagnosticos en Reporte Hospitalizacion");
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Button(buttonName).Click();
}

function clickCoberturasDeSaludButton(buttonName)
{
  var MDI = getMDIWindow(determineForm(), "Coberturas de Salud");
  entity = "Button*" + buttonName + ")";
  // var rootObject = MDI.Window("ui60Drawn_W32", "", 1).FindChild("Name", entity, 2);
  var rootObject = MDI.Window("ui60Drawn_W32", "", 1).FindChild("Name", "Button(*" + buttonName + ")", 2);
  rootObject.Click();
}

function  clickSeleccionDeReclamacionesButton(buttonName)
{
  var formObject, rootObject, entity;
  formObject = determineForm();
  entity = "Button*" + buttonName + ")";
  rootObject = formObject.Panel("Workspace").FindChild("Name", entity, 7);
  if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + rootObject.FullName);
  rootObject.Click();
 // formObject.Panel("Workspace").MDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Button("Aprobación QC").Click();
}

function goToMain()
{ // backtrack to Menu Principal
   var loopCount = 0; var  value = ""; var item = "";
   while (loopCount <= 10)
   {
        var formObject = determineForm();
        var MDIMenuPrincipal = getMDIWindow(formObject, "Menu Principal");
        if(MDIMenuPrincipal.Visible) { return true;}           
        Log.Enabled = false;
        if (formObject.MenuBar("Application").MenuItem("Action").Exists)     
        { value = "Action";  item = "Exit";}
        else
        {
          if (formObject.MenuBar("Application").MenuItem("Accion").Exists)           
          { value = "Accion"; item = "Salir";}
          else
          {
            if (formObject.MenuBar("Seguros de Personas").MenuItem("Action").Exists) 
            { value = "Action"; item = "Exit";}
          }
        }          
        Log.Enabled = true;
        formObject.MenuBar("Application").MenuItem(value).Click(); 
        var exitmenu = Sys.Process("ifrun60").Popup(value).MenuItem(item);
        if(exitmenu.Enabled) exitmenu.Click();
        else
        { 
           Log.Warning("The exit menu item is not enabled. Exiting from saludecoreToolbar: Salir");
           exitForm(formObject);
           return true;
        } 
        // Potential dialog: Save before exit?
        var popupMSG = MENSAJE_ALERTA("Desea salvor los cambios antes de salir?", 0, "NO", 0);
        loopCount++;
   }
   Log.Error("Exceeded goToMain loop range"); return false;
}

function extractNextString(inputString, inputValue)
{
   upperInputSring = aqString.ToUpper(inputString);
   upperInputValue = aqString.ToUpper(inputValue);
   valueLength = aqString.GetLength(upperInputValue);
   inputLength = aqString.GetLength(upperInputSring);
   position = aqString.Find(upperInputSring, upperInputValue);
   
   newSubstring = aqString.SubString(upperInputSring, position + valueLength + 1, inputLength);
   var position = aqString.Find(newSubstring, " ");
   if (position == -1) position = aqString.GetLength(newSubstring);     
   return aqString.SubString(newSubstring, 0, position);
}

function getMDIWindow(form, MDIname)
{  if (MDIname == "MDI_Payment") { var name = ""; } else { name = MDIname;} 
   if (name != "")
   {var mdi = form.Panel("Workspace").MDIWindow(name+"*");}
   else
   {var mdi = form.Panel("Workspace").MDIWindow("Aplicación de Pagos").Window("ui60MDIdocument_W32", " ", 1);}
   if (mdi.Exists) Log.Message("MDIWindow: " + mdi.FullName);
   return mdi;
}

function closeMDIWindow(MDIwin, expected)
{ // Close by clicking on "X".
   if ( expected <= 0 ) {Log.Enabled = false;}
   var button = MDIwin.TitleBar(0).Button("Close");
   Log.Enabled = true;
   if (button.Exists) { MDIwin.TitleBar(0).Button("Close").ClickButton(); return;}
   if( expected > 0 ) { Log.Error("Close button not found. Window:" + MDIwin.FullName);}
}

function MDICliente_RelacionDeDependiente(AddORDelete)
{ // pencil icons in the middle of the form
   var MDIClientes = getMDIWindow(determineForm(), "Mantenimiento De Clientes");
   var rootwindow = MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   if (AddORDelete) 
   { // Add dependents
      rootwindow.Window("ui60Viewcore_W32", "", 7).Click(); 
      // Expected Dialog: Are you sure you want to enable the capture dependendiente
      var popupMSG = MENSAJE_DE_ALERTA("Esta seguro que desea activar la capture dependendiente", 0, "Si", 0);
      var popupMSG = MENSAJE_INFORMATIVO("Captura Dependendiente Activada", 0, "OK", 0);
   }
   else
   { // Delete dependents
      rootwindow.Window("ui60Viewcore_W32", "", 6).Click();
      // Expected Dialog: Are you sure you'd like to clear the massive capture dependent?
      var popupMSG = MENSAJE_DE_ALERTA("Esta seguro que desactivar la captura dependiente masiva?", 0, "Si", 0);
      var popupMSG = MENSAJE_INFORMATIVO("Captura Dependendiente Desactivada", 0, "OK", 0);
   }
}

function MDICliente_icon_Dirrecion()
{ // clicking on Direcion icon to enter address info 
    var MDIClientes = getMDIWindow(determineForm(), "Mantenimiento De Clientes");
    MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 21).Click();
    var popupMSG = MENSAJE_DE_ALERTA("Cliente con el apellido...", 0, "Si", 0);
    var popupMSG = MENSAJE_INFORMATIVO("Accept Modifications?", 0, "OK", 0); 
    return getMDIWindow(determineForm(),"Mantenimiento de Direcciones"); 
}

function MDICliente_icon_Telefono()
{ // clicking on Telefono icon to enter telephone info 
    var MDIClientes = getMDIWindow(determineForm(),"Mantenimiento De Clientes");
    MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 20).Click();
    aqUtils.Delay(400);
    return getMDIWindow(determineForm(),"Mantenimiento De Telefonos"); 
}

function icon_ConsultarAfiliado()
{ // clicking on Convertir Persona A Afiliado icon (the group)  
   var MDIClientes = getMDIWindow(determineForm(), "Mantenimiento De Clientes");
   MDIClientes.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 25).Click(); 
   return MDICrearAfiliado = getMDIWindow(determineForm(), "Crear Afiliado"); 
}

function icon_ConsultarABeneficiario(primary)
{ // clicking on Convertir/Consultar A Beneficiario icon (the blond man in black suite with a money bag) to make a beneficiery 
   var MDIConsulta = getMDIWindow(determineForm(), "Consulta");
   MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 8).Click();
   // Launches the next window for primary applicants. Displays various dialogs otherwise.  
   if (primary == 0) {return getMDIWindow(determineForm(), "Mantenimiento Beneficiarios");}
   return null; 
}

function icon_informacionMedica()
{ // clicking on Informacion Medica icon (the white and blue doctor) to add doctors' info 
   var MDIConsulta = getMDIWindow(determineForm(), "Consulta");
   MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 7).Click();
   return getMDIWindow(determineForm(), "Información Médica"); // MDIConsulta;
}

function icon_infoSegMedicosAdicional()
{ // clicking on Informacion Segurados Medicos Adicional icon (the young boy with i) to add additional info
   var MDIConsulta = getMDIWindow(determineForm(),"Consulta");
   MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 6).Click();
   return getMDIWindow(determineForm(), "Mantenimiento ASEGURADO_SEGURO_MEDICO_ADICIONAL");
}

function icon_PantalaAnterior()
{ // clicking on Pantala Anterior (Previous Screen) icon (the door icon) 
   var MDIConsulta = getMDIWindow(determineForm(), "Consulta");
   MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 3).Click();
   return getMDIWindow(determineForm(), "Mantenimiento De Solicitudes");
}

/*
function MDIConsulta_icon_Requisitos()
{// clicking on Requisitos icon (the open book)
   var MDIConsulta = getMDIWindow(determineForm(), "Consulta");
   MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 4).Click();
   return getMDIWindow(determineForm(), "Mantenimiento De*");
}
*/
function MDIConsulta_icon_Requisitos()
{// clicking on Requisitos icon (the open book)
   var MDIConsulta = getMDIWindow(determineForm(), "Consulta Estructura de Afiliado");
   MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 4).Click();
   return getMDIWindow(determineForm(), "Mantenimiento de Requisitos de Afiliados");
}   


function icon_FileServer(MDIConsulta) // Fileserver icon
{ 
    MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 2).Click();
    selectApprovePolicyClickBox(1);
    return getMDIWindow(determineForm(),"Emision de Polizas");
}


function MDIConsulta_icon_Generar(mdi) // Fileserver icon
{   
    mdi.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 2).Click();
    return getMDIWindow(determineForm(),"Emision de Polizas");
}

function calendar(viewcore, value, nextkey)
{
   viewcore.Click();
   // Allow for multiple calendar instances
   var root = Sys.Process("ifrun60");
   var str = root.FullName + ".Dialog(\"Calendar\"*.Button(\"Cancel\")";
   root.FindChild("FullName", str, 4).ClickButton();  // Cancel on calendar
   
   var rootWindow = viewcore.Parent;
   rootWindow.Window("Edit", "", 1).Keys(value);
   if (nextkey != "") {rootWindow.Window("Edit", "", 1).Keys(nextkey);}
}

function selectByClickitem(comboBox, value, nextkey)
{
   comboBox.ClickItem(value);
   if (nextkey != "") {comboBox.Text(0).Keys(nextkey);}
}

function enterText(editBox, value, nextkey)
{
   editBox.SetText(value);
   if (nextkey != "") {comboBox.Text(0).Keys(nextkey);}
}

function enterKeys(editBox, value, nextkey)
{
   editBox.Keys(value);
   if (nextkey != "") {comboBox.Text(0).Keys(nextkey);}
}

function executeCmd(command)
{
  var process = dotNET.System_Diagnostics.Process.Start_3("cmd","/c "+command);
  process.WaitForExit(); 
}

function executeCmd2(command)
{
  //var process = dotNET.System_Diagnostics.Process.Start_3("cmd","/c "+command);
  var process = dotNET.System_Diagnostics.Process.Start_3("wscript.exe",command);
  
  /*
  var process = dotNET.System_Diagnostics.Process.Start_2("cmd");
  
  var p, w, txt, cnt, i, s; 
  p = Sys.Process("cmd"); 
  w = p.Window("ConsoleWindowClass", "*"); 
  w.Keys(command); 
  txt = w.wText; 
  aqString.ListSeparator = "\r\n"; 
  cnt = aqString.GetListLength(txt); 
  for (i = 0; i < cnt; i++) 
  { 
    s = aqString.GetListItem(txt, i); 
    Log.Message(s); 
  }
  */
  /*
  var SecurityWarning = Sys.Process("cmd").Dialog("Open File - Security Warning");
  if (SecurityWarning.Exists) { Sys.Keys("O");
  Sys.Keys("O");
  // SecurityWarning.Button("Open").Click();
  }
  else { Log.Warning("No Security Warning");}
  */
  
  //Sys.Process("EXCEL").Popup("Microsoft Excel").Button("Yes").Click();
  
  process.WaitForExit(); 
}

/// Test Stubs

