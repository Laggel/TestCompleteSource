//USEUNIT utilities
//USEUNIT excelUtilities
//USEUNIT navigateMainWindow
//USEUNIT policySection

/// Script File: paymentSection
/// Last update: May 29

function paymentButtons(rootwindow) { return rootwindow.Window("ui60Drawn_W32", "", 1);}

function setPaymentValues()
{  /// TODO....Replace this with a reader from spreadsheet.
   /// HARDCODED Payment info
   var myfields = new Array("FormaDeCobro", "EconomicUnits", "Doc", "Bank", "PorDistribuir", "MontoACobrar");
   var pvname = "paymentInfo"; 
   var columnCount = addProjectVariableTable(pvname, myfields);  
   var pvrow = addProjectVariableRow(pvname);
   var pvcol = 0; Project.Variables.VariableByName(pvname)(pvcol, pvrow) = "CHEQ";
   pvcol++; Project.Variables.VariableByName(pvname)(pvcol, pvrow) = "1";  // first selection
   pvcol++; Project.Variables.VariableByName(pvname)(pvcol, pvrow) = "99"; // doc#
   Project.Variables.VariableByName(pvname)(pvcol, pvrow) = "1"; //Banco no parameterized
}

function exit_LISTA_DE_UNIDADES_ECONOMICAS(rootwindow)
{ /// TODO....Replace ...
  // var rootwindow = Sys.Process("ifrun60").Form("ARS (JRAP) - [ ]").Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32", "", 1);
  var compania = rootwindow.FindChild("Name", "Window(\"Edit*", 2);
  if (compania.Exists) { compania.Keys("[Tab]");}
}

function  LISTA_DE_FORMAS_DE_PAGO(rootwindow, pvcol, pvrow)
{
//     var cobro = rootwindow.Window("ui60Drawn_W32", "", 2);
     var cobro = rootwindow;
//     Log.Enabled = false; var cobroEdit = cobro.Window("Edit", "", 1); Log.Enabled = true;
//     if (!cobroEdit.Exists) return;
     
     // FormaDeCobro...for LISTA DE FORMAS DE PAGO
        // Sometimes the first row is prepopulated and the dialog is 
        // popped up as soon as the cursor is moved to this section
        // rootWindow.Window("Edit", "", 1).Keys(Project.Variables.paymentInfo(formaPVcol, pvrow));
        // rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        // exit_LISTA_DE_UNIDADES_ECONOMICAS(rootwindow); 
        cobro.Keys("[F9]");
        var tmp = selectGriditemByName("LISTA DE", 0, Project.Variables.paymentInfo(pvcol, pvrow));
        Log.Message("LISTA DE FORMAS DE PAGO:" + Project.Variables.paymentInfo(pvcol, pvrow));
        cobro.Keys("[Tab]");
        cobro.Keys("[Tab]");
}

function  LISTA_DE_UNIDADES_ECONOMICAS_compania(rootwindow)
{  
     var compania = rootwindow; // .FindChild("Name", "Window(\"Edit*", 2);
//     if (compania.Exists) { 
     compania.Keys("[Tab]"); // }
}

function  docTarjeta(rootwindow, pvcol, pvrow)
{  
     var edit = rootwindow; //  landingEditbox(rootwindow); if (!edit) return;
     // if (edit.Text == "") { 
     edit.SetText(Project.Variables.paymentInfo(pvcol, pvrow)); // }
     edit.Keys("[Tab]");
}

function  LISTA_DE_BANCOS(rootwindow, pvcol, pvrow)
{  
     var edit = rootwindow; // landingEditbox(rootwindow); if (!edit) return;
     edit.Keys("[F9]");
     var tmp = selectGriditemByName("LISTA DE BANCOS", 0, Project.Variables.paymentInfo(pvcol, pvrow));
     //  var edit = landingEditbox(rootwindow); if (!edit) return;
     edit.Keys("[Tab]");
}

