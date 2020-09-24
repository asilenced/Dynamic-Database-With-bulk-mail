<?php
    date_default_timezone_set("Asia/Dhaka");
    $servername = "localhost";
    $username = "";
    $password = "";
    $db = "";
    
    // Create connection
    $connect = mysqli_connect($servername, $username, $password, $db);
    $conn1 = mysqli_connect($servername, $username, $password, $db);
    
    // Check connection
    if (!$connect or !$conn1) {
      die("Connection failed: " . mysqli_connect_error());
    }
?>