<?php  
require "connection.php";
$counter = 50; 
// $sql = '';
// $table = $_POST["t_name"];
// $sql = "DELETE FROM `".$table."` WHERE `Serial No`='".$_POST["id"]."'"; 
// if(mysqli_query($connect, $sql))  {  
//      $msg = 'Data Deleted';  
// }else{
//      $msg = mysqli_error($connect);
// }
  
// $d=strtotime("+1 hours");
// $d0 = date("d-M-Y h:ma", $d);
// $d1=date("d-M-Y h:m:sa", strtotime("now"));
// $d2=date("d-M-Y h:ma", strtotime("-1 hours"));
// if($d0>$d1 && $d1>$d2){
// echo "The time";
// }

$sql = "SELECT * FROM `counter` WHERE `id`=(SELECT MAX(`id`) FROM `counter`)";
$result = mysqli_query($connect,$sql);
$counter_row = mysqli_fetch_row($result);
$d=date("d-M-Y ha", strtotime("now"));





// $sql = "SELECT * FROM `counter` WHERE `id`=(SELECT MAX(`id`) FROM `counter`)";
// $result = mysqli_query($connect,$sql);
// $counter_row = mysqli_fetch_row($result);
// $d=date("d-M-Y ha", strtotime("now"));
// $limite = '';

// if(!$counter_row){
//     $sql = "INSERT INTO `counter`(`slot`, `counter`, `limite`) VALUES ('".$d."',0, '".$limite."')";
//     mysqli_query($connect, $sql);
//     $counter = $sql."Error inserting record: " . mysqli_error($connect);
// }

// else if(date("d-M-Y ha", strtotime($counter_row[1])) != $d)
// {
//     $spl = "INSERT INTO `counter`(`slot`, `counter`, `limite`) VALUES ('".$d."',0,'".$limite."')";
//     mysqli_query($connect, $sql);
//     $counter = "Error updating record: " . mysqli_error($connect);
//     $counter= $counter_row[2];
// }
if ($counter_row) {
    $counter= $counter_row[2];
}
else{
    $counter = 'Not set';
}



echo "Counter: ".$counter;  
  
?>