function  PorDistribuir(rootwindow, pvcol, pvrow)
{    
     var TODOissue = "TODOissue: PorDistribuir field bypassed.Cursor jumps to MontoACobrar upon tabbing on Banco";
     if (TODOissue != "") { Log.Warning(TODOissue); return;}
     
     var edit = landingEditbox(rootwindow); if (!edit) return;
     Log.Message("PorDistribuir:" + edit.Text);
     if (Project.Variables.paymentInfo(pvcol, pvrow) != null)
     {edit.SetText(Project.Variables.paymentInfo(pvcol, pvrow));}
     edit.Keys("[Tab]");
}

function  MontoACobrar(rootwindow, pvcol, pvrow)
{  
     var edit = rootwindow;
     edit.Keys(Project.Variables.policy_policyBalance);
     // landingEditbox(rootwindow); if (!edit) return;
//     Log.Message("MontoACobrar:" + edit.Text);
//     if (Project.Variables.paymentInfo(pvcol, pvrow) != null)
//     {edit.SetText(Project.Variables.paymentInfo(pvcol, pvrow));} 
//     //if (pvrow < Project.Variables.paymentInfo.RowCount - 1) edit.Keys("[Enter]");
}

function cobroBalance(rootwindow)
{    // Enter balance for the cheque. Tab to the last column.
     var cobro = rootwindow.Window("ui60Drawn_W32", "", 2);
     cobro.Window("Edit", "", 1).Keys(Project.Variables.input_policyBalance);  //or  policy_policyBalance or payment_policyBalance
}

function cobroDistribuir(rootwindow)
{ 
   var TODOissue = "TODOissue: Distribuir button gives error: From Payment...seus...";
   if (TODOissue != "") { Log.Warning(TODOissue); return;}
   paymentButtons(rootwindow).Button("Distribuir").Click();
}

function cobroConfirmar(rootwindow)
{ paymentButtons(rootwindow).Button("Confirmar").Click();}

function cobroDialogs()
{ 
     // Potential Dialog: remittance out of position
     var popupMSG = MENSAJE_AVISO("Remesa descuadrada", 0, "Aceptar", 0);
     if ( popupMSG != NEGATIVE) { return;}  // to exit from gotomain
     
     // Potential Dialog: be confirmed before proceeding
     var popupMSG = MENSAJE_TITULO("debe confirmar antes de continuar", 0, "Aceptar", 0);
     if ( popupMSG != NEGATIVE) { return;}  // to exit from gotomain
     
     var popupMSG = MENSAJE_ERROR("From Payment...seus...", 0, "Aceptar", 0);
     if ( popupMSG != NEGATIVE)
     {  
        var popupMSG = MENSAJE_FORMS("Save changes?", 0, "No", 0);
        if ( popupMSG != NEGATIVE)
        {  var popupMSG = MENSAJE_ALERTA("Alerta Save changes?", 0, "No", 0);
           if ( popupMSG != NEGATIVE) { Log.Message("TODO....what?");} 
           return;
        } 
        return;
     }
     var popupMSG = MENSAJE_AVISO("Remesa descuadrada", 0, "Aceptar", 0);
     if ( popupMSG != NEGATIVE) { return;}  // to exit from gotomain
}

