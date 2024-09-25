<?php
require_once '../../modelo/cliente/EnviarPedido.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $carritoJson = $_POST['carrito'];

    //tengo el carrito
    $carrito = json_decode($carritoJson, true);
    $nit = $_POST['nit'];
    $nombreCliente = $_POST['nombre'];
    $apellidoCliente = $_POST['apellido'];
    $cf = $_POST['consumidor_f'];
    $sucursal = 0;

    if ($carrito !== null) {
        // Procesar cada producto en el carrito
        foreach ($carrito as $producto) {
            $idProducto = $producto['id_producto'];
            $sucursal = $producto['id_sucursal'];
            $precio = $producto['precio'];
            $cantidad = $producto['cantidad'];
            $nombre = $producto['nombre'];

            //echo "Producto: $nombre, Precio: $precio, Cantidad: $cantidad<br>";
        }
    } else {
        echo "Error al decodificar el JSON.";
    }

    $enviarPedido = new EnviarPedido();
    $realizado = $enviarPedido->enviarPedido($nit, $cf, $nombreCliente, $apellidoCliente, $sucursal, $carrito);

    $enviarPedido->cerrarConexion();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Realizar Pedido</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <?php if ($realizado): ?>
                    <h5 class="card-title">Pedido realizado con éxito</h5>
                    <p>Gracias por su compra. Su pedido ha sido registrado correctamente.</p>
                <?php else: ?>
                    <h5 class="card-title">Error en el pedido</h5>
                    <p>Lo sentimos, ocurrió un error al procesar su pedido. Por favor, inténtelo nuevamente.</p>
                <?php endif; ?>
                <a href="../../vista/login/login.php" class="btn btn-primary">Salir</a>
            </div>
        </div>
    </div>


</body>

</html>