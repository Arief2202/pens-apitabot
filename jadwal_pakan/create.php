<?php
    include "../koneksi.php";
    $hari = null;
    $jam = null;
    if(isset($_GET['hari'])) $hari = $_GET['hari'];
    if(isset($_GET['jam'])) $jam = $_GET['jam'];

    if(isset($_POST['hari'])) $hari = $_POST['hari'];
    if(isset($_POST['jam'])) $jam = $_POST['jam'];
    
    if(isset($hari) && isset($jam)){
        $menit = explode(":", $jam)[1];
        $jam = explode(":", $jam)[0];
        switch($hari){
            case "Minggu" : $hari = 0; break;
            case "Senin" : $hari = 1; break;
            case "Selasa" : $hari = 2; break;
            case "Rabu" : $hari = 3; break;
            case "Kamis" : $hari = 4; break;
            case "Jumat" : $hari = 5; break;
            case "Sabtu" : $hari = 6; break;
            default : $hari = 0; break;
        }
        $sql = "SELECT * FROM `jadwal_pakan` WHERE hari = $hari AND jam = $jam AND menit = $menit";
        $query = mysqli_query($koneksi, $sql);
        $result = mysqli_fetch_object($query);
        if(!$result){
            $sql = "INSERT INTO `jadwal_pakan` (`id`, `hari`, `jam`, `menit`, `timestamp`) VALUES (NULL, '".$hari."', '".$jam."', '".$menit."',  current_timestamp());";
            $query = mysqli_query($koneksi, $sql);
            var_dump($query);die;
        }
    }
