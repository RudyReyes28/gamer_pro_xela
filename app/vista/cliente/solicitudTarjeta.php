<?php
require_once '../../modelo/cliente/EnviarSolicitudTarjeta.php';
    $conexion = new EnviarSolicitudTarjeta();

    $cliente = null;
    $nit = "";

    if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['nit'])) {
        $nit = $_POST['nit'];

        $cliente = $conexion->obtenerTarjetaCliente($nit);

    }

    $tarjetas = $conexion->obtenerTipoTarjeta();

    $conexion->cerrarConexion();


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
        <h2>Buscar Cliente por NIT</h2>
        <form method="POST" action="">
            <div class="mb-3">
                <label for="nit" class="form-label">Ingrese su NIT</label>
                <input type="text" name="nit" id="nit" class="form-control" value="<?= htmlspecialchars($nit) ?>" required>
            </div>
            <button type="submit" class="btn btn-primary">Buscar</button>
        </form>

        <?php if ($cliente): ?>
            <div class="mt-5">
                <h3>Información del Cliente</h3>
                <p><strong>Tipo de Tarjeta:</strong> <?= $cliente['tipo_tarjeta'] ?: 'Ninguna' ?></p>
                <p><strong>Puntos:</strong> <?= $cliente['puntos_tarjeta'] ?: 0 ?></p>
                <p><strong>Total de Compras:</strong> <?= $cliente['total_ventas'] ?></p>

                <h3>Solicitar Tarjeta</h3>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Tipo de Tarjeta</th>
                            <th>Cantidad Adquisición</th>
                            <th>Puntos Descuento por cada 200Q</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($tarjetas as $tarjeta): ?>
                            <tr>
                                <td><?= $tarjeta['nombre'] ?></td>
                                <td><?= $tarjeta['cantidad_adquisicion'] ?></td>
                                <td><?= $tarjeta['puntos_descuento'] ?></td>
                                <td>
                                    <?php
                                    
                                    $totalVentas = $cliente['total_ventas'] ?: 0;
                                    $tipoActual = $cliente['tipo_tarjeta'] ?: 'ninguna';
                                    $puedeSolicitar = false;

                                    if ($tipoActual === 'ninguna' && $tarjeta['nombre'] === 'comun') {
                                        $puedeSolicitar = true;  
                                    } elseif ($tipoActual === 'comun' && $tarjeta['nombre'] === 'oro') {
                                        $puedeSolicitar = $totalVentas >= $tarjeta['cantidad_adquisicion'];
                                    } elseif ($tipoActual === 'oro' && $tarjeta['nombre'] === 'platino') {
                                        $puedeSolicitar = $totalVentas >= $tarjeta['cantidad_adquisicion'];
                                    } elseif ($tipoActual === 'platino' && $tarjeta['nombre'] === 'diamante') {
                                        $puedeSolicitar = $totalVentas >= $tarjeta['cantidad_adquisicion'];
                                    }

                                    if ($puedeSolicitar):
                                    ?>
                                        <form method="POST" action="../../controlador/cliente/procesarSolicitudTarjeta.php">
                                            <input type="hidden" name="nit" value="<?= $nit ?>">
                                            <input type="hidden" name="id_tipo" value="<?= $tarjeta['id_tipo'] ?>">
                                            <button type="submit" class="btn btn-success">Solicitar</button>
                                        </form>
                                    <?php else: ?>
                                        <button class="btn btn-secondary" disabled>No disponible</button>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php else: ?>
            <div class="mt-5">
                <p>No se encontró información del cliente con NIT <?= htmlspecialchars($nit) ?></p>
            </div>
        <?php endif; ?>

        <a href="../../vista/cliente/home.php" class="btn btn-primary">Regresar</a>
    </div>
</body>
</html>