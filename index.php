<?php
namespace Phppot;

use \Phppot\Member;

if (! empty($_SESSION["userId"])) {
    require_once __DIR__ . './user_login_session/class/Member.php';
    $member = new Member();
    $memberResult = $member->getMemberById($_SESSION["userId"]);
    if(!empty($memberResult[0]["display_name"])) {
        $displayName = ucwords($memberResult[0]["display_name"]);
    } else {
        $displayName = $memberResult[0]["user_name"];
    }
}
?>
<!DOCTYPE html>
<html lang="en">  
     <head>  
          <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
          <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
          <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>            
          <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
          <script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap.min.js"></script>
          <script  src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"  integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
          <script src="Text-Editor/editor.js"></script>
          <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.21/b-1.6.3/b-colvis-1.6.3/datatables.min.js"></script> 
          <title><?php echo $displayName; ?></title>  
          <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />  
          <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css"> 
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
          <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.21/b-1.6.3/b-colvis-1.6.3/datatables.min.css"/>
          <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.2.5/css/responsive.bootstrap.min.css"/>
          <link href="Text-Editor/editor.css" type="text/css" rel="stylesheet"/>
          <link href="style.css" type="text/css" rel="stylesheet">
          <link href="style/style.css" rel="stylesheet" type="text/css" /> 
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

                         <label for="input-b2" class="col-sm-4 col-form-label" id="attached_file_label">Attached file:</label>
                              <div class="col-sm-8">
                              <textarea  id="file_names" class="form-control file" placeholder="Upload file to attached" readonly></textarea>
                              
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
                         
                         <div class="form-group col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="reset_btn"
                                             style="background-color: #56AA1C; color: white;" name="reset" value="Reset Status">
                         </div>
                         
                         <div class="col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="sent_btn"
                                                       style="background-color: #56AA1C; color: white;" name="sent" value="Sent mail">
                         </div>
                         
                         <div class="col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="eb"
                                                       style="background-color: #56AA1C; color: white;" name="eb" value="Show mail editor">
                         </div>
                         <div class="col-sm-3">
                              <input type="button" class="btn btn-default col-sm-12" id="fu"
                                                       style="background-color: #56AA1C; color: white;" name="fu" value="Show file uploader">
                         </div>
                    </div>
               </form>
               <div class="row" id="file_uploader">
                    <div id="Uploader_container" class="col-md-6">
                         <div id="header"><div id="header_left"></div>
                         <div id="header_main">File Uploader</div><div id="header_right"></div></div>
                         <div id="content">
                              <form action="upload.php" method="post" enctype="multipart/form-data" target="upload_target" onsubmit="startUpload();" >
                                   <p id="f1_upload_process">Loading...<br/><img src="loader.gif" /><br/></p>
                                   <p id="file_link"></p>
                                   <p id="f1_upload_form" align="center"><br/>
                                        <label>File:  
                                             <input name="myfile" type="file" size="30" />
                                        </label>
                                        <label>
                                        <input type="submit" name="submitBtn" class="sbtn" value="Upload" />
                                        </label>
                                   </p>
                                   
                                   <iframe id="upload_target" name="upload_target" src="#" style="width:0;height:0;border:0px solid #fff;"></iframe>
                              </form>
                         </div>
                         <div id="footer"><a href="http://www.paxzonebd.com" target="_blank">Powered by paxzone</a></div>
                    </div> 
                    <div class="col-md-6" id="file_list_div">
                         
                    </div>
               </div>
               <div id="dialog">
                    <p></p>
               </div>
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
                         <option value="0" disabled selected>Select database</option>
                         <option value="paxzone_email_data">Email Data</option>
                         <option value="paxzone_client_master">Full Data</option>
                         <option value="ecofarms_wholesale">Wholse Client</option>
                    </select> 
               </div>
               <div id="live_data">
                    <h3 align="center">Claint Table</h3>
                    <div class="table-responsive"> 
                         <table class="table table-bordered"  id="mytable" width="100%" cellspacing="0" cellpadding="0" data-page-length="25" data-order="[[ 0, &quot;asc&quot; ]]">
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
     var fileName = [];
     var fName = '';
     var editor = $("#placeHolder").Editor();
     function fetch_list()  
          {   
               $.ajax({  
                    url:"upload_file_handler.php",  
                    method:"POST",
                    success:function(data){  
                         $('#file_list_div').html(data); 
                         $('#file_list').DataTable();

                    }  
               });  
          }
     
     $(document).ready(function(){ 
          
          $('input[type="file"]').change(function(e){
               fName = e.target.files[0].name;
               fileName.push(fName);
               $('#file_names').val(fileName.join(",\n"));
               $('#attached_file_label').html("Remove file");
        });
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
          
          fetch_list();

          $('#dialog').dialog({
                autoOpen: false,
            });          
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
               else if(t_name=='ecofarms_wholesale'){
                    // var sno = $('#Serial No').text();  
                    var CompanyName = $('#CompanyName').text();  
                    var CompanyAddress = $('#CompanyAddress').text();  
                    var ContactPerson = $('#ContactPerson').text();  
                    var MobileNo = $('#MobileNo').text();  
                    var email = $('#EmailAddress').text();   
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
                    data:{t_name:t_name, CompanyName:CompanyName, CompanyAddress:CompanyAddress, ContactPerson:ContactPerson, email:email, MobileNo:MobileNo, Zone:Zone, Remarks:Remarks},  
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
          $(document).on('click', '#del_list', function(){  
               var id=$(this).data("id1");  
               var path=$(this).data("id15");  
               if(confirm("Are you sure you want to delete this file?"))  
               {  
                    $.ajax({  
                         url:"delete_file.php",  
                         method:"POST",  
                         data:{id:id, path:path},  
                         dataType:"text",  
                         success:function(data){  
                              alert(data);  
                              fetch_list();  
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
                         data:{t_name:t_name, start_no:start_no,end_no:end_no,mail_text:mail_text,sub:sub,fileName:fileName},  
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
          $(document).on('click', '#reset_btn', function(){   
               var start_no = $('#st').val();  
               var end_no = $('#ed').val();
               //var file_data = $("#avatar").prop("files")[0];
               if(t_name==''){
                    alert("Select a database!")
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
               if(confirm("Are you sure you want to RESET Status from "+start_no+" to "+end_no+"?"))  
               {  
                    $.ajax({  
                         url:"reset_status.php",  
                         method:"POST",  
                         data:{t_name:t_name, start_no:start_no,end_no:end_no},  
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
                    t_name = this.value;;
                    fetch_data();  
               });    
     });  
     $("#et").hide();
     $("#file_uploader").hide();
     $("#save_temp").click(function(){
          mail_text = $("#placeHolder").Editor("getText");
          alert("Mail body saved!");
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
     $("#fu").click(function(){
          $("#file_uploader").toggle();
          if($("#fu").val()=='Show file uploader'){
               $("#fu").val("Hide file uploader");
          }
          else{
               $("#fu").val("Show file uploader");
          }
     });
     $("#attached_file_label").click(function(){
          if(fileName.length>0){
               fileName.length = 0;
               $('#file_names').val("Upload file to attached");
               $('#attached_file_label').html("Attached file");
               $('input[type="file"]').val("");
          }
          else{
               return false;
          }
          
     });
     function startUpload(){
          $('#f1_upload_process').show();
          $('#f1_upload_form').hide();
          return true;
     }

     function stopUpload(success){
          var result = '';
          if (success == 0){
          result = '<span class="emsg">There was an error during file upload!<\/span><br/><br/>';
          }
          else {
          // result = '<span class="emsg">There was an error during file upload!<\/span><br/><br/>';
          result = '<span class="emsg">'+success+'<\/span><br/><br/>';
          }
          $('#f1_upload_process').hide();
          // document.getElementById('f1_upload_form').innerHTML = result + '<label>File: <input name="myfile" type="file" size="30" /><\/label><label><input type="submit" name="submitBtn" class="sbtn" value="Upload" /><\/label>';
          $('#f1_upload_form').show(); 
          $('#file_link').html(result); 
          fetch_list(); 
          return true;   
     }
 </script>