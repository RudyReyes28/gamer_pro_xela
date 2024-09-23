<?php
require_once '../../modelo/cliente/EnviarSolicitudTarjeta.php';
    
    $realizado = false;
    if ($_SERVER['REQUEST_METHOD'] ) {
        $nit = $_POST['nit'];
        $tarjeta = $_POST['id_tipo'];

        $conexion = new EnviarSolicitudTarjeta();
        $realizado = $conexion->solicitarTarjeta($nit,$tarjeta);

    }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitud Tarjeta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <?php if ($realizado): ?>
                    <h5 class="card-title">Tarjeta pedida con éxito</h5>
                    <p>Espere que el administrador acepte su solicitud</p>
                <?php else: ?>
                    <h5 class="card-title">Error en el pedido</h5>
                    <p>Lo sentimos, ocurrió un error al procesar su pedido. Por favor, inténtelo nuevamente.</p>
                <?php endif; ?>
                <a href="../../vista/login/login.html" class="btn btn-primary">Salir</a>
            </div>
        </div>
    </div>


</body>

</html>