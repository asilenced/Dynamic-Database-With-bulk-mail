<?php

require "PHPMailer/PHPMailerAutoload.php";
require "connection.php"; 

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

function smtpmailer($to, $from, $from_name, $subject, $body, $file)
    {
        $error = "i";
        $mail = new PHPMailer();
        $mail->IsSMTP();
        $mail->SMTPAuth = true; 
 
        $mail->SMTPSecure = 'ssl'; 
        $mail->Host = 'sg2plcpnl0221.prod.sin2.secureserver.net';
        $mail->Port = 465;  
        $mail->Username = 'autoreply@ecofarmsbd.com';
        $mail->Password = 'bV3%;;YNoJi9'; 
        
        // $path = $_FILES['filename']['tmp_name'];
        // $mail->AddAttachment($path);
        if($file){
            $mail->AddAttachment("upload_file/".$file);
        }
        $mail->IsHTML(true);
        $mail->From="info@ecofarmsbd.com";
        $mail->FromName=$from_name;
        $mail->Sender=$from;
        $mail->AddReplyTo("info@ecofarmsbd.com", $from_name);
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

function sent_mail($to, $from, $name, $subj, $final_message1){
        $error = "i";
        if (filter_var($to, FILTER_VALIDATE_EMAIL)) {
            $error=smtpmailer($to, $from, $name, $subj, $final_message1, $file);
        }
        return $error;
    }
    $ms = "Error!";
    $from = "autoreply@ecofarmsbd.com";
    $sub = "Brochure of Paxzone Electronics";
    $file = false;
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
                $to = $row['E-mailAddress'];
                // $final_message1 = sprintf($crtm, $row["name"]);
                $sm=sent_mail($to, $from, "Paxzone Electronics", $sub, $msg, $file);
                $sts = "Failed";
                if($sm == 'd'){
                    $sts = "Done";
                }else if($sm == 'i'){
                    $sts = "Invalid";
                }
                if(isset($row['EmailAddress_IT'])){
                    $to = $row['EmailAddress_IT'];
                    // $final_message1 = sprintf($crtm, $row["name"]);
                    $sm=sent_mail($to, $from, "Eco Farms", $sub, $msg);
                    
                    if($sm == 'd'){
                        $sts .= ", Done";
                    }else if($sm == 'i'){
                        $sts .= ", Invalid";
                    }else{
                        $sts .= ", Failed";
                    }
                }
                $sql1 = "UPDATE `".$table."` SET `Status` = '".$sts."' WHERE `Serial No` = '".$row["Serial No"]."'";
                if (mysqli_query($connect, $sql1)) {
                    $ms="Data Updated!";
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

