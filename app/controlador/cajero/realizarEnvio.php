<?php
require_once '../../modelo/cajero/EnviarVenta.php';
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $carritoJson = $_POST['carrito'];

    //tengo el carrito
    $carrito = json_decode($carritoJson, true);
    $nit = $_POST['nit'];
    $cf = $_POST['consumidor_f'];
    
    $idEmpleado = $_SESSION['empleado_id'];
    $idPedido = $_POST['id_pedido'];
    $idSucursal = $_SESSION['id_sucursal'];
    $puntos_tarjeta = $_POST['puntos_tarjeta'];

    $enviarV = new EnviarVenta();
    $realizado = $enviarV->enviarVenta($idEmpleado,$idPedido,$carrito,$idSucursal,$puntos_tarjeta,$nit,$cf);
    //$realizado = true;
    //$enviarV->enviarProductoV($idEmpleado,$idPedido,$carrito,$idSucursal,$puntos_tarjeta,$nit,$cf);

    $enviarV->cerrarConexion();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venta realizada</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <?php if ($realizado): ?>
                    <h5 class="card-title">Venta realizada con éxito</h5>
                    <p>Gracias por su compra. Su venta ha sido realizada correctamente.</p>
                <?php else: ?>
                    <h5 class="card-title">Error en la venta</h5>
                    <p>Lo sentimos, ocurrió un error al procesar su pedido. Por favor, inténtelo nuevamente.</p>
                <?php endif; ?>
                <a href="../../vista/cajero/vistaCajero.php" class="btn btn-primary">Salir</a>
            </div>
        </div>
    </div>


</body>

</html>