function  populateFormaDeCobro(paramRootWindow)
{      
   var rootwindow = paramRootWindow.Window("ui60Drawn_W32", "", 1);
   for (var pvrow = 0; pvrow < Project.Variables.paymentInfo.RowCount; pvrow++)
   { var pvcol = 0; // runflag
     Sys.Keys("[Tab]");
     pvcol++; // statrting with form of payment: CHQ, card, .... 
     Sys.Keys("[F9]");
     var tmp = selectGriditemByName("LISTA DE", 0, Project.Variables.paymentInfo(pvcol, pvrow));
     Log.Message("LISTA DE FORMAS DE PAGO:" + Project.Variables.paymentInfo(pvcol, pvrow));
     Sys.Keys("[Tab]");
     
     pvcol++; 
     Sys.Keys("[Tab]");
     
     pvcol++;
     Sys.Keys(Project.Variables.paymentInfo(pvcol, pvrow)); // }
     Sys.Keys("[Tab]");
     
     pvcol++; 
     Sys.Keys("[F9]");
     var tmp = selectGriditemByName("LISTA DE BANCOS", 0, Project.Variables.paymentInfo(pvcol, pvrow));
     Sys.Keys("[Tab]");
     
     pvcol++; // PorDistribuir(rootwindow, pvcol, pvrow); 
     var montoPagar2 = Project.Variables.paymentInfo(pvcol, pvrow);
     
     pvcol++; 
     var montoPagar = Project.Variables.paymentInfo(pvcol, pvrow);
     if (montoPagar == 0)
     {
        montoPagar = Project.Variables.policy_policyBalance;
     }
     
     Sys.Keys(montoPagar);
     
//     pvcol++; // statrting with form of payment: CHQ, card, .... 
//     LISTA_DE_FORMAS_DE_PAGO(rootwindow, pvcol, pvrow);
//     
//     pvcol++; 
//     LISTA_DE_UNIDADES_ECONOMICAS_compania(rootwindow); 
//     pvcol++; docTarjeta(rootwindow, pvcol, pvrow);
//     pvcol++; LISTA_DE_BANCOS(rootwindow, pvcol, pvrow);
//     
//     pvcol++; // PorDistribuir(rootwindow, pvcol, pvrow); 
//     
//     pvcol++; MontoACobrar(rootwindow, pvcol, pvrow);
     
   }
     // cobroBalance(rootwindow);
     rootwindow.Button("Distribuir").Click();
//     rootwindow = paramRootWindow.Window("ui60Drawn_W32", "", 2);
     rootwindow.Button("Acumular").Click();
     rootwindow.Button("Confirmar").Click();
     Delay(18000);
     MENSAJE_FORMS("Se generaron los documentos de Cobros", 0, "OK", 0);
     MENSAJE_FORMS("Se generaron los documentos de Cobros", 0, "OK", 0);
     if(Sys.Process("RWRBE60").Exists)
      Sys.Process("RWRBE60").Close();
//     cobroDistribuir(rootwindow);
//     cobroConfirmar(rootwindow);
//     cobroDialogs();
}

function  ClienteBuscarPorPoliza(rootwindow, policynum)
{ // Buscar Cliente Por Poliza...Dialog to search customer by insurance policy
    rootwindow.Window("ui60Drawn_W32", "", 1).Button("Póliza").Click();
    var wnd_BuscarClientePorPoliza = rootwindow.Window("ui60Drawn_W32", "", 1);
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).SetText(policynum);
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys("[Tab]");
    
    var popupMSG = MENSAJE_ERROR("Persona inexistente", 0, "Aceptar", 0);
    if ( popupMSG != NEGATIVE)
    { wnd_BuscarClientePorPoliza.Button("Salir").ClickButton(); return false;}
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).SetText("");
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys("[BS]");    
    wnd_BuscarClientePorPoliza.Button("Salir").ClickButton();
}

function  MontoRemesa_EnterBalance(rootwindow)
{   
    var policyBalanceField = landingEditbox(rootwindow);
    if (!policyBalanceField.Exists){ return;}
    addProjectVariable("payment_policyBalance", "string", policyBalanceField.Text);   
    if (Project.Variables.policy_policyBalance != Project.Variables.payment_policyBalance)
    { Log.Message("Policy balance difference: " +  Project.Variables.policy_policyBalance + "!=" + Project.Variables.payment_policyBalance);}
    if (aqString.GetLength(Project.Variables.payment_policyBalance) == 0)
    { policyBalanceField.Keys(Project.Variables.policy_policyBalance);}
    policyBalanceField.Keys("[Tab]");
}

function landingEditbox(rootwindow){ return rootwindow.FindChild("Name", "Window(\"Edit*", 2);}

