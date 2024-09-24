<?php
    if (isset($_POST['login'])) {
        $usuario = $_POST['usuario'];
        $password = $_POST['contrasenia'];

        echo $usuario." contra" .$password; 
        $passwordHashed = password_hash($password, PASSWORD_DEFAULT);
        echo "<br>";
        echo $passwordHashed;
    }

?>