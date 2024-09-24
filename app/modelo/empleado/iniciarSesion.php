<?php
require_once '../../modelo/conexionesBD/ConexionEmpleado.php';
class IniciarSesion
{
    private $conectar;
    public function __construct()
    {
        $this->conectar = new ConexionEmpleado();
    }

    public function buscarEmpleado($usuario)
    {


        $conexion = $this->conectar->getConexion();

        // Cambia la consulta para solo obtener el hash almacenado
        $query = "SELECT id_empleado, nombre, id_sucursal, tipo_empleado, numero_caja, contrasenia 
              FROM empleados.empleado 
              WHERE usuario = $1";

        // Ejecutar la consulta
        $result = pg_query_params($conexion, $query, array($usuario));

        // Verificar si la consulta fue exitosa
        if (!$result) {
            die("Error en la consulta: " . pg_last_error());
        }

        $empleado = pg_fetch_assoc($result);

        return $empleado;
    }

    public function cerrarConexion()
    {
        $this->conectar->cerrarConexion();
    }
}