function makePaymentBK(testNum)
{  //For debugging, start from Menu Principal. Manually click on Aplicacion de Pagos
   // Potential dialog: Did not have the box assigned Review
   // if ((handleADialog("Usuario no tiene la caja asignada, Revise", "PRECAUCION", 0, "OK", 0)!= RESULT_NEGATIVE)) { return;}
   Log.Message("Started Payment: "+testNum); 
   var rootwindow = getMDIWindow(determineForm(), MDI_Payment).Window("ui60Drawn_W32");
  
    if (aqConvert.StrToInt(Project.Variables.policyBalance) < 0)
    { Log.Message("Negative Balance: " +  Project.Variables.policyBalance); }
    else
    { Sys.Keys(Project.Variables.policyBalance);}
    Sys.Keys("[Tab]");
    
    // Buscar Cliente Por Poliza...Dialog to search customer by insurance policy
    rootwindow.Window("ui60Drawn_W32", "", 1).Button("Póliza").Click();
    var wnd_BuscarClientePorPoliza = rootwindow.Window("ui60Drawn_W32", "", 1);
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys(Project.Variables.PolicyNum);
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys("[Tab]");
    if (dialog_Error("Persona inexistente", "Aceptar", 0) != -1)
    {
       wnd_BuscarClientePorPoliza.Button("Salir").ClickButton();
       if(!goToMain()) { Log.Message("TODO .... in makepayment");}
       return;
    }
    /*
    Borraban el codigo de la poliza O.o
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).SetText(""); 
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys("[BS]");
    */    
    wnd_BuscarClientePorPoliza.Button("Salir").ClickButton();
    
    // Upon click cursor goes to the cliente section Estado field
    var combboxContainer = rootwindow.Window("ui60Drawn_W32", "", 2);

    //from Estado to CedulaRNC to formaDeCobro 
    Sys.Keys("[Tab]");
    
    //setPaymentValues(); /// TODO....Replace this with a reader fron spreadsheet.
    readPaymentValues(testNum);
      
    var pvrow = 0; var pvcol = 0; 
    // Enter chq/credit card info
    
    var cobro = rootwindow.Window("ui60Drawn_W32", "", 2); 
    
    pvcol++; // EconomicUnits     
    if (aqString.FindLast(Project.Variables.saludcoreExecutable, "SaludcoreTestSwitch", false) == -1)
    {
       //combboxContainer.Window("ComboBox", "", 1).Keys("[Tab][Tab]");
       var cobro = rootwindow.Window("ui60Drawn_W32", "", 2);
       cobro.Window("Edit", "", 1).Keys("[F9]");
       // FormaDeCobro...for LISTA DE FORMAS DE PAGO
       var tmp = selectGriditemByName("LISTA DE*", 0, Project.Variables.paymentInfo(pvcol, pvrow));
       cobro.Window("Edit", "", 1).Keys("[Tab]");
           // LISTA_DE_UNIDADES_ECONOMICAS
    
    // rootWindow.Window("Edit", "", 1).Keys(Project.Variables.paymentInfo(pvcol, pvrow));
    // rootWindow.Window("Edit", "", 1).Keys("[Tab]");
    }
    var paymentMode = Project.Variables.paymentInfo(pvcol, pvrow);
    if (paymentMode != 'EFEC')
    {
        exit_LISTA_DE_UNIDADES_ECONOMICAS(rootwindow);    
    }

    pvcol++; // Doc e.g. cheque number
    if (aqString.FindLast(Project.Variables.saludcoreExecutable, "SaludcoreTestSwitch", false) == -1)
    { cobro.Window("Edit", "", 1).Keys(Project.Variables.paymentInfo(pvcol, pvrow));}
    
    var docTarjeta = landingEditbox(rootwindow); docTarjeta.Keys("[Tab]"); 
    
    if (paymentMode != 'EFEC')
    {
        var cobro = docTarjeta.Parent;
        pvcol++; // Bank info
        cobro.Window("Edit", "", 1).Keys("[F9]");
        //Dialog: "LISTA DE BANCOS"
        var tmp = selectGriditemByName("LISTA DE BANCOS", 0, Project.Variables.paymentInfo(pvcol, pvrow));
    
        var banco = landingEditbox(rootwindow); 
        banco.Keys("[Tab]"); 
        var cobro = banco.Parent;
    }
    //Sys.Keys("[Tab]"); //cobro.Window("Edit", "", 1).Keys("[Tab]");
    
    // Enter balance for the cheque. Tab to the last column.
    cobro.Window("Edit", "", 1).Keys(Project.Variables.policyBalance);
    
    cobro.Button("Distribuir").Click();
    cobro.Button("Acumular").Click();
    cobro.Button("Confirmar").Click();
    
    // Potential Dialog: remittance out of position
    if (handleADialog("Remesa descuadrada", "Aviso", 0, "Aceptar", 0) != -1) { return;}  // to exit from gotomain
    
    if (handleADialog("From Payment...seus...", "Error", 0, "Aceptar", 0) != -1)
    {
        if (handleADialog("Save changes?", "Forms", 0, "No", 0) != -1)
        {
           if (handleADialog("Alerta Save changes?", "Alerta", 0, "No", 0) != -1)
           { Log.Message("TODO....what?");} return;
        } 
        return;
    }
    
    var tmp = handleADialog("Se generaron*", "Forms", 0, "OK", 1);
    
    if (handleADialog("Remesa descuadrada", "Aviso", 0, "Aceptar", 0) != -1) { return;}  // to exit from gotomain 
 }
 

 function makePayment2()
{  //For debugging, start from Menu Principal. Manually click on Aplicacion de Pagos
   // Potential dialog: Did not have the box assigned Review
   // if ((handleADialog("Usuario no tiene la caja asignada, Revise", "PRECAUCION", 0, "OK", 0)!= RESULT_NEGATIVE)) { return;}
   var testNum = 1;
   Log.Message("Started Payment: "+testNum); 
   var rootwindow = getMDIWindow(determineForm(), "Aplicación de Pagos").Window("ui60Drawn_W32");
    /*
    var policyBalance = landingEditbox(rootwindow);
    if (!policyBalance.Exists){ return;}
    */
    // var leftwindow = firstEditWindow.Parent; // rootwindow.Window("ui60Drawn_W32", "", 1);
    // Monto Remesa....Enter balance
    // TODO: check for negative balance
    if (aqConvert.StrToInt(Project.Variables.policyBalance) < 0)
    { Log.Message("Negative Balance: " +  Project.Variables.policyBalance); }
    else
    { Sys.Keys(Project.Variables.policyBalance);}
    Sys.Keys("[Tab]");
    
    // Buscar Cliente Por Poliza...Dialog to search customer by insurance policy
    rootwindow.Window("ui60Drawn_W32", "", 1).Button("Póliza").Click();
    var wnd_BuscarClientePorPoliza = rootwindow.Window("ui60Drawn_W32", "", 1);
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys(Project.Variables.PolicyNum);
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys("[Tab]");
    if (dialog_Error("Persona inexistente", "Aceptar", 0) != -1)
    {
       wnd_BuscarClientePorPoliza.Button("Salir").ClickButton();
       if(!goToMain()) { Log.Message("TODO .... in makepayment");}
       return;
    }
    /*
    Borraban el codigo de la poliza O.o
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).SetText(""); 
    wnd_BuscarClientePorPoliza.Window("Edit", "", 1).Keys("[BS]");
    */    
    wnd_BuscarClientePorPoliza.Button("Salir").ClickButton();
    
    // Upon click cursor goes to the cliente section Estado field
    var combboxContainer = rootwindow.Window("ui60Drawn_W32", "", 2);

    //from Estado to CedulaRNC to formaDeCobro 
    Sys.Keys("[Tab]");
    
    //setPaymentValues(); /// TODO....Replace this with a reader fron spreadsheet.
    readPaymentValues(testNum);
      
    var pvrow = 0; var pvcol = 0; 
    // Enter chq/credit card info
    
    var cobro = rootwindow.Window("ui60Drawn_W32", "", 2); 
    
    pvcol++; // EconomicUnits     
    if (aqString.FindLast(Project.Variables.saludcoreExecutable, "SaludcoreTestSwitch", false) == -1)
    {
       //combboxContainer.Window("ComboBox", "", 1).Keys("[Tab][Tab]");
       var cobro = rootwindow.Window("ui60Drawn_W32", "", 2);
       cobro.Window("Edit", "", 1).Keys("[F9]");
       // FormaDeCobro...for LISTA DE FORMAS DE PAGO
       var tmp = selectGriditemByName("LISTA DE*", 0, Project.Variables.paymentInfo(pvcol, pvrow));
       cobro.Window("Edit", "", 1).Keys("[Tab]");
           // LISTA_DE_UNIDADES_ECONOMICAS
    
    // rootWindow.Window("Edit", "", 1).Keys(Project.Variables.paymentInfo(pvcol, pvrow));
    // rootWindow.Window("Edit", "", 1).Keys("[Tab]");
    }
    var paymentMode = Project.Variables.paymentInfo(pvcol, pvrow);
    if (paymentMode != 'EFEC')
    {
        exit_LISTA_DE_UNIDADES_ECONOMICAS(rootwindow);    
    }

    pvcol++; // Doc e.g. cheque number
    if (aqString.FindLast(Project.Variables.saludcoreExecutable, "SaludcoreTestSwitch", false) == -1)
    { cobro.Window("Edit", "", 1).Keys(Project.Variables.paymentInfo(pvcol, pvrow));}
    
    var docTarjeta = landingEditbox(rootwindow); docTarjeta.Keys("[Tab]"); 
    
    if (paymentMode != 'EFEC')
    {
        var cobro = docTarjeta.Parent;
        pvcol++; // Bank info
        cobro.Window("Edit", "", 1).Keys("[F9]");
        //Dialog: "LISTA DE BANCOS"
        var tmp = selectGriditemByName("LISTA DE BANCOS", 0, Project.Variables.paymentInfo(pvcol, pvrow));
    
        var banco = landingEditbox(rootwindow); 
        banco.Keys("[Tab]"); 
        var cobro = banco.Parent;
    }
    //Sys.Keys("[Tab]"); //cobro.Window("Edit", "", 1).Keys("[Tab]");
    
    // Enter balance for the cheque. Tab to the last column.
    cobro.Window("Edit", "", 1).Keys(Project.Variables.policyBalance);
    
    cobro.Button("Distribuir").Click();
    cobro.Button("Acumular").Click();
    cobro.Button("Confirmar").Click();
    
    // Potential Dialog: remittance out of position
    if (handleADialog("Remesa descuadrada", "Aviso", 0, "Aceptar", 0) != -1) { return;}  // to exit from gotomain
    
    if (handleADialog("From Payment...seus...", "Error", 0, "Aceptar", 0) != -1)
    {
        if (handleADialog("Save changes?", "Forms", 0, "No", 0) != -1)
        {
           if (handleADialog("Alerta Save changes?", "Alerta", 0, "No", 0) != -1)
           { Log.Message("TODO....what?");} return;
        } 
        return;
    }
    
    var tmp = handleADialog("Se generaron*", "Forms", 0, "OK", 1);
    
    if (handleADialog("Remesa descuadrada", "Aviso", 0, "Aceptar", 0) != -1) { return;}  // to exit from gotomain 
 }
 
 
