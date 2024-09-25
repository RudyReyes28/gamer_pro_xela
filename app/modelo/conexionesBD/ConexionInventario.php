<?php
    class ConexionInventario{
        private $conexion;

    public function __construct() {
        $host = "localhost";
        $dbname = "gamer_pro_xela";
        $user = "acceso_inventario";
        $password = "inventario";

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