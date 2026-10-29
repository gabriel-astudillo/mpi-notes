# Enviar y recibir datos primitivos.

## Problema

Se quiere implementar un programa paralelo que encadene el envío y recepción de un mensaje, en nuestro caso el mensaje será el rango (identificador) del proceso que envía. Los mensajes se enviarán de forma encadenada, lo que quiere decir que el primero enviará un mensaje al segundo, el segundo recibirá uno del primero y enviará uno al tercero, y así sucesivamente para todos los procesos lanzados. Todo proceso que reciba un mensaje debe mostrarlo en pantalla de la forma "Soy el proceso $X$ y he recibido $M$", siendo $X$ el rango del proceso y $M$ el dato recibido.
