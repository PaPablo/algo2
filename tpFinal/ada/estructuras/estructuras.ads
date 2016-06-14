with arbol, cola, lista, utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;
use utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;

package estructuras is
   -- ABB clientes
   subtype tipoClaveClientes is integer; --DNI
   type tipoInfoClientes is record
      nombre:Unbounded_String;
      telefono:integer;
      email:Unbounded_String;
   end record;
   package arbolClientes is new arbol(tipoClaveClientes, tipoInfoClientes,">","<", "=");


     --Lista Ordenada Calendario de Mantenimientos
   subtype tipoClaveCalendario is integer; --cantidad de km correspondiente a la etapa de mantenimiento - 10000, 20000...
   subtype tipoInfoCalendario is integer; --precio minimo
   package listaCalendario is new lista(tipoClaveCalendario, tipoInfoCalendario, "<", "=");


   --Lista Ordenada Modelos
   subtype tipoClaveModelos is integer; --AUTONUMERADO codigo de modelo
   type tipoInfoModelos is record
      nombre:Unbounded_String;
      calendario:listaCalendario.tipoLista;
   end record;
   package listaModelos is new lista(tipoClaveModelos, tipoInfoModelos, "<", "=");

   --TIPO CLAVE DE SERVICIOS - PARA QUE EL COMPILADOR LO DETECTE ANTES
   subtype tipoClaveServicios is integer; --AUTONUMERADO codigo de servicio

  --Lista Ordenada de Mantenimientos
   subtype tipoClaveMantenimientos is tipoClaveServicios;
   subtype tipoInfoMantenimientos is integer; --precio final del mantenimiento
   package listaMantenimientos is new lista (tipoClaveMantenimientos, tipoInfoMantenimientos, "<", "=");

   --ABB vehiculos
   subtype tipoClaveVehiculos is Unbounded_String; --PATENTE
   type tipoInfoVehiculos is record
      dueño:tipoClaveClientes;
      modelo:tipoClaveModelos;
      añoFabri: integer; --año
      manten: listaMantenimientos.tipoLista;
   end record;
   package arbolVehiculos is new arbol(tipoClaveVehiculos, tipoInfoVehiculos,">","<", "=");


   --Lista Ordenada Servicios Realizados
   --El tipoCLave esta mas arriba
   type tipoInfoServicios is record
      dniCliente:tipoClaveClientes;
      dominio:tipoClaveVehiculos;
      etapa: tipoClaveCalendario;
      kmReal: integer;
      fecha:tFecha;
   end record;
   package listaServicios is new lista(tipoClaveServicios, tipoInfoServicios, "<", "=");

end estructuras;
