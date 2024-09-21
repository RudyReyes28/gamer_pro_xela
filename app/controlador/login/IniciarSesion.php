<?php
    if (isset($_POST['login'])) {
        $usuario = $_POST['usuario'];
        $password = $_POST['contrasenia'];

        echo $usuario." contra" .$password; 
    }

?>