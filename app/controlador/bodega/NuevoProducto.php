<?php
require_once '../../modelo/bodega/ProductosBodega.php';
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $codigo = $_POST['codigo'];
    $nombre = $_POST['nombre'];
    $descripcion = $_POST['descripcion'];
    $precio = $_POST['precio'];
    $cantidad = $_POST['cantidad'];

    $codigo_sucursal = $_SESSION['id_sucursal'];

    //echo $codigoProducto." ".$codigo_sucursal." ".$cantidadAumentar;

    $nuevo = new ProductosBodega();
    $realizado = $nuevo->nuevoProducto($codigo,$nombre,$descripcion,$precio, $codigo_sucursal, $cantidad);
    

    $nuevo->cerrarConexion();
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
                    <h5 class="card-title">Producto agregado con éxito</h5>
                    <p>El producto se ha añadido a la tienda correctamente</p>
                <?php else: ?>
                    <h5 class="card-title">Error al agregar Producto</h5>
                    <p>Lo sentimos, ocurrió un error al procesar el nuevo producto. Por favor, inténtelo nuevamente.</p>
                <?php endif; ?>
                <a href="../../vista/bodega/vistaBodega.php" class="btn btn-primary">Salir</a>
            </div>
        </div>
    </div>


</body>

</html>