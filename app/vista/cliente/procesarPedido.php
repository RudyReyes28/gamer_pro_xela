<?php
// Verificar si el formulario fue enviado y si existe el campo 'carrito'
if (isset($_POST['carrito'])) {
    // Recibir el JSON enviado a través del campo 'carrito'
    $carritoJson = $_POST['carrito'];

    // Decodificar el JSON a un arreglo de PHP
    $carrito = json_decode($carritoJson, true);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procesar Pedido</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
</head>

<body>

    <div class="container">
        <h1 class="my-4  gradient-custom-2">Productos a Comprar</h1>
        <?php if ($carrito !== null && count($carrito) > 0): ?>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Nombre</th>
                        <th>Precio</th>
                        <th>Cantidad</th>
                        <th>Quitar Producto</th>
                    </tr>
                </thead>
                <tbody id="tabla-carrito">
                    <?php foreach ($carrito as $producto): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($producto['nombre']); ?></td>
                            <td><?php echo htmlspecialchars($producto['precio']); ?></td>
                            <td>
                                <input type="number" class="form-control cantidad-producto"
                                    value="<?php echo htmlspecialchars($producto['cantidad']); ?>"
                                    min="1" max="<?php echo htmlspecialchars($producto['existencia']); ?>"
                                    data-id="<?php echo htmlspecialchars($producto['id_producto']); ?>"
                                    data-sucursal="<?php echo htmlspecialchars($producto['id_sucursal']); ?>"
                                    data-max="<?php echo htmlspecialchars($producto['existencia']); ?>">
                            </td>
                            <td>
                                <button class="btn btn-danger quitar-producto"
                                    data-id="<?php echo htmlspecialchars($producto['id_producto']); ?>">
                                    Quitar
                                </button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>

            <!-- Modal para ingresar los últimos datos (NIT y Nombre) -->
            <div class="modal fade" id="pedidoModal" tabindex="-1" aria-labelledby="pedidoModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="pedidoModalLabel">Datos del Cliente</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body">
                            <form id="form-pedido">
                                <div class="mb-3">
                                    <label for="tipo-cliente" class="form-label">Tipo de Cliente</label>
                                    <select class="form-select" id="tipo-cliente">
                                        <option value="cf">Consumidor Final</option>
                                        <option value="nit">Con NIT</option>
                                    </select>
                                </div>
                                <div class="mb-3" id="nit-container">
                                    <label for="nit" class="form-label">NIT</label>
                                    <input type="text" class="form-control" id="nit" placeholder="Ingrese el NIT">
                                </div>
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre del Cliente</label>
                                    <input type="text" class="form-control" id="nombre" placeholder="Ingrese el nombre del cliente">
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-primary" id="confirmar-pedido">Confirmar Pedido</button>
                        </div>
                    </div>
                </div>
            </div>

            <button id="realizar-pedido" class="btn btn-primary">Realizar pedido</button>
        <?php else: ?>
            <p>No hay productos en el carrito.</p>
        <?php endif; ?>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js_cliente/procesar_pedido.js"> </script>
</body>

</html>