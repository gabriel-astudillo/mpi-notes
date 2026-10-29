# Qué es MPI

## Descripción

{abbr}`MPI (Message Passing Interface)` es un estándar abierto y portátil de biblioteca para programación paralela basado en el modelo de paso de mensajes. Está diseñado para permitir que múltiples procesos independientes se comuniquen y sincronicen entre sí intercambiando datos, principalmente en arquitecturas de memoria distribuida (clusters y supercomputadores), aunque también opera sobre sistemas multinúcleo de memoria compartida. Como modelo de ejecución utiliza el paradigma {abbr}`SPMD (Single Program, Multiple Data)`, donde cada proceso corre en su propio espacio de memoria privado y se identifica mediante un rango único (rank).

Para realizar el envío y recepción de datos, utiliza los siguientes tipos de comunicación:

* Punto a punto: Transferencias directas emisor-receptor mediante operaciones bloqueantes y no bloqueantes (ej. `MPI_Send`, `MPI_Recv`, `MPI_Isend`).

* Colectivas: Operaciones globales entre grupos de procesos, tales como difusión (`MPI_Bcast`), reducción (`MPI_Reduce`) o distribución/recolección de datos (`MPI_Scatter` y `MPI_Gather`).

## Estructura de una solución basada en MPI

Un programa {abbr}`MPI (Message Passing Interface)` crea un ambiente paralelo llamado `MPI_COMM_WORLD`. La cantidad de procesos que se van a crear dentro de este ambiente es un parámetro del comando `mpirun` ([explicado acá](#ejecucion)).

(implementacion)=
## Implementación de programas basados en MPI

### Estructura genérica

La estructura básica de un programa MPI es la siguiente:

```{code} c
#include <mpi.h>

int main(int argc, char** argv) {
  int rank, size;

  // Inicializar el entorno MPI
  MPI_Init(&argc, &argv);

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  /*
   *  Lógica de la solución paralela
   */

  MPI_Finalize();


  exit(EXIT_SUCCESS);
}
```

### Compilación

La compilación se realiza a través del wrapper estándar de MPI llamado `mpicc`. Se usa de la misma que un compilador tradicional de c:

```{code} shell
$ mpicc codigo_fuente -o nombre_ejecutable
```

:::{note} Qué es un "wrapper"
:class: dropdown
:open: false

Un wrapper es una capa de software (función, clase, script o programa ejecutable) que encapsula otra entidad subyacente para adaptar su interfaz, simplificar su uso, añadir funcionalidad o controlar cómo se invoca, sin alterar la implementación original. Actúa como intermediario: el cliente interactúa con el wrapper, y este traduce o delega la petición al componente interno.
:::

(ejecucion)=
### Ejecución paralela

Para ejecutarlo en un ambiente paralelo del tipo {abbr}`SPMD (Single Program, Multiple Data)`, se debe utilizar el programa `mpirun`. Por ejemplo, si se quiere ejecutar con 8 procesos un programa compilado con MPI, se debe escribir la siguiente orden en la línea de comandos:

```{code} shell
$ mpirun -n 8 ./nombre_ejecutable
```


