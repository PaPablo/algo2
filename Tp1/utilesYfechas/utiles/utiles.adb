with Ada.Text_IO,
     Ada.Strings.Unbounded,
     Ada.Text_IO.Unbounded_IO,
     Ada.Integer_Text_IO,
     Ada.Float_Text_IO;
use Ada.Text_IO,
    Ada.Strings.Unbounded,
    Ada.Text_IO.Unbounded_IO,
    Ada.Integer_Text_IO,
    Ada.Float_Text_IO;

package body utiles is

   -- Que hace: Muestra un mensaje al usuario y devuelve verdadero o falso.
   -- Precondiciones: m=M
   -- Poscondiciones: confirma = V si el usuario confirma, falso sino.
   function confirma(mensaje: in string) return boolean is
      resp:string(1..1);
   begin
      loop begin
            put_line(mensaje & " (s/n)");
            resp:=get_line;
            exit when resp="s" or resp="S" or resp="n" or resp="N";
         exception
            when CONSTRAINT_ERROR=>
               put_line("Respuesta no valida.");
         end;
      end loop;
      return resp="s" or resp="S";
   end confirma;

   -- Que hace: Muestra un mensaje al usuario y espera a que presione una tecla.
   -- Precondiciones: m = M
   -- Poscondiciones: no tiene.
   procedure continua(mensaje: in string) is
      resp:unbounded_string;
   begin
	null; -- IMPLEMENTAR
   end continua;

   -- Que hace: Muestra un mensaje al usuario y devuelve el entero ingresado.
   -- Precondiciones: m=M
   -- Poscondiciones: numeroEnt = N y N es entero.
   function numeroEnt(mensaje: in string) return integer is
   begin
	null; -- IMPLEMENTAR
   end numeroEnt;

   -- Que hace: Muestra un mensaje al usuario y devuelve el real ingresado.
   -- Precondiciones: m=M
   -- Poscondiciones: numeroReal = R y R es un float.
   function numeroReal(mensaje: in string) return float is
   begin
      null; -- IMPLEMENTAR algoritmo
   end numeroReal;

   -- Que hace: Muestra un mensaje al usuario y devuelve el entero ingresado.
   -- Precondiciones: m=M, rangoInf= RI, rangoSup= RS
   -- Poscondiciones: enteroEnRango = N y RI <= N <= RS.
   function enteroEnRango(mensaje: in string; rangoInf, rangoSup: in integer) return integer is
      resp:integer;
   begin
      loop
         begin
            put_line(mensaje & Integer'image(rangoinf) & " y " & Integer'image(rangosup) & ": ");
            get(resp);
            exit when rangoInf <= resp and resp<=rangoSup;
         exception
            when Data_Error =>
               skip_line;
         end;
      end loop;
      skip_line;
      return resp;
   end enteroEnRango;


   -- Que hace: Muestra un mensaje al usuario y devuelve el real ingresado.
   -- Precondiciones: m=M, rangoInf= RI, rangoSup= RS
   -- Poscondiciones: realEnRango = R y RI <= R <= RS.
   function realEnRango(mensaje: in string; rangoInf, rangoSup: in float) return float is
      resp:float;
   begin
      null; -- IMPLEMENTAR
   end realEnRango;

   -- Que hace: Muestra un mensaje al usuario y devuelve una cadena ingresada.
   -- Precondiciones: m=M
   -- Poscondiciones: textoNoVacio = S y longitud(S) > 0.
   function textoNoVacio(mensaje: in string) return string is
   begin
      null; -- IMPLEMENTAR
   end textoNoVacio;

   -- Que hace: Limpia la pantalla.
   -- Precondiciones: no tiene.
   -- Poscondiciones: no tiene.
   procedure CLS is
   begin
      Ada.Text_IO.put(ASCII.ESC & "[2J");
   end CLS;

end utiles;
