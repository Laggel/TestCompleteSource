//USEUNIT excelUtilities
//USEUNIT navigateMainWindow
//USEUNIT Tests
//USEUNIT utilities
//USEUNIT policySection
//USEUNIT paymentSection 

/// Script File: Claims
/// Last update: May 8    


//Dilip
function processClaims()
{  
   Log.Message("Starting test for Test Case Number: " + Project.Variables.tcNum);
   readClaim();
   addProjectVariable("Validaciones" , "string", "N");           
           
   
   if (aqString.Find(Project.Variables.executeClaim, "N") > - 1 ) return; 
   if(!goToMain()) { Log.Message("TODO .... in processClaim"); return;}
   
   MantenimientosMenu("Comprobacion Derechos");
   
   if(comprobacionDerechos() == NEGATIVE){return;}
   
   MENSAJE_INFORMATIVO("Informational Message",0,"OK",0);
   
   if( MaintenimientoDeReclamaciones()== NEGATIVE){return;}
   
}

function processTipoReclamante(rootWindow, value)
{
  var localWindow = rootWindow;
  var localTipoReclamante = aqString.ToLower(value);
  
  switch (localTipoReclamante)
  {
    case "asegurado":
      {
         var paymentMode= getMDIWindow(determineForm(),"Transferencia");
         var paymentWindow=paymentMode.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
     
        if(paymentWindow.Exists)
        {
          var transferencia= Project.Variables.formaDePago;
          if(aqString.Compare(transferencia,"Cheque",false) == 0)
          {
            paymentWindow.RadioButton("Cheque").Click();
            paymentWindow.RadioButton("Cheque").Keys("[Tab]");
            Project.Variables.expectedRazonAfterProcessing = "PENDING CHECK ISSUANCE";
            // paymentWindow.Button("Pantalla Anterior").Click(); 
          }
          else
          {
            paymentWindow.RadioButton("Transferencia").Click();
            paymentWindow.Button("Cuenta Transferencia").Keys("[Tab]");
            Project.Variables.expectedRazonAfterProcessing = "PENDING BANK TRANSACTION";
             
          }
        }
        MENSAJE_PRECAUCION("Debe engresar un numero de factura, este campo es obligatorio.",0,"OK",0);
               localWindow.Window("ComboBox","",3).Button("Open").Click(); 
      selectComboBoxItem(Project.Variables.tipoInsalacion);
      localWindow.Window("ComboBox","",3).Keys("[Tab]");
      localWindow.Window("Edit","",1).Keys("[Tab]");
      if(aqString.Compare(Project.Variables.tipoInsalacion,"medico",false) == 0)
      {
        selectGriditemByName("AFILIADOS MEDICOS", 0, Project.Variables.listaDeTipo);
        
      }
      else
      {
        selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)", 0, Project.Variables.listaDeTipo);
      }
      localWindow.Window("Edit","",1).Keys(Project.Variables.facturaNumber);
      localWindow.Window("Edit","",1).Keys("[Tab]");
      localWindow.Window("ComboBox","",4).Button("Open").Click(); 
      selectComboBoxItem(Project.Variables.tipoServicio);
      localWindow.Window("ComboBox","",4).Keys("[Tab]");
         
      }
      break;
  
    case "medico":
      {
        selectGriditemByName("AFILIADOS MEDICOS",0,Project.Variables.afiliadoMedicos);
        localWindow.Window("Edit","",1).Keys("[Tab]");
        localWindow.Window("Edit","",1).Keys("[Tab]");
        selectGriditemByName("Categorias Medicos",0,Project.Variables.categoriasMedicos);
       // localWindow.Window("Edit","",1).Keys("[Tab]");
          localWindow.Window("ComboBox","",2).Button("Open").Click(); 
      selectComboBoxItem(Project.Variables.tipoInsalacion);
      localWindow.Window("ComboBox","",2).Keys("[Tab]");
        localWindow.Window("Edit","",1).Keys("[Tab]");
       if(aqString.Compare(Project.Variables.tipoInsalacion,"medico",false) == 0)
      {
        selectGriditemByName("AFILIADOS MEDICOS", 0, Project.Variables.listaDeTipo);
        
      }
      else
      {
        selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)", 0, Project.Variables.listaDeTipo);
      }
      localWindow.Window("Edit","",1).Keys(Project.Variables.facturaNumber);
      localWindow.Window("Edit","",1).Keys("[Tab]");
       
      MENSAJE_PRECAUCION("Debe engresar un numero de factura, este campo es obligatorio.",0,"OK",0);
      localWindow.Window("ComboBox","",3).Button("Open").Click(); 
      selectComboBoxItem(Project.Variables.tipoServicio);
      localWindow.Window("ComboBox","",3).Keys("[Tab]");
        
        // TODO: write function to handle reprising network window
//        Log.Enabled=false;
//        if(Sys.Process("ifrun60").Dialog("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)").Exists)
//        {
//        if(Sys.Process("ifrun60").Dialog("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)").Visible)
//          { 
//          Log.Enabled=true;
//          selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)",0,Project.Variables.repricingNetwork)
//          localWindow.Window("Edit","",1).Keys("[Tab]");
//          }
//        }
//        Log.Enabled=true;


//        // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Mantenimiento De Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("%");
//        localWindow.Button("%").Click();
//        // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Tipos de Fee")
//        var MDITipoDeFee=getMDIWindow(determineForm(),"Tipos de Fee");
//        MDITipoDeFee.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Click();
//        //Sys.Process("ifrun60").Window("ui60Modal_W32", " ", 1)
//        Sys.Process("ifrun60").Window("ui60Modal_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).keys("Contrato sin fee");
//        Sys.Process("ifrun60").Window("ui60Modal_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Button("OK").Click();
//        Sys.Process("ifrun60").Window("ui60Modal_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).keys("[Tab]");
//        
//        MDITipoDeFee.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("OK").Click();
//        
        // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Tipos de Fee").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1)
        
      }
      break;
    
    case "clinica/lab":
      {
        selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)",0,Project.Variables.afiliadoMedicos);
        localWindow.Window("Edit","",1).Keys("[Tab]");
        localWindow.Window("Edit","",1).Keys("[Tab]");
        
        selectGriditemByName("Categorias No Medicos",0,Project.Variables.categoriasMedicos);
        localWindow.Window("ComboBox","",2).Button("Open").Click(); 
        selectComboBoxItem(Project.Variables.tipoInsalacion);
        localWindow.Window("ComboBox","",2).Keys("[Tab]");
        localWindow.Window("Edit","",1).Keys("[Tab]");
      
      if(aqString.Compare(Project.Variables.tipoInsalacion,"medico",false) == 0)
      {
        selectGriditemByName("AFILIADOS MEDICOS", 0, Project.Variables.listaDeTipo);
        
      }
      else
      {
        selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)", 0, Project.Variables.listaDeTipo);
      }
      aqUtils.Delay(100);
      localWindow.Window("Edit","",1).Keys(Project.Variables.facturaNumber);
      localWindow.Window("Edit","",1).Keys("[Tab]");
      
      while (MENSAJE_PRECAUCION("Debe ingresar un numero de factura, este campo es obligatorio.",0,"OK",0) == POSITIVE)
      {
        Sys.Keys(Project.Variables.facturaNumber);
      }
 
      localWindow.Window("ComboBox","",3).Button("Open").Click(); 
      selectComboBoxItem(Project.Variables.tipoServicio);
      localWindow.Window("ComboBox","",3).Keys("[Tab]");
       
 //TODO: Handle reprising network
        
//        Log.Enabled=false;
//        if(Sys.Process("ifrun60").Dialog("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)").Exists)
//        {
//          Log.Enabled=true;
//          selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)",0,Project.Variables.repricingNetwork)
//          localWindow.Window("Edit","",1).Keys("[Tab]");
//        }
//        Log.Enabled=true;
      }
      break;
      
  }
  
}


