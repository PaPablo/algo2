with utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;
with estructuras;
use estructuras;
use utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;

procedure tpfinal is

   model:listaModelos.tipoLista;
   client:arbolClientes.tipoArbol;
   serv:listaServicios.tipoLista;
   vehiculos:arbolVehiculos.tipoArbol;
      
   
   function menuGeneral return integer is
   begin
      return numeroEnt("Ingrese Opcion");
   end;
   
   
begin
   listaModelos.crear(model);
   arbolClientes.crear(client);
   listaServicios.crear(serv);
   arbolVehiculos.crear(vehiculos);
end tpfinal;
