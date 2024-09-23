<?php
require_once '../../modelo/conexionesBD/ConexionCliente.php';
class EnviarPedido
{
    private $conectar;
    public function __construct()
    {
        $this->conectar = new ConexionCliente();
    }

    public function enviarPedido($nit, $cf, $nombre, $apellido, $sucursal, $carrito)
    {


        $conexion = $this->conectar->getConexion();

        $query = "SELECT ventas.registrar_pedido($1, $2, $3, $4, $5)";
        $result = pg_query_params($conexion, $query, array($sucursal, $nit, $nombre, $cf, $apellido));
        $realizado = false;

        if ($result) {
            $idPedido = pg_fetch_result($result, 0, 0); // Obtener el ID del pedido registrado
            //echo "Pedido registrado con éxito. ID del pedido: " . $idPedido;
            $productos = json_encode($carrito);  // Convertir el carrito en JSON
            $queryP = "SELECT ventas.registrar_detalle_pedido($1, $2)";
            $resultP = pg_query_params($conexion, $queryP, array($idPedido, $productos));
            $realizado = true;
            
        }else{
            $realizado = false;
        } 

        return $realizado;
    }

    public function cerrarConexion()
    {
        $this->conectar->cerrarConexion();
    }
}
