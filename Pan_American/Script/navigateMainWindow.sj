//USEUNIT excelUtilities
//USEUNIT utilities

/// Scriptfile: navigateMainWindow
/// Last update: May 8 

function mainMenuMap(firstColumn, treeItem)
{
var sheetFirstColumn = new Array( 1,  2,  2,  3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  5,  5,  5,  6,  6,  6);
var sheetTreeItem =    new Array( 1,  1,  2,  1,  2,  3,  4,  5,  6,  7,  1,  2,  3,  1,  2,  3,  1,  2,  3);
var scrollRequired =   new Array("n","n","n","n","n","n","n","n","n","y","n","n","y","y","y","n","y","y","n");
var menuCount =        new Array( 0,  0,  0,  0,  0,  0,  0,  0,  0,  12, 0,  0,  27, 16, 20, 0,  58, 20, 0);
var scrollCount =      new Array( 0,  0,  0,  0,  0,  0,  0,  0,  0,  8,  0,  0,  17, 8,  13, 0,  17, 13, 0);
var beforeCount =      new Array( 0,  0,  0,  0,  0,  0,  0,  0,  0,  6,  0,  0,  10, 12, 11, 0,  12, 11, 0);
var afterCount =     new Array( 0,  0,  0,  0,  0,  0,  0,  0,  0,  12, 0,  0,  13, 11, 12, 0,  13, 12, 0);
var newTreeItem =      new Array( 0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0);

   var count = sheetFirstColumn.length;
   for (var i=0; i < count; i++)     
   {
      if ((firstColumn == sheetFirstColumn[i]) || (treeItem == sheetTreeItem[i]))
      { 
         addProjectVariable("scrollRequired" , "string", scrollRequired[i]);
         addProjectVariable("menuCount" , "integer", menuCount[i]);
         addProjectVariable("scrollCount" , "integer", scrollCount[i]);
         addProjectVariable("beforeCount" , "integer", beforeCount[i]);
         addProjectVariable("afterCount" , "integer", afterCount[i]);
         addProjectVariable("newTreeItem" , "integer", newTreeItem[i]);
         return i;
      }
   }
   return -1;  // No valid entry
}

function updateMainMenuData()
{
  /*
  var GetMenu = "sqlplus "+Project.Variables.username+"/"+Project.Variables.password+"@"+Project.Variables.ambiente+" @'\\\\pera\\Documentos\\TCScripts\\Opciones.sql' [Enter]"; 
  var process = dotNET.System_Diagnostics.Process.Start_3("cmd","/c "+GetMenu);
  process.WaitForExit(); 
  */
  executeCmd("del \\\\Pera\\Documentos\\TCScripts\\main_menu_config.xls");
  executeCmd("echo sqlplus "+Project.Variables.username+"/"+Project.Variables.password+"@"+Project.Variables.ambiente+" @'\\\\pera\\Documentos\\TCScripts\\Opciones.sql' Project.Variables.username "+  +" "+Project.Variables.countryCode+" [Enter]");
  executeCmd("sqlplus "+Project.Variables.username+"/"+Project.Variables.password+"@"+Project.Variables.ambiente+" @\\\\pera\\Documentos\\TCScripts\\Opciones.sql '"+ aqString.Quote("AAGUAS")+"' '1' [Enter]");
  
  var Executable = "\\\\pera\\Documentos\\TCScripts\\csv2xls.vbs";
  var From = "\\\\pera\\Documentos\\TCScripts\\main_menu_config.csv";
  var TempTo = "\\\\pera\\Documentos\\TCScripts";
  var To = "C:\\\\Users\\Simetri\\Desktop\\SIMETRICA\\Test Complete\\Proyectos\\Pan_American_Nov07\\Pan_American\\Pan_American\\Stores\\Files";
  var Separator  = " , ";
  var Finish = "[Enter]";
  
  executeCmd2(Executable + " " + From + " " + TempTo + Separator + Finish);
  executeCmd("ROBOCOPY "+TempTo+" "+aqString.Quote(To)+" main_menu_config.xls /xx /log+:log.txt");
  executeCmd("del \\\\Pera\\Documentos\\TCScripts\\main_menu_config.*");
}


