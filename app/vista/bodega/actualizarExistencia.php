<?php
require_once '../../modelo/bodega/ProductosBodega.php';
session_start();

if (isset($_SESSION['empleado_id'])) {
    $nombreC = $_SESSION['empleado_nombre'];
    $codigo_sucursal = $_SESSION['id_sucursal'];
    $obtenerProductos = new ProductosBodega();
    $productos = $obtenerProductos->buscarProductos($codigo_sucursal);

    $obtenerProductos->cerrarConexion();
    
} else {
    // Redirigir si no hay sesión iniciada
    header("Location: ../login/login.php");
    exit;
}

?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aumentar Existencias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../../../public/css/login.css" rel="stylesheet" type="text/css">
</head>
<body>

<div class="container mt-5">
        <header class="my-4 gradient-custom-2">
            <h2 class="text-center " >Aumentar Existencias</h2>
        </header>
    

    <form id="formAumentarExistencia" action="../../controlador/bodega/Existencias.php" method="POST" class="mt-4">
        <div class="mb-3">
            <label for="selectProducto" class="form-label">Seleccione un producto</label>
            <select id="selectProducto" name="codigo_producto" class="form-select" required>
                <option value="">Seleccione un producto</option>
                <?php foreach ($productos as $producto): ?>
                    <option value="<?= $producto['codigo'] ?>"><?= htmlspecialchars($producto['nombre']) ?></option>
                <?php endforeach; ?>
            </select>
        </div>

        <div id="detalleProducto" class="mt-4" style="display: none;">
            <h4>Detalles del Producto</h4>
            <div class="mb-3">
                <label for="nombreProducto" class="form-label"><strong>Nombre:</strong></label>
                <p id="nombreProducto"></p>
            </div>

            <div class="mb-3">
                <label for="descripcionProducto" class="form-label"><strong>Descripción:</strong></label>
                <p id="descripcionProducto"></p>
            </div>

            <div class="mb-3">
                <label for="precioProducto" class="form-label"><strong>Precio:</strong></label>
                <p id="precioProducto"></p>
            </div>

            <div class="mb-3">
                <label for="cantidadDisponible" class="form-label"><strong>Cantidad Disponible:</strong></label>
                <p id="cantidadDisponible"></p>
            </div>

            <div class="mb-3">
                <label for="nuevaCantidad" class="form-label">Cantidad a Aumentar</label>
                <input type="number" class="form-control" id="nuevaCantidad" name="cantidad_aumentar" min="1" required>
            </div>

            <div class="mb-3">
                <button type="submit" class="btn btn-primary">Aumentar Existencia</button>
            </div>

            
        </div>
    </form>
</div>

<script>
const productos = <?php echo json_encode($productos); ?>;

document.getElementById('selectProducto').addEventListener('change', function() {
    const codigoProducto = this.value;
    const producto = productos.find(p => p.codigo == codigoProducto);
    
    if (producto) {
        document.getElementById('nombreProducto').textContent = producto.nombre;
        document.getElementById('descripcionProducto').textContent = producto.descripcion;
        document.getElementById('precioProducto').textContent = producto.precio;
        document.getElementById('cantidadDisponible').textContent = producto.cantidad_disponible;
        
        document.getElementById('detalleProducto').style.display = 'block';
    } else {
        document.getElementById('detalleProducto').style.display = 'none';
    }
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>