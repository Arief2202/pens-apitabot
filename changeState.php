<?php
    include "koneksi.php";
    $column = null;
    $state = null;
    if(isset($_GET['column'])) $column = $_GET['column'];
    if(isset($_GET['state'])) $state = $_GET['state'];

    if(isset($_POST['column'])) $column = $_POST['column'];    
    if(isset($_POST['state'])) $state = $_POST['state'];    

    // if(isset($id)){
        $sql = "SELECT * FROM `state` ORDER BY id DESC";        
        $query = mysqli_query($koneksi, $sql);
        $result = mysqli_fetch_object($query);
        $pengisi_air = $result->pengisi_air;
        $pembuang_c1 = $result->pembuang_c1;
        $pembuang_c2 = $result->pembuang_c2;
        $lampu = $result->lampu;
        switch($column){
            case "pengisi_air" : $pengisi_air = $state; break;
            case "pembuang_c1" : $pembuang_c1 = $state; break;
            case "pembuang_c2" : $pembuang_c2 = $state; break;
            case "lampu" : $lampu = $state; break;
        }
        $sql = "INSERT INTO `state` (`id`, `pengisi_air`, `pembuang_c1`, `pembuang_c2`, `lampu`, `timestamp`) VALUES (NULL, '".$pengisi_air."', '".$pembuang_c1."', '".$pembuang_c2."', '".$lampu."', current_timestamp());";     
        $query = mysqli_query($koneksi, $sql);
        var_dump($result);die;
    // }
