with utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;
with estructuras;
use estructuras;
use utiles, fechas, Ada.Strings.Unbounded, Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Exceptions; use Ada.Exceptions;



procedure tpfinal is

   model:listaModelos.tipoLista;
   client:arbolClientes.tipoArbol;
   serv:listaServicios.tipoLista;
   vehiculos:arbolVehiculos.tipoArbol;
   opc:integer;
   noHayClientes, cancelarIngreso, noHayServicios, noHayEtapas, noHayModelos:Exception;
   noHayVehiculos, errorAlAgregarServicio:exception;
   
   --nivel 6
   
   function menuModiCal return Integer is 
   begin
      Put_Line("Menu modificacion Calendario");
      Put_Line("1-Etapa");
      Put_Line("2-Precio");
      Put_Line("3-Salir");
      return enteroEnRango("Ingrese su opcion",1,4);
      
   end menuModiCal;
   
   function obtenerEtapa(calendario: in listaCalendario.tipoLista;
                         msj: in String) return Integer is 
      etapa: tipoClaveCalendario;
      precio:tipoInfoCalendario;
      ok:Boolean; 
   
   begin
      ok:=false;
      if (listaCalendario.esVacia(calendario)) then 
         raise noHayEtapas;
      else
         loop 
            Put_Line(msj & "(0 para cancelar y volver al menu anterior)");
            etapa:= numeroEnt("ingrese etapa");
            If (etapa=0) then
               raise cancelarIngreso;
            else
               begin
                  listaCalendario.recuClave(calendario,etapa,precio);
                  ok:=true; 
               exception
                  when listaCalendario.claveNoExiste=> Put_Line("Esa etapa no existe");
               end;
            end if;
         exit when ok; 
         end loop;     
      end if; 
      return etapa;
      
   end obtenerEtapa;
   
   --nivel 5
   
   function menuCalendario return integer is 
   begin
      Put_Line("Menu Calendario");
      Put_Line("1-Agregar etapa de Mantenimiento");
      Put_Line("2-Modificar etapa de Mantenimiento");
      Put_Line("3-Quitar etapa de Mantenimiento");
      Put_Line("4-Salir");
      return enteroEnRango("Ingrese su opción",1,4);
   end menuCalendario;
   
   procedure agregarEtapa(calendario: in out listaCalendario.tipoLista) is
      etapa:tipoClaveCalendario;
      precio:tipoInfoCalendario;
   begin
      etapa:=numeroEnt("Ingrese etapa de mantenimiento");
      precio:=numeroEnt("Ingrese precio de mantenimiento");
      begin 
         listaCalendario.insertar(calendario,etapa,precio);
      exception
         when listaCalendario.claveExiste=> Put_Line("Esa etapa de mantenimiento ya existe");
      end;
   exception
      when listaCalendario.listaLlena=> Put_Line("No se pudo agregar la etapa. Intente nuevamente mas tarde");
   end agregarEtapa;
   
         
   procedure modificarEtapa(calendario: in out listaCalendario.tipoLista) is
            opc:integer;
            etapa:tipoClaveCalendario;
            precio:tipoInfoCalendario;
   begin
            etapa:=obtenerEtapa(calendario, "Ingrese la etapa de mantenimiento que desea modificar");
            loop
               opc:=menuModiCal;
               case (opc) is
                  when 1=> etapa:=obtenerEtapa(calendario,"Ingrese la nueva etapa de mantenimiento");
                  when 2=> precio:=numeroEnt("Ingrese nuevo precio de mantenimiento");
               end case;
            exit when (opc=3);
            end loop;   
   exception 
          when noHayEtapas=>Put_Line("No hay etapas de mantenimiento. Agregue una e intente nuevamente");
   end modificarEtapa;
   
   procedure quitarEtapa(calendario: in out listaCalendario.tipoLista) is
         etapa:tipoClaveCalendario;   
            
   begin 
            etapa:=obtenerEtapa (calendario,"Ingrese la etapa de mantenimienot a quitar");
            listaCalendario.suprimir(calendario,etapa);
   exception
         when noHayEtapas=>Put_Line("No hay etapas de mantenimiento. Agregue una e intente nuevamente");      
   end quitarEtapa;  
   
   
   --nivel 4
   
   function menuModiModelo return integer is 
   begin 
      Put_Line("MODIFICAR MODELO");
      Put_Line("1 - Moficar Nombre");
      Put_Line("2 - Agregar, modificar o quitar etapas de su calendario de mantenimientos");
      Put_Line("3 - Volver al menú anterior");
      return enteroEnRango("Ingrese su opcion",1,3);
   end menuModiModelo;
       
    procedure ABMCalendario (calendario: in out listaCalendario.tipoLista) is 
      opc:integer;
    begin 
      loop 
         opc:=menuCalendario;
         case (opc) is 
            when 1=>agregarEtapa(calendario);
            when 2=>modificarEtapa(calendario);
            when 3=>quitarEtapa(calendario);
         end case;
         exit when (opc=4);
      end loop;
    end ABMCalendario;
   
   function obtenerEmail(cad: in Unbounded_String) return Unbounded_String is
      ok:boolean;
      email:Unbounded_String;
      i:integer;
   begin
      ok:=true;
      loop
         Put_Line(cad);
         Get_Line(email);
         for i in 1..Length(email)loop
            ok:= ok and (email(i)='@');
         end loop; 
         exit when ok;
         return email;
      end loop;
   end obtenerEmail;
      
   function menuModifCliente return integer is 
   begin 
      Put_Line ("¿Que desea modificar?");
      Put_Line("1- DNI");
      Put_Line("2- Nombre");
      Put_Line("3- Numero de Telefono");
      Put_Line("4- E-Mail");
      return enteroEnRango("Ingrese su opcion",1,4);
   end menuModifCliente;
   
   function menuModifVehiculos return Integer is
   begin 
      Put_Line("¿Que desea modificar?");
      Put_Line("1-Modelo");
      Put_Line("2-Año de Fabricacion");
      Put_Line("3-Dueño");
      Put_Line("4-Salir");
      return enteroEnRango("Ingrese su opcion",1,4);
   end menuModifVehiculos;
   --nivel 3
   
   procedure menuModifServicio is
   begin
      Put_Line("Modificar Servicio");
      Put_Line("1 - Cambiar Cliente");
      Put_Line("2 - Cambiar vehiculo (dominio)");
      Put_Line("3 - Cambiar etapa de mantenimiento");
      Put_Line("4 - Cambiar Fecha");
      Put_Line("5 - Cambiar Precio final");
      Put_Line("6 - Cambiar kilometraje");
      Put_Line("7 - Volver al menu anterior");
   end menuModifServicio;
   
   procedure actualizarSC(serv: in out listaServicios.tipoLista; viejoDni,dni: in tipoClaveClientes) is
      datosServicio:tipoInfoServicios;
      codigoServicio:tipoClaveServicios;
      sigo:Boolean;
      
   begin
      if (not(listaServicios.esVacia(serv))) then
         sigo := True;
         listaServicios.recuPrim(serv,codigoServicio);
         
         while sigo loop
            begin
               listaServicios.recuClave(serv,codigoServicio,datosServicio);
               
               if (datosServicio.dniCliente = viejoDni) then
                  datosServicio.dniCliente := dni;
                  listaServicios.modificar(serv, codigoServicio,datosServicio);
               end if;
               
               listaServicios.recuSig(serv,codigoServicio,codigoServicio);
            exception
               when listaServicios.claveEsUltima => sigo := False;
            end;
         end loop;
      end if;
   end;
   
   procedure limpiarVehiculo(vehiculos: in out arbolVehiculos.tipoArbol ; patente: in tipoClaveVehiculos) is 
      datosVehiculo:tipoInfoVehiculos;
   begin
      arbolVehiculos.buscar(vehiculos,patente,datosVehiculo);
      
      listaMantenimientos.vaciar(datosVehiculo.manten);
      
      arbolVehiculos.modificar(vehiculos,patente,datosVehiculo);
   end;
   
   
   
   --nivel 2
   
   function obtenerCliente(client:in arbolClientes.tipoArbol) return integer is
      valido:Boolean;
      dni:tipoClaveClientes;
      i:tipoInfoClientes;
      
   begin
      valido := False;
      if (arbolClientes.esVacio(client)) then
         raise noHayClientes;
      else
         loop
            dni := numeroEnt("Ingrese cliente");
            if (dni = 0) then
               raise cancelarIngreso;
            else
               begin
                  arbolClientes.buscar(client, dni, i);
                  valido := True;
               exception
                  when arbolVehiculos.claveNoExiste => null;
               end;
            end if;
            exit when valido;
         end loop;
      end if;
      return dni;
   end;
   
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
                              model: in listaModelos.tipoLista;
                              client: in arbolClientes.tipoArbol) is
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
                             client: in arbolClientes.tipoArbol;
                             model: in listaModelos.tipoLista;
                             vehiculos: in out arbolVehiculos.tipoArbol) is
      
      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
      datosCliente:tipoInfoClientes;
   begin
 
      codigoServicio := generarCodigoServicio(serv);
      
      datosServicio.dniCliente := obtenerCliente(client);
      datosServicio.dominio := obtenerVehiculo(datosServicio.dniCliente, vehiculos);
      datosServicio.etapa := obtenerEtapaValida(model, vehiculos, datosServicio.dominio);
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
            menuModifServicio;
            opc:= 0;
            --esto es para evitar inconsistencias
            case opc is
               when 1=> opc:= 2;
               when 2 => 
                  begin
                     opc := 3;
                     viejoDominio := datosServicio.dominio;
                  end;
               when 3 => opc := 4;
               when 4 => opc := 6;               
               when others => opc := enteroEnRango("Ingrese opción",1,6);
            end case;
            -- seleccion de opciones
            case opc is
               when 1 => datosServicio.dniCliente := obtenerCliente(client);
               when 2 => datosServicio.dominio := obtenerVehiculo(vehiculos, datosServicio.dniCliente);
               when 3 => obtenerEtapaValida(model, vehiculos, datosServicio.dominio, etapa);
               when 4 => obtenerFecha("Fecha del servicio", datosServicio.fecha);				
               when 5 => obtenerPrecioFinal(model, datosServicio.etapa, datosServicio.precioFinal);
               when 6 => obtenerKmReal(model, vehiculos, datosServicio.dominio, datosServicio.etapa);
            end case;
            exit when opc = 7;
         exception
               when cancelarIngreso => null;
         end;
      end loop;
      listaServicios.modificar(serv,codigoServicio,datosServicio);
      if viejoDominio /= datosServicio.dominio then
         bajaSV(vehiculos, codigoServicio,viejoDominio);
      end if;
   exception
      when noHayServicios => Put_Line("No existen servicios. Agregue uno e intente nuevamente");
      when cancelarIngreso => null;
   end;
   
   procedure quitarServicio (serv: in out listaServicios.tipoLista ; vehiculos: in out arbolVehiculos.tipoArbol) is
      codigoServicio:tipoClaveServicios;
      datosServicio: tipoInfoServicios;
   begin
      codigoServicio := obtenerServicio(serv);
      listaServicios.recuClave(serv, codigoServicio, datosServicio);
      listaServicios.suprimir(serv,codigoServicio);
      bajaSV(vehiculos, codigoServicio, datosServicio.dominio);
   exception
      when noHayServicios => Put_Line("No existen servicios. Agregue uno e intente nuevamente mas tarde");
      when cancelarIngreso => null;      
   end;
      
   procedure mantenPorCliente(client: in arbolClientes.tipoArbol; 
                              serv: in listaServicios.tipoLista) is 
      total:integer;
      sigo:Boolean;
      codigoServicios:tipoClaveServicios;
      datosServicios:tipoInfoServicios;
      dni:tipoClaveClientes;
      datosCliente:tipoInfoClientes;
   begin
      total:=0;
      dni:=obtenerCliente(client);
      arbolClientes.buscar(client,dni,datosCliente);
      sigo:=True;
      listaServicios.recuPrim(serv,codigoServicios);
      mostrarCabeceraMantenPorCliente(datosCliente.nombre);
      while sigo loop 
         begin 
            listaServicios.recuClave(serv,codigoServicios,datosServicios);
            if (datosServicios.dniCliente = dni) then
               mostrarDatosServicios(datosServicios,codigoServicios);
               total:=total+1;
            end if;
            listaServicios.recuSig(serv,codigoServicios,codigoServicios);
         exception
            when listaServicios.claveEsUltima => sigo:=False;
         end;
      end loop; 
      Put_Line("TOTAL: " &Integer'image(total));
   exception
      when cancelarIngreso=> null;
      when noHayClientes=> Put_Line("No existen clientes. Agregue por lo menos uno para poder realizar esta consulta");
      when listaServicios.listaVacia=> Put_Line("No existen servicios realizados. Agregue por lo menos uno para poder realizar esta consulta");
   end mantenPorCliente; 
   
   
   procedure mantPorModelo( model: in listaModelos.tipoLista;
                            serv: in listaServicios.tipoLista;
                            vehiculos: in arbolVehiculos.tipoArbol) is
   	total:integer;
	sigo:Boolean;
	codigoModelo:tipoClaveModelos;
	codigoServicio:tipoClaveServicios;
	datosServicio:tipoInfoServicios;
        datosVehiculo:tipoInfoVehiculos;
        datosModelo:tipoInfoModelos;
   begin
      codigoModelo:=obtenerModelo;
      listaServicios.recuPrim(serv,codigoServicio);
      sigo:=true;
      total:=0;
      listaModelos.recuClave(model,codigoModelo,datosModelo);
      mostrarEncabezadoMantModelo(datosModelo.nombre);
         while sigo loop
            begin
               --recupero los datos del servicio
               listaServicios.recuClave(serv, codigoServicio, datosServicio);
               --busco en el arbol de vehiculos
               arbolVehiculos.buscar(vehiculos, datosServicio.dominio, datosVehiculo);
               --si el modelo coincide, muestro y contabilizo
               if (datosVehiculo.modelo = codigoModelo) then
                  mostrarDatosServicioyDNI(datosServicio);
                  total:= total + 1;
               end if;
            
               listaServicios.recuSig(serv, codigoServicio, codigoServicio);
            exception
               when listaServicios.claveEsUltima => sigo:=false;
            end;   
         end loop;
         Put_Line("TOTAL: " & Integer'Image(total));
   exception
         when noHayModelos => Put_Line("No existen Modelos. Agregue por lo menos uno e intente nuevamente");
         when listaServicios.listaVacia => Put_Line("No existen servicios. Agregue por lo menos uno e intente nuevamente");
   end mantPorModelo;
      
  procedure datosClientesSinMant(client: in arbolClientes.tipoArbol; serv: in listaServicios.tipoLista) is
     	muestro:boolean;
	total:integer;
	sigo:boolean;
	colaClientes:arbolClientes.ColaRecorridos.tipoCola;
	dni:tipoClaveClientes;
        datosCliente:tipoInfoClientes;
  begin 
         arbolClientes.ColaRecorridos.crear(colaClientes);
         muestro:= true;
	 total:= 0;	
         arbolClientes.inOrder(client, colaClientes);                   
         mostrarEncabezadoClientSinMant;
         while no(arbolClientes.ColaRecorridos.esVacia(colaClientes)) loop
            arbolClientes.ColaRecorridos.frente(colaClientes, dni);
            listaServicios.recuPrim(serv, codigoServicio);
            sigo:=true;
            while sigo loop
               begin
                  listaServicios.recuClave(serv, codigoServicio, datosServicio);
                  muestro := muestro and (dni = datosServicio.dniCliente);
                  listaServicios.recuSig(serv, codigoServicio, codigoServicio);
               exception
                  when listaServicios.claveEsUltima => sigo:=False; 
               end; 
            end loop; 
            If muestro then 
               arbolClientes.buscar(client, dni, datosCliente);
               mostrarDatosCliente(dni, datosCliente);
               total :=total + 1;
            end if;
            arbolClientes.ColaRecorridos.desencolar(colaClientes);
         end loop;
         Put_Line("TOTAL: " & Integer'Image(total));
  end datosClientesSinMant;
 
      
  function menuVehiculos return integer is 
  
  begin
         Put_Line("Seleccione una opcion");
         Put_Line("1 - Agregar un Vehículo");
         Put_Line("2 - Modificar un Vehículo");
         Put_Line("3 - Quitar un Vehículo");
         Put_Line("4 - Salir");
         return enteroEnRango("Ingrese su opcion",1,4);
  end menuVehiculos;
      
         
  function menuClientes return integer is        
  begin 
         Put_Line("Seleccione una Opcion");
         Put_Line("1 - Agregar Cliente");
         Put_Line("2 - Modificar Cliente");
         Put_Line("3 - Quitar Cliente");
         Put_Line("4 - Salir") ;
         return enteroEnRango("Ingrese su opcion",1,4);
  end menuClientes;
  
   function menuServicios return integer is
   begin 
      Put_Line("Seleccione una Opcion");
      Put_Line("1 - Agregar Servicios");
      Put_Line("2 - Modificar Servicios");
      Put_Line("3 - Quitar Servicios");
      Put_Line("4 - Salir");
      return enteroEnRango("Ingrese su opción",1,4);
   end menuServicios;
      
    
   function menuConsultas return integer is
   begin
      Put_Line("Seleccione una Opcion");
      Put_Line("1 - Consultar mantenimientos por cliente");
      Put_Line("2 - Consultar mantenimientos por modelos");
      Put_Line("3 - Consultar datos de clientes sin mantenimientos");
      Put_Line("4 - Salir") ;
      return enteroEnRango("Ingrese su opción",1,4);
   end menuConsultas;
      
      
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
   end menuGeneral;
   
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
   
   procedure ABMVehiculos (vehiculos: in out arbolVehiculos.tipoArbol;
                           serv: in out listaServicios.tipoLista;
                           model: in out listaModelos.tipoLista;
                           client: in out arbolClientes.tipoArbol) is
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
            when 1 => mantenPorCliente(client, serv);
            when 2 => mantPorModelo(model, serv, vehiculos);
            when 3 => datosClientesSinMant(client,serv);
         end case;
         
         exit when opc = 3;
      end loop;
   end;
   
          
   --nivel 0
begin
   listaModelos.crear(model);
   arbolClientes.crear(client);
   listaServicios.crear(serv);
   arbolVehiculos.crear(vehiculos);
    Loop
     opc := menuGeneral;
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