function MaintenimientoDeReclamaciones()
{
    
     var  MDIMaintenimientoDeReclamaciones= getMDIWindow(determineForm(),"Mantenimiento De Reclamaciones");
     MDIMaintenimientoDeReclamaciones.TitleBar(0).Button("Maximize").Click();
     
     //MDIMaintenimientoDeReclamaciones.TitleBar(0).Button("Maximize").Click();
     var rootwindow = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
     rootwindow.Window("Edit", "", 1).Keys("[Tab]");
     // rootwindow.Window("ui60Viewcore_W32", "", 13).Click();
     rootwindow.Window("Edit", "", 1).Keys(Project.Variables.fechaServico);
     rootwindow.Window("Edit", "", 1).Keys("[Tab]");
     MENSAJE_INFORMATIVO("Informational Message", 0,"OK",0);
     
     
     /*
     if(aqString.Compare(Project.Variables.modoDeCaptura,"Afiliado",false) == 0)
     {
      rootwindow.RadioButton("Afiliado").Click();
      rootwindow.RadioButton("Afiliado").Keys("[Tab]"); 
     }
     else
     {
      rootwindow.RadioButton("Poliza").Click();
      rootwindow.RadioButton("Poliza").Keys("[Tab]"); 
     }
     */
     Sys.Keys("[Tab]");
     
     rootwindow.Window("Edit","",1).Keys("[Tab]");
     rootwindow.Window("Edit","",1).Keys("[Tab]");
     MENSAJE_INFORMATIVO("Asegurado presenta enmienda aumento de deducible.",0,"OK",0);
     rootwindow.Window("Edit","",1).Keys("[Tab]");
     rootwindow.Window("ComboBox","",4).Button("Open").Click();
     selectComboBoxItem(Project.Variables.tipoReclamante);
     rootwindow.Window("ComboBox","",4).Keys("[Tab]");
    
     rootwindow.Window("Edit","",1).Keys("[Tab]");
     processTipoReclamante(rootwindow,Project.Variables.tipoReclamante);
       
//       if(aqString.Compare(Project.Variables.tipoReclamante,"asegurado",false) == 0)
//       {
//        rootwindow.Window("ComboBox","",4).Button("Open").Click(); 
//      selectComboBoxItem(Project.Variables.tipoServicio);
//      rootwindow.Window("ComboBox","",4).Keys("[Tab]");
//       rootwindow.Window("ComboBox","",3).Button("Open").Click(); 
//      selectComboBoxItem(Project.Variables.tipoInsalacion);
//      rootwindow.Window("ComboBox","",3).Keys("[Tab]");
//     
//       }
//        else
//       { 
//      rootwindow.Window("ComboBox","",3).Button("Open").Click(); 
//      selectComboBoxItem(Project.Variables.tipoServicio);
//      rootwindow.Window("ComboBox","",3).Keys("[Tab]");
//       rootwindow.Window("ComboBox","",2).Button("Open").Click(); 
//      selectComboBoxItem(Project.Variables.tipoInsalacion);
//      rootwindow.Window("ComboBox","",2).Keys("[Tab]");
//     
//      }
//      rootwindow.Window("Edit","",1).Keys("[Tab]");
//      if(aqString.Compare(Project.Variables.tipoInsalacion,"medico",false) == 0)
//      {
//        selectGriditemByName("AFILIADOS MEDICOS", 0, Project.Variables.listaDeTipo);
//        
//      }
//      else
//      {
//        selectGriditemByName("AFILIADOS NO MEDICO (CLINICAS, LABORATORIOS)", 0, Project.Variables.listaDeTipo);
//      }
//      
       // var tmp = selectGriditemByName("AFILIADOS MEDICOS", 0, Project.Variables.listaDeTipo); 
       rootwindow.Window("Edit","",1).Keys("[Tab]");
      MENSAJE_INFORMATIVO("Informational Message",0,"OK",0);
      // rootwindow.Window("Edit","",1).Keys("[Tab]");
       //Sys.Process("ifrun60").Dialog("Lista de")
         var tmp = selectGriditemByName("Lista de Tipos de Enfermedades", 0, Project.Variables.listaDeTipo);
         /*
         Sys.Keys("[Enter]");
         
        if(aqString.Compare(Project.Variables.tipoReclamante,"asegurado",false) != 0)
        {
          getPaymentOption();
        }
        */ 
        
         rootwindow.Button("Diagnosticos").Click(); 
//    clickMantenimientoDeReclamaciones("Diagnosticos");
      MENSAJE_INFORMATIVO("Informational Message",0,"OK",0);
      
    //Sys.Process("ifrun60").Dialog("Lista de").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1)
    if ( aqString.Find(Project.Variables.diagnosticCodeFlag, "y") > -1)
    {
      count = determineNumberOfClaimDataRows("diagnostics",Project.Variables.tcNum); //determineNumberOfDiagnosticCodes(Project.Variables.tcNum);
      if (count > 0)
      {
           for (i = 1; i<=count; i++)
           {
               readDiagnosticCode(i);
               var MDIDiagnosticos = getMDIWindow(determineForm() ,"Diagnosticos en Reporte Hospitalizacion");
               var rootwindow = MDIDiagnosticos.Window("ui60Drawn_W32", "", 1);
               rootwindow.Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys(Project.Variables.diagnosticCode);
               
//               rootwindow.Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys("[Tab]");
//               selectGriditemByName("Diagnosticos",0,Project.Variables.diagnosticCode);
               rootwindow.Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys("[Tab]");  
               if (i < count)
               { rootwindow.Window("ui60Drawn_W32", "", 2).Keys("[Tab]");}
               else
               {
                rootwindow.Window("ui60Drawn_W32", "", 2).Button("Coberturas").Click();
               }
           }
      }
      else
      {
        return NEGATIVE;
      }
    
    }
    
  //    clickDiagnosticEnReporteButton("coberturas");
  MENSAJE_PRECAUCION("Precaucion Message",0,"OK",0);
  //Jeff insert here
  //different form
    
  addCoberturarDeSalud(Project.Variables.tcNum);
    
  // formObject.Panel("Workspace").getMDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(39, 30);
  
  clickCoberturasDeSaludButton("Anterior");
  var popupMSG = MENSAJE_DE_ERROR("Coberturas de Salud", 0, "OK", 0);
  MENSAJE_INFORMATIVO("Asegurado presenta enmienda aumento de deducible.",0,"OK",0);
  //MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 3).Keys("Test");
  
  var formObject = determineForm();
  
  if (formObject.MenuBar("Application").MenuItem("Action").Exists)     
  {
        Log.Enabled = true;
        formObject.MenuBar("Application").MenuItem("Action").Click(); 
        var savemenu = Sys.Process("ifrun60").Popup("Action").MenuItem("Save");
        if(savemenu.Enabled) savemenu.Click();
  }
  
  Delay(500,"Delay script execution for 500 milliseconds");
          
  MENSAJE_PRECAUCION("Possible Duplicado",0,"OK",0);
  MENSAJE_INFORMATIVO("Modificacions han sido grabadas.",0,"OK",0);
  MENSAJE_PRECAUCION("Este reclamo debe de ser evaluado por al Director Medico de reclamo.",0,"OK",0);

  //MDIMaintenimientoDeReclamaciones.TitleBar(0).Button("Maximize").Click();
    
  
  if (aqString.Compare(Project.Variables.cerrarParaPago, "Y", false) == ZERO) 
  { 
    clickMantenimientoDeReclamaciones("Cerrar/Pago");
  
    var popupMSG = MENSAJE_DE_ALERTA("Coberturas de Salud", 0, "Si", 1);
    // formObject.Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Click();
    var MDIquality = Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1);
    MDIquality.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Click();
  
    var tmp = selectGriditemByName("Lista Motivo Estatus Reclamación", 0, Project.Variables.qualityCode);
    MDIquality.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Aceptar").Click();
  
        var  MDIMaintenimientoDeReclamaciones= getMDIWindow(determineForm(),"Mantenimiento De Reclamaciones");
  
        MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(25,75);
        value = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text; 
        if (value == null)
        {
          var value1 = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
        }
        addProjectVariable("claimNumber_1", "integer", value);
        MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(55,75);
        value = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text; 
        addProjectVariable("claimNumber_2", "integer", value);
        MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(85,75);
        value = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text; 
        addProjectVariable("claimNumber_3", "integer", value);
        MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(120,75);
        value = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text; 
        addProjectVariable("claimNumber_4", "integer", value);
 
        MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(120,515);
        value = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text; 
                 
        if ( aqString.Find(Project.Variables.expectedEstatus, value) > -1)
        {
          Log.Message("The correct Estatus value observed: " + value);
        }
        else
          Log.Error("Incorrect Estatus value observed. Expected: " + Project.Variables.expectedEstatus + " Detected: " + value);

        MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(120,550);
        value = MDIMaintenimientoDeReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text; 
        if ( aqString.Find(Project.Variables.expectedRazon , value) > -1)
        {
          Log.Message("The correct Razon Estatus value observed: " + value);
        }
        else
          Log.Error("Incorrect Estatus value observed. Expected: " + Project.Variables.expectedRazon + " Detected: " + value);
    
    //qualityControl1(true);
    //goback to quality control to verify state information based on boolean passed in
    //qualityControl1(false);
  
  }
    
  Log.Checkpoint("Exiting test for Test Case Number: " + Project.Variables.tcNum); 
     
     
}

function getPaymentOption()
{
var formObject = determineForm();
  if (formObject.MenuBar("Application").MenuItem("Action").Exists)     
        {
        Log.Enabled = true;
        formObject.MenuBar("Application").MenuItem("Action").Click(); 
        var exitmenu = Sys.Process("ifrun60").Popup("Action").MenuItem("Save");
        if(exitmenu.Enabled) exitmenu.Click();
        }
  
  MDILocal = getMDIWindow(determineForm(),"Mantenimiento De Reclamaciones");
        
   MENSAJE_INFORMATIVO("Poliza se encuentra dentro del periodo de 60 dias de tiempo de espera.",0,"OK",0);
  
   MENSAJE_INFORMATIVO("Modificaciones Han Sido Grabadas.",2,"OK",0);
   
   
   
   
   MDILocal.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).DblClick(465,305);
   // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Mantenimiento de Afiliados Medicos").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 3)
   if(aqString.Compare(Project.Variables.tipoReclamante ,"medico",false) == 0)
   {
    MDIManAfiliadosMedicos = getMDIWindow(determineForm(),"Mantenimiento de Afiliados Medicos");
    paymentType =  MDIManAfiliadosMedicos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 3).Value;
   }
   else
   {
    MDIManAfiliadosMedicos = getMDIWindow(determineForm(),"Mantenimiento de Afiliados No Medicos");
    paymentType =  MDIManAfiliadosMedicos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 1).Value;
   }
  Log.Message("Payment Mode Detected: " + paymentType);
  if(aqString.Compare("cheque",paymentType,false) == 0)
  {
    Project.Variables.expectedRazonAfterProcessing = "PENDING CHECK ISSUANCE";
  }
  else
  {
    Project.Variables.expectedRazonAfterProcessing = "PENDING BANK TRANSACTION";
  }
  
  var formObject = determineForm();
  if (formObject.MenuBar("Application").MenuItem("Action").Exists)     
        {
        Log.Enabled = true;
        formObject.MenuBar("Application").MenuItem("Action").Click(); 
        var exitmenu = Sys.Process("ifrun60").Popup("Action").MenuItem("Exit");
        if(exitmenu.Enabled) exitmenu.Click();
        }
    MENSAJE_INFORMATIVO("Poliza se encuentra dentro del periodo de 60 dias de tiempo de espera.",0,"OK",0);      
  //  MENSAJE_FORMS("Do you want to save changes you have made.",0,"Cancel",0);
      var  MDIMaintenimientoDeReclamaciones= getMDIWindow(determineForm(),"Mantenimiento De Reclamaciones");
      MDIMaintenimientoDeReclamaciones.TitleBar(0).Button("Maximize").Click();  
  }

  function handleMENSAJE_INFORMATIVO()
{
 Log.Enabled = false;
      if (Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Exists)
      {
         Log.Enabled = true;   
         Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
      }
      else
      {
       if (Sys.Process("ifrun60").Dialog("PRECAUCION").Exists)
      {
         Log.Enabled = true;   
         Sys.Process("ifrun60").Dialog("PRECAUCION").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
      }
     }
 Log.Enabled = true;  
 }
 
