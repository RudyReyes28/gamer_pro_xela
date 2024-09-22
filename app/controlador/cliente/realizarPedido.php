<?php
   if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtener el JSON del carrito
    $carritoJson = $_POST['carrito'];
    
    // Decodificar el JSON en un arreglo asociativo
    $carrito = json_decode($carritoJson, true);

    // Verificar si la decodificación fue exitosa
    if ($carrito !== null) {
        // Procesar cada producto en el carrito
        foreach ($carrito as $producto) {
            $idProducto = $producto['id_producto'];
            $sucursal = $producto['id_sucursal'];
            $precio = $producto['precio'];
            $cantidad = $producto['cantidad'];
            $nombre = $producto['nombre'];

            // Aquí puedes hacer lo que necesites con los datos, como guardarlos en la base de datos
            // Por ejemplo:
            echo "Producto: $nombre, Precio: $precio, Cantidad: $cantidad<br>";
        }
    } else {
        echo "Error al decodificar el JSON.";
    }

    // También puedes acceder al NIT y nombre
    $nit = $_POST['nit'];
    $nombreCliente = $_POST['nombre'];
    $cf = $_POST['consumidor_f'];

    echo "NIT: $nit, Nombre: $nombreCliente, ConsumidorFinal: $cf";
}

?>