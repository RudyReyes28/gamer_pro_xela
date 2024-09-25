<?php
require_once '../../modelo/bodega/ProductosBodega.php';
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $codigoProducto = $_POST['codigo_producto'];
    $cantidadAumentar = $_POST['cantidad_aumentar'];
    $codigo_sucursal = $_SESSION['id_sucursal'];

    //echo $codigoProducto." ".$codigo_sucursal." ".$cantidadAumentar;

    $actualizar = new ProductosBodega();
    $realizado = $actualizar->actualizarExistencia($codigo_sucursal,$codigoProducto,$cantidadAumentar);
    

    $actualizar->cerrarConexion();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Existencia Actualizada</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <?php if ($realizado): ?>
                    <h5 class="card-title">Existencia actualizada con éxito</h5>
                    <p>La existencia del producto se ha actualizado correctamente </p>
                <?php else: ?>
                    <h5 class="card-title">Error en la existencia</h5>
                    <p>Lo sentimos, ocurrió un error al procesar la existencia. Por favor, inténtelo nuevamente.</p>
                <?php endif; ?>
                <a href="../../vista/bodega/vistaBodega.php" class="btn btn-primary">Salir</a>
            </div>
        </div>
    </div>


</body>

</html>