<?php
require_once '../../modelo/empleado/iniciarSesion.php';

$error = ''; // Variable para guardar el mensaje de error

if (isset($_POST['login'])) {
    $usuario = $_POST['usuario'];
    $passwordIngresada = $_POST['contrasenia'];

    $conexion = new IniciarSesion();
    $empleado = $conexion->buscarEmpleado($usuario); 
    $conexion->cerrarConexion();

    session_start();
    if ($empleado && password_verify($passwordIngresada, $empleado['contrasenia'])) {
        
        $_SESSION['empleado_id'] = $empleado['id_empleado'];
        $_SESSION['empleado_nombre'] = $empleado['nombre'];
        $_SESSION['tipo_empleado'] = $empleado['tipo_empleado'];
        $_SESSION['numero_caja'] = $empleado['numero_caja'];
        $_SESSION['id_sucursal'] = $empleado['id_sucursal'];
        switch ($empleado['tipo_empleado']) {
            case 'cajero':
                header("Location: ../cajero/vistaCajero.php");
                exit;
            case 'admin':
                header("Location: ../admin/vistaAdmin.php");
                exit;
            case 'bodega':
                header("Location: ../bodega/vistaBodega.php");
                exit;
            case 'inventario':
                header("Location: ../inventario/vistaInventario.php");
                exit;
            default:
                $error = "Tipo de empleado desconocido.";
                break;
        }
    } else {
        
        $error = "Usuario o contraseña incorrectos.";
    }
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gamer pro-xela</title>
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
    <!-- Enlace a Bootstrap 5 CSS desde una CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Opcional: Enlace a Bootstrap 5 JavaScript (para funciones interactivas como modales, dropdowns, etc.) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <section class="h-100 gradient-form" style="background-color: #eee;">
        <div class="container py-5 h-100">
          <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-xl-10">
              <div class="card rounded-3 text-black">
                <div class="row g-0">
                  <div class="col-lg-6">
                    <div class="card-body p-md-5 mx-md-4">
      
                      <div class="text-center">
                        <img src="../../../public/imagenes/logo_gamer.jpg"
                          style="width: 185px;" alt="logo">
                        <h4 class="mt-1 mb-5 pb-1">GamerProXela</h4>
                      </div>
      
                      <form method="post" action="#">
                        <p>Ingrese su cuenta de empleado</p>

                        <?php if (!empty($error)): ?>
                            <div class="alert alert-danger" role="alert">
                                <?php echo $error; ?>
                            </div>
                        <?php endif; ?>
      
                        <div data-mdb-input-init class="form-outline mb-4">
                          <input type="text" id="usuario" name="usuario" class="form-control"
                            placeholder="Usuario" />
                        </div>
      
                        <div data-mdb-input-init class="form-outline mb-4">
                          <input type="password" id="contrasenia" name="contrasenia" class="form-control" 
                            placeholder="Contraseña" />
                        </div>
      
                        <div class="text-center pt-1 mb-5 pb-1">
                          <button data-mdb-button-init data-mdb-ripple-init class="btn btn-primary btn-block fa-lg gradient-custom-2 mb-3" 
                          type="submit" name="login">Iniciar Sesion</button>
                          
                        </div>
      
                        
      
                      </form >
                      
                      <form method="post" action="../cliente/home.php">
                        <div class="d-flex align-items-center justify-content-center pb-4">
                            <p class="mb-0 me-2">¿Eres un cliente?</p>
                            <button  type="submit" data-mdb-button-init data-mdb-ripple-init class="btn btn-outline-danger">¡Compra ahora!</button>
                          </div>
                      </form>

      
                    </div>
                  </div>
                  <div class="col-lg-6 d-flex align-items-center gradient-custom-2">
                    <div class="text-white px-3 py-4 p-md-5 mx-md-4">
                      <h4 class="mb-4">Quienes son GamerProXela</h4>
                      <p class="small mb-0">GamerProXela es una tienda online de articulos para videojuegos,
                        donde encontrarás videojuegos, consolas, computadoras, y repuestos. Tenemos 3 sucursales 
                        distribuidas por todo el el departamento de Quetzaltenango.</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

</body>
</html>