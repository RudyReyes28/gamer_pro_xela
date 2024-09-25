<?php
session_start();

if (isset($_SESSION['empleado_id'])) {
    $nombreC = $_SESSION['empleado_nombre'];
    
} else {
    // Redirigir si no hay sesión iniciada
    header("Location: ../login/login.php");
    exit;
}

?>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Bodega</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
</head>

<body>
    <div class="container">
        <!-- Header -->
        <header class="my-4 gradient-custom-2">
            <h1 class="text-center">Bienvenido  <?php echo  $nombreC; ?></h1>
        </header>

        <!-- Bloques de Opciones -->
        <div class="row">
            
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Actualizar Existencias Bodega</h5>
                            <p class="card-text">Actualice las existencias de los productos en la bodega</p>
                            <!-- Formulario para enviar el código de la sucursal -->
                            <form method="post" action="actualizarExistencia.php">
                                <button type="submit" class="btn btn-primary">Actualizar</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Ingresar nuevo producto</h5>
                            <p class="card-text">Ingrese un nuevo producto a la bodega</p>
                            <form method="post" action="nuevoProducto.php">
                                <button type="submit" class="btn btn-primary">Nuevo Producto</button>
                            </form>
                        </div>
                    </div>
                </div>
            
        </div>

        <!-- Opción para solicitar tarjeta de descuento -->
        <div class="text-center my-4">
           
            <a href="../../controlador/login/cerrarSesion.php" class="btn btn-primary">Cerrar Sesion</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>