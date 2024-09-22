// Función para ordenar productos
function ordenarProductosPorPrecio(ascendente = true) {
    let productos = Array.from(document.querySelectorAll('.col-md-4')); // Obtener todas las columnas

    productos.sort(function(a, b) {
        let precioA = parseFloat(a.querySelector('.ordenarPrecio').textContent.replace('Precio: ', ''));
        let precioB = parseFloat(b.querySelector('.ordenarPrecio').textContent.replace('Precio: ', ''));

        return ascendente ? precioA - precioB : precioB - precioA;
    });

    const contenedor = document.querySelector('.row');
    productos.forEach(function(producto) {
        contenedor.appendChild(producto); 
    });
}

document.getElementById('ordenarAsc').addEventListener('click', function() {
    ordenarProductosPorPrecio(true); // Ordenar ascendente
});

document.getElementById('ordenarDesc').addEventListener('click', function() {
    ordenarProductosPorPrecio(false); // Ordenar descendente
});

document.getElementById('buscar').addEventListener('keyup', function() {
    const searchValue = this.value.toLowerCase();
    const productos = document.querySelectorAll('.col-md-4'); 

    let productosVisibles = [];

    productos.forEach(function(producto) {
        const nombre = producto.querySelector('.card-title').textContent.toLowerCase();
        if (nombre.includes(searchValue)) {
            producto.style.display = ''; 
            productosVisibles.push(producto); 
        } else {
            producto.style.display = 'none'; 
        }
    });

    const contenedor = document.querySelector('.row');
    productosVisibles.forEach(function(producto) {
        contenedor.appendChild(producto); 
    });
});