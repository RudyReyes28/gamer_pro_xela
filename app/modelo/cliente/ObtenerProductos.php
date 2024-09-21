<?php
require_once '../../modelo/conexionesBD/ConexionCliente.php';
    class ObtenerProductos{
       private $conectar;
        public function __construct() {
            $this->conectar = new ConexionCliente();
            
        }

        public function buscarProductos($idSucursal){
            
            
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT 
                p.codigo, 
                p.nombre, 
                p.descripcion, 
                p.precio,
	            ie.cantidad_disponible
                FROM 
                productos.producto p
                JOIN 
                sucursales.inventario_estanteria ie ON p.codigo = ie.codigo_producto
                JOIN
	            sucursales.estanteria e ON e.id_estanteria = ie.id_estanteria
                WHERE 
                e.id_sucursal = $idSucursal";
        
            // Ejecutar la consulta
             $result = pg_query($conexion, $query);
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $productos = pg_fetch_all($result);

            return $productos;



            
        }

        public function cerrarConexion(){
            $this->conectar->cerrarConexion();
        }


    }

?>