<!DOCTYPE html>
<html lang="en">  
     <head>  
          <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
          <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
           <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>            
          <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
          <script src="https://cdn.jsdelivr.net/gh/jeffreydwalter/ColReorderWithResize@9ce30c640e394282c9e0df5787d54e5887bc8ecc/ColReorderWithResize.js"></script>
          <script src="Text-Editor/editor.js"></script>
          <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.21/b-1.6.3/b-colvis-1.6.3/datatables.min.js"></script>
           <title>Live Table Data Edit</title>  
           <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />  
           <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css"> 
           <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
           <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.21/b-1.6.3/b-colvis-1.6.3/datatables.min.css"/>
           <link href="Text-Editor/editor.css" type="text/css" rel="stylesheet"/>
          <link href="style.css" type="text/css" rel="stylesheet">
      </head> 
      <style>
      .p-5{
           padding: 3%;
      }
      </style> 
      <body>  
           <div class="container">
               <form class="p-5">
                    <div class="row">
                         <div class="form-group col-md-6">
                         <label for="st" class="col-sm-4 col-form-label col-form-label-sm">Start number</label>
                         <div class="col-sm-8">
                              <input type="number" class="form-control form-control-sm" id="st" placeholder="Click on a row">
                         </div>
                         </div>
                         <div class="form-group col-md-6">
                         <label for="ed" class="col-sm-4 col-form-label">Ending number</label>
                         <div class="col-sm-8">
                              <input type="number" class="form-control" id="ed" placeholder="Click on a row">
                         </div>
                         </div>
                    </div>
                    <div class="row">
                         <div class="form-group col-md-6">

                         <label for="input-b2" class="col-sm-4 col-form-label">Attached file:</label>
                              <div class="col-sm-8">
                              <input id="input-b2" name="input-b2" type="file" class="form-control file" data-show-preview="false">
                              </div>
                              <div class="input-group col-sm-12">
                              </div>
                         </div>
                         <div class="form-group col-md-6">
                              <label for="sub" class="col-sm-4 col-form-label">Mail subject:</label>
                              <div class="col-sm-8">
                                   <input type="text" class="form-control" id="sub" placeholder="Enter mail subject">
                              </div>
                         </div>
                    </div>

                    <div class="row">
                         <div class="form-group col-md-1">
                         </div>
                         <div class="form-group col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="reset_btn"
                                             style="background-color: #56AA1C; color: white;" name="reset" value="Reset Status">
                         </div>
                         <div class="form-group col-md-1">
                         </div>
                         <div class="col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="sent_btn"
                                                       style="background-color: #56AA1C; color: white;" name="sent" value="Sent mail">
                         </div>
                         <div class="form-group col-md-1">
                         </div>
                         <div class="col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="eb"
                                                       style="background-color: #56AA1C; color: white;" name="eb" value="Show mail editor">
                         </div>
                    </div>
               </form>
               <div id="et" class="row text_editor">
                    <h2 class="demo-text">Mail body Editor</h2>
                    <div class="container">
                         <div class="row">
                              <div class="col-lg-12 nopadding">
                                   <!-- <textarea id="txtEditor"></textarea>  -->
                                   <div id="placeHolder"> </div>
                              </div>
                         </div>
                         <input type="button" value="Save" id="save_temp">
                    </div>
               </div>
               
               <div class="col-md-12">
                    <input type="submit" id="refresh" value="Refresh Table">  
                    <select class="browser-default custom-select float-right" id="t_name">
                         <option value=0 disabled selected>Select database</option>
                         <option value="paxzone_email_data">Email Data</option>
                         <option value="paxzone_client_master">Full Data</option>
                    </select> 
               </div>
               <div id="live_data">
                    <h3 align="center">Claint Table</h3>
                    <div class="table-responsive"> 
                         <table class="table table-bordered"  id="mytable" width="100%" cellspacing="0" cellpadding="0" data-page-length="10" data-order="[[ 0, &quot;asc&quot; ]]">
                         </table>  
                    </div>
               </div>                       
           </div> 
      </body>  
 </html>  
 <script>
     var mail_text = '';
     var t_name = '';  
     var table = '';
     var editor = $("#placeHolder").Editor();
     $(document).ready(function(){ 
          function fetch_data()  
          {   
               if(t_name==''){
                    alert("Select a database!");  
                    return false;
               }
               if ( $.fn.DataTable.isDataTable( '#mytable' ) ) {
                    $('#mytable').DataTable().clear().destroy();
               }
               $.ajax({  
                    url:"select.php",  
                    method:"POST",
                    data:{t_name:t_name},  
                    success:function(data){  
                         $('#mytable').html(data); 
                    }  
               });  
          }
          // $("#txtEditor").Editor(); 
          $(document).on('click', '#btn_add', function(){
               if(t_name=='paxzone_email_data'){
                    var email = $('#EmailAddress').text();  
                    var Remarks = $('#Remarks').text();
                    $.ajax({  
                    url:"insert.php",  
                    method:"POST",  
                    data:{t_name:t_name,email:email,Remarks:Remarks},  
                    dataType:"text",  
                    success:function(data)  
                    {  
                         alert(data);  
                         fetch_data();  
                    }  
               }) 
               }
               else if(t_name=='paxzone_client_master'){
                    // var sno = $('#Serial No').text();  
                    var CompanyName = $('#CompanyName').text();  
                    var CompanyAddress = $('#CompanyAddress').text();  
                    var ContactPerson = $('#ContactPerson').text();  
                    var Designation = $('#Designation').text();  
                    var MobileNo = $('#MobileNo').text();  
                    var email = $('#EmailAddress').text();  
                    var ITManager = $('#ITManager').text();  
                    var ContactNo = $('#ContactNo').text();  
                    var emailIT = $('#EmailAddress_IT').text();  
                    var Zone = $('#Zone').text();  
                    var Remarks = $('#Remarks').text();

                    if(CompanyName == '')  
                    {  
                         alert("Enter Company Name");  
                         return false;  
                    }  
                    if(CompanyAddress == '')  
                    {  
                         alert("Company Address can not be empty!");  
                         return false;  
                    }  
                    if(ContactPerson == '')  
                    {  
                         alert("Contact person can not be empty!");  
                         return false;  
                    }  
                    if(Zone == '')  
                    {  
                         alert("Zone can not be empty!");  
                         return false;  
                    }   
                    $.ajax({  
                    url:"insert.php",  
                    method:"POST",  
                    data:{t_name:t_name, CompanyName:CompanyName, CompanyAddress:CompanyAddress, ContactPerson:ContactPerson, Designation:Designation, email:email, ITManager:ITManager, MobileNo:MobileNo, ContactNo:ContactNo, emailIT:emailIT, Zone:Zone, Remarks:Remarks},  
                    dataType:"text",  
                    success:function(data)  
                    {  
                         alert(data);  
                         fetch_data();  
                    }  
               })
               }   
          });  
          $(document).on('click', '.btn_edit', function(){  
               var email = $(this).parents().siblings(".EmailAddress").text(); 
               var Remarks = $(this).parents().siblings(".Remarks").text();
               var id = $(this).data("id7"); 
               if(t_name=='paxzone_email_data'){
                    $.ajax({  
                         url:"edit.php",  
                         method:"POST",  
                         data:{t_name:t_name,id:id,email:email,Remarks:Remarks},  
                         dataType:"text",  
                         success:function(data)  
                         {  
                              alert(data);  
                              fetch_data();  
                         }  
               }) 
               }
               else if(t_name=='paxzone_client_master'){
                    // var sno = $('#Serial No').text();  
                    var CompanyName =  $(this).parents().siblings(".CompanyName").text(); 
                    var CompanyAddress =  $(this).parents().siblings(".CompanyAddress").text(); 
                    var ContactPerson = $(this).parents().siblings(".ContactPerson").text(); 
                    var Designation =   $(this).parents().siblings(".Designation").text();
                    var MobileNo =  $(this).parents().siblings(".MobileNo").text();   
                    var ITManager = $(this).parents().siblings(".ITManager").text(); 
                    var ContactNo = $(this).parents().siblings(".ContactNo").text();
                    var emailIT = $(this).parents().siblings(".EmailAddress_IT").text();
                    var Zone = $(this).parents().siblings(".Zone").text();
                    if(CompanyName == '')  
                    {  
                         alert("Company Name can not be empty!");  
                         return false;  
                    }  
                    if(CompanyAddress == '')  
                    {  
                         alert("Company Address can not be empty!");  
                         return false;  
                    }  
                    if(ContactPerson == '')  
                    {  
                         alert("Contact person can not be empty!");  
                         return false;  
                    }  
                    if(Zone == '')  
                    {  
                         alert("Zone can not be empty!");  
                         return false;  
                    }   
                    $.ajax({  
                         url:"edit.php",  
                         method:"POST",  
                         data:{t_name:t_name, id:id, CompanyName:CompanyName, CompanyAddress:CompanyAddress, ContactPerson:ContactPerson, Designation:Designation, email:email, ITManager:ITManager, MobileNo:MobileNo, ContactNo:ContactNo, emailIT:emailIT, Zone:Zone, Remarks:Remarks},  
                         dataType:"text",  
                         success:function(data)  
                         {  
                              alert(data);  
                              fetch_data();  
                         }  
                    })
               } 
          });  
          
          $(document).on('click', '.btn_delete', function(){  
               var id=$(this).data("id1");  
               if(confirm("Are you sure you want to delete this?") && t_name != '')  
               {  
                    $.ajax({  
                         url:"delete.php",  
                         method:"POST",  
                         data:{t_name:t_name, id:id},  
                         dataType:"text",  
                         success:function(data){  
                              alert(data);  
                              fetch_data();  
                         }  
                    });  
               }  
          });  
          $(document).on('click', '#refresh', function(){  
               fetch_data();
          });  
          $(document).on('click', '#sent_btn', function(){   
               var start_no = $('#st').val();  
               var end_no = $('#ed').val();
               var sub = $('#sub').val();
               //var file_data = $("#avatar").prop("files")[0];
               if(t_name==''){
                    alert("Select a database!")
                    return false;
               } 
               if(sub == ''){
                    alert("Email subject can`t be empty!")
                    return false; 
               }  
               if(mail_text == ''){
                    alert("Email body can`t be empty!")
                    return false; 
               }  
               if(start_no==''){
                    alert("Please enter a start no!");
                    return false; 
               }
               if(end_no==''){
                    alert("Please enter a ending no!")
                    return false; 
               }  
               if(end_no < start_no){
                    alert("Ending No most be greater than or equal to start no!")
                    return false; 
               }  
               if(confirm("Are you sure you want to sent email from "+start_no+" to "+end_no+"?"))  
               {  
                    $.ajax({  
                         url:"method.php",  
                         method:"POST",  
                         data:{t_name:t_name, start_no:start_no,end_no:end_no,mail_text:mail_text,sub:sub},  
                         // data:{t_name:t_name, start_no:start_no,end_no:end_no,mail_text:mail_text,sub:sub, file_data:file_data},  
                         dataType:"text",  
                         success:function(data){  
                              alert(data);  
                              fetch_data();  
                         }  
                    });  
               } 
               else{
                    return false;
               } 
          });
          $('#t_name').on('change', function() {
                    t_name = this.value;
                    // $('#mytable').html("");
                    fetch_data();  
               });    
     });  
     $("#et").hide();
     $("#save_temp").click(function(){
          mail_text = $("#placeHolder").Editor("getText");
          alert(mail_text);
     });
     $("#eb").click(function(){
          $("#et").toggle();
          if($("#eb").val()=='Show mail editor'){
               $("#eb").val("Hide mail editor");
          }
          else{
               $("#eb").val("Show mail editor");
          }
     });
 </script>