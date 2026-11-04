# Enviar y recibir datos primitivos.


## Prueba de concepto

### Objetivo

Conocer y utilizar primitivas [](#MPI_Send) y [](#MPI_Recv) para envío y recepción de datos primitivos.

### Descripción

Este código es una prueba de conceptos del funcionamiento de las funciones de envío y recepción. Lo que hace es que cada proceso se envía a sí mismo el mensaje deseado.

```{code} C
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[]){
    int rank, dato;
    
    MPI_Status estado;

    // Inicialización del ambiente paralelo
    MPI_Init(&argc, &argv); 
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
 
    //Envia y recibe mensajes
    int dato_enviar = 1974;
    
    MPI_Send(&rank //referencia al vector de elementos a enviar
            ,1 // tamaño del vector a enviar
            ,MPI_INT // Tipo de dato que envias
            ,rank // pid del proceso destino
            ,0 //etiqueta
            ,MPI_COMM_WORLD); //Comunicador por el que se manda
 
    MPI_Recv(&dato // Referencia al vector donde se almacenara lo recibido
            ,1 // tamaño del vector a recibir
            ,MPI_INT // Tipo de dato que recibe
            ,rank // pid del proceso origen de la que se recibe
            ,0 // etiqueta
            ,MPI_COMM_WORLD // Comunicador por el que se recibe
            ,&estado); // estructura informativa del estado
 

    int origen = estado.MPI_SOURCE;
    printf("Proceso %d> dato recibido: %d desde el proceso %d\n", rank, dato_recibido, origen);
 
    MPI_Finalize();
    exit(EXIT_SUCCESS);
}
```

Los campos de una variable de tipo `MPI_Status` están explicado en la Sección [](#tipos-especificos)

Si se compila el código mostrado con `mpicc -o example example.cc` y se ejecuta con `mpirun -n 5 ./example`, se obtiene una salida como:

```
Proceso 4> dato recibido: 1974 desde el proceso 4
Proceso 3> dato recibido: 1974 desde el proceso 3
Proceso 2> dato recibido: 1974 desde el proceso 2
Proceso 1> dato recibido: 1974 desde el proceso 1
Proceso 0> dato recibido: 1974 desde el proceso 0
```

## Problema 1: Envío de datos en una topología de anillo

### Objetivo

Conocer y utilizar primitivas [](#MPI_Send) y [](#MPI_Recv) para envío y recepción de datos primitivos.

### Descripción

Se quiere implementar un programa paralelo que encadene el envío y recepción de un mensaje, en nuestro caso el mensaje será el rango (identificador) del proceso que envía. Los mensajes se enviarán de forma encadenada, siguiendo el siguiente esquema (ver {numref}`Figura %s <ejemplo-send-recv>`). El proceso $0$ enviará un mensaje al proceso $1$. Este proceso enviará su mensaje al proceso $3$ sólo cuando haya recibido el dato del proceso $0$ y así sucesivamente para todos los procesos lanzados. Todo proceso que reciba un mensaje debe mostrarlo en pantalla de la forma "Proceso $X$: dato recibido $M$.", siendo $X$ el rango del proceso y $M$ el dato recibido.

```{figure} images/02-01-ejemplo-send-recv.png
:label:ejemplo-send-recv
:width: 70%
:align: center
```

### Solución


```{code} C
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    int dato_enviado, dato_recibido;
    MPI_Status estado;
 
    // Inicialización del ambiente paralelo
    MPI_Init(&argc, &argv); 
    MPI_Comm_size(MPI_COMM_WORLD, &size); 
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
 
    if(rank == 0){
        dato_enviado = 2*(rank+1);
        MPI_Send(&dato_enviado    // referencia al vector de elementos a enviar
                ,1                // tamaño del vector a enviar
                ,MPI_INT          // Tipo de dato que envias
                ,rank+1           // id del proceso destino
                ,0                // etiqueta
                ,MPI_COMM_WORLD); // Comunicador por el que se manda
 
    }else{
        MPI_Recv(&dato_recibido // Referencia al vector donde se almacenará lo recibido
                ,1              // tamaño del vector a recibir
                ,MPI_INT        // Tipo de dato que recibe
                ,rank-1         // id del proceso origen de la que se recibe
                ,0              // etiqueta
                ,MPI_COMM_WORLD // Comunicador por el que se recibe
                ,&estado);      // estructura del estado de la recepción
 
        int origen = estado.MPI_SOURCE;
        printf("Proceso %d> dato recibido: %d desde el proceso %d\n", rank, dato_recibido, origen);
        dato_enviado = 2*(rank+1);
        
        if(rank != size-1){
            MPI_Send(&dato_enviado, 1 ,MPI_INT ,rank+1 , 0 ,MPI_COMM_WORLD);
        }
    }
 
    MPI_Finalize();
    exit(EXIT_SUCCESS);
}
```

Obtenido el numero de procesos (`size`) y el rango (`rank`), el envío del mensaje se realiza al proceso siguiente (`rank` aumentado en 1). Debido a esto, el proceso destino debe indicar que quiere recibir un mensaje del proceso inmediatamente anterior. En la solución propuesta se hace una distinción ya que no todos los procesos hacen lo mismo, el primero no recibirá de nadie y el último no envía ningún mensaje. Esto se especifica mediante condiciones que filtran el rango del proceso.

### Salida

```
$ mpicc example.cc -o example 
$ mpirun -n 10 ./example
Proceso 1> dato recibido: 2 desde el proceso 0
Proceso 2> dato recibido: 4 desde el proceso 1
Proceso 3> dato recibido: 6 desde el proceso 2
Proceso 4> dato recibido: 8 desde el proceso 3
Proceso 5> dato recibido: 10 desde el proceso 4
Proceso 6> dato recibido: 12 desde el proceso 5
Proceso 7> dato recibido: 14 desde el proceso 6
Proceso 8> dato recibido: 16 desde el proceso 7
Proceso 9> dato recibido: 18 desde el proceso 8
```


## Problema 2: Cálculo paralelo de $\pi$

### Objetivo

Conocer y utilizar primitivas [](#MPI_Bcast) y [](#MPI_Reduce) para repartir datos entre los procesos de un comunicador.

### Descripción

Paralelizar el cálculo de la aproximación del número $\pi$ indicando un factor de precisión. El numero PI se puede determinar resolviendo en forma numérica la  [Ecuación %s](#pi-eq). 

(pi-eq)=
```{math}
\int_0^1 \frac{4}{1+x^2} \,dx
```

### Solución

```{code} C
int main(int argc, char *argv[]) { 
    int n;    // Número de iteraciones
	int	rank; // Identificador de proceso
	int	size; // Numero de procesos

    double PI25DT = 3.141592653589793238462643;
    double mypi; // Valor local de PI
	double pi;   // Valor globarl de PI
	double h;    // Aproximacion del area para el calculo de PI
	double sum;  // Acumulador para la suma del area de PI
 
    MPI_Init(&argc, &argv); // Inicializamos los procesos
    MPI_Comm_size(MPI_COMM_WORLD, &size); // Obtenemos el numero total de procesos
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); // Obtenemos el valor de nuestro identificador
 
    // Solo el proceso 0 va a conocer el numero de iteraciones que vamos a
    // ejecutar para la aproximacion de PI
	if (rank == 0) {
        if(argc != 2){
            fprintf(stderr, "Uso: mpirun -n <nro_proc> %s <iteraciones>\n", argv[0]);
            MPI_Finalize(); 
            exit(EXIT_FAILURE);
        }
		
        n = atoi(argv[1]);

        if (n <= 0){
            MPI_Finalize();
            exit(EXIT_FAILURE);
	    }
	}
 
	// El proceso 0 reparte al resto de procesos el numero de iteraciones
	// que calcularemos para la aproximacion de PI
	MPI_Bcast(&n, // Puntero al dato que vamos a enviar
	            1,  // Numero de datos a los que apunta el puntero
                MPI_INT, // Tipo del dato a enviar
                0, // Identificacion del proceso que envia el dato
                MPI_COMM_WORLD);  
	
    // Calculo de PI
    h = 1.0 / (double) n;
    sum = 0.0;
    for (int i = rank + 1; i <= n; i += size) {
        double x = h * ((double)i - 0.5);
        sum += (4.0 / (1.0 + x*x));
    }
    mypi = h * sum;

    // Todos los procesos ahora comparten su valor local de PI,
    // lo hacen reduciendo su valor local a un proceso
    // seleccionada a traves de una operacion aritmetica.
    MPI_Reduce(&mypi, // Valor local de PI
                &pi,  // Dato sobre el que vamos a reducir el resto
                1,	  // Numero de datos que vamos a reducir
                MPI_DOUBLE,  // Tipo de dato que vamos a reducir
                MPI_SUM,  // Operacion que aplicaremos
                0, // proceso que va a recibir el dato reducido
                MPI_COMM_WORLD);   

    // Solo el proceso 0 muestra el mensaje, ya que es el único que
    // conoce el valor de PI aproximado.
    if (rank == 0)
        printf("Valor aprox de PI: %f, error: %f\n", pi, fabs(pi - PI25DT));
 
    MPI_Finalize(); 
    exit(EXIT_SUCCESS); 
}
```

### Salida

```
$ mpicc example.cc -o example 
$ mpirun -n 5 ./example 20
Valor aprox de PI: 3.141801, error: 0.000208
```