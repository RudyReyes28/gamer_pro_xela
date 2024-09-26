<?php
session_start();

if (isset($_SESSION['empleado_id'])) {
    $nombreC = $_SESSION['empleado_nombre'];
} else {
    // Redirigir si no hay sesión iniciada
    header("Location: ../login.php");
    exit;
}

?>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrador</title>
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
                            <h5 class="card-title">Solicitudes de Tarjetas</h5>
                            <p class="card-text">Acepte las solicitudes de las tarjetas de regalo enviada por los clientes</p>
                            <!-- Formulario para enviar el código de la sucursal -->
                            <a href="solicitudTarjeta.php" class="btn btn-primary">Ver Solicitudes</a>
                                
                            
                        </div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Reportes</h5>
                            <p class="card-text">Revise los diferentes reportes de las ventas</p>
                            <a href="reportesAdmin.php" class="btn btn-primary">Ver Reportes</a>
                                
                            
                        </div>
                    </div>
                </div>
            
        </div>

        <!-- Opción para solicitar tarjeta de descuento -->
        <div class="text-center my-4">
           
            <a href="../../controlador/login/cerrarSesion.php" class="btn btn-primary">Salir</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>