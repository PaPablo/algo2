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
		listaServicios.claveEsUltima => siguiente := codigoServicio;
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
					listaServicios.claveEsUltima => null;
				end;
			else
				listaServicios.recuSig(serv,codigoServicio,codigoServicio);
			end if;

		exception
			listaServicios.claveNoExiste | listaServicios.claveEsUltima => sigo := False;
		end;

	end loop;
end bajaSC;


function generarCodigoModelo(model: in listaModelos.tipoLista) return integer is
	codigo:tipoClaveModelos;
begin
	if (listaModelos.esVacia(model)) then 
		return 1;
	else
		listaModelos.recuUlt(model,codigo);
		return (codigo + 1);
	end if;
end generarCodigoModelo;



function obtenerModelo return  is
	ok:Boolean;
	modelo:tipoClaveModelos;
	dm:tipoInfoModelos;
begin
	if (listaModelos.esVacia(model)) then
		raise NoHayModelos;
	else
		ok := False;

		loop
			modelo:numeroEnt("Ingrese codigo de modelo (0 para cancelar ingreso)");

			if (modelo = 0) then
				raise cancelarIngreso;
			else
				begin
					listaModelos.recuClave(modelo,modelo, dm);
					ok := True;
				exception
					listaModelos.claveNoExiste => Put_Line("Codigo de Modelo invalido");
				 end;
			end if;
			exit when ok;
		end loop;

	return modelo;
end obtenerModelo;


procedure bajaSMant(serv: in out listaServicios.tipoLista ; calendario: in listaCalendario.tipoLista) is
	codigoServicio,siguiente:tipoClaveServicios;
	datosServicio:tipoInfoServicios;
	datosEtapa:tipoInfoCalendario;
	sigo:Boolean;
begin -- bajaSMant
	sigo := True;

	begin
		listaServicios.recuPrim(serv, codigoServicio, siguiente);
	exception
		listaServicios.claveEsUltima => siguiente := codigoServicio;
	end;

	while sigo loop
		begin
			listaServicios.recuClave(serv, codigoServicio, datosServicio);

			begin
				listaCalendario.recuClave(calendario, datosServicio.etapa, datosEtapa);
				listaServicios.recuSig(serv, codigoServicio);
			exception	
				listaServicios.claveNoExiste => 
					begin 
						listaServicios.suprimir(serv, codigoServicio)
						codigoServicio := siguiente;

						begin
							listaServicios.recuSig(serv,siguiente, siguiente);
						exception
							listaServicios.claveEsUltima => null;
						end;
					end;

			end;
		exception	
			listaServicios.claveNoExiste | listaServicios.claveEsUltima => sigo := False;
		end;
	end loop;
end bajaSMant;

procedure actualizarVS(vehiculos: in out arbolVehiculos.tipoArbol ; serv:in listaServicios.tipoLista) is
	sigo:Boolean;
	codigoServicio:tipoClaveServicios;
	patente:tipoClaveVehiculos;
	datosVehiculo:tipoInfoVehiculos;
	colaVehiculos:arbolVehiculos.ColaRecorridos.tipoCola;
	siguiente:tipoClaveMantenimientos;
	mantenimiento:tipoClaveMantenimientos;
begin -- actualizarVS
	
end actualizarVS;