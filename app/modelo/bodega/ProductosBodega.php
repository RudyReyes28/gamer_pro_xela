<?php
require_once '../../modelo/conexionesBD/ConexionBodega.php';
    class ProductosBodega{
       private $conectar;
        public function __construct() {
            $this->conectar = new ConexionBodega();
            
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
                sucursales.inventario_bodega ie ON p.codigo = ie.codigo_producto
                JOIN
	            sucursales.bodega e ON e.id_bodega = ie.id_bodega
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

        public function actualizarExistencia($idSucursal, $idProducto, $idCantidad){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT sucursales.actualizar_existencia_bodega($1, $2, $3);";
        
            // Ejecutar la consulta
             $result = pg_query_params($conexion, $query, array($idSucursal, $idProducto, $idCantidad));
        
            // Verificar si la consulta fue exitosa
            if ($result) {
                return true;
            }

            return false;

        }

        public function nuevoProducto($idProducto,$nombre,$descripcion,$costo, $idSucursal, $idCantidad){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT sucursales.agregar_producto_a_bodega($1, $2, $3,$4,$5,$6);";
        
            // Ejecutar la consulta
             $result = pg_query_params($conexion, $query, array($idProducto,$nombre,$descripcion,$costo, $idSucursal, $idCantidad));
        
            // Verificar si la consulta fue exitosa
            if ($result) {
                return true;
            }

            return false;

        }

        

        public function cerrarConexion(){
            $this->conectar->cerrarConexion();
        }


    }

?>