function comprobacionDerechos()
{
  var MDIComprobacionDerechos = getMDIWindow(determineForm() , "Comprobacion Derechos");
   var rootwindow = MDIComprobacionDerechos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   
  //rootwindow.Window("Edit", "", 1).Keys(Project.Variables.Codigo);
   rootwindow.Window("Edit", "", 1).Keys("[Tab]");
   rootwindow.Window("Edit", "", 1).Keys(Project.Variables.poliza);
   rootwindow.Window("Edit", "", 1).Keys("[F9]");
   if(selectAsegurados() == NEGATIVE ) { return NEGATIVE;} 
    rootwindow.Window("ComboBox","",4).Click();
    rootwindow.Window("ComboBox","",4).Click();
    
    value =  rootwindow.Window("Edit","",1).Text;
    /*
    if ( aqString.Find("           .00",value )> -1)
    {
     Log.Message("Balance value as required: " + value);
    } 
    else
    {
    Log.Error("Can not process claim incorrect Balance value observed" + value);
    return NEGATIVE;
    }
    */
    
    rootwindow.Window("Edit","",1).Keys("![Tab]");
    rootwindow.Window("Edit","",1).Keys("![Tab]");
    rootwindow.Window("Edit","",1).Keys("![Tab]");
    rootwindow.Window("Edit","",1).Keys("![Tab]");
    
    var value =  rootwindow.Window("Edit","",1).Text;
    if ( aqString.Find("VIGENTE",value )> -1)
    {
     Log.Message("Estatus value as required: " + value);
    } 
    else
    {
    Log.Error("Can not process claim incorrect Estatus value observed" + value);
    return NEGATIVE;
    }
//    rootwindow.Window("Edit", "", 1).Keys("[Tab]");
//   rootwindow.Window("Edit", "", 1).Keys("[Tab]");
//   rootwindow.Window("Edit", "", 1).Keys("[Tab]");
//   rootwindow.Window("Edit", "", 1).Keys("[Tab]");

     if (Project.Variables.Validaciones == "Y")
     {
       rootwindow.Button("Beneficios").Click();
       calculateDeductible();
       checkDeductibleApplicability();
       calculateDisponible();
     }
    
//     rootwindow.dblClick(210,335);
     rootwindow.Button("Autorizar").Click();
     selectOpciones();
//    clickComprobacionDerechosButton("Autorizar");
//    clickOpcionesRadioButton("Autorizacion / Reclamo");
//    clickOpcionesButton("Continuar");
    Sys.Process("ifrun60").Refresh();
}

function comprobacionDerechosAuto()
{
  var flag = false;
  //var  nextButton = Sys.Process("ifrun60").Form("Seguro de Personas").Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 2);
  var  nextButton = Sys.Process("ifrun60").Form("Saludcore").Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 2);
  var MDIComprobacionDerechos = getMDIWindow(determineForm() , "Comprobacion Derechos");
  var rootwindow = MDIComprobacionDerechos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootwindow.Window("Edit", "", 1).Keys("[F8]"); 
  var counter = 0;
  Log.Error("Start");
  while(counter<11)// !flag)
  {   
      counter++;
      rootwindow.Click(575,333);
      rootwindow.Click(575,333);
      
      var value =  rootwindow.Window("Edit","",1).Text;
      
      if ( aqString.Find("VIGENTA",value )> -1)
      {
        flag = true;
      } 
      else
      {
        var test = MENSAJE_INFORMATIVO("Ultimo Registro",0,"OK",0);
        
        if (test != 1) 
        {
          rootwindow.Click(100,120);
          //Sys.Process("ifrun60").Form("Saludcore").Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 2).Click();
          nextButton.Click();
          
        }
        else 
          return -1;
      }
    }
    Log.Error("Finish");
    
    /*
    counter = 0;
    Log.Error("Start2");
    while(counter<11)// !flag)
    {     
      counter++;
    //rootwindow.Window("Edit", "", 1).Keys(Project.Variables.Codigo);
    //rootwindow.Window("Edit", "", 1).Keys("[Tab]");
    //rootwindow.Window("Edit", "", 1).Keys(Project.Variables.poliza);
     
     //if(selectAsegurados() == NEGATIVE ) { return NEGATIVE;} 
      
      rootwindow.Window("ComboBox","",4).Click();
      rootwindow.Window("ComboBox","",4).Click();
    
      rootwindow.Window("Edit","",1).Keys("![Tab]");
      rootwindow.Window("Edit","",1).Keys("![Tab]");
      rootwindow.Window("Edit","",1).Keys("![Tab]");
      rootwindow.Window("Edit","",1).Keys("![Tab]");
      
      var value =  rootwindow.Window("Edit","",1).Text;
      
      if ( aqString.Find("VIGENTA",value )> -1)
      {
        flag = true;
      } 
      else
      {
        var test = MENSAJE_INFORMATIVO("Ultimo Registro",0,"OK",0);
        Log.Error(test);
        if (test != 1) 
        {
          rootwindow.Window("ComboBox", "", 5).Click();
          rootwindow.Window("ComboBox", "", 5).Click();
          Sys.Process("ifrun60").Form("Seguro de Personas").Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 2).Click();
        }
        else 
          return -1;
      }
    } 
    Log.Error("Finish2");
    */
//    rootwindow.Window("Edit", "", 1).Keys("[Tab]");
//   rootwindow.Window("Edit", "", 1).Keys("[Tab]");
//   rootwindow.Window("Edit", "", 1).Keys("[Tab]");
//   rootwindow.Window("Edit", "", 1).Keys("[Tab]");

     if (Project.Variables.Validaciones == "Y")
     {
       rootwindow.Button("Beneficios").Click();
       calculateDeductible();
       checkDeductibleApplicability();
       calculateDisponible();
     }
    
//     rootwindow.dblClick(210,335);
     rootwindow.Button("Autorizar").Click();
     selectOpciones();
//    clickComprobacionDerechosButton("Autorizar");
//    clickOpcionesRadioButton("Autorizacion / Reclamo");
//    clickOpcionesButton("Continuar");
    Sys.Process("ifrun60").Refresh();
}

function checkDeductibleApplicability()
{
//  var MDIBeneficiosAsegurado = getMDIWindow(determineForm(),"Beneficios Asegurado");
//  MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Keys("[Down]");
//  Project.Variables.tcNum=5;
  var MDIComprobacionDerechos = getMDIWindow(determineForm() , "Comprobacion Derechos");
   var rootwindow = MDIComprobacionDerechos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootwindow.dblClick(210,335);
  Delay(2000);
  MDISaludcore = getMDIWindow(determineForm(),"Saludcore");
  Delay(500);
  MDISaludcore.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Limites/Tipo Cob").Click();
  
//  Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Saludcore").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Limites/Tipo Cob").Click();
  Delay(500);
  var MDIRestriccionesPor = getMDIWindow(determineForm(),"Restricciones por Tipo Coberturas");
  var rootWindowRestc = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  
  var myfields = new Array("rowflag", "Test", "tipoCoberturaCode", "tipoCobertura", "deductible", "disponible");
   var pvname = "Disponible"; 
   var columnCount = addProjectVariableTable(pvname, myfields);
          
   count = determineNumberOfClaimDataRows("TipoCobertura",Project.Variables.tcNum); // determineNumberOfTipoCorberturaCodes(Project.Variables.tcNum);
      if ( count > 0)
      {
        for (i=1; i<= count; i++)
        {
           readTipoCorberturaCode(i);
           rootWindowRestc.Window("Edit","",1).Keys("[F7]"); 
           rootWindowRestc.Window("ui60Viewcore_W32", "", 11).Click();
           selectGriditemByName("Tipos de Coberturas",0,Project.Variables.tipo);
           MDIComprobacionDerechos.Window("ui60Drawn_W32", "", 1).Keys("[F8]");
           rootWindowRestc.Click(160,290);
           var tipoCobName = rootWindowRestc.Window("Edit","",1).Text;
           Log.Enabled = false;
           for(j=0;j<5;j++)
           {
            MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 1).Button("Page right").Click();
           }
           Log.Enabled = true;
           
           var applyDeductible = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Button", " ", 25).State;
            Log.Enabled = false;
            for(j=0;j<5;j++)
           {
            MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 1).Button("Page left").Click();
           }
           Log.Enabled = true;
          
           
           pvrow=addProjectVariableRow(pvname);
           // first column is reserved for rowflag; rowflag = row number.
           Project.Variables.VariableByName(pvname)(0,pvrow) = pvrow;
           Project.Variables.VariableByName(pvname)(1,pvrow) = Project.Variables.tcNum;
           Project.Variables.VariableByName(pvname)(2,pvrow) = Project.Variables.tipo;
           Project.Variables.VariableByName(pvname)(3,pvrow) = tipoCobName;
           Project.Variables.VariableByName(pvname)(4,pvrow) = applyDeductible;
           Project.Variables.VariableByName(pvname)(5,pvrow) = 0;
           rootWindowRestc.Click(160,290);
        }
      }
      rootWindowRestc.Button("Pantalla Anterior").Click();
      var formObject = determineForm();
      if (formObject.MenuBar("Application").MenuItem("Action").Exists)     
        {
        Log.Enabled = true;
        formObject.MenuBar("Application").MenuItem("Action").Click(); 
        var exitmenu = Sys.Process("ifrun60").Popup("Action").MenuItem("Exit");
        if(exitmenu.Enabled) exitmenu.Click();
        }
}

