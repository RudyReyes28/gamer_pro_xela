<?php
    class ConexionEmpleado{
        private $conexion;

    public function __construct() {
        $host = "localhost";   // Cambia esto si es necesario
        $dbname = "gamer_pro_xela";
        $user = "postgres";
        $password = "1234";

        $this->conexion = pg_connect("host=$host dbname=$dbname user=$user password=$password");

        // Verificar si la conexión fue exitosa
        if (!$this->conexion) {
            die("Error de conexión: " . pg_last_error());
        }
    }

    public function getConexion() {
        return $this->conexion;
    }


    public function cerrarConexion() {
        pg_close($this->conexion);
    }
    }

?>