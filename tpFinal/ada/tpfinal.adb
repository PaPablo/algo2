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

   --Qué Hace: devuelve un dni correspondiente a un cliente existente
   --PRE: client = C
   --POST: obtenerCliente = D ; D pertenece a C
   --Excep: 	noHayClientes - ingresoCancelado
   function obtenerCliente(client:in arbolClientes.tipoArbol) return tipoClaveClientes is
      valido:Boolean;
      dni:tipoClaveClientes;
      i:tipoInfoClientes;

   begin
      valido := False;
      if (arbolClientes.esVacio(client)) then
         raise noHayClientes;
      else
         loop
            dni := enteroMayorIgualACero("Ingrese cliente");
            if (dni = 0) then
               raise cancelarIngreso;
            else
               begin
                  arbolClientes.buscar(client, dni, i);
                  valido := True;
               exception
                  when arbolClientes.claveNoExiste => put_line("Cliente no Existe");
               end;
            end if;
            exit when valido;
         end loop;
      end if;
      return dni;
   end obtenerCliente;

   --nivel 6
   
   --que hace: muestra las opcienes para modificar el calendario
   --pre:-
   --pos: menuModiCal = O ; O es una opcion valida 
   --exp:-
   function menuModiCal return Integer is
   begin
      Put_Line("Menu modificacion Calendario");
      Put_Line("1-Etapa");
      Put_Line("2-Precio");
      Put_Line("3-Salir");
      return enteroEnRango("Ingrese su opcion",1,4);
   end menuModiCal;
   
   --que hace: valida que la etapa que se desea modificar exista
   --pre: calendario=C
   --pos: obtenerEtapa=N y N>0
   --exp: cancelarIngreso, noHayEtapas}
   function obtenerEtapa(calendario: in listaCalendario.tipoLista;
                         msj: in String) return tipoClaveCalendario is
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
            etapa:= enteroMayorIgualACero("ingrese etapa");
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
   
   --que hace: muestra las opciones para el ABM de calendario
   --pre:-
   --pos: menuCalendario = O ; O es una opcion valida
   --exp:-
   function menuCalendario return integer is
   begin
      Put_Line("Menu Calendario");
      Put_Line("1-Agregar etapa de Mantenimiento");
      Put_Line("2-Modificar etapa de Mantenimiento");
      Put_Line("3-Quitar etapa de Mantenimiento");
      Put_Line("4-Salir");
      return enteroEnRango("Ingrese su opción",1,4);
   end menuCalendario;
   
   --que hace: agrega una nueva eatapa al calenadrio de mantenimientos
   --pre: calendario=C y C puede estar vacio o tenes estapas
   --pos: calendario=C1 y C1 tiene una nueva estapa agregada
   --exp: -
   procedure agregarEtapa(calendario: in out listaCalendario.tipoLista) is
      etapa:tipoClaveCalendario;
      precio:tipoInfoCalendario;
   begin
      CLS;
      loop
         etapa:=enteroMayorIgualACero("Ingrese etapa de mantenimiento");
         exit when etapa > 0;
      end loop;

      loop
         precio:=enteroMayorIgualACero("Ingrese precio de mantenimiento");
         exit when precio > 0;
      end loop;

      begin
         listaCalendario.insertar(calendario,etapa,precio);
      exception
         when listaCalendario.claveExiste=> Put_Line("Esa etapa de mantenimiento ya existe");
      end;
   exception
      when listaCalendario.listaLlena=> Put_Line("No se pudo agregar la etapa. Intente nuevamente mas tarde");
   end agregarEtapa;

   --que hace: permite modificar las etapas de mantenimientos
   --pre: calendario=C y C tiene al menos una etapa
   --pos: calendario=C1 y C1 tiene una etapa modificada
   --exp: -
   procedure modificarEtapa(calendario: in out listaCalendario.tipoLista) is
      opc:integer;
      etapa:tipoClaveCalendario;
      precio:tipoInfoCalendario;
   begin
      CLS;
      etapa:=obtenerEtapa(calendario, "Ingrese la etapa de mantenimiento que desea modificar");
      listaCalendario.recuClave(calendario, etapa, precio);
      listaCalendario.suprimir(calendario, etapa);
      loop
         opc:=menuModiCal;
         case (opc) is
            when 1=>
               begin
                  loop
                     etapa:=enteroMayorIgualACero("Ingrese la nueva etapa de mantenimiento");
                     exit when etapa > 0;
                  end loop;
               end;
            when 2=>
               begin
                  loop
                     precio:=enteroMayorIgualACero("Ingrese nuevo precio de mantenimiento");
                     exit when precio > 0;
                  end loop;
               end;

            when others => null;
         end case;
         exit when (opc=3);
      end loop;
      listaCalendario.insertar(calendario, etapa, precio);
   exception
      when listaCalendario.listaLlena => Put_Line("No se pudo modificar la etapa. Intente nuevamente más tarde");
   end modificarEtapa;
   
   --que hace: elimina una etpa del calendario de mantenimiento
   --pre: calendario=C y C tiene al menos una etapa valida
   --pos: calendario=C1 y C1 tiene una etapa menos o esta vacia
   --exp: -
   procedure quitarEtapa(calendario: in out listaCalendario.tipoLista) is
         etapa:tipoClaveCalendario;

   begin
      CLS;
      etapa:=obtenerEtapa (calendario,"Ingrese la etapa de mantenimienot a quitar");
      listaCalendario.suprimir(calendario,etapa);
   exception
      when noHayEtapas=>Put_Line("No hay etapas de mantenimiento. Agregue una e intente nuevamente");
   end quitarEtapa;


   --nivel 4
   
   --Qué Hace: muestra un menu con las opciones para modificar los datos de un modelo
   --PRE: - 
   --POST: - 
   --EXCEP: - 
   function menuModifModelo return integer is
   begin
      Put_Line("MODIFICAR MODELO");
      Put_Line("1 - Moficar Nombre");
      Put_Line("2 - Agregar, modificar o quitar etapas de su calendario de mantenimientos");
      Put_Line("3 - Volver al menú anterior");
      return enteroEnRango("Ingrese su opcion",1,3);
   end menuModifModelo;
   
   --Qué Hace: Permite agregar, quitar o modificar etapas del calendario de mantenimientos de un modelo
   --PRE: calendario = C
   --POST: calendario = C1 ; C1 en C según lo haya querido el usuario
   --EXCEP: -
   procedure ABMCalendario (calendario: in out listaCalendario.tipoLista) is
      opc:integer;
   begin
      loop
         CLS;
         opc:=menuCalendario;
         case (opc) is
            when 1=>agregarEtapa(calendario);
            when 2=>modificarEtapa(calendario);
            when 3=>quitarEtapa(calendario);
            when others => null;
         end case;
         exit when (opc=4);
      end loop;
   end ABMCalendario;
   
   --Que Hace: devuelve una direccion de email valida
   --PRE: cad = C 
   --POST: obtenerEmail = M ; M es un email valido
   --EXCEP: 
   function obtenerEmail(cad: in String) return Unbounded_String is
      ok:boolean;
      email:Unbounded_String;
      i:integer;
   begin
      i:=1;
      ok:=False;
      loop
         email := To_Unbounded_String(textoNoVacio(cad));
         for i in 1.. Length(email) loop
            ok := ok or Element(email, i) = '@';
         end loop;

         exit when ok;
      end loop;
      return email;
   end obtenerEmail;

   --que hace: muestra las opciones para modificar un cliente
   --pre:-
   --pos: menuModifClient = O ; O es una opcion valida
   --exp:-
   function menuModifCliente return integer is
   begin
      Put_Line ("¿Que desea modificar?");
      Put_Line("1- DNI");
      Put_Line("2- Nombre");
      Put_Line("3- Numero de Telefono");
      Put_Line("4- E-Mail");
      Put_Line("5- Salir");
      return enteroEnRango("Ingrese su opcion",1,5);
   end menuModifCliente;
   
   --que hace: muestra las opciones para modificar los datos de un vehiculo
   --pre:-
   --pos: menuModifVehiculo = O ; O es una opcion valida
   --exp:-
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

   --Qué Hace: muestra el menu con las opciones para modificar un servicio
   --PRE: -
   --POST: -
   --EXCEP: -
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

   --Que Hace: actualiza el dni de un cliente en el listado de servicio
   --PRE: serv = S ; viejoDni = T ; dni = R
   --POST: serv = S1; S1 podria tener en los servicios con dniCliente = R en lugar de dniCliente = T
   --EXCEP: -
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
   end actualizarSC;
   
   --Qué Hace: Vacía las estructuras de datos pertenecientes a un vehículo
   --PRE: vehiculos = A ; patente = P
   --POST: vehiculos = A1 ; A1 en A con las estructuras pertenecientes a P vacías
   --EXCEP: - 
   procedure limpiarVehiculo(vehiculos: in out arbolVehiculos.tipoArbol ; patente: in tipoClaveVehiculos) is
      datosVehiculo:tipoInfoVehiculos;
   begin
      arbolVehiculos.buscar(vehiculos,patente,datosVehiculo);

      listaMantenimientos.vaciar(datosVehiculo.manten);

      arbolVehiculos.modificar(vehiculos,patente,datosVehiculo);
   end limpiarVehiculo;

   --Qué Hace: da de baja los servicios a nombre de un cliente en particular
   --PRE: serv = S ; dni = D
   --POST: serv = S1 ; S1 en S menos los servicios con dniCliente = D, que fueron eliminados
   --EXCEP:
   procedure bajaSC (serv: in out listaServicios.tipoLista ; dni: in tipoCLaveClientes) is
      siguiente:tipoClaveServicios;
      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
      sigo:Boolean;
   begin
      sigo := True;
      listaServicios.recuPrim(serv, codigoServicio);

      begin
         listaServicios.recuSig(serv,codigoServicio,siguiente);
      exception
            when listaServicios.claveEsUltima => siguiente := codigoServicio;
      end;

      while sigo loop
         begin
            listaServicios.recuClave(serv, codigoServicio, datosServicio);

            if (datosServicio.dniCliente = dni) then
               listaServicios.suprimir(serv,codigoServicio);
               codigoServicio := siguiente;

               begin
                  listaServicios.recuSig(serv, siguiente, siguiente);
               exception
                     when listaServicios.claveEsUltima => null;
               end;
            else
               listaServicios.recuSig(serv,codigoServicio,codigoServicio);
            end if;

         exception
               when listaServicios.claveNoExiste | listaServicios.claveEsUltima => sigo := False;
         end;

      end loop;
   exception
         when listaServicios.listaVacia => null;
   end bajaSC;
   
   --Qué hace: Actualiza los vehiculos con respecto a un cambio en el dni de un cliente
   --PRE: vehiculos = A ; viejoDni = D ; dni = D1
   --POST: vehiculos = A1; A1 en A salvo los clientes en A con dni igual a D, que ahora tienen dni igual a D1
   --EXCEP: - 
   procedure actualizarVC(vehiculos: in out arbolVehiculos.tipoArbol ; viejoDni,dni:in tipoClaveClientes) is
      colaVehiculos:arbolVehiculos.ColaRecorridos.tipoCola;
      datosVehiculo:tipoInfoVehiculos;
      patente:tipoClaveVehiculos;
   begin
      arbolVehiculos.ColaRecorridos.crear(colaVehiculos);
      arbolVehiculos.inOrder(vehiculos, colaVehiculos);

      while (not(arbolVehiculos.ColaRecorridos.esVacia(colaVehiculos))) loop
         arbolVehiculos.ColaRecorridos.frente(colaVehiculos,patente);
         arbolVehiculos.ColaRecorridos.desencolar(colaVehiculos);

         arbolVehiculos.buscar(vehiculos,patente, datosVehiculo);

         if datosVehiculo.dueño = viejoDni then
            datosVehiculo.dueño := dni;
            arbolVehiculos.modificar(vehiculos,patente, datosVehiculo);
         end if;
      end loop;
   end actualizarVC;

   --Qué Hace: genera el codigo de modelo correspondiente a un nuevo modelo
   --PRE: model = M
   --POST:generarCodigoModelo = CM ; CM es un codigo de modelo valido
   --EXCEP:
   function generarCodigoModelo(model: in listaModelos.tipoLista) return tipoClaveModelos is
      codigo:tipoClaveModelos;
   begin
      if (listaModelos.esVacia(model)) then
         return 1;
      else
         listaModelos.recuUlt(model,codigo);
         return (codigo + 1);
      end if;
   end generarCodigoModelo;


   --Qué Hace: obtiene un codigo válido de modelo
   --PRE: model = M
   --POST: obtenerModelo=N y N es un modelo valido
   --EXCEP: noHayModelos,cancelarIngreso
   function obtenerModelo(model: in listaModelos.tipoLista) return  tipoClaveModelos is
      ok:Boolean;
      modelo:tipoClaveModelos;
      dm:tipoInfoModelos;
   begin
      if (listaModelos.esVacia(model)) then
         raise NoHayModelos;
      else
         ok := False;

         loop
            modelo:=enteroMayorIgualACero("Ingrese codigo de modelo (0 para cancelar ingreso)");

            if (modelo = 0) then
               raise cancelarIngreso;
            else
               begin
                  listaModelos.recuClave(model,modelo, dm);
                  ok := True;
               exception
                     when listaModelos.claveNoExiste => Put_Line("Codigo de Modelo invalido");
               end;
            end if;
            exit when ok;
         end loop;
      end if;

      return modelo;

   end obtenerModelo;


   --Qué Hace: actualiza los servicios con respecto a las etapas de mantenimiento existentes
   --PRE: serv = S ; calendario = F 
   --POST: 
   --EXCEP: - 
   procedure bajaSMant(serv: in out listaServicios.tipoLista ; calendario: in listaCalendario.tipoLista) is
      codigoServicio,siguiente:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
      datosEtapa:tipoInfoCalendario;
      sigo:Boolean;
   begin -- bajaSMant

      sigo := True;

      listaServicios.recuPrim(serv,codigoServicio);

      begin
         listaServicios.recuSig(serv, codigoServicio, siguiente);
      exception
         when listaServicios.claveEsUltima => siguiente := codigoServicio;
      end;

      while sigo loop
         begin
            listaServicios.recuClave(serv, codigoServicio, datosServicio);

            begin
               listaCalendario.recuClave(calendario, datosServicio.etapa, datosEtapa);
               listaServicios.recuSig(serv, codigoServicio, codigoServicio);
            exception
               when listaCalendario.claveNoExiste =>
                  begin
                     listaServicios.suprimir(serv, codigoServicio);
                     codigoServicio := siguiente;

                     begin
                        listaServicios.recuSig(serv,siguiente, siguiente);
                     exception
                        when listaServicios.claveEsUltima => null;
                     end;
                  end;

            end;
         exception
            when listaServicios.claveNoExiste | listaServicios.claveEsUltima => sigo := False;
         end;
      end loop;
   exception
      when listaServicios.listaVacia  => null;

   end bajaSMant;

   --Qué Hace: actualiza los mantenimientos de cada vehiculos con respecto a los servicios
   --PRE: client = C ; serv = S
   --POST: client = C1 ; C1 en C menos los servicios correspondientes a codigos inexistentes en S
   --EXCEP: - 
   procedure actualizarVS(vehiculos: in out arbolVehiculos.tipoArbol ; serv:in listaServicios.tipoLista) is
      sigo:Boolean;
      patente:tipoClaveVehiculos;
      datosVehiculo:tipoInfoVehiculos;
      colaVehiculos:arbolVehiculos.ColaRecorridos.tipoCola;
      siguiente:tipoClaveMantenimientos;
      mantenimiento:tipoClaveMantenimientos;
      datosServicio:tipoInfoServicios;
   begin -- actualizarVS
      arbolVehiculos.ColaRecorridos.crear(colaVehiculos);
      arbolVehiculos.inOrder(vehiculos,colaVehiculos);
      
      while(not(arbolVehiculos.ColaRecorridos.esVacia(colaVehiculos))) loop
         arbolVehiculos.ColaRecorridos.frente(colaVehiculos,patente);
         arbolVehiculos.ColaRecorridos.desencolar(colaVehiculos);
         arbolVehiculos.buscar(vehiculos, patente, datosVehiculo);
         
         begin
            listaMantenimientos.recuPrim(datosVehiculo.manten, mantenimiento);
            
            begin
               listaMantenimientos.recuSig(datosVehiculo.manten, mantenimiento,siguiente);
            exception
               when listaMantenimientos.claveEsUltima => siguiente := mantenimiento;
            end;
            
            sigo := True;
            
            while sigo loop
               begin
                  begin
                     listaServicios.recuClave(serv, mantenimiento, datosServicio);
                     listaMantenimientos.recuSig(datosVehiculo.manten, mantenimiento,mantenimiento);
                  exception
                     when listaServicios.claveNoExiste =>
                        begin
                           listaMantenimientos.suprimir(datosVehiculo.manten, mantenimiento);
                           mantenimiento := siguiente;
                        end;
                  end;
                  
                  
                  begin
                     listaMantenimientos.recuSig(datosVehiculo.manten, siguiente, siguiente);
                  exception
                     when listaMantenimientos.claveEsUltima => null;
                  end;
                  
               exception
                  when listaMantenimientos.claveEsUltima | listaMantenimientos.claveNoExiste => sigo :=False;
               end;
            end loop;
         exception
            when listaMantenimientos.listaVacia => null;
         end;
      end loop;
   end actualizarVS;
   
   --Que Hace: vacia las estructuras de un modelo en particular
   --PRE: model = M ; codigoModelo = K
   --POST: model = M1 ; M1 en M, salvo el modelo de codigo K que tiene ese modelo con las estructuras vacias
   --EXCEP: -
   procedure limpiarModelo(model: in out listaModelos.tipoLista ; codigoModelo: in tipoClaveModelos) is
      datosModelo:tipoInfoModelos;
   begin
      listaModelos.recuClave(model, codigoModelo, datosModelo);
      listaCalendario.vaciar(datosModelo.calendario);
      
      listaModelos.modificar(model, codigoModelo, datosModelo);
   end;
   
   --Que Hace: Devuelve una patente valida
   --PRE: - 
   --POST:obtenerCadena = P ;P es una patente valida
   --EXCEP:cancelarIngreso
   function obtenerPatente return tipoClaveVehiculos is
      letras:Unbounded_String;
      numeros:integer;
   begin
      loop

         letras := To_Unbounded_String(textoNoVacio("Ingrese Letras (0 para cancelar ingreso)"));
         if letras = "0" then
            raise cancelarIngreso;
         end if;
         
         exit when ((letras <= "ZZZ") and (letras >= "AAA"));
      end loop;
      
      loop
         numeros := enteroMayorIgualACero("Ingrese numeros");
         exit when (numeros <= 999);
      end loop;
      return (letras & Integer'Image(numeros));
   end;
   
   --Que Hace: devuelve un vehiculo valido de una lista de vehiculos
   --PRE: vehiculos = L
   --POST: obtenerVehiculo = A ; A pertence a  L
   --EXCEP: noHayVehiculos - cancelarIngreso
   function obtenerVehiculo (vehiculos: in arbolVehiculos.tipoArbol) return tipoClaveVehiculos is
      ok:Boolean;
      patente:tipoClaveVehiculos;
      datosVehiculo:tipoInfoVehiculos;
   begin
      ok := False;
      if(arbolVehiculos.esVacio(vehiculos)) then
         raise noHayVehiculos;
      else
         loop
            patente:= obtenerPatente;
            begin
               arbolVehiculos.buscar(vehiculos,patente, datosVehiculo);
               ok := True;
            exception
               when arbolVehiculos.claveNoExiste => Put_Line("Vehiculo inexistente");
            end;
            exit when ok;
         end loop;
      end if;

      return patente;
   end obtenerVehiculo;

   --Que hace: devuelve un vehiculo perteneciente a un cliente en particular
   --PRE: Vehiculos = A; dni = D
   --POST: obtenerVehiculoCliente = O ; O pertenece a A y D es dueño de O
   --EXCEP: -
   function obtenerVehiculoCliente (vehiculos: in arbolVehiculos.tipoArbol ; dni: in tipoClaveClientes) return tipoClaveVehiculos is
      patente:tipoClaveVehiculos;
      datosVehiculo:tipoInfoVehiculos;
   begin
      loop
         Put_line("Dominio del vehiculo a realizarle el mantenimiento");
         patente := obtenerVehiculo(vehiculos);
         arbolVehiculos.buscar(vehiculos, patente, datosVehiculo);
         exit when datosVehiculo.dueño = dni;
      end loop;

      return patente;
   end obtenerVehiculoCliente;

   --Que Hace: quita los servicios pertenecientes a vehiculos inexistentes
   --PRE: serv = S ; patente = P
   --POST: serv = S1 ; S1 en S menos los servicios realizados a vehiculos de patente P
   --EXCEP: - 
   procedure bajaSV(serv: in out listaServicios.tipoLista; patente: in tipoClaveVehiculos) is
      siguiente: tipoClaveServicios;
      sigo:Boolean;
      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
   begin
      sigo:= True;
      listaServicios.recuPrim(serv, codigoServicio);

      begin
         listaServicios.recuSig(serv, codigoServicio, siguiente);
      exception
            when listaServicios.claveEsUltima => siguiente := codigoServicio;
      end;

      while sigo loop
         begin
            listaServicios.recuClave(serv, codigoServicio, datosServicio);

            if datosServicio.dominio = patente then
               listaServicios.suprimir(serv, codigoServicio);
               codigoServicio := siguiente;

               begin
                  listaServicios.recuSig(serv, siguiente, siguiente);
               exception
                  when listaServicios.claveEsUltima => null;
               end;
            else
               listaServicios.recuSig(serv,codigoServicio, codigoServicio);

               begin
                  listaServicios.recuSig(serv, siguiente, siguiente);
               exception
                  when listaServicios.claveEsUltima => null;
               end;
            end if;
         exception
            when listaServicios.claveNoExiste | listaServicios.claveEsUltima => sigo := False;
         end;
      end loop;
   exception
         when listaServicios.listaVacia => null;
   end;
   
   --Qué Hace: elimina todos lo vehiculos pertenecientes a un mismo cliente
   --PRE: vehiculos = A ; dni = D
   --POST: vehiculos = A1 ; A1 en A menos los vehiculos que pertenecían a D
   --EXCEP: - 
   procedure bajaVC(vehiculos: in out arbolVehiculos.tipoArbol ; dni: in tipoClaveClientes) is
      colaVehiculos:arbolVehiculos.ColaRecorridos.tipoCola;
      patente:tipoClaveVehiculos;
      datosVehiculo:tipoInfoVehiculos;
   begin
      arbolVehiculos.ColaRecorridos.crear(colaVehiculos);

      while (not(arbolVehiculos.ColaRecorridos.esVacia(colaVehiculos))) loop
         arbolVehiculos.ColaRecorridos.frente(colaVehiculos,patente);
         arbolVehiculos.ColaRecorridos.desencolar(colaVehiculos);

         arbolVehiculos.buscar(vehiculos, patente, datosVehiculo);

         if(datosVehiculo.dueño = dni) then
            arbolVehiculos.suprimir(vehiculos, patente);
         end if;
      end loop;
   end bajaVC;

   --Que Hace: devuelve un nuevo codigo de servicio valido
   --PRE: serv = S
   --POST: generarCodigoServicio = K ; K es un codigo valido en S
   --EXCEP: - 
   function generarCodigoServicio(serv: in listaServicios.tipoLista) return tipoClaveServicios is
      codigo: tipoClaveServicios;
   begin
      if (listaServicios.esVacia(serv)) then
         codigo := 1;
      else
         listaServicios.recuUlt(serv,codigo);
         codigo := codigo + 1;
      end if;
      return codigo;
   end;

   --Que Hace: devuelve una etapa del calendario de mantenimientos valida correspondiente a un modelo
   --PRE: model = M ; vehiculos = A ; dominio = D ; D pertenece a A
   --POST: obtenerEtapaValida = E ; E es una etapa valida al vehiculo de dominio D, perteneciente a A con modelo en M
   --EXCEP: noHayEtapas - cancelarIngreso}
   function obtenerEtapaValida(model: in listaModelos.tipoLista ; vehiculos: in arbolVehiculos.tipoArbol ; dominio: in tipoClaveVehiculos) return tipoClaveCalendario is
      datosModelo:tipoInfoModelos;
      ok:Boolean;
      etapa:tipoClaveCalendario;
      datosEtapa:tipoInfoCalendario;
      datosVehiculo:tipoInfoVehiculos;
   begin
      ok := False;


      loop
         arbolVehiculos.buscar(vehiculos, dominio,datosVehiculo);
         listaModelos.recuClave(model, datosVehiculo.modelo, datosModelo);

         if (listaCalendario.esVacia(datosModelo.calendario)) then
            raise noHayEtapas;
         else
               etapa := enteroMayorIgualACero("Ingrese etapa de mantenimiento");
               if etapa = 0 then
                  raise cancelarIngreso;
               else
                  begin

                     listaCalendario.recuClave(datosModelo.calendario,etapa, datosEtapa);

                     ok := true;

                  exception

                     when listaCalendario.claveNoExiste => Put_Line("Etapa Invalida");

                  end;


            end if;
         end if;

         exit when ok;
      end loop;

      return etapa;
   end obtenerEtapaValida;

   --Que Hace: obtiene un kiloemtraje real para poder realizar un mantenimiento 
   --PRE: model = M ; vehiculos = A ; dominio = D ; etapa = T;  D pertenece a A, y el modelo del auto con dominio D pertenece a M y T es una etapa de mantenimiento valida para este
   --POST: obtnerKmReal = K ; K esta entre T y la proxima etapa para ese modelo
   --EXCEP: - 
   function obtenerKmReal(model: in listaModelos.tipoLista ; vehiculos: in arbolVehiculos.tipoArbol ;dominio: in tipoClaveVehiculos; etapa: in tipoClaveCalendario) return integer is
      etapaSiguiente:tipoClaveCalendario;
      km:integer;
      ok:Boolean;
      datosModelo:tipoInfoModelos;
      datosVehiculo:tipoInfoVehiculos;
   begin
      arbolVehiculos.buscar(vehiculos, dominio, datosVehiculo);
      listaModelos.recuClave(model, datosVehiculo.modelo, datosModelo);

      ok := False;

      loop

         km:=enteroMayorIgualACero("Ingrese kilometraje");
         if km >= etapa then
            begin
               listaCalendario.recuSig(datosModelo.calendario, etapa, etapaSiguiente);
               if((km >= etapa) and (km <= etapaSiguiente)) then
                  ok := True;
               else
                  Put_Line("Kilometraje Invalido");
               end if;
            exception
               when listaCalendario.claveEsUltima => ok := True;
            end;
         else
            Put_Line ("Kilometraje Invalido");
         end if;
         
         exit when ok;
      end loop;
      return km;
   end;

   --Que Hace: da de alta un servicio en la lista de mantenimientos de un vehiculos
   --PRE: client = C; codigoServicio = K ; datosServicio = S ; S es los datos del servicio K y el vehiculos al cual sele realizo el servicio K es de un cliente que esta en C
   --POST: client = C1 ; C1 en C mas el servicio con codigo K hecho a un vehiculo perteneciente a un cliente
   --EXCEP: -
   procedure altaSV(vehiculos: in arbolVehiculos.tipoArbol ; codigoServicio: in tipoClaveServicios ; datosServicio: in tipoInfoServicios) is
      datosVehiculo:tipoInfoVehiculos;
   begin
      arbolVehiculos.buscar(vehiculos, datosServicio.dominio, datosVehiculo);

      listaMantenimientos.insertar(datosVehiculo.manten, codigoServicio, datosServicio.precioFinal);
   exception
      when listaMantenimientos.listaLlena => raise errorAlAgregarServicio;
   end altaSV;
   
   --Qué Hace: elimina los vehiculos de modelos inexistentes y los servicios realizados a dichos vehiculos
   --PRE: vehiculos = A ; serv = S ; codigoModelos = K ; K es un modelos inexistente
   --POST:vehiculos = A1 ; serv = S1 ; A1 en A menos los vehiculos de modelo K, si los hubiesen ; 
   --S1 en S menos los servicios realizados a los vehiculos de modelo K, si los hubiere
   --EXCEP: - 
   procedure bajaVSM(vehiculos: in out arbolVehiculos.tipoArbol ; serv: in out listaServicios.tipoLista; codigoModelo: in tipoClaveModelos) is
      colaVehiculos: arbolVehiculos.ColaRecorridos.tipoCola;
      patente:tipoClaveVehiculos;
      datosVehiculo:tipoInfoVehiculos;

   begin
      arbolVehiculos.ColaRecorridos.crear(colaVehiculos);
      arbolVehiculos.inOrder(vehiculos, colaVehiculos);

      while(not(arbolVehiculos.ColaRecorridos.esVacia(colaVehiculos))) loop
         arbolVehiculos.ColaRecorridos.frente(colaVehiculos, patente);

         arbolVehiculos.ColaRecorridos.desencolar(colaVehiculos);

         arbolVehiculos.buscar(vehiculos, patente, datosVehiculo);

         if (codigoModelo = datosVehiculo.modelo) then
            arbolVehiculos.suprimir(vehiculos, patente);
            bajaSV(serv, patente);
         end if;
      end loop;
   end;

   --que hace: muestra la cabecera de los mantenimientos de un cliente
   --pre: nomCli=N y N no es vacio
   --pos: -
   --exp: -
   procedure mostrarCabeceraMantenPorCliente(nomCli: in Unbounded_String) is
   begin
      Put_Line("Mantenimientos realizador por el cliente:" & To_String(nomCli));
      Put_Line("Codigo servicio Dominio etapa Km Real Fecha de Mantenimiento Precio Final");
   end mostrarCabeceraMantenPorCliente;

   --que hace: muestra los datos de servicio de mantenimiento realizado por un cliente
   --pre: datosServicio=D y D tiene que tener datos validos; codigoServicio=C y tiene un codigo valido
   --pos: -
   --exp: -
   procedure mostrarDatosServicio (datosServicio: in tipoInfoServicios; codigoServicio: in tipoClaveServicios) is
   begin
      Put_Line(Integer'Image(codigoServicio) &
                 " " &
                 To_String(datosServicio.dominio) &
                 " " &
                 Integer'Image(datosServicio.etapa) &
                 " " &
                 Integer'Image(datosServicio.kmReal) &
                 " " &
                 Integer'Image(datosServicio.fecha.dia) &
                 "/" &
                 Integer'Image(datosServicio.fecha.mes) &
                 "/" &
                 Integer'Image(datosServicio.fecha.anio) &
                 "  $" &
                 Integer'Image(datosServicio.precioFinal));
   end  mostrarDatosServicio;

   --que hace: muestra el encabezado de los mantenimientos por modelo
   --pre: nomMod=N y N tiene un nombre de modelo valido
   --pos: -
   --exp: -
   procedure mostrarEncabezadoMantModelo(nomMod: in Unbounded_String) is
   begin
      Put_Line("Mantenimientos realizados al modelo: " &
                 To_String(nomMod));
      Put_Line("Codigo servicio Dni Dueño Dominio etapa Km Real Fecha de Mantenimiento Precio Final");
   end mostrarEncabezadoMantModelo;
   
   --que hace: muestra el encabezado de los clientes sin mantenimientos
   --pre:-
   --pos:-
   --exp:-
   procedure mostrarEncabezadoClientSinMant is
   begin
      Put_Line("Datos de los clientes que no han realizado ningun mantenimiento en sus vehiculos");
      Put_Line("DNI Nombre Telefono E-Mail");
   end mostrarEncabezadoClientSinMant;

   --que hace: muestra los datos de los clientes que no han realizado mantenimientos
   --pre: datosCliente=C y C tiene datos validos
   --pos: -
   --exp: - 
   procedure mostrarDatosCliente(dni: in tipoClaveClientes ; datosCliente: in tipoInfoClientes) is
   begin
      Put_Line(Integer'Image(dni) &
                 To_String(datosCliente.nombre) &
                 " " &
                 Integer'Image(datosCliente.telefono) &
                 " " &
                 To_String(datosCliente.email));
   end;
   
   --que hace: obtiene un codigo valido de servicio
   --pre: servicio=S 
   --pos: obtenerServicio=OS y OS es un codigo valido
   --exp: noHayServicios- cancelarIngreso}
   function obtenerServicio(serv:listaServicios.tipoLista) return tipoClaveServicios is
      ok:Boolean;
      claServ:tipoClaveServicios;
      infoSer:tipoInfoServicios;

   begin
      if (listaServicios.esVacia(serv)) then
         raise noHayServicios;
      else
         ok := False;
         loop
            claServ := enteroMayorIgualACero("Ingrese codigo de servicios (0 para cancelar ingreso)");

            if claServ = 0 then
               raise cancelarIngreso;
            else
               begin
                  listaServicios.recuClave(serv, claServ, infoSer);
                  ok := True;
               exception
                  when listaServicios.claveNoExiste => Put_Line("Codigo de Servicio Invalido");
               end;
            end if;
            exit when ok;
         end loop;
      end if;
      return claServ;
   end obtenerServicio;

   --que hace: obtiene un precio final valido respecto a la etapa de calendario
   --pre: model:M y etapa=E 
   --pos: precio=P y P es un precio valido
   --exp: -
   function obtenerPrecioFinal (model: in listaModelos.tipoLista; vehiculos: in arbolVehiculos.tipoArbol ; datosServicio: in tipoInfoServicios) return integer is
      datosEtapa:tipoInfoCalendario;
      datosVehiculo:tipoInfoVehiculos;
      datosModelo:tipoInfoModelos;
      ok:Boolean;
      precio:integer;
   begin
      ok:= False;

      arbolVehiculos.buscar(vehiculos, datosServicio.dominio, datosVehiculo);
      listaModelos.recuClave(model, datosVehiculo.modelo, datosModelo);

      listaCalendario.recuClave(datosModelo.calendario, datosServicio.etapa, datosEtapa);
      loop
         precio := enteroMayorIgualACero("Ingrese Precio Final");

         ok := precio >= datosEtapa;

         exit when ok;
      end loop;

      return precio;
   end obtenerPrecioFinal;

   --Que hace: obtiene la fecha en la que se realizo el servicio
   --pre: -
   --pos: obtenerFecha=N y N es una fecha valida
   --exp: - 
   procedure obtenerFecha(fecha: out tFecha) is
   begin
      loop
         Put_Line("Ingrese Fecha");
         fecha.dia := enteroEnRango("Dia",1,31);
         fecha.mes := enteroEnRango("Mes",1,12);
         loop
            fecha.anio := enteroMayorIgualACero("Año");
            exit when fecha.anio > 0;
         end loop;
         exit when esFechaCorrecta(fecha);
      end loop;
   end obtenerFecha;

   --Que hace: modifica lo datos del modelo seleccionado por el usuario
   --pre: datosModelos=M 
   --pos: datosModelos=M1
   --exp: - 
   procedure modifModelo(datosModelo: in out tipoInfoModelos) is
      opc:integer;
   begin
      loop
         opc := menuModifModelo;

         case opc is
            when 1 => datosModelo.nombre := To_Unbounded_String(textoNoVacio("Ingrese Nombre de modelo"));
            when 2 => ABMCalendario(datosModelo.calendario);
            when others => null;
         end case;

         exit when opc = 3;
      end loop;
   end modifModelo;
   
   --Que hace: modifica los datos del cliente seleccionado por el usuario
   --pre: datosClientes=C
   --pos: datosClientes=C1
   --exp: -
   procedure modifCliente(dni:in out tipoClaveClientes; datosCliente: in out tipoInfoClientes) is
      opc:integer;
   begin
      loop
         opc:= menuModifCliente;
         case opc is
            when 1 =>
               begin
                  loop
                     dni := enteroMayorIgualACero("Ingrese DNI");
                     exit when dni > 0;
                  end loop;
               end;
            when 2 => datosCliente.nombre := To_Unbounded_String(textoNoVacio("Ingrese Nombre Completo"));
            when 3 => datosCliente.telefono := enteroMayorIgualACero("Ingrese Telefono");
            when 4 => datosCliente.email := obtenerEmail("Ingrese E-Mail");
            when others => null;
         end case;
         exit when opc = 5;
      end loop;
   end;

   --Que hace: modifica los datos del vehiculo seleccionado por el usuario
   --pre: datosClientes=V
   --pos: datosClientes=V1
   --exp:-
   procedure modifVehiculo(datosVehiculo: in out tipoInfoVehiculos;model: in listaModelos.tipoLista; client: in arbolClientes.tipoArbol) is
      opc:integer;
   begin
      loop
         opc := menuModifVehiculos;

         case opc is
            when 1 => datosVehiculo.modelo:= obtenerModelo(model);
            when 2 =>
               begin
                  loop
                     datosVehiculo.añoFabri := enteroMayorIgualACero("Ingrese nuevo año de fabricacion");
                     exit when datosVehiculo.añoFabri > 0;
                  end loop;
               end;
            when 3 => datosVehiculo.dueño := obtenerCliente(client);
            when others => null;
         end case;
         exit when opc = 4;
      end loop;
   end modifVehiculo;



   --nivel 2


   --Qué Hace: muestra el menu con las opciones correspondientes al ABM de modelos
   --PRE: -
   --POST: menuModelos = O; O es una opcion valida
   --EXCEP:
   function menuModelos return integer is
   begin
      Put_Line("Modelos");
      Put_Line("1 - Agregar Modelo");
      Put_Line("2 - Modificar Modelo (Nombre o etapas de su calendario de mantenimiento");
      Put_Line("3 - Quitar Modelo");
      Put_Line("4 - Volver al menu anterior");
      return enteroEnRango("Ingrese su opción",1,4);
   end menuModelos;

   --Qué Hace: crea un nuevo modelo
   --PRE: model = Mo ; Mo puede estar vacío o tener modelos válidos
   --POST: model = Mo1; Mo1 tiene un modelo válido más que Mo
   --EXCEP:
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
   
   --Qué Hace: agrega un nuevo cliente
   --PRE: client = C ; C puede estar vacío o tener clientes válidos
   --POST: client = C1 ; C1 tiene un cliente nuevo agregado
   --EXCEP: - 
   procedure agregarCliente(client: in out arbolClientes.tipoArbol) is
      datosCliente:tipoInfoClientes;
      dni:tipoClaveClientes;
   begin
      dni := enteroMayorIgualACero("Ingrese DNI de cliente (0 para cancelar el ingreso)");
      if dni = 0 then
         raise cancelarIngreso;
      end if;
      begin
         arbolClientes.buscar(client,dni, datosCliente);
         Put_Line("Cliente ya existe");
      exception
         when arbolClientes.claveNoExiste =>
            begin
               datosCliente.nombre := To_Unbounded_String(textoNoVacio("Ingrese Nombre del Cliente"));
               loop
                  datosCliente.telefono := enteroMayorIgualACero("Ingrese Telefono");
                  exit when datosCliente.telefono > 0;
               end loop;

               datosCliente.email := obtenerEmail("Ingrese E-Mail");
               arbolClientes.insertar(client, dni, datosCliente);
            end;
      end;
   exception
      when cancelarIngreso => null;

      when arbolClientes.arbolLleno => Put_Line("No se puede insertar un cliente en este momento, intente nuevamente más tarde");
   end agregarCliente;

   --Qué Hace: permite modificar los datos pertenecientes a un cliente en particular
   --PRE: client = C ; vehiculos = A ; serv = S ; 
   --POST: client = C1 ; C1 contiene un cliente con los datos modificados o no
   --EXCEP: - 
   procedure modificarCliente(client: in out arbolClientes.tipoArbol; vehiculos: in out arbolVehiculos.tipoArbol; serv: in out listaServicios.tipoLista) is
      dni:tipoClaveClientes;
      viejoDni:tipoClaveClientes;
      datosCliente:tipoInfoClientes;
   begin
      viejoDni := obtenerCliente(client);
      arbolClientes.buscar(client,viejoDni,datosCliente);
      dni := viejoDni;
      modifCliente(dni,datosCliente);

      if (dni /= viejoDni) then
         arbolClientes.insertar(client, dni, datosCliente);
         arbolClientes.suprimir(client, viejoDni);
         actualizarSC(serv,viejoDni,dni);
         actualizarVC(vehiculos,viejoDni,dni);
      else
         arbolClientes.modificar(client, viejoDni, datosCliente);
      end if;

   exception
         when arbolClientes.arbolLleno => Put_Line("No se puede modificar el cliente en este momento.Intente nuevamente más tarde");
      when noHayClientes => Put_Line("No hay clientes agregados. Agregue un cliente e intente nuevamente");
      when cancelarIngreso => null;
   end modificarCliente;

   --Qué Hace: quita un cliente y actualiza su relación con respecto a los servicios a su nombre
   --PRE: client = C ; C tiene que tener al menos un cliente válido ; serv = S 
   --POST: client = C1 ; C1 tiene un cliente menos ; serv = S1 ; S1 tiene uno o más servicios menos si el cliente eliminado tenía algún servicio a su nombre
   --EXCEP: - 
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
   end quitarCliente;

   --Qué Hace: Permite modificar los datos correpondientes a un modelo en particular y actualiza las relaciones de dicho modelos con los clientes y los servicios realizados
   --PRE: model = M ; M contiene al menos un modelo ; serv = S ; vehiculos = A
   --POST: model = M1 ; serv = S1 ; vehiculos = A1  ; M1, S1, A1 tiene cambios con respecto a M, S y A (respectivamente), segun lo haya deseado el usuario
   --EXCEP: -
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
   end modificarModelo;

   --Qué Hace: quita un modelo y actualiza su relacion con los clientes y los servicios
   --PRE: model = M ; M tiene al menos un modelo ; serv = S ; vehiculos = A
   --POST: model = M1 ; M1 tiene un modelo menos ; serv = S1 ; vehiculos = A1 ; C1 y S1 
   --tienen clientes o servicios menos si el modelo eliminado tenia servicios relacionados o un 
   --cliente tenía un vehiculo de ese modelo en particular
   --EXCEP: - 
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
   end quitarModelo;

    --Que Hace: agrega un vehiculo para un cliente determinado
   --PRE: vehiculos = A ; client = C ; model = M; 
   --POST: vehiculos = A1 ; A1 tiene un vehiculo mas con respecto a A
   --EXCEP: - 
   procedure agregarVehiculo (vehiculos: in out arbolVehiculos.tipoArbol;
                              model: in listaModelos.tipoLista;
                              client: in arbolClientes.tipoArbol) is
      datosVehiculo:tipoInfoVehiculos;
      patente:tipoClaveVehiculos;
   begin
      CLS;
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
                  loop
                     datosVehiculo.añoFabri := enteroMayorIgualACero("Ingrese año de fabricacion");
                     exit when datosVehiculo.añoFabri > 0;
                     end loop;
                  listaMantenimientos.crear(datosVehiculo.manten);
                  arbolVehiculos.insertar(vehiculos, patente, datosVehiculo);
               end;
         end;
      end if;
   exception
      when arbolVehiculos.arbolLleno => Put_Line("No se puede agregar un vehiculo en este momento. Intente nuevamente mas tarde");
      when noHayClientes => Put_Line("No hay clientes. Agregue uno e intente nuvamente más tarde");
      when noHayModelos => Put_Line("No existen modelos. Agregue uno e intente nuevamente mas tarde");
      when cancelarIngreso => null;
   end agregarVehiculo;

   --Que Hace: modifica los vehiculos pertenecientes a un cliente en particular
   --PRE: vehiculos = A ; client = C; model = M;
   --POST: vehiculos = A1 ; A1 tiene cambios con respecto a A segun lo hay deseado el usuario
   --EXCEP: -
   procedure modificarVehiculo(vehiculos: in out arbolVehiculos.tipoArbol; client: in arbolClientes.tipoArbol ; model: in listaModelos.tipoLista) is

      datosVehiculo:tipoInfoVehiculos;
      patente:tipoClaveVehiculos;
   begin
      CLS;
      patente := obtenerVehiculo(vehiculos);
      arbolVehiculos.buscar(vehiculos, patente, datosVehiculo);
      modifVehiculo(datosVehiculo, model, client);
      arbolVehiculos.modificar(vehiculos, patente, datosVehiculo);
   exception
      when noHayVehiculos => Put_Line("No existen vehiculos. Agregue uno e intente nuevamente más tarde");
      when cancelarIngreso => null;
   end modificarVehiculo;
   
   --Que Hace: elimina un vehiculo de un cliente
   --PRE: client = C ; dni = K ; K pertenece a C ; serv = S
   --POST: client = C1 ; C1 tiene un vehiculo menos segun haya deseado el usuario
   --EXCEP: - 
   procedure quitarVehiculo(vehiculos: in out arbolVehiculos.tipoArbol; serv:in out listaServicios.tipoLista) is
      patente:tipoClaveVehiculos;
   begin
      patente := obtenerVehiculo(vehiculos);

      arbolVehiculos.suprimir(vehiculos, patente);

      bajaSV(serv,patente);
   end quitarVehiculo;
   
   --Qué Hace: agrega un nuevo servicio realizado a un vehiculo en particular
   --PRE:	serv = S ; client = C ; model = M ; vehiculos = A
   --POST:	serv = S1 ; S1 tiene un nuevo servicio según lo haya querido el usuario
   --EXCEP:	
   procedure agregarServicio(serv: in out listaServicios.tipoLista;
                             client: in arbolClientes.tipoArbol;
                             model: in listaModelos.tipoLista;
                             vehiculos: in out arbolVehiculos.tipoArbol) is

      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
   begin
      CLS;
      codigoServicio := generarCodigoServicio(serv);

      datosServicio.dniCliente := obtenerCliente(client);
      datosServicio.dominio := obtenerVehiculoCliente(vehiculos, datosServicio.dniCliente);
      datosServicio.etapa := obtenerEtapaValida(model, vehiculos, datosServicio.dominio);
      datosServicio.kmReal := obtenerKmReal(model,vehiculos, datosServicio.dominio, datosServicio.etapa);
      obtenerFecha(datosServicio.fecha);
      datosServicio.precioFinal := obtenerPrecioFinal(model,vehiculos, datosServicio);

      listaServicios.insertar(serv,codigoServicio,datosServicio);

      altaSV(vehiculos, codigoServicio, datosServicio);

   exception
      when errorAlAgregarServicio | listaServicios.listaLLena => Put_Line("No se puede agregar sevicio en este momento. Intente nuevamente más tarde");
      when noHayEtapas => Put_Line("El modelo seleccionado no posee etapas en su calendario de mantenimientos. Agregue una e intente nuevamente");
      when noHayClientes => Put_Line("No hay clientes agregados. Agregue uno e intente nuevamente");
      when noHayVehiculos => Put_Line("El cliente no tiene vehiculos a su nombre. Agregue uno e intente nuevamente");
      when cancelarIngreso => null;
   end agregarServicio;

   --Qué Hace: modifica los datos de un servicio de mantenimiento en particular
   --PRE: serv = S ; client = C ; model = M ; vehiculos = A 
   --POST: serv = S1 ; client = C1 ; model = M1 ; vehiculos = A1 ; S1, A1 tienen cambios con respecto a S1 y A1 segun lo haya deseado el usuario
   --EXCEP:	- 
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
            CLS;
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
               when others => opc := enteroEnRango("Ingrese opción",1,7);
            end case;
            -- seleccion de opciones
            case opc is
               when 1 => datosServicio.dniCliente := obtenerCliente(client);
               when 2 => datosServicio.dominio := obtenerVehiculoCliente(vehiculos, datosServicio.dniCliente);
               when 3 => datosServicio.etapa := obtenerEtapaValida(model, vehiculos, datosServicio.dominio);
               when 4 => obtenerFecha(datosServicio.fecha);
               when 5 => datosServicio.precioFinal:= obtenerPrecioFinal(model, vehiculos, datosServicio);
               when 6 => datosServicio.kmReal:= obtenerKmReal(model, vehiculos, datosServicio.dominio, datosServicio.etapa);
                  when others => null;
            end case;
            exit when opc = 7;
         exception
               when cancelarIngreso => null;
         end;
      end loop;
      listaServicios.modificar(serv,codigoServicio,datosServicio);
      if viejoDominio /= datosServicio.dominio then
         bajaSV(serv, viejoDominio);
      end if;
   exception
      when noHayServicios => Put_Line("No existen servicios. Agregue uno e intente nuevamente");
      when cancelarIngreso => null;
   end modificarServicio;
   
   --Qué Hace: elimina un servicio
   --PRE: serv = S; client = C
   --POST: serv = S1 ; client = C1; S1 es distinto de S y C1 distinto de C según lo haya decidido el usuario
   --EXCEP: - 
   procedure quitarServicio (serv: in out listaServicios.tipoLista ; vehiculos: in out arbolVehiculos.tipoArbol) is
      codigoServicio:tipoClaveServicios;
      datosServicio: tipoInfoServicios;
   begin
      codigoServicio := obtenerServicio(serv);
      listaServicios.recuClave(serv, codigoServicio, datosServicio);
      listaServicios.suprimir(serv,codigoServicio);
      bajaSV(serv, datosServicio.dominio);
   exception
      when noHayServicios => Put_Line("No existen servicios. Agregue uno e intente nuevamente mas tarde");
      when cancelarIngreso => null;
   end quitarServicio;
   
   --Qué Hace: muestra por pantalla los mantenimientos realizados por un mismo cliente
   --PRE: client = C ; serv = S
   --POST: - 
   --EXCEP: - 
   procedure mantenPorCliente(client: in arbolClientes.tipoArbol;
                              serv: in listaServicios.tipoLista) is
      total:integer;
      sigo:Boolean;
      codigoServicio:tipoClaveServicios;
      datosServicio:tipoInfoServicios;
      dni:tipoClaveClientes;
      datosCliente:tipoInfoClientes;
   begin
      CLS;
      total:=0;
      dni:=obtenerCliente(client);
      arbolClientes.buscar(client,dni,datosCliente);
      sigo:=True;
      listaServicios.recuPrim(serv,codigoServicio);
      mostrarCabeceraMantenPorCliente(datosCliente.nombre);
      while sigo loop
         begin
            listaServicios.recuClave(serv,codigoServicio,datosServicio);
            if (datosServicio.dniCliente = dni) then
               mostrarDatosServicio(datosServicio,codigoServicio);
               total:=total+1;
            end if;
            listaServicios.recuSig(serv,codigoServicio,codigoServicio);
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

   --Qué Hace: muestra por pantalla los mantenimientos realizados para un mantenimiento en particular
   --PRE: model = M ; serv: S ; client = C
   --POST: -
   --EXCEP: -
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
      CLS;
      codigoModelo:=obtenerModelo(model);
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
                  mostrarDatosServicio(datosServicio,codigoServicio);
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
   
   --Qué Hace: muestra por pantalla los datos de los clientes sin mantenimientos
   --PRE: client = C ; serv = S
   --POST: - 
   --EXCEP: - 
  procedure datosClientesSinMant(client: in arbolClientes.tipoArbol; serv: in listaServicios.tipoLista) is
     	muestro:boolean;
	total:integer;
	sigo:boolean;
	colaClientes:arbolClientes.ColaRecorridos.tipoCola;
      dni:tipoClaveClientes;
      datosServicio:tipoInfoServicios;
      codigoServicio:tipoClaveServicios;
      datosCliente:tipoInfoClientes;
   begin
      CLS;
         arbolClientes.ColaRecorridos.crear(colaClientes);
         muestro:= true;
	 total:= 0;
         arbolClientes.inOrder(client, colaClientes);
         mostrarEncabezadoClientSinMant;
         while not(arbolClientes.ColaRecorridos.esVacia(colaClientes)) loop
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

   --Qué Hace: muestra el menu con las opciones correspondientes al ABM de vehiculos
   --PRE: -
   --POST: menuVehiculos = O ; O es una opción válida
   --EXCEP: -
  function menuVehiculos return integer is

  begin
         Put_Line("Seleccione una opcion");
         Put_Line("1 - Agregar un Vehículo");
         Put_Line("2 - Modificar un Vehículo");
         Put_Line("3 - Quitar un Vehículo");
         Put_Line("4 - Salir");
         return enteroEnRango("Ingrese su opcion",1,4);
  end menuVehiculos;

   --Qué Hace: muestra el menu con las opciones correspondientes al ABM de clientes
   --PRE: -
   --POST: menuClientes = O ; O es una opcion valida
   --EXCEP: -
  function menuClientes return integer is
  begin
         Put_Line("Seleccione una Opcion");
         Put_Line("1 - Agregar Cliente");
         Put_Line("2 - Modificar Cliente");
         Put_Line("3 - Quitar Cliente");
         Put_Line("4 - Salir") ;
         return enteroEnRango("Ingrese su opcion",1,4);
  end menuClientes;

   --Qué Hace: muestra el menu con las opciones correspondientes al ABM de clientes
   --PRE: -
   --POST: menuServicios = O ; O es una opción valida
   --EXCEP: -
   function menuServicios return integer is
   begin
      Put_Line("Seleccione una Opcion");
      Put_Line("1 - Agregar Servicios");
      Put_Line("2 - Modificar Servicios");
      Put_Line("3 - Quitar Servicios");
      Put_Line("4 - Salir");
      return enteroEnRango("Ingrese su opción",1,4);
   end menuServicios;

   --Qué Hace: muestra el menu con las opciones correspondientes al ABM de clientes
   --PRE: -
   --POST: menuConsultas = O ; O es una opción valida
   --EXCEP: -
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
   
   
   --Qué Hace: muestra el menu con las opciones correspondientes a las tareas a realizar
   --PRE: -
   --POST: menuGeneral = O ; O es una opcion valida
   --EXCEP: - 
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
      return enteroEnRango("Ingrese su opciòn",1,6);
   end menuGeneral;

   --Qué Hace: Permite agregar, modificar, o quitar modelos y etapas de sus calendarios de mantenimientos
   --PRE: model = M ; serv = S ; vehiculos = A ; M, S o A pueden estar vacios o tener informaciones validas
   --POST: model = M1 ; serv = S1 ; vehiculos = A1 ; M1, S1 o A1 han cambiado segun lo que haya querido el usuario
   --EXCEP: - 
   procedure ABMModelos (model: in out listaModelos.tipoLista; serv: in out listaServicios.tipoLista; vehiculos: in out arbolVehiculos.tipoArbol) is
   opc:integer;
   begin
      loop
         CLS;
         opc:=menuModelos;
         Case opc is
            when 1=> agregarModelo(model);
            when 2=> modificarModelo(model,serv,vehiculos);
            when 3=> quitarModelo(model,serv,vehiculos);
               when others => null;
         end case;
         exit when(opc=4);
      end loop;

   end ABMModelos;
   
   
   --Qué Hace: Permite agregar, modificar, o quitar clientes y sus vehículos
   --PRE: 	client = C ; serv = S ; model= M ; vehiculos = A; C,S,M,A pueden estar vacios o tener informacion valida
   --POST:	client = C1 ; serv = S2 ; model = M1 ; vehiculos = A1; C1,S1,M1,A1 tiene cambios con respecto a C,S,M,A (respectivamente, segun lo haya deseado el usuario)
   --EXCEP: -}
   procedure ABMClientes (client: in out arbolClientes.tipoArbol; serv: in out listaServicios.tipoLista; model: in out listaModelos.tipoLista ;vehiculos: in out arbolVehiculos.tipoArbol ) is
   opc:integer;
   begin
      loop
         CLS;
         opc:=menuClientes;
         Case opc is
            when 1=> agregarCliente(client);
            when 2=> modificarCliente(client,vehiculos,serv);
            when 3=> quitarCliente(client,vehiculos,serv);
               when others => null;
         end case;
         exit when(opc=4);
      end loop;

   end ABMClientes;

   
   --Qué Hace: Permite agregar, modificar, o quitar servicios de mantenimiento realizados
   --PRE: client = C ; serv = S ; model= M ; vehiculos = A; C,S,M,A pueden estar vacios o tener informacion valida
   --POST: client = C1 ; serv = S2 ; model = M1 ; vehiculos = A1; C1,S1,M1,A1 tiene cambios con respecto a C,S,M,A (respectivamente, segun lo haya deseado el usuario)
   --EXCEP:	
   procedure ABMServicios (serv: in out listaServicios.tipoLista; client: in out arbolClientes.tipoArbol; model: in out listaModelos.tipoLista;  vehiculos: in out arbolVehiculos.tipoArbol) is
   opc:integer;
   begin
      loop
         CLS;
         opc:=menuServicios;
         Case opc is
            when 1=> agregarServicio(serv,client,model,vehiculos);
            when 2=> modificarServicio(serv,client,model,vehiculos);
            when 3=> quitarServicio(serv,vehiculos);
               when others => null;
         end case;
         exit when(opc=4);
      end loop;

   end ABMServicios;
   
   --Qué Hace: Permite agregar, modificar o quitar vehiculos de los clientes, según el usuario lo desee
   --PRE: vehiculos = A ; A puede estar vacio o tener vehiculos validos;  model = M ; M puede estar vacio o tener modelos validos
   --POST: vehiculos = A1 ; A1 tiene diferencias con respecto a A según lo haya deseado el usuario
   --EXCEP:
   procedure ABMVehiculos (vehiculos: in out arbolVehiculos.tipoArbol;
                           serv: in out listaServicios.tipoLista;
                           model: in out listaModelos.tipoLista;
                           client: in out arbolClientes.tipoArbol) is
   opc:integer;
   begin
      loop
         CLS;
         opc:=menuVehiculos;
         Case opc is
            when 1=> agregarVehiculo(vehiculos,model,client);
            when 2=> modificarVehiculo(vehiculos,client,model);
            when 3=> quitarVehiculo(vehiculos,serv);
               when others => null;
         end case;
         exit when(opc=4);
      end loop;

   end ABMVehiculos;

   --Qué Hace: Permite realizar distintas consultas especificadas
   --PRE: serv = S ; S tiene servicios válidos ; model = M ; M tiene modelos válidos ;
   --client = C ; C tiene clientes válidos
   --POST: - 	
   --EXCEP:
   procedure Consultas(client: in arbolClientes.tipoArbol;
                       model: in listaModelos.tipoLista;
                       serv: in listaServicios.tipoLista;
                       vehiculos: in arbolVehiculos.tipoArbol) is
      opc:integer;
   begin
      loop
         CLS;
         opc := menuConsultas;

         case opc is
            when 1 => mantenPorCliente(client, serv);
            when 2 => mantPorModelo(model, serv, vehiculos);
            when 3 => datosClientesSinMant(client,serv);
               when others => null;
         end case;

         exit when opc = 4;
      end loop;
   end Consultas;


   --nivel 0
begin
   listaModelos.crear(model);
   arbolClientes.crear(client);
   listaServicios.crear(serv);
   arbolVehiculos.crear(vehiculos);
   Loop
      CLS;
      opc := menuGeneral;
      Case opc is
         When 1=>ABMModelos(model,serv,vehiculos);
         When 2=>ABMClientes(client,serv,model,vehiculos);
         When 3=>ABMServicios(serv,client,model,vehiculos);
         When 4=>ABMvehiculos(vehiculos,serv,model,client);
         When 5=>Consultas(client,model,serv,vehiculos);
         when others => null;
      end case;
      exit when (opc=6);
   end loop ;

end tpfinal;
