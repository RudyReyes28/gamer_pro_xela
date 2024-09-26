document.querySelectorAll('.cantidad-producto').forEach(function(input) {
    input.addEventListener('input', function() {
        const maxCantidad = parseInt(this.getAttribute('data-max'));
        const cantidadActual = parseInt(this.value);

        // Evitar que la cantidad supere la existencia
        if (cantidadActual > maxCantidad) {
            this.value = maxCantidad; // Limitar al máximo permitido
            alert('La cantidad no puede superar la existencia.');
        }
        
    });
});

document.querySelectorAll('.quitar-producto').forEach(function(boton) {
    boton.addEventListener('click', function() {
        const idProducto = this.getAttribute('data-id');


        this.closest('tr').remove();
    });
});


let puntosACanjear=0;
const tablaCarrito = document.getElementById('tabla-carrito');
const botonPedido = document.getElementById('realizar-pedido');
//const confirmarPedidoBtn = document.getElementById('confirmar-pedido');
let nuevoCarrito = [];
// Función para generar un nuevo arreglo con los productos actualizados
function generarNuevoCarrito() {
    const nuevoCarrito = [];
    let totalCompra = 0;
    let totalDescuento=0;

    // Recorrer todas las filas de la tabla
    document.querySelectorAll('#tabla-carrito tr').forEach(function(fila) {
        const idProducto = fila.querySelector('.cantidad-producto').getAttribute('data-id');
        const nombre = fila.querySelector('td:first-child').textContent;
        const precio = parseFloat(fila.querySelector('td:nth-child(2)').textContent);
        const cantidad = parseInt(fila.querySelector('.cantidad-producto').value);
        const maxCantidad = parseInt(fila.querySelector('.cantidad-producto').getAttribute('data-max'));

        // Validar que la cantidad no exceda la existencia
        if (cantidad > maxCantidad) {
            alert(`La cantidad para el producto ${nombre} no puede exceder ${maxCantidad}`);
        } else {
            // Añadir el producto actualizado al nuevo carrito
            nuevoCarrito.push({
                id_producto: idProducto,
                nombre: nombre,
                precio: precio,
                cantidad: cantidad
            });
        }
        totalCompra += precio * cantidad;

    });
    console.log(totalDescuento);
    totalDescuento = totalCompra-puntosACanjear;
    document.getElementById('total-compra').textContent = totalCompra.toFixed(2);
    document.getElementById('total-descuento').textContent = totalDescuento.toFixed(2);
    return nuevoCarrito;
}

    const canjearPuntosBtn = document.querySelector('.agregar-puntos');
   
    let canjearPuntos = false;  // Booleano para saber si canjear puntos
    
    if (canjearPuntosBtn) {  // Verificar si el botón existe en el DOM
        canjearPuntosBtn.addEventListener('click', function() {
            const inputPuntos = document.querySelector('.cantidad-puntos');
            puntosACanjear = parseInt(inputPuntos.value, 10);
            console.log(puntosACanjear);
            canjearPuntos = true;
        });
    }

// Manejar el clic en "Realizar pedido"
botonPedido.addEventListener('click', function() {
    nuevoCarrito = generarNuevoCarrito();
    
    if (nuevoCarrito.length === 0) {
        alert('El carrito está vacío, por favor agrega productos.');

        window.location.href = 'vistaCajero.php';
    } else{

    

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '../../controlador/cajero/realizarEnvio.php';

        // Campo oculto para el carrito
        const carritoInput = document.createElement('input');
        carritoInput.type = 'hidden';
        carritoInput.name = 'carrito';
        carritoInput.value = JSON.stringify(nuevoCarrito);
        form.appendChild(carritoInput);

        // Campo oculto para el NIT
        const nitInput = document.createElement('input');
        nitInput.type = 'hidden';
        nitInput.name = 'nit';
        nitInput.value = nit;
        form.appendChild(nitInput);

        // Campo oculto para el pedido
        const pedidoInput = document.createElement('input');
        pedidoInput.type = 'hidden';
        pedidoInput.name = 'id_pedido';
        pedidoInput.value = idPedido;
        form.appendChild(pedidoInput);


        // Campo oculto para el CF
        const cf = document.createElement('input');
        cf.type = 'hidden';
        cf.name = 'consumidor_f';
        cf.value = consumidorFinal;
        form.appendChild(cf);

        
        //campo oculto para canjear tarjeta
        const canjearTarInput = document.createElement('input');
        canjearTarInput.type = 'hidden';
        canjearTarInput.name = 'canjear_tarjeta';
        canjearTarInput.value = canjearPuntos;
        form.appendChild(canjearTarInput);

        //campo oculto para los puntos
        const puntosInput = document.createElement('input');
        puntosInput.type = 'hidden';
        puntosInput.name = 'puntos_tarjeta';
        puntosInput.value = puntosACanjear;
        form.appendChild(puntosInput);

        // Añadir el formulario al documento y enviarlo
        document.body.appendChild(form);
        form.submit();
    
    }
    
});

// Escuchar cambios en la cantidad de productos y actualizar el total
document.querySelectorAll('.cantidad-producto').forEach(function(input) {
    input.addEventListener('input', generarNuevoCarrito);
});