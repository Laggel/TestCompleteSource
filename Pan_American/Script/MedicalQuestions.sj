//USEUNIT utilities    
//USEUNIT excelUtilities
//USEUNIT navigateMainWindow

/// Script file: MedicalQuestions
/// Last update: May 8     

var MEDQMaxTabIdx = 6;

function MEDQTabidx(idx) { MEDQMaxTabIdx = 6; return MEDQMaxTabIdx - idx + 1;}

function initQuestinPVs_ForDebugging(pvname, value)
{
   var pvrow = addProjectVariableRow(pvname);
   Project.Variables.VariableByName(pvname)(1,0) = value;
   return 1;                       
}

function readMEDQInfo(tabname, myfields, startcol, maxrows)
{
  var pvname = tabname + "Info";
   var pvrow = getUnusedPVRow(pvname); if (pvrow == NEGATIVE) { return 0;}
   var columnCount = addProjectVariableTable(pvname, myfields);
   return readMedicalConfig(tabname , startcol, myfields.length, pvname, maxrows); 
}
   
function MEDQ_grid(gridname, NotfoundSeverity)
{  if (selectFirstGridItemByFind(gridname, NotfoundSeverity)) return;
   // handle potentioal dialogs
   // Dialog: This field can not be modified 
   var popupMSG = MENSAJE_INFORMATIVO("este campo no puede ser modificado", 0, "OK", 0);
}
    
function populatePV_habitosQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "habitos");
   var pvname = "habitosInfo";
   var columnCount = addProjectVariableTable(pvname, myfields);
   if (excelObject == null) { var colCount = initQuestinPVs_ForDebugging(pvname, "y"); return;}
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function populatePV_historialFamiliarQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "historialFamiliar");
   var pvname = "historialFamiliarInfo";
   var columnCount =addProjectVariableTable(pvname, myfields);
   if (excelObject == null) { var colCount = initQuestinPVs_ForDebugging(pvname, "y"); return;}
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function populatePV_medicoFamiliaQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "MedicoDeFamila");
//   var pvname = "medicoFamiliaQ";
   var pvname = "medicoFamiliaInfo";
   var columnCount = addProjectVariableTable(pvname, myfields);
   if (excelObject == null) { var colCount = initQuestinPVs_ForDebugging(pvname, "y"); return;}
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function populatePV_examenesMedicosQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "examenesMedicos");
   var pvname = "examenesMedicosInfo";
   var columnCount = addProjectVariableTable(pvname, myfields);
   if (excelObject == null) { var colCount = initQuestinPVs_ForDebugging(pvname, "y"); return;}
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function populatePV_condicionesMedicasQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "condicionesMedicas");
   var pvname = "condicionesMedicasInfo";
   var columnCount = addProjectVariableTable(pvname, myfields);
   if (excelObject == null) { var colCount = initQuestinPVs_ForDebugging(pvname, "y"); return;}
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function populatePV_medicamentosQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "medicamentos");
   var pvname = "medicamentosInfo";
   var columnCount = addProjectVariableTable(pvname, myfields);
   if (excelObject == null) { var colCount = initQuestinPVs_ForDebugging(pvname, "y"); return;}
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function populatePV_additionalMedicalQ(excelObject, startCol)
{
   var myfields = new Array("rowflag", "additionalMedical");
   var pvname = "additionalMedicalInfo";
   var columnCount = addProjectVariableTable(pvname, myfields);
   var colCount = populatePV(excelObject,startCol, columnCount, pvname);
}

function selectMedicalTab(tabNumber)
{ // Viewcore window index is incremented each time a tab is clicked.  
   // var maxtabs = 6; 
   var rootwindow = getMDIWindow(determineForm(), "Información Médica").Window("ui60Drawn_W32", "", 1);
   var tabBar = rootwindow.FindChild("Name", "Window(\"ui60Drawn_W32\", \"\", 8)", 2);
   var found = tabBar.Exists; var i = 0;
   while ((!found) && ( i < MEDQMaxTabIdx))
   { 
      Log.Enabled = false; 
      var tabBar = rootwindow.Window("ui60Viewcore_W32").Window("ui60Drawn_W32", "", 8); 
      Log.Enabled = true;
      found = tabBar.Exists; i++;
   }
   if (!found) { return null;}
   var  ycord = tabBar.Height/2;
   tabBar.Click(115*tabNumber, ycord);
   return tabBar.Parent;
}

