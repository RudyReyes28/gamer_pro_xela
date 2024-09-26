<?php
require_once '../../modelo/administrador/ConexionReportes.php';
session_start();
$mostrarTabla= false;
// Lógica para manejo de reportes
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $opcion = $_POST['opcion'];
    $reportes = new ConexionReportes();
    
    switch ($opcion) {
        case 1: // Historial de descuentos
            if (!empty($_POST['fecha_inicio']) && !empty($_POST['fecha_fin'])) {
                $fecha_inicio = $_POST['fecha_inicio'];
                $fecha_fin = $_POST['fecha_fin'];
                
                $resultado = $reportes->historialDescuentos($fecha_inicio, $fecha_fin);
                $mostrarTabla=true;
            }
            break;

        case 2: // Top 10 ventas más grandes
            if (!empty($_POST['fecha_inicio']) && !empty($_POST['fecha_fin'])) {
                $fecha_inicio = $_POST['fecha_inicio'];
                $fecha_fin = $_POST['fecha_fin'];
                
                $resultado = $reportes->topVentasMasGrandes($fecha_inicio, $fecha_fin);
                $mostrarTabla = true;
            }
            break;

        case 3: // Top 2 sucursales con más ingresos
            $resultado = $reportes->topSucursalesMasDinero();
            $mostrarTabla = true;
            break;

        case 4: // Top 10 artículos más vendidos
            $resultado = $reportes->topArticulosMasVendidos();
           
            $mostrarTabla = true;
            break;

        case 5: // Top 10 clientes con más gasto
            $resultado = $reportes->topClientesMasGasto();
            $mostrarTabla=true;
            break;

        default:
            $resultado = null;
            $mostrarTabla=false;
            break;
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes Administrador</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .reporte-form { display: none; }
    </style>
</head>
<body class="container">
<h1 class="text-center mt-5">Reportes Administrador</h1>
    <div class="mt-4">
        <form method="POST" id="formReporte" class="text-center">
            <div class="form-group">
                <label for="reporte">Seleccione el reporte:</label>
                <select class="form-control" id="reporte" name="opcion" onchange="mostrarFormulario()">
                    <option value="">Seleccione...</option>
                    <option value="1">Historial de Descuentos</option>
                    <option value="2">Top 10 ventas más grandes en un intervalo de tiempo.</option>
                    <option value="3">Top 2 sucursales que más dinero han ingresado.</option>
                    <option value="4">Top 10 artículos más vendidos.</option>
                    <option value="5">Top 10 clientes que más dinero han gastado.</option>
                </select>
            </div>
            <div id="formFechas" class="form-row reporte-form">
                <div class="form-group col-md-6">
                    <label for="fecha_inicio">Fecha de Inicio</label>
                    <input type="date" class="form-control" name="fecha_inicio" id="fecha_inicio">
                </div>
                <div class="form-group col-md-6">
                    <label for="fecha_fin">Fecha de Fin</label>
                    <input type="date" class="form-control" name="fecha_fin" id="fecha_fin">
                </div>
            </div>
            <button type="submit" class="btn btn-success">Generar Reporte</button>
        </form>
    </div>

    <!-- Resultados de los reportes -->
    <div class="reporte-tabla mt-5" id="tabla-reporte">
        <?php if ($mostrarTabla): ?>
            <table class="table table-bordered">
                <thead>
                    <!-- Cabecera según el reporte -->
                    <?php if ($opcion == 1): ?>
                        <tr>
                            <th>Número de Factura</th>
                            <th>ID Empleado</th>
                            <th>Nombre Empleado</th>
                            <th>NIT</th>
                            <th>Nombre Cliente</th>
                            <th>Descuento</th>
                            <th>Fecha Venta</th>
                        </tr>
                    <?php elseif ($opcion == 2): ?>
                        <tr>
                            <th>Número de Factura</th>
                            <th>ID Empleado</th>
                            <th>Nombre Empleado</th>
                            <th>NIT</th>
                            <th>Nombre Cliente</th>
                            <th>Total</th>
                            <th>Fecha Venta</th>
                        </tr>
                    <?php elseif ($opcion == 3): ?>
                        <tr>
                            <th>ID Sucursal</th>
                            <th>Sucursal</th>
                            <th>Ingresos Totales</th>
                        </tr>
                    <?php elseif ($opcion == 4): ?>
                        <tr>
                            <th>Código Producto</th>
                            <th>Nombre Producto</th>
                            <th>Cantidad Vendida</th>
                        </tr>
                    <?php elseif ($opcion == 5): ?>
                        <tr>
                            <th>NIT Cliente</th>
                            <th>Nombre Cliente</th>
                            <th>Total Gastado</th>
                        </tr>
                    <?php endif; ?>
                </thead>
                <tbody>
                    <!-- Generar filas según el reporte -->
                    <?php foreach ($resultado as $fila): ?>
                        <tr>
                            <?php foreach ($fila as $dato): ?>
                                <td><?= htmlspecialchars($dato) ?></td>
                            <?php endforeach; ?>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php endif; ?>
    </div>
    <a href="vistaAdmin.php" class="btn btn-primary">Regresar</a>

    <script>
        function mostrarFormulario() {
            var select = document.getElementById('reporte').value;
            var formFechas = document.getElementById('formFechas');
            
            // Mostrar el formulario de fechas solo para los reportes que lo requieran
            if (select == 1 || select == 2) {
                formFechas.style.display = 'flex';
                document.getElementById('fecha_inicio').required = true;
                document.getElementById('fecha_fin').required = true;
            } else {
                formFechas.style.display = 'none';
                document.getElementById('fecha_inicio').required = false;
                document.getElementById('fecha_fin').required = false;
            }

        }
    </script>
</body>
</html>