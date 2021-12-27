<?php
$mysqli = new mysqli(dbahost, username, password, database);
if(!$mysqli)  {
    echo"database error";
}else{
    echo"php env successful";
}
$mysqli->close();
?>
