<?php
require_once '../../modelo/conexionesBD/ConexionCliente.php';
    class EncontrarSucursales{
       private $conectar;
        public function __construct() {
            $this->conectar = new ConexionCliente();
            
        }

        public function buscarSucursales(){
            
            
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * FROM sucursales.sucursal";
        
            // Ejecutar la consulta
             $result = pg_query($conexion, $query);
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $sucursales = pg_fetch_all($result);

            return $sucursales;



            
        }

        public function cerrarConexion(){
            $this->conectar->cerrarConexion();
        }


    }

?>