function makePayment()
{  
    Log.Message(" Started Payment ");
    determineForm().Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 13).Click(); 
    //var rootwindow = getMDIWindow(determineForm(), MDI_Payment).Window("ui60Drawn_W32");
   
    //For debugging, start from Menu Principal. Manually click on Aplicacion de Pagos
    /*
    var MDIFormObject = determineForm();
    var MDIWindowPayment = getMDIWindow(MDIFormObject , "MDI_Payment");
    MDIFormObject.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 16).Click();
    
    Sys.Process("ifrun60").Form("ARS (AAGUAS) - [Aplicación de Pagos]").Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 13)
    */
    readPaymentCobros(); 
    
    var rootwindow = Sys;// MDIWindowPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
    var montoPagar = Project.Variables.paymentInfo(6,0);
    
    if (montoPagar == 0)
     {
        montoPagar = Project.Variables.policy_policyBalance;
     }
     
    rootwindow.Keys(montoPagar);
     
    rootwindow.Keys("[Tab]");
    rootwindow.Keys(Project.Variables.Codigo);
    rootwindow.Keys("[Tab]");
    
    /*
    var MDIFormObject = determineForm();
    var MDIWindowPayment = getMDIWindow(MDIFormObject , "MDI_Payment");
    rootwindow = MDIWindowPayment.Window("ui60Drawn_W32", "", 1);
    */
    var base = getMDIWindow(determineForm(), "Aplicación de Pagos");
    rootwindow = base.Window("ui60Drawn_W32");
    

    populateFormaDeCobro(rootwindow);
    
  // Commented by dilip: 01/11/2012  
