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
    
    $new = '{"receipt-data":"'.$new.'","password":"3888249939794d8ea499b35d6d86ec52"}';
    $info = getReceiptData($new);
    ?>