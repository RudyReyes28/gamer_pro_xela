<?php
session_start();

if (isset($_SESSION['empleado_id'])) {
    echo "Bienvenido, " . $_SESSION['empleado_nombre'];
    echo "<br>";
    echo "Tipo". $_SESSION['tipo_empleado'];
    echo "<br>";
    echo "Sucursal". $_SESSION['id_sucursal'];
    // Aquí puedes usar los datos almacenados como $_SESSION['tipo_empleado']
} else {
    // Redirigir si no hay sesión iniciada
    header("Location: ../login.php");
    exit;
}

?>