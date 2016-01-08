<?php
    function getReceiptData($receipt)
    {
        $endpoint = 'https://sandbox.itunes.apple.com/verifyReceipt';
        $context = [
        'http' => [
        'method' => 'POST',
        'content' => json_encode($receipt)
        ]
        ];
        $context = stream_context_create($context);
        $result = file_get_contents($endpoint, false, $context);
        echo $result;
    }
    
    $info = getReceiptData($_POST);
    ?>