//// Mantenimiento menu selection x coordinate  & y coordinate calculations
function MenuPrincipalBaseItems() { return 10;}
function MenuPrincipalMaxItems() { return 6;}
function MantenimientoMaxItems() { return 13;} 
function MantenimientoBaseCoord(treeItem)
{ return  MenuPrincipalMaxItems() * treeItem + MenuPrincipalBaseItems() * (treeItem - 1); }
function Mantenimiento_ycoord (treeItem, itemNumber) 
{ return  MantenimientoBaseCoord(treeItem)  + itemNumber * (MenuPrincipalMaxItems() + MenuPrincipalBaseItems()  + 1);} 
function MantenimientoTree_xcoord() { return 7;}
function MantenimientoSubtree_xcoord() { return 78;} 

////
function selectSubTreeItem(treeItem, itemNumber)
{
  expandMantenimientos(treeItem);  
  clickSubTreeItem(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
}

function MenuPrincipal(section)
{
   var menuList = new Array("Planes", "Proveedores", "Suscripcion", "Reclamacion", "Finanzas", 
      "Administracion", "Creditors", "Salir", "Mantenimiento", "Reportes");
   
   addProjectVariable("MenuPrincipalItemCount" , "integer", menuList.length);
   
   for (var i=0; i < menuList.length; i++)
   { if (section == menuList[i]) return selectActionBox(i + 1);}
   Log.Error("Unsupported section name: " + section);
   return NEGATIVE;
}

function Mantenimiento_PlanesSuscripcion(item)
{
   var menuList = new Array("Solicitudes", "Polizas", "Asegurados", "Clientes", "Agentes", "ServicioAlCliente", "ReportePALIGPC");
      
   if (MenuPrincipal("Planes") == NEGATIVE) return NEGATIVE;
   if (MenuPrincipal("Suscripcion") == NEGATIVE) return NEGATIVE;
   for (var idx=0; idx  < menuList.length; idx++) 
   { if (item == menuList[idx]) return idx + 1;}
   return NEGATIVE;
}

function MantenimientoPolizasMenu(section)
{
   var menuList = new Array("Cambio Fecha de Version", "Cambio Masivo de Primas", "Cambio de Poliza Masivo", "Consulta de Polizas",
   "Emission dePoliza", "Estado de Cuenta de Clientes", "Facturas Y Creditos de Ajuste", "Generacion Documentos para Poliza", 
   "Mantenimiento De Pólizas", "Reporte Desscuentos de Primas", "Seleccion de Polizas...", "Servicio al Cliente");
   
   var menuCount = menuList.length;
   var itemNumber = 0; while (itemNumber < menuCount) { if (section == menuList[itemNumber]) break; itemNumber++;}   
   if ( itemNumber >= menuCount) {Log.Error("Invalid menu item: " + section); return false;}
   
   var treeItem = Mantenimiento_PlanesSuscripcion("Polizas"); if (treeItem == NEGATIVE) { return false;} 
   // expandMantenimientos(treeItem);  
   // clickSubTreeItem(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
   selectSubTreeItemTest(treeItem, itemNumber);
   return true; 
}

function Mantenimiento_PlanesReclamacion(item)
{
   var menuList = new Array("Reclamaciones", "ReportesDeReclamaciones","RepostesDeHospitalizacion");
   if (MenuPrincipal("Planes") == NEGATIVE) return NEGATIVE;
   if (MenuPrincipal("Reclamacion") == NEGATIVE) return NEGATIVE; 
   for (var idx=0; idx  < menuList.length; idx++) 
   { if (item == menuList[idx]) return idx + 1;}
   return NEGATIVE;
}

function MantenimientoReclamaciones(section)
{
   //var treeItem = Mantenimiento_PlanesReclamacion("Reclamaciones"); if (treeItem == NEGATIVE) { return false;} 
   
   var menuList = new Array("Actulizacion", "Cargos", 
      "CompDeDerecho", "CompDeReembolos", "CompDeDerechos", "CompDeDerechosmodoConsulta", 
      "ConsultaDeMedicos", "ConsultaDeNCF", 
      "EnvioArchivos", "EnvioSoportes", "EnvioDeSoporte", "EnvioDeComun", 
      "Estado1", "Estado2", "Generacion", 
      "ManDeComun", "ManDeMotivos", "ManDeRezonesEstatus","ManDeRezonesMod", "ManDeRecl", 
      "Notas", "PaGOS", "Pase", "PreCert", "ReclRepet", "Seleccion", "Solicitudes");
   
   var menuCount = menuList.length;
   var itemNumber = 0; while (itemNumber < menuCount) { if (section == menuList[itemNumber]) break; itemNumber++;}   
   if ( itemNumber >= menuCount) {Log.Error("Invalid menu item:" + section); return false;}
   
   var treeItem = Mantenimiento_PlanesReclamacion("Reclamaciones"); if (treeItem == NEGATIVE) { return false;}  
   // expandMantenimientos(treeItem);  
   // clickSubTreeItem(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
   selectSubTreeItemTest(treeItem, itemNumber);
   return true; 
}

function MantenimientoDeClientes(section)
{
   var menuList = new Array("Clientes", "ManDeGrupo");
      
   var menuCount = menuList.length;
   var itemNumber = 0; while (itemNumber < menuCount) { if (section == menuList[itemNumber]) break; itemNumber++;}   
   if ( itemNumber >= menuCount) {Log.Error("Invalid menu item:" + section); return false;}
   
   var treeItem = Mantenimiento_PlanesSuscripcion("Clientes"); if (treeItem == NEGATIVE) { return false;}
   // expandMantenimientos(treeItem);  
   // clickSubTreeItem(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
   selectSubTreeItemTest(treeItem, itemNumber);
   return true; 
}

function Mantenimiento_PlanesFinanzas(item)
{
   var menuList = new Array("ProcesosCobros", "ConsultaDeCobrosClientes", "ProcesoComision", "Reportes de Cobros", "Reportes");
   
   if (MenuPrincipal("Planes") == NEGATIVE) return NEGATIVE;
   if (MenuPrincipal("Finanzas") == NEGATIVE) return NEGATIVE;
   for (var idx=0; idx  < menuList.length; idx++) 
   { if (item == menuList[idx]) return idx + 1;}
   return NEGATIVE;
}

function MantenimientoProcesosCobros(section)
{
   var menuList = new Array("AplicacionDePagos", "AplicacionDePagosMondaExtra", "CancelacionReciboDias", 
      "CancelacionDeRecibo", "Cheque", "CobroCon", "CobrosDiarios", "ConsultaSuspension", "CuadreDeCaja", 
      "DepositoDeDinero", "DepositoDeDineroMondaExtra", "FacturasYCreditos", "GestionDeCobros", "ImpresionEstados", "ManejoDeGestion", 
      "OtrosIngresos", "ReclasificationDeBalance", "SolicitudeDeCheque", "TransferenciaAuto", "TransferenciaPrima");
      
   var menuCount = menuList.length;
   var itemNumber = 0; while (itemNumber < menuCount) { if (section == menuList[itemNumber]) break; itemNumber++;}   
   if ( itemNumber >= menuCount) {Log.Error("Invalid menu item:" + section); return false;}
   
   var treeItem = Mantenimiento_PlanesFinanzas("ProcesosCobros"); if (treeItem == NEGATIVE) { return false;}
   // expandMantenimientos(treeItem);  
   // clickSubTreeItem(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
   selectSubTreeItemTest(treeItem, itemNumber);
   return true; 
}

function Mantenimiento_SuscripcionPlanes(item)
{
   var menuList = new Array("PlanesDeSalud");
   
   if (MenuPrincipal("Suscripcion") == NEGATIVE) return NEGATIVE;
   if (MenuPrincipal("Planes") == NEGATIVE) return NEGATIVE;
   for (var idx=0; idx  < menuList.length; idx++) 
   { if (item == menuList[idx]) return idx + 1;}
   return NEGATIVE;
}

function MantenimientoPlanesDeSalud(section)
{
   var menuList = new Array("MantenimientoCategoria", "MantenimientoPlanesDeSalud");
      
   var menuCount = menuList.length;
   var itemNumber = 0; while (itemNumber < menuCount) { if (section == menuList[itemNumber]) break; itemNumber++;}   
   if ( itemNumber >= menuCount) {Log.Error("Invalid menu item:" + section); return false;}
   
   var treeItem = Mantenimiento_SuscripcionPlanes("PlanesDeSalud"); if (treeItem == NEGATIVE) { return false;}
   // expandMantenimientos(treeItem);  
   // clickSubTreeItem(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
   selectSubTreeItem(treeItem, itemNumber);
   return true; 
}

function selectActionBox(boxNumber)
{   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "selectActionBox" + boxNumber);   
    var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");
    var wnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1);
    var buttonObject = wnd.FindChild("name", "Window*, 10)", 2);
    var buttonObject = buttonObject.Parent;
    buttonObject.Window("ui60Viewcore_W32", "", (10 - (boxNumber -1))).Click();
}

