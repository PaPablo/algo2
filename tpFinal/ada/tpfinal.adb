with utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;
with estructuras;
use estructuras;
use utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;



procedure tpfinal is

   model:listaModelos.tipoLista;
   client:arbolClientes.tipoArbol;
   serv:listaServicios.tipoLista;
   vehiculos:arbolVehiculos.tipoArbol;
   opc:integer;
        
   --nivel 1
   
   function menuGeneral return integer is
   begin
      return numeroEnt("Ingrese Opcion");
   end;
     
begin
   --nivel 0
   listaModelos.crear(model);
   arbolClientes.crear(client);
   listaServicios.crear(serv);
   arbolVehiculos.crear(vehiculos);
   Loop
     opc:= menuGeneral;
      Case opc is
         When 1=>ABMModelos(model,serv,vehiculos);
         When 2=>ABMClientes(client,serv,model,vehiculos);
         When 3=>ABMServicios(serv,client,model,vehiculos);
         When 4=>ABMvehiculos(vehiculos,client,model,vehiculos);  
      end case;
      exit when (opc=5);
   end loop ;
end tpfinal;
