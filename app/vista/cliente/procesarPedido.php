<?php
// Verificar si el formulario fue enviado y si existe el campo 'carrito'
if (isset($_POST['carrito'])) {
    // Recibir el JSON enviado a través del campo 'carrito'
    $carritoJson = $_POST['carrito'];
    
    // Decodificar el JSON a un arreglo de PHP
    $carrito = json_decode($carritoJson, true);
    
    // Verificar si la decodificación fue exitosa
    if ($carrito !== null) {
        // Ahora puedes acceder a los productos en el carrito y procesarlos
        foreach ($carrito as $producto) {
            $idProducto = $producto['idProducto'];
            $sucursal = $producto['sucursal'];
            $precio = $producto['precio'];

            // Aquí puedes agregar lógica para procesar cada producto (e.g., guardarlo en la base de datos)
            echo "Producto ID: " . $idProducto . "<br>";
            echo "Sucursal: " . $sucursal . "<br>";
            echo "Precio: " . $precio . "<br>";
        }
    } else {
        echo "Error al decodificar el JSON del carrito.";
    }
} else {
    echo "No se recibió ningún carrito.";
}
?>