function MEDQ_CondicionesMedicas(medqtab, medQ, medqidx, medqmax, tabidx, tablerow, pvrow, startcol)
{
   var medqLeftTable = medqtab.Window("ui60Drawn_W32", "", MEDQTabidx(tabidx));
   if (medQ == "No") {  medqLeftTable.RadioButton("No").Click();}
   else
   {
   medqLeftTable.RadioButton("Si").Click();
   medqLeftTable.Click(145,105);
   medqLeftTable.Window("ui60Viewcore_W32", "", tablerow).Click(); // Cod_Afiliado pulldown
   MEDQ_grid("Lista de", 0);
   
   var pvcol = startcol - 1; // cod
   medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
    pvcol++;
   var rootwindow = medqtab.Parent;
   var medqRightTable = rootwindow.Window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   
   pvcol++; // condition
   medqRightTable.Window("Edit", "", 1).Keys(aqString.Unquote(Project.Variables.condicionesMedicasInfo(pvcol, pvrow)));
   medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
   pvcol++; // desde
   // Project.Variables.condicionesMedicasInfo(pvcol, pvrow) = aqString.Unquote(Project.Variables.condicionesMedicasInfo(pvcol, pvrow));
   medqRightTable.Window("Edit", "", 1).Keys(aqString.Unquote(Project.Variables.condicionesMedicasInfo(pvcol, pvrow)));
   medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
   pvcol++; // hasta
   // Project.Variables.condicionesMedicasInfo(pvcol, pvrow) = aqString.Unquote(Project.Variables.condicionesMedicasInfo(pvcol, pvrow));
   medqRightTable.Window("Edit", "", 1).Keys(aqString.Unquote(Project.Variables.condicionesMedicasInfo(pvcol, pvrow)));
   medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
   pvcol++; // result
   medqRightTable.Window("Edit", "", 1).Keys(Project.Variables.condicionesMedicasInfo(pvcol, pvrow));
   medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
   pvcol++; // estadio
   medqRightTable.Window("Edit", "", 1).Keys(Project.Variables.condicionesMedicasInfo(pvcol, pvrow));
   medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
   pvcol++; // information
   medqRightTable.Window("Edit", "", 1).Keys(Project.Variables.condicionesMedicasInfo(pvcol, pvrow));
   }

   if (medqidx < medqmax) { Delay(100); medqLeftTable.Window("ScrollBar", "", 2).Button("Line down").Click();  } // Next MEDQ Question
} 

function icon_MEDQ_Save(MDIMedica)
{
   // icon_Save(= open door)
   saludecoreToolbar("Grabar");
   var popupMSG = MENSAJE_INFORMATIVO("icon_MEDQ_Save", 0, "OK", 0);
   MDIMedica.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 2).Window("ui60Viewcore_W32", "", 2).Click(); 
   var popupMSG = MENSAJE_FORMS("icon_MEDQ_Save", 0, "Si", 0);
   var popupMSG = MENSAJE_INFORMATIVO("icon_MEDQ_Save", 0, "OK", 0);
   return getMDIWindow(determineForm(),"Consulta"); 
}     

function medicalAdditional1()
{   //populate secondary medical form
    var MDISegMedicosAdicional = icon_infoSegMedicosAdicional();
    if (!MDISegMedicosAdicional.Visible) { Log.Error("Not visible. " + MDISegMedicosAdicional.FullName); return;} 
    var rootwindow = MDISegMedicosAdicional.Window("ui60Drawn_W32", "", 1).Window("ui60Drawn_W32", "", 3);
    
    if (!ifQ("additionalMedicalInfo")) 
    { rootwindow.RadioButton("No", 2).ClickButton(); }
    else
    {
      rootwindow.RadioButton("Si", 2).Click();
      rootwindow.Window("ui60Viewcore_W32", "", 8).Click();
      MEDQ_grid("SEGUROS MEDICOS", 0);
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys(Project.Variables.numeropolizao);
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys(Project.Variables.product);
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys(Project.Variables.deducible);
      MDISegMedicosAdicional.TitleBar(0).Button("Close").Click();  
    }
    
     if (Sys.Process("ifrun60").Dialog("Forms").Visible)
      var popupMSG = MENSAJE_FORMS("medicalAdditional1", 0, "Yes", 0);   
    else
      var popupMSG = MENSAJE_FORMS("medicalAdditional1", 2, "Yes", 0);
   
   var popupMSG = MENSAJE_INFORMATIVO("medicalAdditional1", 0, "OK", 0);  
   
    if (!ifQ("additionalMedicalInfo")) 
    { rootwindow.RadioButton("No").ClickButton(); }
    else
    {
      rootwindow.RadioButton("Si", 1).Click();
      rootwindow.Window("ui60Viewcore_W32", "", 4).Click();
      MEDQ_grid("SEGUROS MEDICOS", 0);
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys(Project.Variables.numeropolizao);
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys(Project.Variables.product);
      rootwindow.Window("Edit", "", 1).Keys("[Tab]");
      rootwindow.Window("Edit", "", 1).Keys(Project.Variables.deducible);
      MDISegMedicosAdicional.TitleBar(0).Button("Close").Click();  
    }
   
//    rootwindow.Window("Button", " ", 3).Click();
    saludecoreToolbar("Grabar");
    var popupMSG = MENSAJE_INFORMATIVO("medicalAdditional1", 0, "OK", 0); 
   closeMDIWindow(MDISegMedicosAdicional, 1);
    /*Log.Enabled=false;
    if (Sys.Process("ifrun60").Dialog("Forms").Visible)
      var popupMSG = MENSAJE_FORMS("medicalAdditional1", 0, "Si", 0);   
    else
      var popupMSG = MENSAJE_FORMS("medicalAdditional1", 2, "Si", 0);
    Log.Enabled=true;
    */
   var popupMSG = MENSAJE_INFORMATIVO("medicalAdditional1", 0, "OK", 0); 
}

