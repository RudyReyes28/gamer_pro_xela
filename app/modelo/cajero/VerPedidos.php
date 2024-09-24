<?php
require_once '../../modelo/conexionesBD/ConexionCajero.php';
    class VerPedidos{
       private $conectar;
        public function __construct() {
            $this->conectar = new ConexionCajero();
            
        }

        public function buscarPedidos($id_sucursal){
            
            
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT id_pedido, nit_cliente, nombre_cliente, consumidor_final, total, fecha_pedido 
	                    FROM ventas.pedido
                        WHERE id_sucursal = $1 AND estado= false";
        
            // Ejecutar la consulta
             $result = pg_query_params($conexion, $query, array($id_sucursal));
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $pedidos = pg_fetch_all($result);

            return $pedidos;
            
        }


        public function verProductos($id_pedido){
            
            
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT d.codigo_producto, pr.nombre, d.costo_u, d.cantidad FROM ventas.detalle_pedido d
	                JOIN productos.producto pr ON pr.codigo=d.codigo_producto 
	                WHERE
	                id_pedido = $1";
        
            // Ejecutar la consulta
             $result = pg_query_params($conexion, $query, array($id_pedido));
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $productos = pg_fetch_all($result);

            return $productos;
            
        }

        public function obtenerTarjetaCliente($nit) {

            $conexion = $this->conectar->getConexion();

            $query = "SELECT * FROM clientes.vista_tarjeta_cliente WHERE nit = $1";
            $result = pg_query_params($conexion, $query, array($nit));
            $cliente = pg_fetch_assoc($result);
        
            return $cliente;

        }

        public function cerrarConexion(){
            $this->conectar->cerrarConexion();
        }


    }

?>