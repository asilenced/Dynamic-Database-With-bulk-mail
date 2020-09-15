<?php
require "PHPMailer/PHPMailerAutoload.php";
require "connection.php"; 
    $ms = "Error!";
    $st = $_POST['start_no'];
    $ed = $_POST['end_no'];
    $table = $_POST["t_name"];
    $id_list = '';
    for($x=$st;$x<=$ed;$x++){
        $sql = "SELECT * FROM `".$table."` WHERE `Serial No` = $x";  
        $result = mysqli_query($connect, $sql);
        if (mysqli_num_rows($result) > 0){
            while($row = mysqli_fetch_assoc($result)){
                $sql1 = "UPDATE `".$table."` SET `Status` = 'RESET' WHERE `Serial No` = '".$row["Serial No"]."'";
                if (mysqli_query($connect, $sql1)) {
                    $ms="Status RESET!";
                } else {
                    $id_list .=  $row["Serial No"].", ";
                }
            }
        }else {
            $id_list .= $x.", ";
        }
    }
    if($id_list != ''){
        $ms .= " but id ".$id_list. "not found";
    }
    echo $ms;
?>

