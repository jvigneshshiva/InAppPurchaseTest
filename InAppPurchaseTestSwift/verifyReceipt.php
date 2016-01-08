<?php
    function getReceiptData($receipt)
    {
        $fh = fopen('showme.txt',w);
        fwrite($fh,$receipt);
        fclose($fh);
        $endpoint = 'https://sandbox.itunes.apple.com/verifyReceipt';
        
        $ch = curl_init($endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $receipt);
        $response = curl_exec($ch);
        $errno = curl_errno($ch);
        $errmsg = curl_error($ch);
        curl_close($ch);
        $msg = $response.' - '.$errno.' - '.$errmsg;
        echo $response;
    }
    
    foreach ($_POST as $key=>$value){
        $newcontent .= $key.' '.$value;
    }
    
    $new = trim($newcontent);
    $new = trim($newcontent);
    $new = str_replace('_','+',$new);
    $new = str_replace(' =','==',$new);
    
    if (substr_count($new,'=') == 0){
        if (strpos('=',$new) === false){
            $new .= '=';
        }
    }
    
    $new = '{"receipt-data":"'.$new.'","password":"7bceb97f86fb4ecba7439c19facde395"}';
    $info = getReceiptData($new);
    ?>
