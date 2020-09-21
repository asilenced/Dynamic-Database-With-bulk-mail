<?php  
 require "connection.php";  
 $temp = array();
 $output = '<table id="file_list" class="table table-striped table-bordered" cellspacing="0" cellpadding="0" data-page-length="5" data-order="[[ 1, &quot;dec&quot; ]]">
               <thead>
                    <tr>
                         <th width="80">File Name</th>
                         <th width="10">Created At</th>
                         <th width="10">Atcion</th>
                    </tr>
               </thead>
               <tbody>
               ';  
//  $sql = "SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA`='EF_Applicant' AND `TABLE_NAME`='".$table."'";
//  $column_name = mysqli_query($connect, $sql);
 $sql = "SELECT * FROM `file_list` ORDER BY `created_at` DESC";  
 $result = mysqli_query($connect, $sql);   
 if(mysqli_num_rows($result) > 0)  
 {  
      while($row = mysqli_fetch_array($result))  
      {
          $output .= 
               '
               <tr>
                     <td class="file_row" data-id12="'.$row["File_name"].'" data-id13="'.$row["URL"].'" data-id14="'.$row["created_at"].'">'.$row["File_name"].'</td>   
                     <td >'.$row["created_at"].'</td>   
                     <td><button type="button" name="delete_btn" data-id1="'.$row["No"].'" data-id15="'.$row["Path"].'" id="del_list" class="btn btn-xs btn-danger">x</button></td>  
                </tr>';
          
      } 
      $output .= '<script>
      $(".file_row").click(function(){
          var f_name = $(this).data("id12"); 
          var f_url = "<strong>URL: </strong>"; 
          f_url += $(this).data("id13");
          $( "#dialog p").html(f_url);
          $( "#dialog" ).dialog({ title: f_name });
          $( "#dialog" ).dialog( "open" ).css("background","lightsteelblue");
          if(confirm("Add "+f_name+" to attached file?")){
               if(!fileName.includes(f_name)){
                    fileName.push(f_name);
               }
          $("#file_names").val(fileName.join(",\n"));
          $("#attached_file_label").html("Remove file");     
          }
});
      </script>';
 }  
 else  
 {  
      $output .= '<tr>  
                        <td colspan="3">Data not Found</td>  
                        <td ></td>  
                        <td ></td>  
                </tr>';  
 } 
 
 $output .='</tbody>
 </table>';

 echo $output;  
 ?>


