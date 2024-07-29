<?php
    include "koneksi.php";
    header('Content-Type: application/json; charset=utf-8');
    header("Access-Control-Allow-Origin: *");
    http_response_code(406);

    if(isset($_POST['manual_trigger'])){
        if(isset($_POST['mode'])){
            $sql = "INSERT INTO `manual` (`id`, `mode`, `is_run`, `timestamp`) VALUES (NULL, '".$_POST['mode']."', '0', current_timestamp());";
            mysqli_query($koneksi, $sql);
        }
    }
    else{
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
            $data3flutter[$index]['duration'] = $dt->duration;
            $index++;
        }
        http_response_code(200);
        echo json_encode([
            "success" => "true",
            "data_latest" => $data,
            "state_latest" => $data2,
            "jadwal_pakan" => $data3,
            "jadwal_pakan_flutter" => $data3flutter
        ]);die;        
    }
