/// Last update: May 8 

//compare validation policy sheet with the form data
//compare effective date
function compare_excel_vs_Saludcore (paymentMode)
{
  //compare effective date here
  if (aqDateTime.Compare(Project.Variables.excel_effective_date, Project.Variables.effective_date) == 0)
     Log.Message("Portal date is - " + Project.Variables.excel_effective_date + "  Saludcore date - " + Project.Variables.effective_date + "the dates match");
  else
     Log.Error("Portal date is - " + Project.Variables.excel_effective_date + "  Saludcore date - " + Project.Variables.effective_date + "the dates do not match");   
     
  //compare plan type here
   
    switch (aqString.Compare(Project.Variables.planTypeform, Project.Variables.excel_plan, false))
  {
    case -1 : Log.Error("PAL Portal plan type is  " +  Project.Variables.excel_plan + " Saludcore plan type is  " + Project.Variables.planTypeform); break;
    case 0  : Log.Message("PAL Portal plan type is  " +  Project.Variables.excel_plan + " Saludcore plan type is  " + Project.Variables.planTypeform);break;
    case 1  : Log.Error("PAL Portal plan type is  " +  Project.Variables.excel_plan + " Saludcore plan type is  " + Project.Variables.planTypeform); break;
  }

  //compare/validate payment method between spreadsheet and Saludcore
  switch (aqString.Compare(paymentMode, Project.Variables.excel_payment, false))
  {
    case -1 : Log.Error("PAL Portal plan type is  " +  Project.Variables.excel_payment + " Saludcore plan type is  " + paymentMode); break;
    case 0  : Log.Message("PAL Portal plan type is  " +  Project.Variables.excel_payment + " Saludcore plan type is  " + paymentMode);break;
    case 1  : Log.Error("PAL Portal plan type is  " +  Project.Variables.excel_payment + " Saludcore plan type is  " + paymentMode); break;
  } 
}

//validate number of dependant records
function compare_num_recs  ()
{
   aqString.Find(Project.Variables.excel_num_records, Project.Variables.backend_num_dependants, 0, false);
   if (aqString.Find(Project.Variables.excel_num_records, Project.Variables.backend_num_dependants, 0, false)> -1)
      Log.Message("Number of records match, Saludcore = " + Project.Variables.backend_num_dependants + "Web Portal = " + Project.Variables.excel_num_records);
  else
    Log.Error("Number of records do not match, Saludcore = "+ Project.Variables.backend_num_dependants + "Web Portal = " + Project.Variables.excel_num_records);
}

//validate policy members data (name, DOB etc...)
function validate_policy_members ()
{
 //get the project variable Project.Variables.excel_fullName populated in backendexcelutilities
 //get the project varaible Project.Variables.backend_form_name 
 //compare and log pass or fail
 //after one is done need to loop through until end of records

}