1. Ten en cuenta que dicho método devuelve un parámetro Any que puede contener tanto un Array de Dictionary como un Dictionary. Mira en la ayuda en método t  e(of:) y como usarlo para saber qué te han devuelto exactamente. ¿En qué otros modos podemos trabajar? ¿is, as?

Con "is" podríamos comprobar su tipo y con "as" hacer un cast

2. Haz lo mismo para las imágenes de portada y los pdfs. ¿Donde guardarías estos datos? 

Esos datos irían a la carpeta Documents del bundle de la App

3. ¿Cómo harías eso? ¿Se te ocurre más de una forma de hacerlo? Explica la decisión de diseño que hayas tomado.

Se ha decidido optar por utilizar UserDefaults para almacenar un array de libros favoritos. Se podría hacer con otros métodos de persistencia como Realm o Core Data

4. ¿Cómo lo harías? Es decir, ¿cómo enviarías información de un Book a un LibraryViewController? ¿Se te ocurre más de una forma de hacerlo? ¿Cual te parece mejor? Explica tu elección.

Se me ocurre hacerlo de dos formas: mediante un delegado (se ha descartado para no crear una cadena de delegados) o mediante una notificación, que es la decisión de implementación para la práctica. Así se evita la cadena.

5. Nota: para que la tabla se actualice, usa el método reloadData de UITableView. Esto hace que la tabla vuelva a pedir datos a su dataSource. ¿Es esto una aberración desde el punto de rendimiento (volver a cargar datos que en su mayoría ya estaban correctos)? Explica por qué no es así. ¿Hay una forma alternativa? ¿Cuando crees que vale la pena usarlo?

No, la tabla va a cargar los valores a representar reutilizando celdas en la medida de lo posible. Un método alternativo sería cambiar el dataSource de la tabla, pero es realmente lo que hace el reloadData.

6. Cuando el usuario cambia en la tabla el libro seleccionado, el PDFViewController debe de actualizarse. ¿Cómo lo harías?

Se ha implementado mediante una notificación

7. Extras

a ¿Qué funcionalidades le añadirías antes de subirla a la App Store?

Se podría almacenar la página por la que se va leyende un libro para retomar a partir de ahí
Posibilidad de añadir alguna anotación en una página determinada

b Ponle otro nombre e intenta subir esta primera versión a la App
Store. Como aun no tienes idea de diseño, aquí tienes plantillas gratis
y de pago

No está subida

c Usando esta App como "plantilla", ¿qué otras versiones se te
ocurren? ¿Algo que puedas monetizar?

Aplicaciones para mantener cualquier tipo de colección: tebeos, monedas, discos...
La monetización se podría hacer mediante publicidad o desbloqueando características premium