function medicalAdditional()
{
   var MDISegMedicosAdicional = icon_infoSegMedicosAdicional();
   if (!MDISegMedicosAdicional.Visible) { Log.Error("Not visible. " + MDISegMedicosAdicional.FullName); return;} 
   
   MDISegMedicosAdicional.Window("ui60Drawn_W32").Window("ui60Drawn_W32", "", 3).RadioButton("No", 2).ClickButton();

   var popupMSG = MENSAJE_FORMS("medicalAdditional", 0, "Yes", 0);
   
   var popupMSG = MENSAJE_INFORMATIVO("medicalAdditional", 0, "OK", 0);
   closeMDIWindow(MDISegMedicosAdicional, 1);
}

function Populate_medicoFamilia()
{  
   var tabidx = 1; var maxrows = 5; //FIXED LIMIT for number of rows
   var myfields = new Array("rowflag", "codigo", "nombreMedico", "especialdad", "telephono");
   var tabname = "medicoFamilia"; var startcol = 1;
   
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
   
   var medqtab = selectMedicalTab(tabidx); if (medqtab == null) { return; }
   var medqLeftTable = medqtab.Window("ui60Drawn_W32", "", MEDQTabidx(tabidx)); 
   var rootwindow = medqtab.Parent;
   var medqRightTable = rootwindow.window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   
   addProjectVariable("requireAdditionalData", "string", tabname);
//   var pvrow = getUnusedPVRow("medicoFamiliaInfo"); var pvcol = 1; // first column is for rowflag
   var pvrow = getUnusedPVRow("medicoFamiliaInfo"); var pvcol = 1; // first column is for rowflag
   while (pvrow != NEGATIVE)
   {
      var tablerow = maxrows - pvrow;  // var pvcol = startcol - 1;
      medqLeftTable.Window("ui60Viewcore_W32", "", tablerow).Click();
      MEDQ_grid("Lista de", 0);
      
      // codigo  
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // nombreMedico
      medqLeftTable.Window("Edit", "", 1).Keys(Project.Variables.medicoFamiliaInfo(pvcol, pvrow));
      medqRightTable.Window("ui60Viewcore_W32", "", tablerow).Click();
      pvcol++; // especialdad
      Project.Variables.medicoFamiliaInfo(pvcol, pvrow) = aqString.Unquote(Project.Variables.medicoFamiliaInfo(pvcol, pvrow));
      var tmp = selectGriditemByName("Lista de Especialidades", 0, Project.Variables.medicoFamiliaInfo(pvcol, pvrow));
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // telephono
      medqRightTable.Window("Edit", "", 1).Keys(Project.Variables.medicoFamiliaInfo(pvcol, pvrow));
      pvrow = getUnusedPVRow("medicoFamiliaInfo"); pvcol = 1;
   }
   Log.Message("medicoFamilia..." + Project.Variables.medicoFamiliaInfo.RowCount);
}
function Populate_examenesMedicos()
{  
   var tabidx = 2; var maxrows = 5; //FIXED LIMIT for number of rows
   var myfields = new Array("rowflag", "cod", "tipo", "fecha", "resultada", "comentario");
   var tabname = "examenesMedicos"; var startcol = 1;
   
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
//   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
   
   var medqtab = selectMedicalTab(tabidx); if (medqtab == null) { return; }
   var medqLeftTable = medqtab.Window("ui60Drawn_W32", "", MEDQTabidx(tabidx));
   if (rows == 0)
   { 
   Log.Warning("No data for " + tabname); 
   medqLeftTable.RadioButton("No").Click(); 
   return;
   }
   
   medqLeftTable.RadioButton("Si").Click(); 
   var rootwindow = medqtab.Parent;
   var medqRightTable = rootwindow.window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   
   addProjectVariable("requireAdditionalData", "string", tabname);
   var pvrow = getUnusedPVRow("examenesMedicosInfo"); var pvcol = 1; // first column is for rowflag
   while (pvrow != NEGATIVE)
   // for (var pvrow = 0; pvrow < Project.Variables.examenesMedicosInfo.RowCount; pvrow++)
   {
      var tablerow = maxrows - pvrow;  // var pvcol = startcol - 1;
      medqLeftTable.Window("ui60Viewcore_W32", "", tablerow).Click(); // Cod_Afiliado viewer 
      MEDQ_grid("Lista de", 0);
      // cod
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // tipo 
      medqLeftTable.Window("Edit", "", 1).Keys(Project.Variables.examenesMedicosInfo(pvcol, pvrow));
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // fecha 
      medqRightTable.Window("Edit", "", 1).Keys(aqString.Unquote(Project.Variables.examenesMedicosInfo(pvcol, pvrow)));
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      medqRightTable.Window("ComboBox", "", 5).Button("Open").Click();  // Resultado viewer
      pvcol++; // resultada 
      selectComboBoxItem(Project.Variables.examenesMedicosInfo(pvcol, pvrow));
      pvrow = getUnusedPVRow("examenesMedicosInfo"); pvcol = 1;
   }
   Log.Message("medicoFamilia..." + Project.Variables.examenesMedicosInfo.RowCount);
}

