(funciones-MPI)=
# Funciones MPI

(MPI_Init)=
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


(MPI_Comm_size)=
:::{note} `MPI_Comm_size()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Comm_size(MPI_Comm comm, // Comunicador sobre el que se quiere conocer el tamaño.
                  int *size      // Tamaño del comunicador. (Salida)
                  )
```

**Descripción**

Esta función devuelve el tamaño del comunicador seleccionado. Su uso es muy común en los programas basados en MPI. La {numref}`Figura %s <comm-size>` muestra dos comunicadores, el comunicador global, en el que siempre se encuentran todos los procesos (`MPI_COMM_WORLD`) y un comunicador creado manualmente (`comm1`) en el que sólo tenemos cuatro de los procesos. Vemos que en total son ocho procesos (desde P0 hasta P7). Si se pide el tamaño del comunicador global, MPI entregará el valor de ocho procesos, para el otro comunicador, MPI entregará un valor 4.

```{figure} images/02-01-comm-size.png
:label:comm-size
:width: 50%
:align: center

```

```{code} C
int main(int argc, char* argv[]){
    /* Declaracion de variables */
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size); // Se obtiene el tamaño del comunicador
    
    /**
     * Lógica de la solución paralela
     */
     
    MPI_Finalize();
}
```
:::

(MPI_Comm_rank)=
:::{note} `MPI_Comm_rank()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Comm_rank(MPI_Comm comm, // Comunicador sobre el que se quiere conocer el identificador.
                  int *rank      // Entero que indica el rango del proceso.
                  )
```

**Descripción**

Esta función devuelve el rango del proceso que lo llama en el grupo de comunicación. La {numref}`Figura %s <comm-rank>` muestra que cada proceso tiene un identificador diferente según el comunicador en el que se encuentre. En el global (`MPI_COMM_WORLD`) sus rangos serían 0 para P0, 1 para P1, etc. En el comunicador `comm1`, sus rangos son diferentes, siendo 0 para P2, 1 para P3, 2 para P6 y 3 para P7.

```{figure} images/02-01-comm-rank.png
:label:comm-rank
:width: 80%
:align: center

```

```{code} C
int main(int argc, char* argv[]){
    /* Declaracion de variables */
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size); // Se obtiene el tamaño del comunicador
    
    /**
     * Lógica de la solución paralela
     */
     
    MPI_Finalize();
}
```
:::


(MPI_Finalize)=
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

(MPI_Bcast)=
:::{note} `MPI_Bcast()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Bcast(void *buffer,           // Dirección inicial del buffer (a enviar para la raíz y a recibir por el resto).
              int count,              // Número de elementos en el buffer (int).
              MPI_Datatype datatype,  // Tipo de dato de los elementos del buffer (Por ejemplo, `MPI_INT`).
			  int root,               // Rank del proceso que transmitirá el mensaje al resto (int).
              MPI_Comm comm           // Comunicador por el que se realiza la transmisión.
              )
```

**Descripción**

MPI_Bcast envía un único mensaje desde el proceso que tenga el rango de raíz (root) a todos los procesos del grupo (en general, los del comunicador especificado), incluyendose a sí mismo. Todos los procesos llaman a la función exactamente de la misma manera, usando siempre los mismos argumentos para comm (el comunicador) y para el proceso raíz (root). Cuando se haya completado la función, todos los procesos tendrán una copia en su buffer de entrada de lo enviado por el proceso raíz.

En general los tipos de datos derivados están permitidos para el parámetro datatype. La concordancia en tamaño entre los tipos de datos especificados por los procesos receptores y del emisor debe ser igual. Esto implica que la cantidad de datos enviados debe ser la misma cantidad que los datos recibidos entre cada proceso con la raíz (root). Todas las rutinas de envío y recepción de datos a colectivos (o entre colectivos) tienen esta restricción impuesta.
:::

(MPI_Reduce)=
:::{note} `MPI_Reduce()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Reduce(void *sendbuf,         // Dirección inicial del buffer en envío.
               void *recvbuf,         // Dirección inicial del buffer de recepción, 
                                      // útil únicamente para el proceso raíz.
               int count,             // Número de elementos que se va a enviar del 
                                      // buffer de envío (int).
               MPI_Datatype datatype, // Tipo de datos de los elementos del buffer de 
                                      // envío (por ejemplo MPI_INT).
               MPI_Op op,             // Operación de reducción, constante definida 
                                      // por MPI.
               int root,              // Rango del proceso raíz, el proceso receptor.
               MPI_Comm comm          // Comunicador que se utiliza.
               )
```

**Descripción**

Reduce un valor de un grupo de procesos en un único proceso raíz. La operación de reducción están definidas en [acá](#funciones-reduccion).
:::

(MPI_Allreduce)=
:::{note} `MPI_Allreduce()`
:class: dropdown
:open: false

**Sintaxis**
```{code} C
int MPI_Allreduce(void *sendbuf,          // Dirección inicial del buffer en envío.
                  void *recvbuf,          // Dirección inicial del buffer de recepción.
                  int count,              // Número de elementos que se va a enviar del 
                                          // buffer de envío.
                  MPI_Datatype datatype,  // Tipo de datos de los elementos del buffer de 
                                          // envío (por ejemplo `MPI_INT`).
                  MPI_Op op,              // Operación de reducción, constante definida 
                                          // por MPI
                  MPI_Comm comm           // Comunicador que se utiliza.
                  )
```

**Descripción**

Similar a [](#MPI_Reduce). El resultado se redistribuye entre todos los procesos. La operación de reducción están definidas en [acá](#funciones-reduccion).
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
