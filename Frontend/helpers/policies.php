<?php

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

function generateCSP(array $scripts = null, array $styles = null) {
    $scriptHash = null;
    $styleHash = null;

    if (isset($scripts) || isset($styles)) {
        $csp = "Content-Security-Policy: script-src https://styleme.best ";
        
        if (isset($scripts) && is_array($scripts) && count($scripts) > 0) {
            for ($i = 0; $i < count($scripts); $i++) {
                $csp .= "'sha256-" . hash('sha256', $scripts[$i]) . "' ";
            }
        }

        $csp .= "https://api.styleme.best https://cdnjs.cloudflare.com https://fonts.googleapis.com https://fonts.gstatic.com; style-src ";

        if (isset($scripts) && is_array($scripts) && count($scripts) > 0) {
            for ($i = 0; $i < count($scripts); $i++) {
                $csp .= "'sha256-" . hash('sha256', $styles[$i]) . "' ";
            }
        }
        
        $csp .= "https://api.styleme.best https://cdnjs.cloudflare.com https://fonts.googleapis.com https://fonts.gstatic.com;";
    }
    else {
        header("Content-Security-Policy: script-src https://styleme.best https://api.styleme.best https://cdnjs.cloudflare.com https://fonts.googleapis.com https://fonts.gstatic.com; style-src https://styleme.best https://api.styleme.best https://cdnjs.cloudflare.com https://fonts.googleapis.com https://fonts.gstatic.com;");
    }
}