function calculateDeductible()
{
  
  var MDIBeneficiosAsegurado = getMDIWindow(determineForm(),"Beneficios Asegurado");
  MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 12).Click();
  var MDIDeducible = getMDIWindow(determineForm(),"Acumuladores - Deducible Grupo Familiar");
  var rootWindowDeductible = MDIDeducible.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
  var aseguradoNum = Project.Variables.asegurado;
  var retrivedAseguradoNum = rootWindowDeductible.Window("Edit","",1).Text;
  dialogname = "Dialog(\"" + "MENSAJE INFORMATIVO" + "\")";
  while(aseguradoNum != retrivedAseguradoNum)
  {
    rootWindowDeductible.Window("Edit","",1).Keys("[Up]");
    dialog = Sys.Process("ifrun60").FindChild("Name", dialogname, 1);
    if(dialog.Exists)
    {
      dialog.Window("ui60Drawn_W32", "", 1).Button("OK").Click();
      Log.Message("Asegurado not found.");
      return NEGATIVE;
    }
    retrivedAseguradoNum = rootWindowDeductible.Window("Edit","",1).Text;
    
 
  }
  if(aseguradoNum == retrivedAseguradoNum)
  {
    rootWindowDeductible.Window("Edit","",1).Keys("[Tab]");
    rootWindowDeductible.Window("Edit","",1).Keys("[Tab]");
    rootWindowDeductible.Window("Edit","",1).Keys("[Tab]");
    rootWindowDeductible.Window("Edit","",1).Keys("[Tab]");
    rootWindowDeductible.Window("Edit","",1).Keys("[Tab]");
    deductibleValue = rootWindowDeductible.Window("Edit","",1).Text;
    disponibleValue = StrToFloat(deductibleValue) ;
    rootWindowDeductible.Window("Edit","",1).Keys("[Tab]");
    deductibleValue = rootWindowDeductible.Window("Edit","",1).Text;
    aplicarValue = StrToFloat(deductibleValue) ;
    if(disponibleValue < 0 || aplicarValue < 0)
     {
      Log.Error("Deductible value can not be less than 0.");
     }
                
    if(disponibleValue > 0 && aplicarValue > 0)
    {
      finalDeductible = aplicarValue;
    } 
    else
      finalDeductible = 0;
  }
  
//  var disponibleXCord = 860;
//  var aplicarXCord = 955;
//  var yCord = 60;
//  var finalDeductible=0;
//  do
//  {
//     rootWindowDeductible.Click(disponibleXCord,yCord);
//     Delay(500,"Delay script execution for 500ms.");
//     deductibleValue = rootWindowDeductible.Window("Edit","",1).Text;
//     if(aqString.GetLength(deductibleValue) > 0)
//          disponibleValue = StrToFloat(deductibleValue) ;
//          
//     rootWindowDeductible.Click(aplicarXCord,yCord);
//     Delay(500,"Delay script execution for 500ms.");
//     deductibleValue = rootWindowDeductible.Window("Edit","",1).Text;
//     if(aqString.GetLength(deductibleValue) > 0)
//          aplicarValue = StrToFloat(deductibleValue) ;
//     else
//          break;
//     if(disponibleValue < 0 || aplicarValue < 0)
//     {
//      Log.Error("Deductible value can not be less than 0.");
//     }
//                
//    if(disponibleValue > 0 && aplicarValue > 0)
//    {
//      finalDeductible = finalDeductible + aplicarValue;
//    }
//    yCord += 18;
//     
//  }
//  while (aqString.GetLength(deductibleValue) != 0);
  addProjectVariable("deductibleApplicable","string",finalDeductible);
  Log.Message("Calculated Deductible: " + Project.Variables.deductibleApplicable);
  rootWindowDeductible.Button("Pantalla Anterior").Click();
  MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Pantalla Anterior").Click();
}

function calculateDisponible()
{
  
  rowCount = Project.Variables.VariableByName("Disponible").RowCount;
  for(i=0;i<rowCount;i++)
  {
    Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Comprobacion Derechos").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Beneficios").Click();
    var MDIBeneficiosAsegurado = getMDIWindow(determineForm(),"Beneficios Asegurado");
    var rootWindowBeneficiosAsegurado = MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
    value = rootWindowBeneficiosAsegurado.Window("Edit","",1).Text;
    tipoCob = Project.Variables.VariableByName("Disponible")(3,i);
    var lastRow=false;
    count =0;
    while(!lastRow)
    {
      if((aqString.Compare(tipoCob,value,false) == 0) || (aqString.Compare(tipoCob + " (" + Project.Variables.tipoServicio + ")",value,false) == 0))
      {
        lastRow = true;
         clientWindow = MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
           MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Keys("[Tab]");
          MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Keys("[Tab]");
          MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Keys("[Tab]");
          MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Keys("[Tab]");
          montoMax = MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit","",1).Text;
          var regExp = / /g; 
          if (montoMax.replace(regExp,"") == "")
          {
            MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(890,390);
            Delay(500);
            MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(890,390); 
            if((aqString.Compare(tipoCob,"TRASPLANTE DE ORGANOS FASE II",false) == 0) || (aqString.Compare(tipoCob,"TRASPLANTE DE ORGANOS FASE III",false) == 0))
            {
              MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Down]");
              MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Down]");
              disponible =StrToFloat(MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text);                                                                                                                                                                            
            }
            else
            {
            disponible =StrToFloat(MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text);
            }
          }
          else
          {
          MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Keys("[Tab]");
          MDIBeneficiosAsegurado.Window("ui60Drawn_W32", "", 1).Keys("[Tab]");
          disponible =StrToFloat(clientWindow.Window("Edit","",1).Text);
          }
         Project.Variables.VariableByName("Disponible")(5,i)=disponible;
        Log.Message("Calculated disponible value for " + Project.Variables.VariableByName("Disponible")(3,i) + " is: " + disponible);
         
        break;
      }
      rootWindowBeneficiosAsegurado.Window("Edit","",1).Keys("[Down]");
      previousValue= value;
      value = rootWindowBeneficiosAsegurado.Window("Edit","",1).Text;
      if(aqString.Compare(previousValue,value,false) == 0)
      {
        lastRow=true;
        MENSAJE_INFORMATIVO("Ultimo Registro",0,"OK",0);
      }
      
      count++;
      
    }
    rootWindowBeneficiosAsegurado.Button("Pantalla Anterior").Click();
    
  }
}

function selectOpciones()
{
  var MDI = getMDIWindow(determineForm(), "OPCIONES");
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).RadioButton("Autorizacion / Reclamo").Click();
  MDI.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Continuar").Click();
}


function selectAsegurados()
{
 var name = "Asegurados";
    var rootWindow  = Sys.Process("ifrun60").Dialog(name);
    if (!rootWindow.Client(name).Exists) { return NEGATIVE;}
    return selectGriditemByName(name, 0, Project.Variables.asegurado);
    
 
}

function FindEditbuttons()
{
  var p, w, textBoxes, i;

  w = Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2);

  // Search for all edit buttons in the Font dialog
  textBoxes = w.FindAll("WndClass", "Edit", 10);
  textBoxes = (new VBArray(textBoxes)).toArray();

  // Log the search results
  if (textBoxes.length > 0)
  {
    for (i = 0; i < textBoxes.length; i++)
      Log.Message("FullName: " + textBoxes[i].FullName + "\r\n" +
                  "Text: " + textBoxes[i].wText);
    Log.Message("Total number of found edit buttons: " + textBoxes.length);
  }
  else
    Log.Warning("No edit buttons found.");
}


function testUtility()
{
  var MDICoberturarDeSalud = getMDIWindow(determineForm(),"Coberturas de Salud"); 
  // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1)
  
  MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(420,44);
  MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(420,64);
  MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(420,84);
  
}

//Dilip

