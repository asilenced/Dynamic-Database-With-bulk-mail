<?php  
require "connection.php";
$msg = 'Data not found!'; 
$sql = '';
$table = $_POST["t_name"];
$sql = "DELETE FROM `".$table."` WHERE `Serial No`='".$_POST["id"]."'"; 
if(mysqli_query($connect, $sql))  {  
     $msg = 'Data Deleted';  
}else{
     $msg = mysqli_error($connect);
}
  
echo $msg;  
  
?>