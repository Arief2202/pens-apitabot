<?php
    include "../koneksi.php";
    $id = null;
    if(isset($_GET['id'])) $id = $_GET['id'];
    if(isset($_POST['id'])) $id = $_POST['id'];    
    if(isset($id)){
        $sql = "DELETE FROM `jadwal_pakan` WHERE `jadwal_pakan`.`id` = $id";        
        // var_dump($sql);die;
        $query = mysqli_query($koneksi, $sql);
        var_dump($query);die;
    }
