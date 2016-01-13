<?php
    function getReceiptData($receipt)
    {
        $endpoint = 'https://sandbox.itunes.apple.com/verifyReceipt';
        $context = [
        'http' => [
        'method' => 'POST',
        'content' => $receipt
        ]
        ];
        $context = stream_context_create($context);
        $result = file_get_contents($endpoint, false, $context);
        echo $result;
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
    
    $new = '{"receipt-data":"'.$new.'","password":"d83dd06e9cf24605a53c3e5786b74613"}';
    $info = getReceiptData($new);
    ?>