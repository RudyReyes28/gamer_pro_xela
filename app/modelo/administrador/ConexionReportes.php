<?php
require_once '../../modelo/conexionesBD/ConexionEmpleado.php';
    class ConexionReportes{
       private $conectar;
        public function __construct() {
            $this->conectar = new ConexionEmpleado();
            
        }

        //Historial de descuentos realizados en un intervalo de tiempo.
        public function historialDescuentos($fechaI, $fechaF){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * 
                    FROM ventas.historial_descuentos
                    WHERE fecha_venta BETWEEN $1 AND $2";
        
            // Ejecutar la consulta
             $result = pg_query_params($conexion, $query, array($fechaI, $fechaF));
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $historial = pg_fetch_all($result);

            return $historial;
        }

        //Top 10 ventas más grandes en un intervalo de tiempo.
        public function topVentasMasGrandes($fechaI, $fechaF){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * 
                        FROM ventas.top_ventas
                        WHERE fecha_venta BETWEEN $1 AND $2
                        ORDER BY total DESC
                        LIMIT 10";
        
            // Ejecutar la consulta
            $result = pg_query_params($conexion, $query, array($fechaI, $fechaF));
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $ventas = pg_fetch_all($result);

            return $ventas;
        }

        //Top 2 sucursales que más dinero han ingresado.
        public function topSucursalesMasDinero(){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * 
                        FROM ventas.top_ingresos_sucursales
                            LIMIT 2";
        
            // Ejecutar la consulta
             $result = pg_query($conexion, $query);
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $sucursales = pg_fetch_all($result);

            return $sucursales;
        }


        // Top 10 artículos más vendidos
        public function topArticulosMasVendidos(){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * 
                    FROM ventas.top_articulos_mas_vendidos
                    LIMIT 10";
        
            // Ejecutar la consulta
             $result = pg_query($conexion, $query);
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $articulos = pg_fetch_all($result);

            return $articulos;
        }

        // Top 10 clientes que más dinero han gastado.
        public function topClientesMasGasto(){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * 
            FROM ventas.top_clientes_mas_dinero_gastado
            LIMIT 10";
        
            // Ejecutar la consulta
             $result = pg_query($conexion, $query);
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $clientes = pg_fetch_all($result);

            return $clientes;
        }


        //solicitudes tarjeta
        public function solicitudesTarjeta(){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT * FROM clientes.vista_solicitudes_tarjetas";
        
            // Ejecutar la consulta
             $result = pg_query($conexion, $query);
        
            // Verificar si la consulta fue exitosa
            if (!$result) {
                die("Error en la consulta: " . pg_last_error());
            }

            $clientes = pg_fetch_all($result);

            return $clientes;
        }

        //aceptar solicitud

        public function aceptarSolicitud($id_solicitud, $id_tipoTarjeta, $nit){
            $conexion = $this->conectar->getConexion();
        
            $query = "SELECT clientes.aceptar_solicitud_tarjeta($1, $2, $3)";
        
             //Ejecutar la consulta
             $result = pg_query_params($conexion, $query, array($id_solicitud, $id_tipoTarjeta, $nit));
        
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