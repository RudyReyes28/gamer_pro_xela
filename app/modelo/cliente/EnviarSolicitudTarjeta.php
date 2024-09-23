<?php
require_once '../../modelo/conexionesBD/ConexionCliente.php';
class EnviarSolicitudTarjeta
{
    private $conectar;
    public function __construct()
    {
        $this->conectar = new ConexionCliente();
        
    }

    public function obtenerTarjetaCliente($nit)
    {

        $conexion = $this->conectar->getConexion();

        $query = "SELECT * FROM clientes.vista_tarjeta_cliente WHERE nit = $1";
        $result = pg_query_params($conexion, $query, array($nit));
        $cliente = pg_fetch_assoc($result);
        
        return $cliente;

    }

    public function obtenerTipoTarjeta(){
        $conexion = $this->conectar->getConexion();
        $queryTarjetas = "SELECT * FROM clientes.tipo_tarjeta";
        $tarjetasResult = pg_query($conexion, $queryTarjetas);
        $tarjetas = pg_fetch_all($tarjetasResult);

        return $tarjetas;
    }

    public function solicitarTarjeta($nit, $tipo){
        $conexion = $this->conectar->getConexion();
        $queryTarjetas = "INSERT INTO clientes.solicitud_tarjeta (id_tipo_tarjeta, nit_cliente) VALUES
                         ($1,$2)";
        
        $result = pg_query_params($conexion, $queryTarjetas, array($tipo,$nit));

        if ($result) {
            return true;  // La solicitud se completó con éxito
        } else {
            return false; // Hubo un error en la solicitud
        }

    }

    public function cerrarConexion()
    {
        $this->conectar->cerrarConexion();
    }
}
