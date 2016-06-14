with estructuras, Ada.Text_IO, utiles;
use estructuras, Ada.Text_IO;

package body nivel1 is

   function menuGeneral return integer is
   begin
      Put_Line("");
      return utiles.numeroEnt("Ingrese Opcion");
   end;

end nivel1;