function Populate_condicionesMedicas()
{  var MEDQquestions = "abcdefghijklmnopqr"; 
   var tabidx = 3; var maxrows = 5; //FIXED LIMIT for number of rows
   var medqtab = selectMedicalTab(tabidx); if (medqtab == null) { return; }
   var myfields = new Array("rowflag","Question", "answer", "cod", "condition", "desde", "hasta", "result", "estadio", "information");
   var tabname = "condicionesMedicas"; var startcol = 1;
   var tablerow = 5;
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
   
   var medqmax = aqString.GetLength(MEDQquestions);
   if (rows == 0)
   { // reset all medical questions
      for (var medq = 1; medq < medqmax + 1; medq++)
      { MEDQ_CondicionesMedicas(medqtab,"No", medq, medqmax, tabidx, -1, -1, -1);}
      return;
   }
   
   addProjectVariable("requireAdditionalData", "string", tabname);
   
   var pvrow = getUnusedPVRow("CondicionesMedicasInfo"); var pvcol = 1; // first column is for rowflag
   if (pvrow == NEGATIVE)
   { // reset all medical questions
      for (var medq = 1; medq < medqmax + 1; medq++)
      { MEDQ_CondicionesMedicas(medqtab,"No", medq, medqmax, tabidx, -1, -1, -1);}
      return;
   }
    
   addProjectVariable("requireAdditionalData", "string", tabname);
   Project.Variables.condicionesMedicasInfo(0,0) = 0; 
   for (var medq = 1; medq < medqmax + 1; medq++)
   { 
//      Project.Variables.condicionesMedicasInfo(0,0) = 0;
      var pvrow = getUnusedPVRow("CondicionesMedicasInfo"); var pvcol = 1;
      if (pvrow == NEGATIVE)
      { MEDQ_CondicionesMedicas(medqtab,"No", medq, medqmax, tabidx, -1, -1, -1);}
      else 
      { 
         var Q = Project.Variables.condicionesMedicasInfo(pvcol,pvrow); pvcol++;
         if (aqString.Compare(Q, aqString.SubString(MEDQquestions, medq - 1, 1), false) == 0)
         { 
           var answer = Project.Variables.condicionesMedicasInfo(pvcol,pvrow); pvcol++;
           if (aqString.Find(answer, "y", 0, false) == NEGATIVE)
           { MEDQ_CondicionesMedicas(medqtab,"No", medq, medqmax, tabidx, -1, -1, -1);}
           else
           { MEDQ_CondicionesMedicas(medqtab,"Si", medq, medqmax, tabidx, tablerow, pvrow, startcol + 2); tablerow--;}
         }
      }
   }
}

