<?php
require_once '../../modelo/cliente/EncontrarSucursales.php';
$encontrarSucursales = new EncontrarSucursales();

$sucursales = $encontrarSucursales->buscarSucursales();

$encontrarSucursales->cerrarConexion();

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
</head>

<body>
    <div class="container">
        <!-- Header -->
        <header class="my-4 gradient-custom-2">
            <h1 class="text-center">Bienvenido a Gamer Pro Xela</h1>
        </header>

        <!-- Bloques de Sucursales -->
        <div class="row">
            <?php foreach ($sucursales as $sucursal): ?>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><?php echo $sucursal['nombre']; ?></h5>
                            <p class="card-text">Dirección: <?php echo $sucursal['direccion']; ?></p>
                            <!-- Formulario para enviar el código de la sucursal -->
                            <form method="post" action="productosComprar.php">
                                <input type="hidden" name="codigo_sucursal" value="<?php echo $sucursal['id_sucursal']; ?>">
                                <button type="submit" class="btn btn-primary">Ver productos</button>
                            </form>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <!-- Opción para solicitar tarjeta de descuento -->
        <div class="text-center my-4">
            <a href="../../vista/cliente/solicitudTarjeta.php" class="btn btn-danger">Solicitar tarjeta de descuento</a>
            <a href="../../vista/login/login.html" class="btn btn-primary">Salir</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>