function expandMantenimientos(treeItem)
{
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "expandMantenimientos" + treeItem); 
   var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");
   var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1);
   var buttonObject = rootWnd.FindChild("name", "Window*, 10)", 2);
    
   buttonObject = buttonObject.Parent;          
   buttonObject.Window("ui60Viewcore_W32", "", 2).Click(); // Click on Mantenimientos
   
   var wnd = rootWnd.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Viewcore_W32", "", 1);
   // var ycoord = MantenimientoBaseCoord(treeItem);
   wnd.Click(MantenimientoTree_xcoord(), MantenimientoBaseCoord(treeItem));  // Click on the treeItem's expander
   // return ycoord;
}
 
function clickSubTreeItem(treeItem, itemNumber, itemsToScroll)
{
  var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");
  var maxitems = MenuPrincipalMaxItems(); var maxLineDown = 4; 
  if (treeItem > maxitems)
  { 
     for (var i =0; i < maxLineDown; i++)
     { MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 2).Button("Line down").Click();}
     remainingItemsToScroll = itemsToScroll - maxLineDown;
     clickSubTreeItem(maxLineDown, itemNumber, remainingItemsToScroll);
     return;
  }
   if (treeItem != maxLineDown) { var itemNum = itemNumber;} 
   else { var itemNum = itemNumber + 1;}
   var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Viewcore_W32", "", 1);
   rootWnd.DblClick(MantenimientoSubtree_xcoord(), Mantenimiento_ycoord (treeItem, itemNum));
   // return true;
}