function retreiveClaimData()
{ //var Project.Variables.tcNum = getProject.Variables.tcNum(1)
  readClaim();  
  readTipoCorberturaCode(1);
   
  MantenimientosMenu("Saludcore");
  var MDISaludcore = getMDIWindow(determineForm(), "Saludcore")
  var rootWindow = MDISaludcore.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootWindow.Window("Edit", "", 1).Keys("[F7]");
  rootWindow.Window("ui60Viewcore_W32", "", 11).Click();

  var tmp = selectGriditemByName("Lista de", 0, Project.Variables.plan); 
  
  rootWindow.Window("ComboBox", "", 7).Text(0).Click();
  rootWindow.Window("ComboBox", "", 7).Text(0).Click();
  rootWindow.Window("ComboBox", "", 7).Text(0).Keys("![Tab]");
  value = rootWindow.Window("Edit", "", 1).Text;
  value = aqString.Trim(value, aqString.stLeading);
  addProjectVariable("planDeduction", "string", value);
  
  clickPlanButton("Limites/Tipo Cob");

  var MDIRestriccionesPor = getMDIWindow(determineForm(),"Restricciones por");
  var rootWindow = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootWindow.Window("Edit", "", 1).Keys("[F7]");
  rootWindow.Window("Edit", "", 1).Keys(Project.Variables.tipo);
  rootWindow.Window("Edit", "", 1).Keys("[F8]");
  rootWindow.Window("Edit", "", 1).Keys("[Tab]");
  
  if (aqString.Find(Project.Variables.examineService, "y") != -1)
  {
     foundEntry = false;
     numberOfRows = determinNumberofRows();
     readServiceClaim();
  //   rootWindow.Window("Edit", "", 1).Keys("[Tab]");
     servicePlan = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
     var i = 0;
     while ((i < numberOfRow) && (!foundEntry))
     // for (var i = 0; i < numberOfRows; i++)
     {   if (aqString.Find(servicePlan, Project.Variables.servicePlan) > -1)
         { foundEntry = true; if ( i > 5) {offset = 4; } else { offset = i; } break;}
         else
         {
             MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Down]");
             servicePlan = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
         }
         i++;
     }
     
     if (foundEntry)
     {
        rootWindow = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 80 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 75 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 70 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 65 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 60 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 55 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 50 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 45 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 40 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 35 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 30 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 25 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 20 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 15 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("Edit", "", 1).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 10 - offset).Text(0).Keys("[Tab]");
        rootWindow.Window("ComboBox", "", 5 - offset).Text(0).Keys("[Tab]");
        applyDeductible = rootWindow.Window("Button", " ", 25 - offset).State;
        if (applyDeductible) { applyDeductible = "y";} else { applyDeductible = "n";} 
        addProjectVariable("applyDeductible", "string", applyDeductible);
     }
  }

  rootWindow = MDIRestriccionesPor.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
  rootWindow.Window("ui60Viewcore_W32", "", 6).Click();
  Sys.Process("ifrun60").Dialog("Saludcore").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
  
  rootWindow.Window("Edit", "", 1).Keys("[F7]");
  rootWindow.Window("Edit", "", 1).Keys(Project.Variables.tipo);
  rootWindow.Window("Edit", "", 1).Keys("[F8]");
  rootWindow.Window("Edit", "", 1).Keys("[Tab]");
  value = rootWindow.Window("Edit", "", 1).Text;
  value = aqString.Trim(value, aqString.stLeading);
  addProjectVariable("planMaxAmount", "string", value);
  rootWindow.Button("Pantalla Anterior").Click();
  //goToMain();
}

function makeClaim()
{ //var Project.Variables.tcNum = getProject.Variables.tcNum(1) 
   readClaim();  
   if (  aqString.Find(Project.Variables.executeClaim, "N") > - 1   ) return; 
   
   retreivePolicydata(Project.Variables.PolicyNum);
   if(!goToMain()) { Log.Message("TODO .... in makeClaim"); return;}
   
   retreiveClaimData(Project.Variables.tcNum);
   if(!goToMain()) { Log.Message("TODO2 .... in makeClaim"); return;}
   
   MantenimientosMenu("Comprobacion Derechos");
   
   var formObject = determineForm();
   var MDIComprobacionDerechos = getMDIWindow(formObject, "Comprobacion Derechos");
   var rootwindow = MDIComprobacionDerechos.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
   rootwindow.Window("Edit", "", 1).Keys(Project.Variables.Codigo);
   rootwindow.Window("Edit", "", 1).Keys("[F8]");
   
    clickComprobacionDerechosButton("Autorizar");
    clickOpcionesRadioButton("Autorizacion / Reclamo");
    clickOpcionesButton("Continuar");
    Sys.Process("ifrun60").Refresh();
    
    var MDIReclamaciones = getMDIWindow(determineForm(), "Mantenimiento De Reclamaciones");
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 13).Click();
     
     var popupMSG = MENSAJE_INFORMATIVO("Reclamaciones", ZZZ0, "OK", 0); 
     // Log.Enabled = false;
     // if (Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Exists)
     // {
        // Log.Enabled = true;   
        // Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
     // }
     // Log.Enabled = true;
     
     Sys.Process("ifrun60").Dialog("Calendario").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Cancel").Click();
    //Jeff add step
    // Sys.Process("ifrun60").Dialog("MENSAJE INFORMATIVO").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
     
    if (Project.Variables.fechaServico != null)
     MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys(Project.Variables.fechaServico);
    
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4).Button("Open").Click();
 //    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4).Button("Open").Click();
    selectComboBoxItem(Project.Variables.tipoReclamante); 
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4).Text(0).Keys("[Tab]");
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Keys("[Tab]");
    
    var MDITransferencia = getMDIWindow(determineForm(), "Transferencia");
    MDITransferencia.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).RadioButton(Project.Variables.formaDePago).Click();
    MDITransferencia.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Pantalla Anterior").Click();
    var popupMSG = MENSAJE_DE_ERROR("Transferencia", 0, "OK", 1);
    
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4).Button("Open").Click();
    selectComboBoxItem(Project.Variables.tipoServicio);                                   
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 4).Keys("[Tab]"); 
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 3).Button("Open").Click();
    selectComboBoxItem(Project.Variables.tipoRemitente);                        
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ComboBox", "", 3).Keys("[Tab]");
    MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("ui60Viewcore_W32", "", 15).Click();
    var tmp = selectGriditemByName("Lista de", 0, Project.Variables.listaDeTipo); 
    
    clickMantenimientoDeReclamaciones("Diagnosticos");
    //Sys.Process("ifrun60").Dialog("Lista de").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1)
    if ( aqString.Find(Project.Variables.diagnosticCodeFlag, "y") > -1)
    {
      count = determineNumberOfClaimDataRows(Project.Variables.tcNum, "diagnostics"); //determineNumberOfDiagnosticCodes(Project.Variables.tcNum);
      if (count > 0)
      {
           for (i = 1; i<=count; i++)
           {
               readDiagnosticCode(Project.Variables.tcNum, i);
               var MDIDiagnosticos = getMDIWindow(formObject,"Diagnosticos en Reporte Hospitalizacion");
               var rootwindow = MDIDiagnosticos.Window("ui60Drawn_W32", "", 1);
               rootwindow.Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys(Project.Variables.diagnosticCode);
               rootwindow.Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys("[Tab]");  
               if (i < count){ rootwindow.Window("ui60Drawn_W32", "", 2).Keys("[Tab]");}
           }
      }
    
    }
    clickDiagnosticEnReporteButton("coberturas");
    Log.Enabled = false;
    if ( Sys.Process("ifrun60").Dialog("PRECAUCION").Exists)
    {
      Log.Enabled = true;
      Sys.Process("ifrun60").Dialog("PRECAUCION").Window("ui60Drawn_W32", "", 1).Button("OK").Click();
    }
    Log.Enabled = true;
     //Jeff insert here
    //different form
    
    addCoberturarDeSalud(Project.Variables.tcNum);
 

   
    
 // formObject.Panel("Workspace").getMDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(39, 30);
  var MDICoberturasDeSalud = getMDIWindow(formObject,"Coberturas de Salud"); 
  rootWindow = MDICoberturasDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2);
  rootWindow.Click(42, 30);
  value = MDICoberturasDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
  addProjectVariable("claimNumber_1", "integer", value);
  rootWindow.Click(71, 30);
  value = MDICoberturasDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
  addProjectVariable("claimNumber_2", "integer", value); 
  rootWindow.Click(100, 30);
  value = MDICoberturasDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
  addProjectVariable("claimNumber_3", "integer", value); 
  rootWindow.Click(142, 30);
  value = MDICoberturasDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
  addProjectVariable("claimNumber_4", "integer", value); 
  clickCoberturasDeSaludButton("Anterior");
  
  var popupMSG = MENSAJE_DE_ERROR("Coberturas de Salud", 0, "OK", 0);
  MENSAJE_INFORMATIVO("Asegurado presenta enmienda aumento de deducible.",0,"OK",0);
  
  clickMantenimientoDeReclamaciones("Cerrar/Pago");
 // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").getMDIWindow("Mantenimiento De Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Cerrar/Pago")

  var popupMSG = MENSAJE_DE_ALERTA("Coberturas de Salud", 0, "Si", 1);
  formObject.Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Click();
  var tmp = selectGriditemByName("Lista Motivo Estatus Reclamación", 0, Project.Variables.qualityCode);
 // Sys.Process("ifrun60").Dialog("Lista Motivo Estatus Reclamación").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1)
  formObject.Panel("Workspace").Window("ui60MDIdocument_W32", " ", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Button("Aceptar").Click();

  MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(156, 519);
  value = MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
  if ( aqString.Find(Project.Variables.expectedEstatus, value) > -1)
  {
    Log.Message("The correct Estatus value observed: " + value);
  }
  else
    Log.Error("Incorrect Estatus value observed. Expected: " + Project.Variables.expectedEstatus + " Detected: " + value);

  MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Click(98, 554);
  value = MDIReclamaciones.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Window("Edit", "", 1).Text;
  if ( aqString.Find(Project.Variables.expectedRazon , value) > -1)
  {
    Log.Message("The correct Razon Estatus value observed: " + value);
  }
  else
    Log.Error("Incorrect Estatus value observed. Expected: " + Project.Variables.expectedRazon + " Detected: " + value);
    
  qualityControl1(true);
  //goback to quality control to verify state information based on boolean passed in
  qualityControl1(false);

}

