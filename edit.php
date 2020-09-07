<?php  
 require "connection.php";
 $id = $_POST["id"];  
 $email = $_POST["email"]; 
 $remarks = $_POST["Remarks"]; 
 $validate = false;
 $msg = 'Data update failed!';
 if(filter_var($email, FILTER_VALIDATE_EMAIL)){
      $validate = true;
 }
 $sql = '';
 if($_POST["t_name"]=='paxzone_email_data'){
      $sql = "UPDATE `paxzone_email_data` SET `EmailAddress`='".$email."',`Valid`='".$remarks."',`Remarks`='".$validate."' WHERE `Serial No`='".$_POST["id"]."'"; 
 }
 else if($_POST["t_name"]=='paxzone_client_master'){
     $cname = $_POST["CompanyName"];  
     $cAddress = $_POST["CompanyAddress"];  
     $cp = $_POST["ContactPerson"]; 
     $Designation = $_POST["Designation"]; 
     $ITManager = $_POST["ITManager"]; 
     $ContactNo = $_POST["ContactNo"]; 
     $emailIT = $_POST["emailIT"]; 
     $MobileNo = $_POST["MobileNo"];
     $Zone = $_POST["Zone"];
     $sql = "UPDATE `paxzone_client_master` SET `CompanyName`='".$cname."',`CompanyAddress`='".$cAddress."',`ContactPerson`='".$cp."',`Designation`='".$Designation."',`MobileNo`='".$MobileNo."',`EmailAddress`='".$email."',`ITManager`='".$ITManager."',`ContactNo`='".$ContactNo."',`EmailAddress_IT`='".$emailIT."',`Zone`='".$Zone."',`Remarks`='".$remarks."' WHERE `Serial No`='".$id."'"; 
 }
 if(mysqli_query($connect, $sql))  {  
      $msg = 'Data Updated';  
 }else{
      $msg = mysqli_error($connect);
 }
   
 echo $msg;  
   
 ?>





 ?>