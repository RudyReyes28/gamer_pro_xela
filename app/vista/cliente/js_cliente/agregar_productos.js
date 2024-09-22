let cartCount = 0;
let carrito = [];

document.querySelectorAll('.agregar-producto').forEach(button => {
    button.addEventListener('click', function () {
        const idProducto = this.getAttribute('data-id');
        const sucursal = this.getAttribute('data-sucursal');
        const precio = this.getAttribute('data-precio');
        const existencia = this.getAttribute('data-existencia');
        const nombre = this.getAttribute('data-nombre');
        cartCount++;
        document.getElementById('cart-count').textContent = cartCount;


        // Agregar producto al carrito
        carrito.push({
            id_producto: idProducto,
            id_sucursal: sucursal,
            nombre:nombre,
            precio: precio,
            existencia: existencia,
            cantidad: 1
        });

        this.disabled = true;
        this.textContent = 'Producto agregado';

    });
});

document.getElementById('finalizar-compra').addEventListener('click', function () {

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '../cliente/procesarPedido.php';


    const carritoInput = document.createElement('input');
    carritoInput.type = 'hidden';
    carritoInput.name = 'carrito';
    carritoInput.value = JSON.stringify(carrito);
    form.appendChild(carritoInput);

    document.body.appendChild(form);
    form.submit();
});