//    var rootwindow = getMDIWindow(determineForm(), "MDI_Payment").Window("ui60Drawn_W32");
//    
//    MontoRemesa_EnterBalance(rootwindow);
//    
//    // Buscar Cliente Por Poliza...Dialog to search customer by insurance policy
//    if (ClienteBuscarPorPoliza(rootwindow, Project.Variables.PolicyNum)) { return false;}
//    
//    // The cursor goes to the cliente section Estado field
//    var combboxContainer = rootwindow.Window("ui60Drawn_W32", "", 2);
//
//    //from Estado to CedulaRNC to formaDeCobro 
//    combboxContainer.Window("ComboBox", "", 1).Keys("[Tab][Tab]");
 
 //Comment ends
    
    // Enter chq/credit card info
//    populateFormaDeCobro(rootwindow); 
 }
 
function payment_icon_BalancesPendientes()
{
    var MDIPayment = getMDIWindow(determineForm(), "MDI_Payment"); //getMDIWindow(determineForm(), "");
    MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 5).Click();
    return getMDIWindow(determineForm(), "");
}

function populatePaymentForm()
{
    var MDIConsultaEstadoDeCuentas = payment_icon_BalancesPendientes();  // getMDIWindow(determineForm(), ""); //
    var rootWindow = MDIConsultaEstadoDeCuentas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
    rootWindow.Window("Edit", "", 1).Keys(Project.Variables.codigo);
    rootWindow.Window("Edit", "", 1).Keys("[Tab]");
    rootWindow.Window("ui60Viewcore_W32", "", 5).Click();
    payment = readRateTable(Project.Variables.Age , Project.Variables.Deductible, Project.Variables.region, Project.Variables.Product, Project.Variables.PaymentSchedule);
    Log.Message("the policy balance and payment amount =  " +  Project.Variables.input_policyBalance);
    Log.Message("the policy amount calculated based on rate table =  " + payment);
    Log.Message("the form policy amount =  " + Project.Variables.policy_policyBalance + " " + Project.Variables.payment_policyBalance);
}
 
