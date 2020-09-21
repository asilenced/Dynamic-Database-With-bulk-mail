<?php  
require "connection.php"; 
$msg = 'Data insertion failed!';
$email = $_POST["email"]; 
$remarks = $_POST["Remarks"]; 
$validate = false;
if(filter_var($email, FILTER_VALIDATE_EMAIL)){
     $validate = true;
}
if($_POST["t_name"]=='paxzone_client_master'){
     $cname = $_POST["CompanyName"];  
     $cAddress = $_POST["CompanyAddress"];  
     $cp = $_POST["ContactPerson"]; 
     $Designation = $_POST["Designation"]; 
     $ITManager = $_POST["ITManager"]; 
     $ContactNo = $_POST["ContactNo"]; 
     $emailIT = $_POST["emailIT"]; 
     $MobileNo = $_POST["MobileNo"];
     $Zone = $_POST["Zone"];
     // $sql = "SELECT * FROM `paxzone_client_master` WHERE `EmailAddress`= '".$email."' or `MobileNo` = '".$MobileNo."' or `ContactNo` = '".$ContactNo."' or `EmailAddress_IT` = '".$emailIT."'";
     // $result = mysqli_query($connect, $sql);  
     // if(mysqli_num_rows($result) > 0) {
     //      $msg = 'Email or phone number already exists'; 
     // }
     // else{
          $sql = "INSERT INTO `paxzone_client_master`(`CompanyName`, `CompanyAddress`, `ContactPerson`, `Designation`, `MobileNo`, `EmailAddress`, `ITManager`, `ContactNo`, `EmailAddress_IT`, `Zone`, `Remarks`) VALUES ('".$cname."','".$cAddress."','".$cp."','".$Designation."','".$MobileNo."','".$email."','".$ITManager."','".$ContactNo."','".$emailIT."','".$Zone."','".$remarks."')";
          if(mysqli_query($connect, $sql))  
          {  
               $msg = 'Data Inserted';  
          }
          else{
               $msg = mysqli_error($connect);
          }
     // }
}
if($_POST["t_name"]=='ecofarms_wholesale'){
     $cname = $_POST["CompanyName"];  
     $cAddress = $_POST["CompanyAddress"];  
     $cp = $_POST["ContactPerson"]; 
     $MobileNo = $_POST["MobileNo"]; 
     $Zone = $_POST["Zone"];
     // $sql = "SELECT * FROM `paxzone_client_master` WHERE `EmailAddress`= '".$email."' or `MobileNo` = '".$MobileNo."' or `ContactNo` = '".$ContactNo."' or `EmailAddress_IT` = '".$emailIT."'";
     // $result = mysqli_query($connect, $sql);  
     // if(mysqli_num_rows($result) > 0) {
     //      $msg = 'Email or phone number already exists'; 
     // }
     // else{
          $sql = "INSERT INTO `ecofarms_wholesale`(`CompanyName`, `CompanyAddress`, `ContactPerson`, `MobileNo`, `EmailAddress`, `Zone`, `Remarks`) VALUES ('".$cname."','".$cAddress."','".$cp."','".$MobileNo."','".$email."','".$Zone."','".$remarks."')";
          if(mysqli_query($connect, $sql))  
          {  
               $msg = 'Data Inserted';  
          }
          else{
               $msg = mysqli_error($connect);
          }
     // }
}
if($_POST["t_name"]=='paxzone_email_data'){
     $sql="INSERT INTO `paxzone_email_data` (`EmailAddress`, `Valid`, `Remarks`) VALUES ('".$email."','".$validate."','".$remarks."')";
     if(mysqli_query($connect, $sql))  
          {  
               $msg = 'Data Inserted';  
          }
          else{
               $msg = mysqli_error($connect);
          }
}
mysqli_close($connect);
   
 echo $msg;  
   
 ?> 