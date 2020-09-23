<?php

require "PHPMailer/PHPMailerAutoload.php";
require "connection.php"; 

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

function smtpmailer($to, $from, $from_name, $subject, $body, $attached_file, $acc)
    {
        $error = "i";
        $mail = new PHPMailer();
        $mail->IsSMTP();
        $mail->SMTPAuth = true; 
        $mail->SMTPSecure = 'ssl'; 
        $mail->Host = 'sg2plcpnl0221.prod.sin2.secureserver.net';
        $mail->Port = 465;  
        $mail->Username = 'sales@paxzonebd.com';
        $mail->Password = '368836'; 
        if($acc){
            $mail->AddCC($acc);
        }
        // $path = $_FILES['filename']['tmp_name'];
        // $mail->AddAttachment($path);
        if(!empty($attached_file)){
            foreach($attached_file as $fl){
                $mail->AddAttachment("upload_file/".$fl);
            }
        }
        $mail->IsHTML(true);
        $mail->From='sales@paxzonebd.com';
        $mail->FromName=$from_name;
        $mail->Sender=$from;
        $mail->AddReplyTo('sales@paxzonebd.com', $from_name);
        $mail->Subject = $subject;
        $mail->Body = $body;
        $mail->AddAddress($to);
        if(!$mail->Send())
        {
            $error ="f";
            return $error; 
        }
        else 
        {
            $error = "d";  
            return $error;
        }
    }

    function sent_mail($to, $from, $name, $subj, $final_message1, $files, $acc){
        $error = "i";
        if (filter_var($to, FILTER_VALIDATE_EMAIL)) {
            $error=smtpmailer($to, $from, $name, $subj, $final_message1, $files, $acc);
        }
        return $error;
    }

    $sql = "SELECT * FROM `counter` WHERE `id`=(SELECT MAX(`id`) FROM `counter`)";
    $result = mysqli_query($connect, $sql);
    $counter_row = mysqli_fetch_row($result);
    $d=date("d-M-Y ha", strtotime("now"));
    $limite = '';
    $counter = 0;
    if($counter_row){
        if(date("d-M-Y ha", strtotime($counter_row[1])) != $d || $counter_row[2]<=$counter_row[3])
        {
            $spl = "INSERT INTO `counter`(`slot`, `counter`, `limite`) VALUES ('".$d."',0,'".$limite."')";
            mysqli_query($connect, $sql);
        }
        else{
            $counter= $counter_row[2];
        }
    }
    else
    {
        $spl = "INSERT INTO `counter`(`slot`, `counter`, `limite`) VALUES ('".$d."',0,'".$limite."')";
        mysqli_query($connect, $sql);
    }

    $ms = "Error!";
    $from = "sales@paxzonebd.com";
    $sub = "Paxzone Electronics";
    $file = array();
    $acc = false;
    if(!empty($_POST['acc'])){
        $acc = $_POST['acc'];
    }
    if(!empty($_POST['sub'])){
        $sub = $_POST['sub'];
    }
    if(!empty($_POST['fileName'])){
        $file = $_POST['fileName'];
    }
    $st = $_POST['start_no'];
    $ed = $_POST['end_no'];
    $msg = $_POST['mail_text'];
    $table = $_POST["t_name"];
    for($x=$st;$x<=$ed;$x++){
        $sql = "SELECT * FROM `".$table."` WHERE `Serial No` = $x";  
        $result = mysqli_query($connect, $sql);
        if (mysqli_num_rows($result) > 0){
            while($row = mysqli_fetch_assoc($result)){
                $to = $row['EmailAddress'];
                // $final_message1 = sprintf($crtm, $row["name"]);
                $sm=sent_mail($to, $from, "Paxzone Electronics", $sub, $msg, $file, $acc);
                $sts = "Failed";
                if($sm == 'd'){
                    $sts = "Done";
                    $counter += 1;
                    if($acc){
                        $counter += 1; 
                    }
                }else if($sm == 'i'){
                    $sts = "Invalid";
                }
                if(isset($row['EmailAddress_IT'])){
                    $to = $row['EmailAddress_IT'];
                    $sm=sent_mail($to, $from, "Paxzone Electronics", $sub, $msg, $file, $acc);
                    if($sm == 'd'){
                        $sts .= ", Done";
                        $counter += 1;
                        if($acc){
                            $counter += 1; 
                        }
    
                    }else if($sm == 'i'){
                        $sts .= ", Invalid";
                    }else{
                        $sts .= ", Failed";
                    }
                }
                
                if (!mysqli_query($connect, "UPDATE `counter` SET `counter`= ".$counter." WHERE `slot`= '".$d."'")) {
                    echo "Error updating record: " . mysqli_error($connect);
                    return;
                }
                $sql1 = "UPDATE `".$table."` SET `Status` = '".$sts."' WHERE `Serial No` = '".$row["Serial No"]."'";
                if (mysqli_query($connect, $sql1)) {
                    $ms="Mail status Updated!";
                } else {
                    $ms =  "Error updating record: " . mysqli_error($connect);
                }
            }
        }else {
            $ms = "No data found";
        }
    }
    echo $ms;
?>