function makepaymenttest()
{ 
    if (Project.Variables.VariableByName("payPolicy") == 'n') return;
    
    // Start from Menu Principal
    Log.Message("Starting Make Payment testing");
    if(!goToMain()) { Log.Message("TODO .... in makepaymenttest"); return;}
    MantenimientosMenu("Mantenimiento De Pólizas");
    var policyinfo = policyInfoFromPolizas("PolicyNum", Project.Variables.PolicyNum);
    var policyinfo = policyInfoFromPolizas("PolicyBalance", "");
    var policyinfo = policyInfoFromPolizas("Codigo", "");
    retreiveRegion();
    var policyinfo = policyInfoFromPolizas("PaymentSchedule", "");
    retreiveAdditionalPolicyData();
//    var balanceDeLaPoliza = getBalanceDeLaPoliza();
//    var payment = readRateTable(Project.Variables.Age , Project.Variables.Deductible, Project.Variables.region, Project.Variables.Product, Project.Variables.PaymentSchedule); 
//    Log.Message("The rate table policy ammount is: " + payment);
    Log.Message("The policy ammount displayed on the form is: " + Project.Variables.policy_policyBalance);
    if(!goToMain()) { Log.Message("TODO2 .... in makepaymenttest"); return;}
    MantenimientosMenu("MDI_Payment");
    makePayment();
    //paymentValidation();
    
//    populatePaymentForm();
    /*validatePayment(1, "RC-P", 2);
    validatePayment(1, "RC-P", 1);
    validatePayment(1, "FT-EMI", 1);
    validatePayment(1, "FT-CAD", 1);*/
}
 