function clickSubTreeItemTest(treeItem, itemNumber, itemsToScroll)
{
  var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");
  var maxitems = MantenimientoMaxItems() // MenuPrincipalMaxItems(); 
  var maxLineDown = 7; 
  if (itemsToScroll > maxitems)
  { 
     for (var i =0; i < maxLineDown; i++)
     { MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 2).Button("Line down").Click();}
     remainingItemsToScroll = itemsToScroll - 5;
     remainingTreeItems = treeItem - 5;
     if(remainingTreeItems < 0)
     remainingTreeItems = 0;
     
     clickSubTreeItemTest(remainingTreeItems, itemNumber-5, remainingItemsToScroll);
     return;
  }
   if (treeItem != maxLineDown) { var itemNum = itemNumber;} 
   else { var itemNum = itemNumber + 1;}
   var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Viewcore_W32", "", 1);
   rootWnd.DblClick(MantenimientoSubtree_xcoord(), Mantenimiento_ycoord (treeItem, itemNum));
   // return true;
}

function selectSubTreeItemTest(treeItem, itemNumber)
{
  expandMantenimientos(treeItem);  
  clickSubTreeItemTest(treeItem, itemNumber + 1, treeItem + itemNumber + 1);
}


function clickSubTreeItem1(firstColumn, treeItem, itemNumber)
{
    if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "clickSubTreeItem1");
    var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");     
    mainMenuMap(firstColumn, treeItem);
    localTreeItem = treeItem;
    localScrollCount = Project.Variables.scrollCount;
    localItemNumber = itemNumber;
    
    if ((aqString.Find(Project.Variables.scrollRequired, "y") > -1) && (itemNumber> Project.Variables.beforeCount) )
    {
      localTreeItem = Project.Variables.newTreeItem;
      if ( itemNumber > Project.Variables.afterCount)
      {
          remainderItems = itemNumber - Project.Variables.beforeCount;
          factor = Math.floor(remainderItems/Project.Variables.afterCount);
          remainder =   remainderItems%Project.Variables.afterCount;
          if ((((factor + 1)*Project.Variables.afterCount) + Project.Variables.beforeCount) > Project.Variables.menuCount)
          { localItemNumber = Project.Variables.afterCount - (Project.Variables.menuCount - itemNumber);} 
          else
          { localItemNumber = remainderItems - (Project.Variables.afterCount* factor);}
          
          localScrollCount = Project.Variables.scrollCount + (Project.Variables.scrollCount* factor);
      }
      for (var i = 0; i < localScrollCount; i++)
      {
         Log.Enabled = false; 
         MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 2).Button("Line down").Click();
         Log.Enabled = true; 
      }
    } 
    
    var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Viewcore_W32", "", 1);
    var basecoord = Mantenimiento_ycoord(localItemNumber);
    rootWnd.DblClick(MantenimientoSubtree_xcoord(), Mantenimiento_ycoord (localTreeItem, localItemNumber));
}