function Populate_medicamentos()
{  
   var tabidx = 4; var maxrows = 5; //FIXED LIMIT for number of rows
   var myfields = new Array("rowflag", "cod", "nombreMedicamento", "causa", "frecuencia", "desde", "hasta");
   var tabname = "medicamentos"; var startcol = 1;
   
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
//   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
   
   var medqtab = selectMedicalTab(tabidx); if (medqtab == null) { return; }
   var medqLeftTable = medqtab.Window("ui60Drawn_W32", "", MEDQTabidx(tabidx));
   if (rows == 0)
   { 
   Log.Warning("No data for " + tabname);
   medqLeftTable.RadioButton("No").Click();
    return;
    }
   
   medqLeftTable.RadioButton("Si").Click();
   var rootwindow = medqtab.Parent;
   var medqRightTable = rootwindow.window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   
   addProjectVariable("requireAdditionalData", "string", tabname);
   var pvrow = getUnusedPVRow("medicamentosInfo"); var pvcol = 1; // first column is for rowflag
   while (pvrow != NEGATIVE)
   {
      var tablerow = maxrows - pvrow;  // var pvcol = startcol - 1;
      medqLeftTable.Window("ui60Viewcore_W32", "", tablerow).Click(); 
      MEDQ_grid("Lista de", 0);
      
      // cod 
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // nombreMedicamento
      medqLeftTable.Window("Edit", "", 1).Keys(Project.Variables.medicamentosInfo(pvcol, pvrow));
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // causa  pvcol++; // dob
      //medqLeftTable.Window("Edit", "", 1).Keys(Project.Variables.medicamentosInfo(pvcol, pvrow));
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // frecuencia
      medqRightTable.Window("ComboBox", "", tablerow).Button("Open").Click();
      selectComboBoxItem(Project.Variables.medicamentosInfo(pvcol, pvrow));
      medqRightTable.Window("ComboBox", "", tablerow).Keys("[Tab]");
      pvcol++; // desde
      medqRightTable.Window("Edit", "", 1).Keys(aqString.Unquote(Project.Variables.medicamentosInfo(pvcol, pvrow)));
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // hasta
      medqRightTable.Window("Edit", "", 1).Keys(aqString.Unquote(Project.Variables.medicamentosInfo(pvcol, pvrow)));
      pvrow = getUnusedPVRow("medicamentosInfo"); pvcol = 1;
   }
}

function Populate_habitos()
{  
   var tabidx = 5; var maxrows = 5; //FIXED LIMIT for number of rows
   var myfields = new Array("rowflag", "cod", "tipo", "cant", "present", "desde", "hasta");
   var tabname = "habitos"; var startcol = 1;
   
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
//   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
   
   var medqtab = selectMedicalTab(tabidx); if (medqtab == null) { return; }
   var medqLeftTable = medqtab.Window("ui60Drawn_W32", "", MEDQTabidx(tabidx));
   if (rows == 0)
   { 
   Log.Warning("No data for " + tabname);
   medqLeftTable.RadioButton("No").Click(); 
   return;
   }
   
   medqLeftTable.RadioButton("Si").Click();
   var rootwindow = medqtab.Parent;
   var medqRightTable = rootwindow.window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   
   addProjectVariable("requireAdditionalData", "string", tabname);
   var pvrow = getUnusedPVRow("habitosInfo"); var pvcol = 1; // first column is for rowflag
   while (pvrow != NEGATIVE)
   {
      var tablerow = maxrows - pvrow;  var pvcol = startcol - 1;
      medqLeftTable.Window("ui60Viewcore_W32", "", tablerow).Click(); 
      MEDQ_grid("Lista de", 0);
      pvcol++;
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      // tipo
      pvcol++; 
      medqLeftTable.Window("Edit", "", 1).Keys(Project.Variables.habitosInfo(pvcol, pvrow));
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      
      pvcol++;
      medqRightTable.Window("Edit", "", 1).Keys("[Tab]");
      pvcol++; // present
      selectByClickitem(medqRightTable.Window("ComboBox", "", tablerow), Project.Variables.habitosInfo(pvcol, pvrow), "");
      
      pvcol++; // desde
      calendar(medqRightTable.Window("ui60Viewcore_W32", "", maxrows + tablerow), aqString.Unquote(Project.Variables.habitosInfo(pvcol, pvrow)), "[Tab]"); 
      pvcol++; // hasta
      calendar(medqRightTable.Window("ui60Viewcore_W32", "", tablerow), aqString.Unquote(Project.Variables.habitosInfo(pvcol, pvrow)), "");
      pvrow = getUnusedPVRow("habitosInfo"); pvcol = 1;
   }
}

