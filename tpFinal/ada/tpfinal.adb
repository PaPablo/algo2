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
      Put_Line("Modelos");
      Put_Line("1 - Agregar Modelo");
      Put_Line("2 - Modificar Modelo (Nombre o etapas de su calendario de mantenimiento");
      Put_Line("3 - Quitar Modelo");
      Put_Line("4 - Volver al menu anterior");
      return numeroEnt("Ingrese su opción");
   end;
   
   procedure agregarModelo(model: in out listaModelos.tipoLista) is
   datosModelo:tipoInfoModelos;
   codigoModelo:tipoClaveModelos;
   begin
      codigoModelo:= generarCodigoModelo(model);
      datosModelo.nombre:= To_Unbounded_String(textoNoVacio("Nombre de Modelo"));
      listaCalendario.crear(datosModelo.calendario);
      listaModelos.insertar(model,codigoModelo,datosModelo);
   exception
         when listaModelos.listaLlena=> Put_Line("No hay espacio para un nuevo modelo, intente nuevamente más tarde.");
   end agregarModelo;
   
   procedure agregarCliente(client: in out arbolClientes.tipoArbol) is
      datosCliente:tipoInfoClientes;
      dni:tipoClaveClientes;
   begin
      dni := numeroEnt("Ingrese DNI de cliente");
      
      begin
         arbolClientes.buscar(client,dni, datosCliente);
         Put_Line("Cliente ya existe");
      exception
         when arbolClientes.claveNoExiste => 
            begin
               datosCliente.nombre := To_Unbounded_String(textoNoVacio("Ingrese Nombre del Cliente"));
               datosCliente.telefono := numeroEnt("Ingrese Telefono");
               datosCliente.email := obtenerEmail;
               arbolClientes.insertar(client, dni, datosCliente);
            end;
      end;
   exception
      when arbolClientes.arbolLleno => Put_Line("No se puede insertar un cliente en este momento, intente nuevamente más tarde");
   end;
   
   procedure modificarCliente(client: in out arbolClientes.tipoArbol; vehiculos: in out arbolVehiculos.tipoArbol; serv: in out listaServicios.tipoLista) is
      dni:tipoClaveClientes;
      viejoDni:tipoClaveClientes;
      datosCliente:tipoInfoClientes;
   begin
      viejoDni := obtenerCliente(client);
      dni := viejoDni;
      modifCliente(datosCliente);
      arbolClientes.modificar(client,dni,datosCliente);
      
      if (dni /= viejoDni) then
         actualizarSC(serv,viejoDni,dni);
      end if;
      
      actualizar(vehiculos,dni);
   exception
      when noHayClientes => Put_Line("No hay clientes agregados. Agregue un cliente e intente nuevamente");
      when cancelarIngreso => null;
   end;
   
   
   procedure quitarCliente (client: in out arbolClientes.tipoArbol;
                            vehiculos: in out arbolVehiculos.tipoArbol ;
                            serv: in out listaServicios.tipoLista) is
      dni:tipoClaveClientes;
   begin
      dni := obtenerCliente(client);
      
      if (confirma("Está seguro que desea eliminar este cliente (S/N)")) then
         arbolClientes.suprimir(client, dni);
         bajaSC(serv, dni);
         bajaVC(vehiculos, dni);
      end if;
      
   exception
      when noHayClientes => Put_Line("No hay clientes. Agregue uno e intente más tarde");
      when cancelarIngreso => null;
   end;
   
   
   procedure modificarModelo (model: in out listaModelos.tipoLista;
                              serv: in out listaServicios.tipoLista;
                              vehiculos: in out arbolVehiculos.tipoArbol) is
      
      codigoModelo:tipoClaveModelos;
      datosModelo:tipoInfoModelos;
   begin
      codigoModelo := obtenerModelo(model);
      listaModelos.recuClave(model, codigoModelo,datosModelo);
      modifModelo(datosModelo);
      listaModelos.modificar(model, codigoModelo, datosModelo);
      bajaSMant(serv, datosModelo.calendario);
      actualizarVS(vehiculos,serv);   
   exception
      when noHayModelos => Put_Line("No existen modelos. Agregue uno e intente nuevamente");
      when cancelarIngreso => null;
   end;
   
   
   procedure quitarModelo(model: in out listaModelos.tipoLista; serv: in out listaServicios.tipoLista ; vehiculos: in out arbolVehiculos.tipoArbol) is
      codigoModelo:tipoClaveModelos;
   begin
      codigoModelo := obtenerModelo(model);
      
      if (confirma("Está seguro que desea eliminar esta modelo?")) then
         limpiarModelo(model,codigoModelo);
         listaModelos.suprimir(model,codigoModelo);
         bajaVSM(vehiculos,serv,codigoModelo);
      end if;
      
   exception
      when noHayModelos => Put_Line("No hay Modelos. Agregue uno e intente nuevamente más tarde");
      when cancelarIngreso => null;
   end;
   
   
   procedure agregarVehiculo (vehiculos: in out arbolVehiculos.tipoArbol;
                              client: in arbolClientes.tipoArbol;
                              model: in listaModelos.tipoLista) is
      datosVehiculo:tipoInfoVehiculos;
      patente:tipoClaveVehiculos;
   begin
      Put_Line("Ingrese el dueño del vehiculo a agregar");
      datosVehiculo.dueño := obtenerCliente(client);
      
      if (listaModelos.esVacia(model)) then
         raise noHayModelos;
      else
         patente := obtenerPatente;
         begin
            arbolVehiculos.buscar(vehiculos,patente, datosVehiculo);
            Put_Line("Este vehiculos ya existe");
         exception
            when arbolVehiculos.claveNoExiste => 
               begin
                  datosVehiculo.modelo := obtenerModelo(model);
                  datosVehiculo.añoFabri := numeroEnt("Ingrese año de fabricacion");
                  listaMantenimientos.crear(datosVehiculo.manten);
                  arbolVehiculos.insertar(vehiculos, patente, datosVehiculo);
               end;
         end;
      end if;
   exception
      when arbolVehiculos.arbolLleno => Put_Line("No se puede agregar un vehiculo en este momento. Intente nuevamente mas tarde");
      when noHayClientes => Put_Line("No hay cliente. Agregue uno e intente nuvamente más tarde");
      when noHayModelos => Put_Line("No existen modelos. Agregue uno e intente nuevamente mas tarde");
      when cancelarIngreso => null;
   end;
   
   
   procedure agregarServicio(serv: in out listaServicios.tipoLista;
                             model: in listaModelos.tipoLista;
                             client: in arbolClientes.tipoArbol;
                             vehiculos: in out arbolVehiculos.tipoArbol) is
      
      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
      datosCliente:tipoInfoClientes;
   begin
 
      codigoServicio := generarCodigoServicio(serv);
      
      datosServicio.dniCliente := obtenerCliente(client);
      datosServicio.dominio := obtenerVehiculo(datosServicio.dniCliente, vehiculos);
      datosServicio.etapa := obtenerEtapa(model, vehiculos, datosServicio.dominio);
      datosServicio.kmReal := obtenerKmReal(model,vehiculos, datosServicio.dominio, datosServicio.etapa);
      obtenerFecha(datosServicio.fecha);
      datosServicio.precioFinal := obtenerPrecioFinal(model, datosServicio.etapa);
      
      listaServicios.insertar(serv,codigoServicio,datosServicio);
      
      altaSV(vehiculos, codigoServicio, datosServicio.precioFinal);
      
   exception
      when errorAlAgregarServicio | listaServicios.listaLLena => Put_Line("No se puede agregar sevicio en este momento. Intente nuevamente más tarde");
      when noHayEtapas => Put_Line("El modelo seleccionado no posee etapas en su calendario de mantenimientos. Agregue una e intente nuevamente");
      when noHayClientes => Put_Line("No hay clientes agregados. Agregue uno e intente nuevamente");
      when noHayVehiculos => Put_Line("El cliente no tiene vehiculos a su nombre. Agregue uno e intente nuevamente");
      when cancelarIngreso => null;
   end;
   

   procedure modificarServicio(serv: in out listaServicios.tipoLista ; client: in out arbolClientes.tipoArbol; model:in listaModelos.tipoLista;vehiculos: in out arbolVehiculos.tipoArbol) is
      viejoDominio:tipoClaveVehiculos;
      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
      opc:Integer;
   begin
      codigoServicio := obtenerServicio(serv);
      listaServicios.recuClave(serv,codigoServicio,datosServicio);
      
      loop
         begin
            menuModig
                                      
       
      
   --nivel 1
   
   function menuGeneral return integer is
   begin
      Put_Line("Consecionaria");
      Put_Line("Seleccione una opcion");
      Put_Line("1 - Modelos");
      Put_Line("2 - Clientes");
      Put_Line("3 - Servicios");
      Put_Line("4 - Vehiculos");
      Put_Line("5 - Consultas");
      Put_Line("6 - Salir");
      return numeroEnt("Ingrese su opciòn");
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
   
   procedure ABMClientes (client: in out arbolClientes.tipoArbol; serv: in out listaServicios.tipoLista; model: in out listaModelos.tipoLista ;vehiculos: in out arbolVehiculos.tipoArbol ) is
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
            when 3=> quitarServicio(serv,client,model,vehiculos);
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
     
   
   procedure Consultas(client: in arbolClientes.tipoArbol;
                       model: in listaModelos.tipoLista;
                       serv: in listaServicios.tipoLista;
                       vehiculos: in arbolVehiculos.tipoArbol) is
      opc:integer;
   begin
      loop
         opc := menuConsultas;
         
         case opc is
            when 1 => mantenPorCliente(clien, serv);
            when 2 => mantPorModelo(model, serv, vehiculos);
            when 3 => datosClientesSinMant(client,serv);
         end case;
         
         exit when opc = 3;
      end loop;
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
         When 4=>ABMvehiculos(vehiculos,serv,model,client);  
         When 5=>Consultas(client,model,serv,vehiculos);
      end case;
      exit when (opc=6);
   end loop ;
  
end tpfinal;
