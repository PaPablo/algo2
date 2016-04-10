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


procedure ej10 is


   function generarCadena(car: in character; k: in integer) return string is
   i:integer;
   aux: Unbounded_String;
   begin

      i := 1;

      while i <= k loop
         aux := aux & car;
      end loop;

      return To_String(aux);

   end generarCadena;

   procedure combinaciones (str: in out string; n,m: in Integer) is

   begin
      if m = 0 then
         Put_Line(str & generarCadena('0', n));
      elsif m = n then
         Put_Line(str & generarCadena('1', n));
      else
         str := str & '1';
         combinaciones(str, n-1, m-1);
      end if;
   end combinaciones;




begin
   null;
end ej10;
