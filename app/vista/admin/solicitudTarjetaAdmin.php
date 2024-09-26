<?php
require_once '../../modelo/administrador/ConexionReportes.php';
    $conexion = new ConexionReportes();

    

    if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['idSolicitud'])) {
        $idSolicitud = $_POST['idSolicitud'];
        $idTipo = $_POST['idTarjeta'];
        $nitC = $_POST['nitC'];
        $solicitudA = $conexion->aceptarSolicitud($idSolicitud, $idTipo, $nitC);
        if ($solicitudA) {
            $mensaje = "La solicitud se aceptó correctamente.";
        } else {
            $mensaje = "Ocurrió un error al aceptar la solicitud. Por favor, inténtelo nuevamente.";
        }
    }

    $tarjetas = $conexion->solicitudesTarjeta();

    $conexion->cerrarConexion();


?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aceptar Solicitudes Tarjeta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Solicitudes de Tarjetas</h2>
        <div class="table-responsive">
            <table class="table table-bordered table-hover mt-4">
                <thead class="thead-light">
                    <tr>
                        <th>NIT Cliente</th>
                        <th>Nombre Cliente</th>
                        <th>Nombre Tarjeta</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (isset($tarjetas) && !empty($tarjetas)) : ?>
                        <?php foreach ($tarjetas as $solicitud) : ?>
                            <tr>
                                <td><?= htmlspecialchars($solicitud['nit_cliente']) ?></td>
                                <td><?= htmlspecialchars($solicitud['nombre_cliente']) ?></td>
                                <td><?= htmlspecialchars($solicitud['nombre_tarjeta']) ?></td>
                                <td>
                                    <form method="POST" action="">
                                        <input type="hidden" name="idSolicitud" value="<?= $solicitud['id_solicitud'] ?>">
                                        <input type="hidden" name="idTarjeta" value="<?= $solicitud['id_tipo_tarjeta'] ?>">
                                        <input type="hidden" name="nitC" value="<?= $solicitud['nit_cliente'] ?>">
                                        <button type="submit" class="btn btn-success">Aceptar</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else : ?>
                        <tr>
                            <td colspan="4" class="text-center">No hay solicitudes pendientes.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
    <?php if (isset($mensaje)): ?>
        <div class="alert <?php echo $solicitudA ? 'alert-success' : 'alert-danger'; ?>" role="alert">
            <?php echo $mensaje; ?>
        </div>
    <?php endif; ?>

    <a href="vistaAdmin.php" class="btn btn-primary">Regresar</a>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>