function paymentValidation()
{
  if(!goToMain()) { Log.Message("TODO2 .... in makepaymenttest"); return;}
  MantenimientosMenu("Mantenimiento De Pólizas");
  var MDIPolizas = getMDIWindow(determineForm(), "Mantenimiento De Pólizas");
  var rootwindow = MDIPolizas.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootwindow.Window("Edit", "", 1).Keys("[Tab]");
  rootwindow.Window("Edit", "", 1).Keys("[Tab]");
  rootwindow.Window("Edit", "", 1).Keys(Project.Variables.Codigo);
  rootwindow.Window("Edit", "", 1).Keys("[F8]");
  rootwindow.Window("ui60Viewcore_W32", "", 3).Click();
  
  var MDIConsulta = getMDIWindow(determineForm(),"WINDOW0");
  var rootwindow = MDIConsulta.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
  rootwindow.Window("ui60Viewcore_W32", "", 6).Click();
  for(i=0;i<9;i++){
  rootwindow.Window("Edit", "", 1).Keys("[Tab]");
  }
  
  var balance = StrToFloat(rootwindow.Window("Edit", "", 1).Text);
  if(balance != 0)
  Log.Error("Payment Failed. Observed Balance Value is: " + balance);
  else
  Log.Message("Payment Completed. Observed Balance Value is: " + balance );
  goToMain();
  
}


function validatePayment(test, code, instance)
{
   var formObject, rootWindow;
   var tabCount = 0;
   var localInstance = 0;
   // formObject = determineForm();
   var MDIPayment = getMDIWindow(determineForm(), "MDI_Payment"); // getMDIWindow(determineForm(), "");
   
    
   readPaymentValidation(test, "payment", instance, code);
   while (tabCount < 50)
   {
       value = MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;         
       if ( aqString.Find(Project.Variables.paymentCode, value) > -1)  
       {
         localInstance++;
         if (localInstance != instance)
         {
           MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
           tabCount++;
           continue;
         }
         
          MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab]");
          tabCount--;
          var formBalance = MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
          var expectedBalance = validatePolicyBalance (formBalance, Project.Variables.input_policyBalance);  // Project.Variables.policyBalance
          
          MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab]");
          tabCount--;
          value = MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;         
          if ( aqString.Find(value, Project.Variables.paymentAmount) > -1  )
             Log.Message("Expected policy amount: " + Project.Variables.paymentAmount );
          else
             Log.Error("Unexpected policy amount: " + value );
          
          MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab]");
          tabCount--;
          MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab]");
          tabCount--;
          MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab]");
          tabCount--;
          value = MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;         
          if ( aqString.Find(value, Project.Variables.valueAmount) > -1  )
             Log.Message("Expected policy value amount: " + Project.Variables.valueAmount );
          else
             Log.Error("Unexpected policy value amount: " + value );
          break;

       }
       else
       {
          MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
          tabCount++;
       }
   }
   
   //go back to the beginning
   for (var i = 0; i < tabCount; i++)
   { MDIPayment.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab]");}
} 

/// Test Stubs

