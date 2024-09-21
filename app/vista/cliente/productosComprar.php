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
        <div class="text-left mt-4">
            <button id="finalizar-compra" class="btn btn-primary">Finalizar compra</button>
        </div>

        <div class="row">
            <?php if ($productos): ?>
                <?php foreach ($productos as $producto): ?>
                    <div class="col-md-4 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title"><?php echo $producto['nombre']; ?></h5>
                                <p class="card-text">Descripcion: <?php echo $producto['descripcion']; ?></p>
                                <p class="card-text">Precio: <?php echo $producto['precio']; ?></p>
                                <!-- Botón para agregar producto al carrito -->
                                <button class="btn btn-success agregar-producto"
                                    data-id="<?php echo $producto['codigo']; ?>"
                                    data-sucursal="<?php echo $codigo_sucursal; ?>"
                                    data-precio="<?php echo $producto['precio']; ?>">Agregar producto</button>
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
    <script>
        let cartCount = 0;
        // Arreglo para almacenar los productos seleccionados
        let carrito = [];

        // Capturar el evento de clic en el botón "Agregar producto"
        document.querySelectorAll('.agregar-producto').forEach(button => {
            button.addEventListener('click', function() {
                const idProducto = this.getAttribute('data-id');
                const sucursal = this.getAttribute('data-sucursal');
                const precio = this.getAttribute('data-precio');
                cartCount++;
                 document.getElementById('cart-count').textContent = cartCount;


                // Agregar producto al carrito
                carrito.push({
                    id_producto: idProducto,
                    id_sucursal: sucursal,
                    precio: precio
                });

            });
        });

        // Finalizar compra, enviar el carrito a la página de procesamiento
        document.getElementById('finalizar-compra').addEventListener('click', function() {
            // Enviar el carrito a otra página para procesar el pedido
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'procesarPedido.php';

            // Añadir los datos del carrito al formulario
            const carritoInput = document.createElement('input');
            carritoInput.type = 'hidden';
            carritoInput.name = 'carrito';
            carritoInput.value = JSON.stringify(carrito); // Convertir el arreglo a JSON
            form.appendChild(carritoInput);

            // Añadir el formulario al documento y enviarlo
            document.body.appendChild(form);
            form.submit();
        });
    </script>

</body>

</html>