function Populate_historialFamiliar()
{  
   var maxrows = 5; var tabidx = 6; //FIXED LIMIT for number of rows
   var myfields = new Array("rowflag", "cod", "tipo", "desorden");
   var tabname = "historialFamiliar"; var startcol = 1;
   
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
//   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
   
   var medqtab = selectMedicalTab(tabidx); if (medqtab == null) { return; }
   var medqLeftTable = medqtab.Window("ui60Drawn_W32", "", MEDQTabidx(tabidx));
   if (rows == 0)
   { 
   Log.Warning("No data for " + tabname);
   medqLeftTable.RadioButton("No").Click(); 
   return;
   }
   
   medqLeftTable.RadioButton("Si").Click();
   var rootwindow = medqtab.Parent;
   var medqRightTable = rootwindow.window("ui60Viewcore_W32", "", 1).Window("ui60Drawn_W32", "", 1);
   
   addProjectVariable("requireAdditionalData", "string", tabname);
   var pvrow = getUnusedPVRow("historialFamiliarInfo"); var pvcol = 1; // first column is for rowflag
   while (pvrow != NEGATIVE)
   {
      var tablerow = maxrows - pvrow;  var pvcol = startcol ;
      medqLeftTable.Window("ui60Viewcore_W32", "", tablerow).Click(); 
      MEDQ_grid("Lista de", 0);
      
      medqLeftTable.Window("Edit", "", 1).Keys("[Tab]");
      
      pvcol++; // tipo Parentesco
      selectByClickitem(medqLeftTable.Window("ComboBox", "", tablerow), Project.Variables.historialFamiliarInfo(pvcol, pvrow), "[Tab]"); 
      pvcol++; // Desorden
      medqLeftTable.Window("Edit", "", 1).Keys(Project.Variables.historialFamiliarInfo(pvcol, pvrow));
      pvrow = getUnusedPVRow("historialFamiliarInfo"); pvcol = 1;
   }
}

function Populate_additionalMedical()
{  
   var tabidx = 5; var maxrows = 5; //FIXED LIMIT for number of rows
   var myfields = new Array("rowflag", "codigo", "numero_de_poliza", "producto", "deductible");
   var tabname = "additionalMedical"; var startcol = 1;
   
   var rows = readMEDQInfo(tabname, myfields, startcol, maxrows);
   if (rows == 0) { Log.Warning("No data for " + tabname); return;}
}

function populateMedicalInfo(MDIMedica)
{ 
   addProjectVariable("requireAdditionalData", "string", "MedicalInfo");
   Populate_medicoFamilia();
   Populate_examenesMedicos();
   Populate_condicionesMedicas(); 
   Populate_medicamentos();
   Populate_habitos();
   Populate_historialFamiliar();
   /// Populate_additionalMedical() TODO...figureout how to use this...
   icon_MEDQ_Save(MDIMedica);
}  

/// Test Stubs

function test_populateMedicalInfo()
{ 
// if (getTcNum(1) == NEGATIVE) return;
    Project.Variables.tcNum = 1;
   
   
   populatePV_habitosQ(null, -1);
   populatePV_historialFamiliarQ(null, -1);
   populatePV_medicoFamiliaQ(null, -1);
   populatePV_examenesMedicosQ(null, -1);
   populatePV_condicionesMedicasQ(null, -1);
   populatePV_medicamentosQ(null, -1);
   var MDIMedica = getMDIWindow(determineForm(), "Información Médica");
    
   var i = 5; // 4; // 0; // 6; //0;
   if (i == 0) {populateMedicalInfo(MDIMedica, Project.Variables.tcNum); return}
   
   addProjectVariable("requireAdditionalData", "string", "MedicalInfo");
   switch (i)
   { case 1: Populate_medicoFamilia(); break;
   case 2: Populate_examenesMedicos(MDIMedica); break;
   case 3: Populate_condicionesMedicas(MDIMedica); break;
   case 4: Populate_medicamentos(MDIMedica); break;
   case 5: Populate_habitos(MDIMedica);; break;
   case 6: Populate_historialFamiliar(MDIMedica); break;
   }   
}  
