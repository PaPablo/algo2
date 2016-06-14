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
   
   --nivel 2
   function menuModelos return integer is
   begin
      return numeroEnt("Ingrese Opcion");
   end;
        
   --nivel 1
   
   function menuGeneral return integer is
   begin
      return numeroEnt("Ingrese Opcion");
   end;
   
   procedure ABMModelos (model: in out listaModelos.tipoLista; serv: in out listaServicios.tipoLista; vehiculos: in out arbolVehiculos.tipoArbol) is
   opc:integer;
   begin
      loop
         opc:=menuModelos;
         Case opc is 
            when 1=> agregarModelo(model);
            when 2=> modificarModelo(model,serv,vehiculos);
            when 3=> quitarModelo(model,serv,vehiculos);
         end case;
         exit when(opc=4);               
      end loop;
      
   end ABMModelos;
   
   procedure ABMClientes (client: in out arbolClientes.tipoArbol; serv: in out listaServicios.tipoLista; vehiculos: in out arbolVehiculos.tipoArbol ) is
   opc:integer;
   begin
      loop
         opc:=menuClientes;
         Case opc is 
            when 1=> agregarCliente(client);
            when 2=> modificarCliente(client,vehiculos,serv);
            when 3=> quitarCliente(client,vehiculos,serv);
         end case;
         exit when(opc=4);               
      end loop;
      
   end ABMClientes;
   
   procedure ABMServicios (serv: in out listaServicios.tipoLista; client: in out arbolClientes.tipoArbol; model: in out listaModelos.tipoLista;  vehiculos: in out arbolVehiculos.tipoArbol) is
   opc:integer;
   begin
      loop
         opc:=menuVehiculos;
         Case opc is 
            when 1=> agregarServicio(serv,client,model,vehiculos);
            when 2=> modificarServicio(serv,client,model,vehiculos);
            when 3=> quitarServicio((serv,client,model,vehiculos);
         end case;
         exit when(opc=4);               
      end loop;
      
   end ABMServicios; 
   
   procedure ABMVehiculos (vehiculos: in out arbolVehiculos.tipoArbol; serv: in out listaServicios.tipoLista;model: in out listaModelos.tipoLista; client: in out arbolClientes.tipoArbol) is
   opc:integer;
   begin
      loop
         opc:=menuVehiculos;
         Case opc is 
            when 1=> agregarVehiculo(vehiculos,model,client);
            when 2=> modificarVehiculo(vehiculos,model,client);
            when 3=> quitarVehiculo(vehiculos,serv);
         end case;
         exit when(opc=4);               
      end loop;
      
   end ABMVehiculos; 
     
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
         When 4=>ABMvehiculos(vehiculos,serv,model,client);  
      end case;
      exit when (opc=5);
   end loop ;
  
end tpfinal;
