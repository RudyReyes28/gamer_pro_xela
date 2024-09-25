<?php
require_once '../../modelo/conexionesBD/ConexionCajero.php';
    class EnviarVenta{
       private $conectar;
        public function __construct() {
            $this->conectar = new ConexionCajero();
            
        }

        public function enviarVenta($id_empleado, $id_pedido, $carrito, $id_sucursal, $descuento, $nit, $consumidor)
    {


        $conexion = $this->conectar->getConexion();

        $query = "SELECT ventas.registrar_venta($1, $2)";
        $result = pg_query_params($conexion, $query, array($id_empleado, $id_pedido));
        $realizado = false;

        if ($result) {
            $idFactura = pg_fetch_result($result, 0, 0); 
            $productos = json_encode($carrito);  // Convertir el carrito en JSON
            $queryP = "SELECT ventas.registrar_detalle_venta($1, $2, $3,$4, $5, $6)";
            $resultP = pg_query_params($conexion, $queryP, array($idFactura, $productos, $id_sucursal, $descuento, $nit, $consumidor));
            $realizado = true;
            
        }else{
            $realizado = false;
        } 

        return $realizado;
    }

    public function enviarProductoV($id_empleado, $id_pedido, $carrito, $id_sucursal, $descuento, $nit, $consumidor){
        $conexion = $this->conectar->getConexion();
        $idFactura = 1; 
            $productos = json_encode($carrito);  // Convertir el carrito en JSON
            $queryP = "SELECT ventas.registrar_detalle_venta($1, $2, $3,$4, $5, $6)";
            $resultP = pg_query_params($conexion, $queryP, array($idFactura, $productos, $id_sucursal, $descuento, $nit, $consumidor));
    }

        

        public function cerrarConexion(){
            $this->conectar->cerrarConexion();
        }


    }

?>