function qualityControl()
{
  
  var formObject, rootWindow;
  
  readQualityControl();
   if(!goToMain()) { Log.Message("TODO .... in qualityControl"); return;}
  MantenimientosMenu("Seleccion de Reclamaciones");   

  Sys.Process("ifrun60").Refresh();  
  formObject = determineForm(); 
  
 // formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys("[Tab]");
  rootWindow = formObject.Panel("Workspace");
  objectItem = rootWindow.FindChild("Name", "Window*, 96)", 6);
  //.getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
 // Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 96)
  //rootWindow.Window("ui60Viewcore_W32", "", 96).Click();
  objectItem.Click();
  var tmp = selectGriditemByName("ESTATUS DE RECLAMACIONES", 0, Project.Variables.estatus);
  objectItem = rootWindow.FindChild("Name", "Window*, 80)", 6);
  objectItem.Click(); 
  //rootWindow.Window("ui60Viewcore_W32", "", 80).Click();
  var tmp = selectGriditemByName("Lista Motivo Estatus Reclamación", 0, Project.Variables.reasonEstatus); 
   objectItem = rootWindow.FindChild("Name", "Window*ComboBox*, 48)", 6);
    objectItem.Button("Open").Click();
    objectItem.Button("Close").Click(); 
    objectItem.Text(0).Keys("[F8]");
  //formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[F8]");
 
 /* aqUtils.Delay(500);
  objectItem = rootWindow.Window("ui60Drawn_W32", "", 2).FindChild("Name", "Window*Edit, 1)", 3); 
  value = objectItem.Text; 
 // value = formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
   
  if ( aqString.Find(Project.Variables.claimNumber_1, value) > -1)
    Log.Message("First portion of the claim number is correct: " + value);
  else
    Log.Error("First portion of the claim number is invalied. expected: " + Project.Variables.claimNumber_1 + " detected: " + value); 
   
    objectItem.Keys("[Tab]");
  //formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys("[Tab]"); 
  value = formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
   
  if ( aqString.Find(Project.Variables.claimNumber_1, value) > -1)
    Log.Message("Third portion of the claim number is correct: " + value);
  else
    Log.Error("Third portion of the claim number is invalied. expected: " + Project.Variables.claimNumber_1 + " detected: " + value); 

  
  formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Keys("[Tab]");
  
  value = formObject.Panel("Workspace").getMDIWindow("Seleccion de Reclamaciones").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("Edit", "", 1).Text;
   
  if ( aqString.Find(Project.Variables.claimNumber_1, value) > -1)
    Log.Message("Fourth portion of the claim number is correct: " + value);
  else
    Log.Error("Fourth portion of the claim number is invalied. expected: " + Project.Variables.claimNumber_1 + " detected: " + value); 
*/
  objectItem = rootWindow.FindChild("Name", "Window*Button*, 26)", 6);
  objectItem.Click(); 
  
  clickSeleccionDeReclamacionesButton("Aprobación QC"); 
  var popupMSG = MENSAJE_DE_ALERTA("Seleccion de Reclamaciones", 0, "Si", 1);
  var popupMSG = MENSAJE_FORMS("Seleccion de Reclamaciones", 0,"OK", 1);
}




function qualityControl1(beforeProcessing)
{
    var formObject, rootWindow;
   // Project.Variables.tcNum = 1;
//    readQualityControl();
   // readClaim();
  if (beforeProcessing)
  {
    if(!goToMain()) { Log.Message("TODO .... in qualityControl1"); return;}
    MantenimientosMenu("Seleccion de Reclamaciones");   
  } 
   // clickSeleccionDeReclamacionesButton("Aprobación QC"); 
   formObject = determineForm();
   rootWindow =  formObject.Panel("Workspace").FindChild("Caption", "Seleccion de Reclamaciones");
  rootWindow =  rootWindow.FindChild("Name", "Window*ui60Drawn_W32*, 2)", 3);
  
  rootWindow.Window("Edit", "", 1).Keys("[F7]"); 
  rootWindow.Window("Edit", "", 1).Keys( Project.Variables.claimNumber_1);
  rootWindow.Window("Edit", "", 1).Keys( "[Tab]");  
  rootWindow.Window("Edit", "", 1).Keys( Project.Variables.claimNumber_3);
  rootWindow.Window("Edit", "", 1).Keys( "[Tab]");  
  rootWindow.Window("Edit", "", 1).Keys( Project.Variables.claimNumber_4);
  rootWindow.Window("Edit", "", 1).Keys( "[F8]");  
  
  objectItem = formObject.Panel("Workspace").FindChild("Name", "Window*, 112)", 6);
  objectItem.Click();
  objectItem = objectItem.Parent;
  value = objectItem.Window("Edit", "", 1).Text;
  addProjectVariable("retreivedEstatus", "string", value);
  
  if ( aqString.Find(Project.Variables.retreivedEstatus, Project.Variables.expectedEstatus)> -1)
  {
     Log.Message("Estatus value as expected: " + Project.Variables.expectedEstatus);
  } 
  else
     Log.Error("Unexpected Estatus value. Expected: " + Project.Variables.expectedEstatus + " Detected: " + Project.Variables.retreivedEstatus);
  
  objectItem = formObject.Panel("Workspace").FindChild("Name", "Window*, 96)", 6);
  objectItem.Click(); 
  objectItem = objectItem.Parent;
  value = objectItem.Window("Edit", "", 1).Text;
  addProjectVariable("retreivedRazonEstatus", "string", value);
  
  if (beforeProcessing)
  {
 
    expectedValue = aqString.ToUpper(Project.Variables.expectedRazon);   
  }
  else
   expectedValue = aqString.ToUpper(Project.Variables.expectedRazonAfterProcessing);
                                                                                   
   if ( aqString.Find(Project.Variables.retreivedRazonEstatus, expectedValue)> -1)
  {
     Log.Message("Razon Estatus value as expected: " + Project.Variables.retreivedRazonEstatus)
  } 
  else
     Log.Error("Unexpected Razon Estatus value. Expected: " + expectedValue + " Detected: " + Project.Variables.retreivedRazonEstatus);
  
  if (beforeProcessing)
  {
    objectItem = formObject.Panel("Workspace").FindChild("Name", "Window*Button*, 28)", 6);
    objectItem.Click(); 
    clickSeleccionDeReclamacionesButton("Aprobación QC");
    var popupMSG = MENSAJE_DE_ALERTA("Aprobación QC", 0, "Si", 0);
    var popupMSG = MENSAJE_FORMS("Aprobación QC", 0, "OK", "OK", 0);  
  }
  
  MENSAJE_FORMS("Proceso de Quality Control termino exitosamente.", 0, "OK", "OK", 0);
  
}

