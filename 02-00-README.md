# Método general de construcción de un programa basado en MPI.

## Problema

Implementar un programa que muestre en pantalla un texto "Hola Mundo. Proceso id=$X$. Total procesos=$Y$". Según la estructura de MPI:
* $X$ debe ser el identificador del proceso (`rank`).
* $Y$ es la cantidad de procesos que fueron creados en forma paralela.

## Paso 1

Lo primero es pensar en una solución completamente secuencial. Se crean dos variables `rank`y `size` para guardar el identificador del proceso y el total de procesos que existen en el ambiente paralelo, respectivamente.

```{code} C
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]){
    int rank, size;

    rank = 0;
    size = 0;

    printf("Hola Mundo. Proceso id=%d. Total=%d\n", rank, size);

    exit(EXIT_SUCCESS);
}
```

Una vez escrito, se debe compilar con `cc` y ejecutarlo para comprobar su funcionamiento:

```
$ cc ejemplo.cc -o ejemplo
$ ./ejemplo
Hola Mundo. Proceso id=0. Total=0
$
```

## Paso 2

Se debe incluir la biblioteca **MPI**:

```{code} C
#include <mpi.h>
```

En la función `main()`, se debe indicar que se va a crear un ambiente paralelo de trabajo. Para esto, se debe utilizar la función `MPI_Init()`. El ambiente de trabajo paralelo creado por esta función, queda visible a través de la variable `MPI_COMM_WORLD`.

```{code} C
MPI_Init(&argc, &argv);
```

:::{note} `MPI_Init()`
:class: dropdown
:open: false

La función `MPI_Init()` utiliza los argumentos del proceso para inicializar el ambiente paralelo. Este tiene sentido ya que la cantidad de procesos y su configuración son pasados a través de `argv` en el programa compilado.
:::

Luego, se le debe indicar a MPI que modifique en forma adecuada las variables `rank` y `size`. El valor de variables las determina a través de las variables de estado del ambiente paralelo cuyo descriptor es `MPI_COMM_WORLD`:

```{code} C
MPI_Comm_rank(MPI_COMM_WORLD, &rank);
MPI_Comm_size(MPI_COMM_WORLD, &size);
```

## Paso 3

Finalemente, el código paralelo final es el siguiente:

```{code} C
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char* argv[]){
    int rank, size;

    MPI_Init(&argc, &argv);
    
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("Hola Mundo. Proceso id=%d. Total=%d\n", rank, size);

    MPI_Finalize();

    exit(EXIT_SUCCESS);
}
```

## Paso 4

Después de compilar con `mpicc`, el ejecutable se debe llamar a través de `mpirun`. Por ejemplo, si se quiere ejecutar el código en 5 procesos:

```
$ mpirun -n 5 ./example
Hola Mundo. Proceso id=0. Total=5
Hola Mundo. Proceso id=1. Total=5
Hola Mundo. Proceso id=2. Total=5
Hola Mundo. Proceso id=3. Total=5
Hola Mundo. Proceso id=4. Total=5
$
```

Se debe tener en consideración que el orden de ejecución de los procesos no es determinista.