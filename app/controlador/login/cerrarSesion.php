<?php
    session_start();
    session_destroy(); // Destruir la sesión
    header("Location: ../../vista/login/login.php");
    exit;
?>