 #Actividad Modelado ER y Normalización: Envios, Retail y cuentas Bancarias

 #Descripcion
  El objetivo de esta actividad es reforzar los conceptos del módulo 5 sobre bases de datos 
  mediante la implementación de tres ejercicios. Cada ejercicio muestra cómo se estructura y 
  normaliza una base de datos según el sistema que se implemente.

  Se aplican los siguientes conceptos:

  Modelo Entidad-Relación (ER).
  Normalización hasta la 3FN.
  Implementación en SQL (DDL).

 #Modelo de datos
  Cada ejercicio incluye un diagrama ER que muestra las entidades, atributos y relaciones.


 #Estructura del Proyecto

  El proyecto contiene tres ejercicios, cada uno con su script SQL y diagrama ER:

  Sistema de Encomienda – Script SQL y diagrama en imagen
  Sistema de Ventas y Productos Retail – Script SQL y diagrama en imagen
  Sistema de Administración de Cuentas Bancarias – Script SQL y diagrama en imagen

 #Consideraciones
 
-En el ejercicio de Retail, para manejar la relación muchos a muchos entre pedido y producto,
 se creó una tabla intermedia llamada detalle_pedido.

-Esta tabla permite almacenar la cantidad y precio de cada producto en cada pedido, evitando
 redundancia y cumpliendo con la 3FN.

-Cada registro de detalle_pedido corresponde a un producto específico de un pedido específico, 
 lo que mantiene la atomicidad y elimina dependencias transitivas.

-Los precios unitarios en detalle_pedido se asignan manualmente en los inserts 
(aunque podrían automatizarse con triggers).
