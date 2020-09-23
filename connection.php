<?php
    date_default_timezone_set("Asia/Dhaka");
    $servername = "localhost";
    $username = "Ecofarms";
    $password = "CtiUG6GnLCejsA@";
    $db = "EF_Applicant";
    
    // Create connection
    $connect = mysqli_connect($servername, $username, $password, $db);
    $conn1 = mysqli_connect($servername, $username, $password, $db);
    
    // Check connection
    if (!$connect or !$conn1) {
      die("Connection failed: " . mysqli_connect_error());
    }
?>