<?php
require_once '../../modelo/cliente/ObtenerProductos.php';
if (isset($_POST['codigo_sucursal'])) {
    $codigo_sucursal = $_POST['codigo_sucursal'];

    $obtenerProductos = new ObtenerProductos();
    $productos = $obtenerProductos->buscarProductos($codigo_sucursal);

    $obtenerProductos->cerrarConexion();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ver Productos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
    <link href="../../../public/css/compras.css" rel="stylesheet" type="text/css">
</head>

<body>
    <div class="container">
        <h1 class="my-4  gradient-custom-2">Productos Disponibles</h1>

        <!-- Botón para finalizar la compra -->
        <div class="text-left mt-4 my-4">
            <button id="finalizar-compra" class="btn btn-primary">Finalizar compra</button>
        </div>

        <input type="text" id="buscar" placeholder="Buscar producto por nombre" class="form-control my-4">
        <!-- Botones de ordenamiento -->
        <div class="d-flex justify-content-end mb-4">
            <button id="ordenarAsc" class="btn btn-primary me-2">Ordenar por precio ascendente</button>
            <button id="ordenarDesc" class="btn btn-primary">Ordenar por precio descendente</button>
        </div>

        <div class="row">
            <?php if ($productos): ?>
                <?php foreach ($productos as $producto): ?>
                    <div class="col-md-4 mb-4">
                        <div class="card border-info mb-3" style="height: 15rem;">
                            <div class="card-body">
                                <h5 class="card-title"><?php echo $producto['nombre']; ?></h5>
                                <p class="card-text">Descripcion: <?php echo $producto['descripcion']; ?></p>
                                <p class="card-text ordenarPrecio">Precio: <?php echo $producto['precio']; ?></p>
                                <!-- Botón para agregar producto al carrito -->
                                <button class="btn btn-success agregar-producto"
                                    data-id="<?php echo $producto['codigo']; ?>"
                                    data-sucursal="<?php echo $codigo_sucursal; ?>"
                                    data-precio="<?php echo $producto['precio']; ?>"
                                    data-nombre="<?php echo $producto['nombre']; ?>"
                                    data-existencia="<?php echo $producto['cantidad_disponible']; ?>">Agregar producto

                                </button>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>No hay productos disponibles en esta sucursal.</p>
            <?php endif; ?>
        </div>



        <div id="cart-icon" class="cart-icon">
            <i class="fas fa-shopping-cart"></i>
            <span id="cart-count" class="cart-count">0</span>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js_cliente/agregar_productos.js"> </script>
    <script src="js_cliente/filtrar_productos.js"> </script>

</body>

</html>