<?php  
 require "connection.php";  
 $msg = "Error!";
 $path = $_POST["path"];
 if (file_exists($path)) {
    unlink($path);
 }
 $sql = "DELETE FROM `file_list` WHERE `No`='".$_POST["id"]."'"; 
 if(mysqli_query($connect, $sql))  {  
    $msg = 'Data Deleted';  
 }else{
    $msg = mysqli_error($connect);
 }
 echo $msg;  
 ?>


