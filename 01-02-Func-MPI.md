(funciones-MPI)=
# Funciones MPI

:::{note} `MPI_Init()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Init (int *argc, char[] *argv)
```

**Descripción**

Inicializa la estructura de comunicación de MPI entre los procesos. Ninguna función de comunicación MPI funcionará sin esta instrucción al inicio. Esta función inicializa todas las estructuras de datos necesarias para permitir la comunicación entre procesos basados en el envío de mensajes MPI. Reserva el canal de comunicación, asigna un valor a la constante `MPI_COMM_WORLD`. Esta función  debe ser invocada antes que cualquier otra función de MPI. Todos los programas MPI deben tener siempre una llamada a esta función. Los argumentos que recibe no son ni modificados, ni interpretados ni distribuidos.
De esta forma, un programa normal MPI debería quedar de la siguiente forma:

```{code} C
int main(int argc, char* argv[]){
    /* Declaracion de variables */
    MPI_Init(&argc, &argv);
    
    /**
     * Lógica de la solución paralela
     */
     
    MPI_Finalize();
}
```
:::

:::{note} `MPI_Finalize()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Finalize()
```

**Descripción**

Finaliza la comunicación paralela entre los procesos. Tras esto no se pueden enviar mensajes entre ellos.sin esta instrucción al inicio. Se debería elegir un único proceso para que continúe la ejecución del programa. MPI no asegura lo que hacen los threads tras el `MPI_Finalize` con lo que lo más seguro es encerrar el resto del código tras la ejecución con una condición que asegure que solo un proceso lo ejecute. Es altamente recomendable proteger la zona de código que sigue al MPI_Finalize. Una forma puede ser como sigue.

```{code} C
int main(int argc, char* argv[]){
    /* Declaracion de variables */
    MPI_Init(&argc, &argv);
    
    /**
     * Lógica de la solución paralela
     */
     
    MPI_Finalize();
    if(/*es proceso elegido*/){
        //Codigo que ejecuta el proceso elegido unicamente
    }
}
```
:::


(MPI_Send)=
:::{note} `MPI_Send()`
:class: dropdown
:open: false

**Descripción**

Realiza el envío de un mensaje de un proceso fuente a otro destino.

**Sintaxis**
```{code} C
int MPI_Send(void *buf,             // referencia al vector de elementos a enviar
             int count,             // tamaño del vector a enviar
             MPI_Datatype datatype, // tipo de dato que se envía
             int dest,              // rank del proceso destino
             int tag,               // etiqueta
             MPI_Comm comm          // ambiente paralelo por el que se manda
             );
```
:::

(MPI_Recv)=
:::{note} `MPI_Recv()`
:class: dropdown
:open: false

**Descripción**

Realiza la recepción de una mensaje desde otro proceso.

**Sintaxis**
```{code} C
int MPI_Recv(void *buf,             // referencia al vector de elementos a enviar
             int count,             // tamaño del vector a enviar
             MPI_Datatype datatype, // tipo de dato que se envía
             int source,            // rank del proceso origen
             int tag,               // etiqueta
             MPI_Comm comm,         // ambiente paralelo por el que se manda
             MPI_Status *status     // Objeto de tipo MPI_Status, contiene datos como:
                                    //   * origen (MPI_SOURCE), 
                                    //   * etiqueta (MPI_TAG),
                                    //   * tamaño (size).

             );
```
:::


(MPI_Wtime)=
:::{note} `MPI_Wtime()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Wtime();
```

**Descripción**

MPI_Wtime devuelve numero de segundos transcurridos desde el comienzo del proceso. Los tiempos son locales al nodo que los llama. No hay seguridad de que los diferentes nodos deban tener el mismo tiempo. Esta llamada es frecuentemente usada para tomar tiempos de duracion de un algoritmo.

```{code} C
double Inicio, Fin;
Inicio = MPI_Wtime();
/**
  *  Algoritmo a medir
  */
Fin = MPI_Wtime();
```
:::
