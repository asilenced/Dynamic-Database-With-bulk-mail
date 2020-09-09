<?php
    require "connection.php";  
   function path2url($file_path) {
      $file_path=str_replace('\\','/',$file_path);
      $file_path=str_replace(' ', '%20',$file_path);
      $file_path=str_replace($_SERVER['DOCUMENT_ROOT'],'',$file_path);
      $file_path='http://'.$_SERVER['HTTP_HOST'].$file_path;
      return $file_path;
      // return $Protocol.$_SERVER['HTTP_HOST'].str_replace($_SERVER['DOCUMENT_ROOT'], '', realpath($file));
   }

   $destination_path = getcwd().DIRECTORY_SEPARATOR;

   $result = 0;
   $file_name = basename( $_FILES['myfile']['name']);
   $target_path = $destination_path ."upload_file/".basename( $_FILES['myfile']['name']);
   $sql = "SELECT * FROM `file_list` WHERE `Path`='".$target_path."'";
   $query = mysqli_query($connect, $sql); 
   if(mysqli_num_rows($query) > 0){
      while($row = mysqli_fetch_array($query)){
         $result = $row["URL"]."<br>File already uploaded!";
      }
   }else{
         if(@move_uploaded_file($_FILES['myfile']['tmp_name'], $target_path)) {
            $result = path2url($target_path);
            $sql = "INSERT INTO `file_list`(`File_name`, `Path`, `URL`) VALUES ('".$file_name."','".$target_path."','".$result."')";
            if(mysqli_query($connect, $sql))  
               {  
                  $result .= "<br>File uploaded and saved!"; 
               }
               else{
                  $result .= "<br>".mysqli_error($connect); 
               } 
         }
   }

   
   sleep(1);
?>

<script language="javascript" type="text/javascript">window.top.window.stopUpload(<?php echo "'".$result."'"; ?>);</script>   
