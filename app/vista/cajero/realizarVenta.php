<?php
require_once '../../modelo/cajero/VerPedidos.php';
session_start();
$realizado = false;
if ($_SERVER['REQUEST_METHOD']) {
    $nit = $_POST['nit'];
    $id_pedido = $_POST['id_pedido'];
    $consumidor_f = $_POST['consumidor_final'];

    $obtenerPedidos = new VerPedidos();
    $carrito = $obtenerPedidos->verProductos($id_pedido);
    $tarjetaC = $obtenerPedidos->obtenerTarjetaCliente($nit);

    $obtenerPedidos->cerrarConexion();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalizar Venta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">

</head>

<body>
    <div class="container">
        <h1 class="my-4  gradient-custom-2">Lista de Pedidos</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Precio</th>
                    <th>Cantidad</th>
                    <th>Quitar Producto</th>
                </tr>
            </thead>
            <tbody id="tabla-carrito">
                <?php foreach ($carrito as $producto): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($producto['nombre']); ?></td>
                        <td><?php echo htmlspecialchars($producto['costo_u']); ?></td>
                        <td>
                            <input type="number" class="form-control cantidad-producto"
                                value="<?php echo htmlspecialchars($producto['cantidad']); ?>"
                                min="1" max="<?php echo htmlspecialchars($producto['cantidad']); ?>"
                                data-id="<?php echo htmlspecialchars($producto['codigo_producto']); ?>"
                                data-max="<?php echo htmlspecialchars($producto['cantidad']); ?>">
                        </td>
                        <td>
                            <button class="btn btn-danger quitar-producto"
                                data-id="<?php echo htmlspecialchars($producto['codigo_producto']); ?>">
                                Quitar
                            </button>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <?php if ($tarjetaC): ?>
            <div class="mt-5">
                <h3>Información del Cliente</h3>
                <p><strong>Tipo de Tarjeta:</strong> <?= $tarjetaC['tipo_tarjeta'] ?: 'Ninguna' ?></p>
                <p><strong>Puntos:</strong> <?= $tarjetaC['puntos_tarjeta'] ?: 0 ?></p>
                <p><strong>Total de Compras:</strong> <?= $tarjetaC['total_ventas'] ?></p>

                <input type="number" class="form-control cantidad-puntos"
                    value="0"
                    min="0" max="<?php echo htmlspecialchars($tarjetaC['puntos_tarjeta'] ?: 0); ?>"
                    data-max="<?php echo htmlspecialchars($tarjetaC['puntos_tarjeta'] ?: 0); ?>">

                    <button class="btn btn-danger agregar-puntos">
                                Canjear Puntos
                    </button>

            </div>
            
            

            
       <?php endif; ?>
       <div class="mt-3">
                <h3>Total: Q<span id="total-compra">0.00</span></h3>
                <h3>Total con descuento: Q<span id="total-descuento">0.00</span></h3>
            </div>
       <div class="mt-5">
                <button id="realizar-pedido" class="btn btn-primary">Realizar pedido</button>
            </div>

    </div>
    <!-- Pasamos las variables de PHP a JS -->
    <script>
            const nit = "<?php echo $nit; ?>";
            const idPedido = "<?php echo $id_pedido; ?>";
            const consumidorFinal = "<?php echo $consumidor_f; ?>";
        </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js_cajero/editar_carrito.js"> </script>
</body>

</html>