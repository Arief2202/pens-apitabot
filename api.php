<?php
    include "koneksi.php";
    header('Content-Type: application/json; charset=utf-8');
    header("Access-Control-Allow-Origin: *");
    http_response_code(406);
    
    if(isset($_POST['manual_finish']) || isset($_GET['manual_finish'])){
        $id = null;
        if(isset($_GET['id'])) $id = $_GET['id'];
        if(isset($_POST['id'])) $id = $_POST['id'];
        if($id != null){
            $sql = "UPDATE `manual` SET `is_run` = '1' WHERE `manual`.`id` = $id;";
            if(mysqli_query($koneksi, $sql)) http_response_code(200);
        }
    }
    else{
        $kelembapan_udara = null;
        $kualitas_air = null;
        $ph_air = null;
        $suhu_air = null;
        $timestamp = null;
        if(isset($_GET['kelembapan_udara'])) $kelembapan_udara = $_GET['kelembapan_udara'];
        if(isset($_GET['kualitas_air'])) $kualitas_air = $_GET['kualitas_air'];
        if(isset($_GET['ph_air'])) $ph_air = $_GET['ph_air'];
        if(isset($_GET['suhu_air'])) $suhu_air = $_GET['suhu_air'];
        if(isset($_GET['timestamp'])) $timestamp = $_GET['timestamp'];

        if(isset($_POST['kelembapan_udara'])) $kelembapan_udara = $_POST['kelembapan_udara'];
        if(isset($_POST['kualitas_air'])) $kualitas_air = $_POST['kualitas_air'];
        if(isset($_POST['ph_air'])) $ph_air = $_POST['ph_air'];
        if(isset($_POST['suhu_air'])) $suhu_air = $_POST['suhu_air'];
        if(isset($_POST['timestamp'])) $timestamp = $_POST['timestamp'];
        
        if($timestamp == null) $timestamp = "current_timestamp()";
        else $timestamp = "'".$timestamp."'";
        $sql = "INSERT INTO `monitoring` (`id`, `kelembapan_udara`, `kualitas_air`, `ph_air`, `suhu_air`, `timestamp`) VALUES (NULL, '".$kelembapan_udara."', '".$kualitas_air."', '".$ph_air."', '".$suhu_air."', ".$timestamp.");";
        
        $query = mysqli_query($koneksi, $sql);
    }
    $hari = [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
    ];

    $sql = "SELECT * FROM monitoring ORDER BY `id` DESC";
    $result = mysqli_query($koneksi, $sql);
    $data = mysqli_fetch_object($result);
    $sql2 = "SELECT * FROM manual WHERE is_run = 0 ORDER BY `id` DESC";
    $result2 = mysqli_query($koneksi, $sql2);
    $data2 = mysqli_fetch_object($result2);

    $sql3 = "SELECT * FROM jadwal_pakan ORDER BY `hari` ASC, jam";
    $result3 = mysqli_query($koneksi, $sql3);
    $data3 = array();
    $data3flutter = array();
    $index = 0;
    while($dt = mysqli_fetch_object($result3)){
        $data3[$index] = $dt;
        $data3flutter[$index]['id'] = $dt->id;
        $data3flutter[$index]['hari'] = $hari[$dt->hari];
        $data3flutter[$index]['jam'] = ($dt->jam<10?"0":"").$dt->jam.":".($dt->menit<10?"0":"").$dt->menit;
        $index++;
    }
    echo json_encode([
        "success" => "true",
        "data_latest" => $data,
        "state_latest" => $data2,
        "jadwal_pakan" => $data3,
        "jadwal_pakan_flutter" => $data3flutter
    ]);die;