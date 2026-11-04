# Etiquetas MPI

Las etiquetas de constantes se definen para especificar a las funciones de MPI el tipo de dato que va a enviar o recibir.

(constantes)=
## Constantes

```{csv-table}
:header: Etiqueta, Descripción
`MPI_ANY_SOURCE`,"En funciones de recepción de mensaje indica que el mensaje a recibir puede proceder de cualquier proceso."
`MPI_ANY_TAG`,"En funciones de recepción de mensaje indica que el mensaje a recibir puede ser tener cualquier etiqueta."
`MPI_COMM_WORLD`,"Identificador del comunicador al que pertenecen todos los procesos de una ejecución MPI."
`MPI_ERROR`,"Representa cualquier error de MPI."
```

(tipos-especificos)=
## Tipos de datos específicos

```{csv-table}
:header: Tipos de dato MPI, Descripción
MPI_Status,"Guarda datos sobre operaciones de recepción de mensajes. Este tipo de dato guarda una estructura interna con los siguientes campos:"
, `MPI_SOURCE`: Indica el rango del proceso origen en el comunicador en el que se realizó la transmisión.
, `MPI_TAG`: Valor de la etiqueta que tenía el mensaje.
, `size`: Número de elementos del tipo de dato especificado en el mensaje.
, `count`: Tamaño del mensaje en bytes.
```

(tipos-mpi)=
## Tipos de datos en MPI para envío y recepción de mensajes

Se utilizan para especificar el tipo de dato de cada elemento que participa en la operación de envío o recepción (como `MPI_Send` o `MPI_Recv`).

```{csv-table}
:header: Tipo de Dato MPI,Descripción
:enumerated: false
`MPI_INT`,Tipo de dato int.
`MPI_CHAR`,Tipo de dato char.
`MPI_BYTE`,Tipo de dato byte.
`MPI_LONG`,Tipo de dato long.
`MPI_FLOAT`,Tipo de dato float.
`MPI_DOUBLE`,Tipo de dato double.
`MPI_UNSIGNED_CHAR`,"Tipo de dato unsigned char, equivalente a byte."
`MPI_UNSIGNED_SHORT`,Tipo de dato unsigned short.
`MPI_UNSIGNED`,Tipo de dato unsigned int.
`MPI_UNSIGNED_LONG`,Tipo de dato unsigned long.
`MPI_LONG_DOUBLE`,"Tipo de dato long double, algunos sistemas no son capaces de implementar este tipo."
`MPI_FLOAT_INT`,"Tipo de dato struct{ float, int }"
`MPI_LONG_INT`,"Tipo de dato struct{ long, int }"
`MPI_DOUBLE_INT`,"Tipo de dato struct{ double, int }"
`MPI_SHORT_INT`,"Tipo de dato struct{ short, int }"
`MPI_2INT`,"Tipo de dato struct{ int, int }"
`MPI_LONG_DOUBLE_INT`,"Tipo de dato struct{ long double, int }. Este tipo es opcional y puede tener valor nulo."
`MPI_PACKED`,Para las funciones MPI_Pack y MPI_Unpack
`MPI_UB`,"Para el tipo de dato MPI_Type_struct, un indicador del límite superior."
`MPI_LB`,"Para el tipo de dato MPI_Type_struct, un indicador del límite inferior."
```
(funciones-reduccion)=
## Funciones de reducción

Las funciones de reducción (tales como [](#MPI_Reduce), [](#MPI_Allreduce)) realizan una operación de reducción global (como puede ser calcular el máximo, la suma, hacer un AND lógico, etc) sobre cada uno de los miembros del grupo. La operación de reducción puede ser tanto una predefinida de la lista de operaciones como una operación definida por el usuario.

Se puede notar que únicamente se especifica una vez el número de datos y el tipo de datos, esto es porque el número de datos es el mismo tanto en la emisión como en la recepción, al igual que el tipo. Si el número de datos es mayor que uno, la operación de reducción se realiza uno a uno cada elemento con su posición correspondiente (es decir, el elemento 1 de envío se reduce con cada elemento en la posición 1 de cada sendbuf).


```{csv-table}
:header: Función de reducción,Descripción
:enumerated: false
`MPI_MAX`,"Máximo entre los elementos"
`MPI_MIN`,"Mínimo entre los elementos"
`MPI_SUM`,"Suma"
`MPI_PROD`,"Producto"
`MPI_LAND`,"AND lógico (devuelve 1 o 0, verdadero o falso)"
`MPI_BAND`,"AND a nivel de bits"
`MPI_LOR`,"OR lógico"
`MPI_BOR`,"OR a nivel de bits"
`MPI_LXOR`,"XOR lógico"
`MPI_BXOR`,"XOR a nivel de bits"
`MPI_MAXLOC`,"Valor máximo entre los elementos y el rango del proceso que lo tenía"
`MPI_MINLOC`,"Valor mínimo entre los elementos y el rango del proceso que lo tenía"
```