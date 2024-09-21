<?php
    // Parámetros de conexión
$host = "localhost";   // Cambia esto si es necesario
$dbname = "gamer_pro_xela";
$user = "postgres";
$password = "1234";

// Crear la conexión
$conn = pg_connect("host=$host dbname=$dbname user=$user password=$password");

// Verificar si la conexión fue exitosa
if (!$conn) {
    die("Error de conexión: " . pg_last_error());
}

$query = "SELECT * FROM sucursales.sucursal";

// Ejecutar la consulta
$result = pg_query($conn, $query);

// Verificar si la consulta fue exitosa
if (!$result) {
    die("Error en la consulta: " . pg_last_error());
}

echo "<table border='1'>
        <tr>
            <th>ID Sucursal</th>
            <th>Nombre</th>
            <th>Dirección</th>
        </tr>";

// Recorrer los resultados y mostrarlos
while ($row = pg_fetch_assoc($result)) {
    echo "<tr>";
    echo "<td>" . $row['id_sucursal'] . "</td>";
    echo "<td>" . $row['nombre'] . "</td>";
    echo "<td>" . $row['direccion'] . "</td>";
    echo "</tr>";
}

echo "</table>";

// Liberar resultados
pg_free_result($result);

// Cerrar la conexión
pg_close($conn);

?>