function expandTree2(treeItem)
{  
    
   if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "expandTree" + treeItem); 
   var maxitems = 6; baseitems = 10; xcord = 7; 
   var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");
   var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1);
   var buttonObject = rootWnd.FindChild("name", "Window*, 10)", 2);
   buttonObject = buttonObject.Parent;          
   buttonObject.Window("ui60Viewcore_W32", "", 2).Click();
   

    if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "clickSubTreeItem1");
    var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");     
    var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Viewcore_W32", "", 1);     //wnd = Sys.Process("ifrun60").Seguros_de_Personas_Menu_Principal_.Panel("Workspace").Menu_Principal.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32").Window("ui60Viewcore_W32");
    
    var maxitems = 6; baseitems = 10; xcord = 17; 
    rootWnd.Click(xcord, ((maxitems * 1)));
    
    for (var i = 1; i < treeItem; i++)
    {
       Log.Enabled = false; 
       rootWnd.Keys("[Down]");
       Log.Enabled = true; 
    }
    
    rootWnd.Keys("[Enter]");   
}


function clickSubTreeItem2(posicionSubMenu)
{
    if (Project.Variables.TRACE) Log.Checkpoint("TRACE:" + "clickSubTreeItem1");
    var MDIMenuPrincipal = getMDIWindow(determineForm(), "Menu Principal");     
    var rootWnd = MDIMenuPrincipal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Viewcore_W32", "", 1);     //wnd = Sys.Process("ifrun60").Seguros_de_Personas_Menu_Principal_.Panel("Workspace").Menu_Principal.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32").Window("ui60Viewcore_W32");
    
    for (var i = 0; i < posicionSubMenu; i++)
    {
       Log.Enabled = false; 
       rootWnd.Keys("[Down]");
       Log.Enabled = true; 
    }
    
    rootWnd.Keys("[Enter]");
}

