<?php
require_once '../../modelo/cajero/VerPedidos.php';
session_start();

if (isset($_SESSION['empleado_id'])) {
    $obtenerPedidos = new VerPedidos();
    $pedidos = $obtenerPedidos->buscarPedidos($_SESSION['id_sucursal']);

    $obtenerPedidos->cerrarConexion();
} else {
    header("Location: ../login/login.php");
    exit;
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ver Pedidos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
</head>

<body>
    <div class="container">
        <h1 class="my-4  gradient-custom-2">Lista de Pedidos</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Numero Pedido</th>
                    <th>Nit/CF</th>
                    <th>Nombre Cliente</th>
                    <th>Total</th>
                    <th>Fecha Pedido</th>
                    <th>Realizar Pedido</th>
                </tr>
            </thead>
            <tbody id="tabla-carrito">
                <?php foreach ($pedidos as $pedido): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($pedido['id_pedido']); ?></td>
                        <td><?php echo htmlspecialchars($pedido['consumidor_final'] === true ? 'C/F' : $pedido['nit_cliente']); ?></td>
                        <td><?php echo htmlspecialchars($pedido['nombre_cliente']); ?></td>
                        <td><?php echo htmlspecialchars($pedido['total']); ?></td>
                        <td><?php echo htmlspecialchars($pedido['fecha_pedido']); ?></td>

                        <td>
                            <form method="POST" action="realizarVenta.php">
                                <input type="hidden" name="nit" value="<?= $pedido['nit_cliente']?>">
                                <input type="hidden" name="consumidor_final" value="<?= $pedido['consumidor_final']?>">
                                <input type="hidden" name="id_pedido" value="<?= $pedido['id_pedido'] ?>">
                                <button type="submit" class="btn btn-success">Realizar venta</button>
                            </form>

                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <a href="vistaCajero.php" class="btn btn-primary">Regresar</a>
    </div>
</body>

</html>