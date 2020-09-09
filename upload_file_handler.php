<?php  
 require "connection.php";  
 $temp = array();
 $output = '';  
//  $sql = "SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA`='EF_Applicant' AND `TABLE_NAME`='".$table."'";
//  $column_name = mysqli_query($connect, $sql);
 $sql = "SELECT * FROM `file_list`";  
 $result = mysqli_query($connect, $sql);   
 if(mysqli_num_rows($result) > 0)  
 {  
      while($row = mysqli_fetch_array($result))  
      {
          $output .= 
               '<tr>
                     <td class="file_row" data-id12="'.$row["File_name"].'" data-id13="'.$row["URL"].'">'.$row["File_name"].'</td>   
                     <td><button type="button" name="delete_btn" data-id1="'.$row["No"].'" id="del_list" class="btn btn-xs btn-danger">x</button></td>  
                </tr>';
          
      }  
 }  
 else  
 {  
      $output .= '<tr>  
                        <td ></td>  
                        <td colspan="3">Data not Found</td>  
                        <td ></td>  
                </tr>';  
 }  
 echo $output;  
 ?>