function addCoberturarDeSalud()
{
  //Project.Variables.tcNum = 3;
  var totalClaimAmount, totalDescuento, totalMontoGlosa, totalMontoElegible, totalMontoAPagar, totalCob, totalReclamando, totalAPager, montoMax, totalTipCob;
  // var formObject = determineForm();
  var MDICoberturarDeSalud = getMDIWindow(determineForm(),"Coberturas de Salud");
  var rootWindowCoberturar = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
  rootWindowCoberturar.Window("ui60Viewcore_W32", "", 58).Click();
  
  selectGriditemByName("Lista de Grupos Cobertura",0,Project.Variables.gruposCoberturar);
     rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]"); 
     MENSAJE_INFORMATIVO("Poliza se encuentra dentro del periodo de 60 dias de tiempo de espera.",0,"OK",0);
     MENSAJE_DE_ERROR("Valor del Campo No Puedo ser Nulo",0,"OK",0);
     MENSAJE_FORMS("Fiels must be entered",0,"OK",0);
     MENSAJE_DE_ERROR("Valor del Campo No Puedo ser Nulo",0,"OK",0);
     
    if (true || aqString.Find(Project.Variables.tipoCoberturaFlag, "y") > -1)
    {
      count = determineNumberOfClaimDataRows("TipoCobertura",Project.Variables.tcNum); // determineNumberOfTipoCorberturaCodes(Project.Variables.tcNum);
      totalTipCob = count;
      if ( count > 0)
      {
        index = 0;
        totalCob = 0;
        totalReclamando = 0;
        totalAPager = 0;
        montoMaxYCorod = 146;
        for (i=1; i<= count; i++)
        {
           readTipoCorberturaCode(i);
          
           if (Project.Variables.Validaciones == "Y")
           {

              if(Project.Variables.VariableByName("Disponible")(4,i-1) == 0)
              addProjectVariable("applyDeductible","string","N");
              else
              addProjectVariable("applyDeductible","string","Y");
          
              Log.Message("Deductible Applicable? " + Project.Variables.applyDeductible );
           }
          // MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 11 - index ).Click();
          MDICoberturarDeSalud = getMDIWindow(determineForm(),"Coberturas de Salud");
          rootWindowCoberturar = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
 
          rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");  
          var tmp = selectGriditemByName("Lista de Tipo Cobertura ", 0, Project.Variables.tipo);  
          rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
          MENSAJE_PRECAUCION("Precaucion Message",0,"OK",0);
          Log.Enabled = true;
          Log.Enabled=false;  
          
          /*     
          var T1 = Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Air Ambulance Check List");
          var T2 = T1.Visible;
          if(Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Air Ambulance Check List").Visible)
          {
            Log.Enabled=true;
            MDIAmbulance = getMDIWindow(determineForm(), "Air Ambulance Check List");
            rootWindowAmbulance = MDIAmbulance.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
            for(k=15;k>0;k--)
            {
              if(k == 9)
              k--;
              if(k == 1)
              rootWindowAmbulance.RadioButton("N/A").Click();
              else
              rootWindowAmbulance.RadioButton("N/A", k).Click();
            }
            Sys.Process("ifrun60").Form("Saludcore").Panel("Workspace").MDIWindow("Air Ambulance Check List").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3).Button("Continuar").Click();
          }
          */
          
          Log.Enabled=true;
          
           if ( aqString.Find(Project.Variables.coberturarDeSaludFlag, "y") > -1 )
           {
             testItem = Project.Variables.coberturarDeSaludTest;
             coberturarDeSaludCount = determineNumberOfClaimDataRows("coberturasDeSalud",Project.Variables.coberturarDeSaludTest); // determineNumberOfCoberturarDeSaludCodes(testItem);
             
             if ( coberturarDeSaludCount > 0)
             {
                coberturarDeSaludIndex = 0;
                coberturarDeSaludDedGLYCord = 44;
                totalClaimAmount = 0;
                totalDescuento = 0;
                totalMontoGlosa = 0;
                totalMontoElegible = 0;
                totalMontoAPagar = 0;
                for (j=1; j<= coberturarDeSaludCount; j++)
                { 
                var MDICoberturarDeSalud = getMDIWindow(determineForm(),"Coberturas de Salud");
                var rootWindowCoberturar = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
 
                    readCoberturarDeSaludCode(j);
                    //MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 7 - coberturarDeSaludIndex).Click();
                    
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Enter]");
                      selectGriditemByName("Lugares de Servicio",0,Project.Variables.lugarDeServicio)
                      //selectFirstGridItem("Lugares de Servicio");
                      
                      //rootWindowCoberturar.Window("ComboBox", "", 7-(j-1)).Button("Open").Click();
                      Sys.Keys("[Down]");
                      selectComboBoxItem(Project.Variables.tipoProc);
                      rootWindowCoberturar.Window("ComboBox", "", 7-(j-1)).Keys("[Tab]");
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                     
                      /*
                      aqUtils.Delay(2500);
                      Sys.Keys("[Enter]");
                      aqUtils.Delay(2500);
                      Sys.Keys("[Down]");
                      aqUtils.Delay(500);
                      Sys.Keys("[Enter][Enter][Enter]");
                      aqUtils.Delay(500);
                      */
                      
                       var tmp = selectGriditemByName("Lista de Coberturas", 0, Project.Variables.listaDeCoberturas);
                       rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                       MENSAJE_INFORMATIVO("Posible duplicado",0,"OK",0);
                       MENSAJE_PRECAUCION("Asegurado posee reclamacion similar.",0,"OK",0);
                        rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                       if(aqString.Compare(Project.Variables.tipoProc,"Rev. Code",false) == 0)
                       {
                        rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                        }
                       rootWindowCoberturar=MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
                      
                        rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                        selectGriditemByName("Servicios",0,Project.Variables.descripicionDeServicio);
                        
                          //rootWindowCoberturar.Window("ComboBox","",7-(j-1)).Button("Open").Click();
                         Sys.Keys("[Tab]");
                         aqUtils.Delay(500);
                         Sys.Keys("[Down]");
                         aqUtils.Delay(500);
                         selectComboBoxItem(Project.Variables.tipoRecl);
                         rootWindowCoberturar.Window("ComboBox","",7-(j-1)).Keys("[Tab]");
                         rootWindowCoberturar.Window("Edit","",1).Keys("[Tab]");
                         
                         
                         var popupMSG = MENSAJE_DE_ALERTA("Debe especificar un reclamante pues se ha seleccionado un tipo reclamante", 0, "Si", 0);
                         selectGriditemByName("Lista de Medicos ",0,Project.Variables.reclamante)
                         //selectFirstGridItem("Lista de Medicos ");
                         rootWindowCoberturar.Window("Button", "", 35-(j-1)).Keys("[Tab]");
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                      Sys.Keys("[Tab]");
                      rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.frec);
                       rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                       rootWindowCoberturar.Window("Edit", "", 1).SetText(Project.Variables.claimAmount);
                    totalClaimAmount = totalClaimAmount + aqConvert.StrToFloat(Project.Variables.claimAmount);
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                   MENSAJE_INFORMATIVO("Usted ha excedido el Monto Maximo.",0,"OK",0);
                      
                   if(aqString.Compare(Project.Variables.negociacionType,"%",false) == 0)
                    {
                      rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.negociacion);
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                    }
                   else
                   {
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                      MENSAJE_INFORMATIVO("Usted ha excedido el Monto Maximo.",0,"OK",0);
                      rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.negociacion);
                   }
                    MENSAJE_INFORMATIVO("Usted ha excedido el Monto Maximo.",0,"OK",0);
                   
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                    if(aqString.Compare(Project.Variables.descuentoType,"%",false) == 0)
                    {
                      rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.descuento); 
                      cobDescuento = aqConvert.StrToFloat(rootWindowCoberturar.Window("Edit", "", 1).Text);
                      totalDescuento =  totalDescuento + cobDescuento*Project.Variables.claimAmount/100;
                      rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                    
                    }
                    else
                    {
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                    rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.descuento); 
                    cobDescuento = aqConvert.StrToFloat(rootWindowCoberturar.Window("Edit", "", 1).Text);
                    totalDescuento =  totalDescuento + cobDescuento;
                    }
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]"); 
                    rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.montoGlosa);
                    cobMontoGlosa = aqConvert.StrToFloat(rootWindowCoberturar.Window("Edit", "", 1).Text);
                    totalMontoGlosa =  totalMontoGlosa + cobMontoGlosa;
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]"); 
//                    rootWindowCoberturar.Window("Edit", "", 1).Keys(Project.Variables.montoElegible);
//                    handleMENSAJE_INFORMATIVO();
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]"); 
                    MENSAJE_INFORMATIVO("Usted ha excedido el Monto Maximo.",0,"OK",0);
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("![Tab]"); 
                    
                    var mon = rootWindowCoberturar.Window("Edit", "", 1).Text;
                    
                    if (mon==null)
                    {
                      totalMontoElegible =  totalMontoElegible + aqConvert.StrToFloat(mon);
                    }
                    
                    rootWindowCoberturar.Window("Edit", "", 1).Keys("[Tab]");
                    
                    var popupMSG = MENSAJE_DE_ERROR("addCoberturarDeSalud", 0, "OK", 0);
                    
                    value = rootWindowCoberturar.Window("Edit", "", 1).Text;
                    totalMontoAPagar =  totalMontoAPagar + aqConvert.StrToFloat(value); 
                    Log.Message("Monto A Pagar is: " + value);  
                    montoAPagar  = aqConvert.StrToFloat(value); 
                    
                    expectedMontoAPagar = aqConvert.StrToFloat(Project.Variables.expectedMontoAPagar);
                    MENSAJE_INFORMATIVO("Usted ha excedido el Monto Maximo.",0,"OK",0);
                    for (k =0; k<1; k++)
                    {
                       //MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 1).Button("Column right").Click();
                       MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ScrollBar", "", 1).Button("Page right").Click();
                    }
                    
                     MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(420, coberturarDeSaludDedGLYCord);
                    value = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
                    if ( aqString.Find(Project.Variables.applyDeductible, "n") > -1)
                    {
                      if ( aqString.Find(value, "0.00") > -1)
                        Log.Message(" Monto Ded GL is set to: " + value);
                      else
                        Log.Error(" Monto Ded GL is set to: " + value + " Expected something else");
                    }
                    else
                    {
                      Log.Message(" Monto Ded GL is set to: " + value);
                    }
                    
                    if (Project.Variables.Validaciones == "S")
                    {
                      if(StrToFloat(Project.Variables.deductibleApplicable)<StrToFloat(value))
                      {
                        Log.Error("Monto Ded GL is set to a value greater than applicable decuctible");
                      }
                    }
                    if(StrToFloat(Project.Variables.montoGlosa)>0)
                    {
                      MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
                      MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[F9]");
                      selectGriditemByName("Lista de Valores de",0,Project.Variables.valores);
                      MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
                     // MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("[Tab]");
                      
                    }
                    
                    
                    
            //        formObject.Panel("Workspace").getMDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Keys("![Tab])");
            //        value = formObject.Panel("Workspace").getMDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;
                   
 
                    if ( j < coberturarDeSaludCount)
                    {
                       // formObject.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 19).Click();
                       if ( j > 7)
                       {
                         coberturarDeSaludIndex = 6;
                         //coberturarDeSaludDedGLxcoord
                       }
                       else
                       {
                         coberturarDeSaludIndex++;
                         coberturarDeSaludDedGLYCord = coberturarDeSaludDedGLYCord + 20;
                       }
                    }
                    if(j<coberturarDeSaludCount)
                    rootWindowCoberturar.Window("Edit","",1).Keys("[Tab]");
                }
             
             }
           }
           
           
           
             Log.Message("The calculated total Monto Reclamado Amount is: " + totalClaimAmount);
             Log.Message("The calculated total Descuento is: " + totalDescuento);
             Log.Message("The calculated total Monto Glosa is: " + totalMontoGlosa);
             Log.Message("The calculated total Monto Elegible is: " + totalMontoElegible);
             Log.Message("The calculated total Monto A Pagar is: " + totalMontoAPagar);
           
           clickCoberturasDeSaludButton("Calcular"); 
           var popUp =  MENSAJE_FORMS("Do you want to save changes you have made",0,"Yes",0);
         MENSAJE_PRECAUCION("Possible Duplicado",0,"OK",0);
         MENSAJE_INFORMATIVO("Modificaciones han sido grabadas",0,"OK",0);
         MENSAJE_PRECAUCION("este reclamo debe de ser evaluado por el director medico de reclamos.",0,"OK",0);
           MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Click(1125, montoMaxYCorod )
    //       formObject.Panel("Workspace").getMDIWindow("Coberturas de Salud").Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Click(244, 27);
           value = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit", "", 1).Text;

           Log.Message("The detected Monto Max value is: " + value);
           if ( aqString.GetLength(value) == 0)
               value = "0";
           montoMax = aqConvert.StrToFloat(value); 
           
           /*PPT
           retreiveTipoCobTotals();
           totalCob = totalCob + coberturarDeSaludCount;
           totalReclamando = totalReclamando + totalClaimAmount;
           totalAPager = totalAPager + totalMontoAPagar;
            if(totalAPager <= 0)
            {
              Project.Variables.expectedRazonAfterProcessing = "PENDING EOB ISSUANCE";
            }
            */
            
    //       if ( totalClaimAmount <= montoMax)
    //       {
    //          Log.Message("The expected calculated Monto A Pagar value is: " + totalClaimAmount + " The detected montoMax value is: " + montoMax);
    //       } 
    //       else
    //       {
    //           Log.Error("The expected calculated Monto A Pagar value is: " + totalClaimAmount + " The detected montoMax value is: " + montoMax);
     //      }

             
           
    //       if ( totalTipCob <= Project.Variables.totalTipoCob)
     //      {
     //         Log.Message("The expected Total Tipo Cob value is: " + totalTipCob + " The detected value is: " + Project.Variables.totalTipoCob);
    //       }
    //       else 
    //       {
    //          Log.Error("The expected Total Tipo Cob value is: " + coberturarDeSaludCount + " The detected value is: " + Project.Variables.totalTipoCob);
    //       }
    
           if (Project.Variables.Validaciones == "Y")
           {
             if ( totalClaimAmount <= Project.Variables.reclamadoTipoCob)
             {
                Log.Message("Totals: The expected  Reclamando Tip Cob value is: " + totalClaimAmount + " The detected value is: " + Project.Variables.reclamadoTipoCob);

             }
             else 
             {
                Log.Error("Totals: The expected Reclamando Tip Cob value is: " + totalClaimAmount + " The detected value is: " + Project.Variables.reclamadoTipoCob);
             } 
           
             if( totalMontoAPagar <= Project.Variables.VariableByName("Disponible")(5,i-1))
             Log.Message("Observed total A Pagar Tip Cob value: " + totalMontoAPagar + " is Less than Calculated Disponible value: " + Project.Variables.VariableByName("Disponible")(5,i-1) );
             else
             Log.Error("Observed total A Pagar Tip Cob value: " + totalMontoAPagar + " is Greater than Calculated Disponible value: " + Project.Variables.VariableByName("Disponible")(5,i-1) );  
           
             if ( totalMontoAPagar <= Project.Variables.aPagarTipoCob)
             {
                Log.Message("Totals: The expected total  A Pagar Tip Cob value is: " + totalMontoAPagar + " The detected value is: " + Project.Variables.aPagarTipoCob);
             }
             else 
             {
                Log.Error("Totals: The expected total  A Pagar Tip Cob value is: " + totalMontoAPagar + " The detected value is: " + Project.Variables.aPagarTipoCob);
             } 
           }    
           
           if (i < count)
           {
              MDICoberturarDeSalud = getMDIWindow(determineForm(),"Coberturas de Salud");
              rootWindowCoberturar = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1);
 
              MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", (54) ).Click();
              //MENSAJE_INFORMATIVO("Este campo no puede ser Modificado.",0,"OK",0);
              Sys.Process("ifrun60").Dialog("Lista de Tipo Cobertura ").Window("ui60Drawn_W32", "", 1).Button("Cancel").Click();
              var x = 0;
              
              while(x != i)
              {
                MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 1).Window("Edit","",1).Keys("[Down]");
                x++;
              }
              
              
             // formObject.Window("ui60Viewcore_W32", "", 2).Window("ui60Drawn_W32", "", 1).Window("ui60Viewcore_W32", "", 19).Click();
              if (i > 4)
                index = 3;
              else
              {
                index++;
                montoMaxYCorod = montoMaxYCorod + 20;
              }
           }
        }
        if ( totalTipCob <= Project.Variables.totalTipoCob)
           {
              Log.Message("The expected Total Tipo Cob value is: " + totalTipCob + " The detected value is: " + Project.Variables.totalTipoCob);
           }
           else 
           {
              Log.Error("The expected Total Tipo Cob value is: " + coberturarDeSaludCount + " The detected value is: " + Project.Variables.totalTipoCob);
           }
      }
    }
    
   /*Ppt
   retreiveTotalCob();
   
   if ( totalCob <= Project.Variables.totalCob)
   {
      Log.Message("The expected Total Cob value is: " + totalCob + " The detected value is: " + Project.Variables.totalCob);
   }
   else 
   {
      Log.Error("The expected Total Cob value is: " + totalCob + " The detected value is: " + Project.Variables.totalCob);
   }
 
   if ( totalReclamando <= Project.Variables.totalReclamado)
   {
      Log.Message("The expected Total Reclamando value is: " + totalReclamando + " The detected value is: " + Project.Variables.totalReclamado);
   }
   else 
   {
      Log.Error("The expected Total Reclamando value is: " + totalReclamando + " The detected value is: " + Project.Variables.totalReclamado);
   } 
   
   if ( totalAPager == Project.Variables.totalAPagar)
   {
      Log.Message("The expected Total A Pager value is: " + totalAPager + " The detected value is: " + Project.Variables.totalAPagar);
   }
   else 
   {
      Log.Error("The expected Total A Pager value is: " + totalAPager + " The detected value is: " + Project.Variables.totalAPagar);
   } 
   */         
}