function MantenimientosMenu(MDIWindow)
{
   switch (MDIWindow)
   {
      case "newBusinessWindow":
      { MenuPrincipal("Planes"); MenuPrincipal("Suscripcion"); 
      }
      break;
      case "makePaymentForm":
      { MenuPrincipal("Planes"); MenuPrincipal("Finanzas"); } // used to be 3); 
      break;
      case "retrievePolicyPage":
      { MenuPrincipal("Planes"); MenuPrincipal("Suscripcion");}
      break;
      case "retrievePlanPage":
      { MenuPrincipal("Suscripcion"); MenuPrincipal("Planes");}
      break;
      case "claimForm":
      { MenuPrincipal("Planes"); MenuPrincipal("Reclamacion"); }
      break;
      case "qualityControlForm":
      { MenuPrincipal("Planes"); MenuPrincipal("Reclamacion"); }
      break;
      case "retreiveSolicitudesPage":
      { MenuPrincipal("Planes"); MenuPrincipal("Suscripcion"); }
      break;
      //////
      case "Mantenimiento De Clientes": { MenuPrincipal("Planes"); MenuPrincipal("Suscripcion"); }
      break;
      case "MDI_Payment": { if (!MantenimientoProcesosCobros("AplicacionDePagos")) { return null;}}
      break;
      case "Mantenimiento De Pólizas": { MenuPrincipal("Planes"); MenuPrincipal("Suscripcion"); }
      break;
      case "Saludcore": { if (!MantenimientoPlanesDeSalud("MantenimientoPlanesDeSalud")) { return null;}}
      break;
      case "Comprobacion Derechos": { MenuPrincipal("Planes"); MenuPrincipal("Reclamacion"); } //if (!MantenimientoReclamaciones("CompDeDerechos")) { return null;} 
      break;
      case "Seleccion de Reclamaciones":
      { MenuPrincipal("Planes"); MenuPrincipal("Reclamacion"); } //if (!MantenimientoReclamaciones("CompDeDerechos")) { return null;} 
      /*{ // MenuPrincipal("Planes"); MenuPrincipal("Reclamacion"); expandMantenimientos(3); clickSubTreeItem1(4, 3,26);
         if (!MantenimientoReclamaciones("Seleccion")) { return null;}} */
      break;
      case "Mantenimiento De Solicitudes":
      { var treeItem = Mantenimiento_PlanesSuscripcion("Solicitudes"); if (treeItem == NEGATIVE) return null; 
        expandMantenimientos(treeItem); clickSubTreeItem(treeItem,1);                
         // var MenuPrincipal("Planes"); MenuPrincipal("Suscripcion"); expandMantenimientos(5); clickSubTreeItem(5,1);
      }
      break;
      default: { Log.Error("Unsupported section name: " + section); return null;}
   }
   
   for (var pvrow = 0; pvrow < Project.Variables.mainMenuInfo.RowCount; pvrow++)
   {
      //Log.Error(Project.Variables.mainMenuInfo(0,pvrow));
      if (Project.Variables.mainMenuInfo(0,pvrow) == MDIWindow)
      {
        expandTree2(Project.Variables.mainMenuInfo(1, pvrow));
        clickSubTreeItem2(Project.Variables.mainMenuInfo(2, pvrow));
      }
   }
   
    return true;
   //return getMDIWindow(determineForm(), MDIWindow);
}


/// Test Stubs

function test_MantenimientosMenu()
{
   var tmp = MantenimientosMenu("Mantenimiento De Clientes"); return;
   var tmp = MantenimientosMenu("MDI_Payment"); return;
   var tmp = MantenimientosMenu("Mantenimiento De Pólizas"); return;
   var tmp = MantenimientosMenu("Saludcore"); return;
   var tmp = MantenimientosMenu("Comprobacion Derechos"); return;
   var tmp = MantenimientosMenu("Seleccion de Reclamaciones"); return;
   var tmp = MantenimientosMenu("Mantenimiento De Solicitudes");
}

function test_MenuPrincipal()
{
   var menuList = new Array("Reportes", "Mantenimiento", "Salir", "Creditors", "Administracion", "Finanzas", 
   "Reclamacion", "Suscripcion", "Proveedores", "Planes");
   
   for (var i=0; i < menuList.length; i++)
   { Log.Message(menuList[i] + " : " + MenuPrincipal(menuList[i]));}
}
