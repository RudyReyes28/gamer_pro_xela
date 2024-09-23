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



const tablaCarrito = document.getElementById('tabla-carrito');
const botonPedido = document.getElementById('realizar-pedido');
const confirmarPedidoBtn = document.getElementById('confirmar-pedido');
let nuevoCarrito = [];
// Función para generar un nuevo arreglo con los productos actualizados
function generarNuevoCarrito() {
    const nuevoCarrito = [];

    // Recorrer todas las filas de la tabla
    document.querySelectorAll('#tabla-carrito tr').forEach(function(fila) {
        const idProducto = fila.querySelector('.cantidad-producto').getAttribute('data-id');
        const idSucursal = fila.querySelector('.cantidad-producto').getAttribute('data-sucursal');
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
                id_sucursal: idSucursal,
                nombre: nombre,
                precio: precio,
                cantidad: cantidad
            });
        }
    });

    return nuevoCarrito;
}

// Manejar el clic en "Realizar pedido"
botonPedido.addEventListener('click', function() {
     nuevoCarrito = generarNuevoCarrito();
     const pedidoModal = new bootstrap.Modal(document.getElementById('pedidoModal'));
        pedidoModal.show();

    
});

confirmarPedidoBtn.addEventListener('click', function() {
    let nit = document.getElementById('nit').value;
    const nombre = document.getElementById('nombre').value;
    const apellido = document.getElementById('apellido').value; 
    let consumidorFinal = false;

    if (nombre && apellido) {
        // Enviar los datos del pedido al servidor junto con NIT y nombre
        if(!nit){
            nit= '';
            consumidorFinal = true;
        }

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '../../controlador/cliente/realizarPedido.php';

        // Campo oculto para el carrito
        const carritoInput = document.createElement('input');
        carritoInput.type = 'hidden';
        carritoInput.name = 'carrito';
        carritoInput.value = JSON.stringify(nuevoCarrito); // Cambia aquí si usas el nuevo carrito
        form.appendChild(carritoInput);

        // Campo oculto para el NIT
        const nitInput = document.createElement('input');
        nitInput.type = 'hidden';
        nitInput.name = 'nit';
        nitInput.value = nit;
        form.appendChild(nitInput);

        // Campo oculto para el nombre
        const nombreInput = document.createElement('input');
        nombreInput.type = 'hidden';
        nombreInput.name = 'nombre';
        nombreInput.value = nombre;
        form.appendChild(nombreInput);

        // Campo oculto para el apellido
        const apellidoInput = document.createElement('input');
        apellidoInput.type = 'hidden';
        apellidoInput.name = 'apellido';
        apellidoInput.value = apellido;
        form.appendChild(apellidoInput);

        // Campo oculto para el CF
        const cf = document.createElement('input');
        cf.type = 'hidden';
        cf.name = 'consumidor_f';
        cf.value = consumidorFinal;
        form.appendChild(cf);

        // Añadir el formulario al documento y enviarlo
        document.body.appendChild(form);
        form.submit();
    } else {
        alert('Por favor, complete todos los campos.');
    }
});

document.getElementById('tipo-cliente').addEventListener('change', function() {
    const nitContainer = document.getElementById('nit-container');
    if (this.value === 'cf') {
        nitContainer.style.display = 'none';
    } else {
        nitContainer.style.display = 'block'; 
    }
});