function retreiveTipoCobTotals()
{  
  var MDICoberturarDeSalud = getMDIWindow(determineForm(), "Coberturas de Salud");
  var panel = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).FindChild("WndCaption", "Anterior", 2);
  panel = panel.Parent;    // .Window("ui60Drawn_W32");
  
  //panel.Click(474, 451);
  panel.Click(600,500);
  Delay(500,"Delay script execution for 500 milliseconds");
  panel.Click(600,500); 
  var temp = panel.Window("Edit", "", 1).Text;
  if (temp == null)
  {
    value = aqConvert.StrToInt();
  }
  else
  {
    value=0;
  }
  
  addProjectVariable("totalTipoCob", "integer", value); 
  Log.Message("retreiveTipoCobTotals procedure: The total Tipo Cob value is: " + value);
  //panel.Click(537, 453);
  panel.Click(650,500);
  panel.Click(650,500);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text); 
  addProjectVariable("reclamadoTipoCob", "Double", value);  
  Log.Message("retreiveTipoCobTotals procedure: The reclamado Tipo Cob value is: " + value);  
  //panel.Click(606, 454);
  panel.Click(800,500);
  Delay(500,"Delay script execution for 500 milliseconds");
  panel.Click(800,500);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text); 
  addProjectVariable("elegibeTipoCob", "Double", value);  
  Log.Message("retreiveTipoCobTotals procedure: The elegibe Tipo cob value is: " + value);  
  //panel.Click(693, 451);
  panel.Click(900,500);
  Delay(500,"Delay script execution for 500 milliseconds");
  panel.Click(900,500);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text); 
  addProjectVariable("montoGlasado", "Double", value);   
  Log.Message("retreiveTipoCobTotals procedure: The monto Glasado value is: " + value); 
  //panel.Click(742, 453);
  panel.Click(1000,500);
  Delay(500,"Delay script execution for 500 milliseconds");
  panel.Click(1000,500);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text); 
  addProjectVariable("aPagarTipoCob", "Double", value); 
  Log.Message("retreiveTipoCobTotals procedure: The a Pagar Tipo Cob value is: " + value);   
  //panel.Click(813, 455);
  panel.Click(1100,500);
  Delay(500,"Delay script execution for 500 milliseconds");
  panel.Click(1100,500);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text); 
  addProjectVariable("descuento", "Double", value);  
  Log.Message("retreiveTipoCobTotals procedure: The total descuento value is: " + value);  
}

function retreiveTotalCob()
{
  var MDICoberturarDeSalud = getMDIWindow(determineForm(), "Coberturas de Salud");
  var panel = MDICoberturarDeSalud.Window("ui60Drawn_W32", "", 1).FindChild("WndCaption", "Anterior", 2);
  panel = panel.Parent;
  panel.Click(25, 497);
  var popupMSG = MENSAJE_FORMS("Do you want to save changes you have made", 0, "Yes", 0 );
 MENSAJE_INFORMATIVO("Modificaciones han sido grabadas",0,"OK",0);
 MENSAJE_INFORMATIVO("Modificaciones han sido grabadas",2,"OK",0);
      
  value = aqConvert.StrToInt(panel.Window("Edit", "", 1).Text);
  addProjectVariable("totalCob", "integer", value); 
  Log.Message("retreiveTotalCob procedure: The total cob value is: " + value);
  panel.Click(85, 497);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text);
  addProjectVariable("totalReclamado", "Double", value); 
  Log.Message("retreiveTotalCob procedure: The total Reclamado value is: " + value);
  panel.Click(170, 497);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text);
  addProjectVariable("totalElegibe", "Double", value);
  Log.Message("retreiveTotalCob procedure: The total Elegibe value is: " + value);
  panel.Click(257, 497);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text);
  addProjectVariable("totalAPagar", "Double", value);
  Log.Message("retreiveTotalCob procedure: The total A Pagar value is: " + value);
  panel.Click(327, 497);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text);
  addProjectVariable("difAsegurado", "Double", value);
  Log.Message("retreiveTotalCob procedure: The total dif Asegurado value is: " + value);
  panel.Click(417, 497);
  value = aqConvert.StrToFloat(panel.Window("Edit", "", 1).Text);
  addProjectVariable("totalDescuento", "Double", value);
  Log.Message("retreiveTotalCob procedure: The total Descuento value is: " + value);

}