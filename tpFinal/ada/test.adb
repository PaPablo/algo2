with utiles,Ada.Text_IO,Ada.Strings.Unbounded;
use Ada.Text_IO, Ada.Strings.Unbounded;

procedure test is
   ok:Boolean;
   texto:Unbounded_String;
   i:integer;
   opc:integer;
begin
   i:=1;
   ok:= False;
   texto := To_Unbounded_String(utiles.textoNoVacio("IngreseTexto"));
   for i in 1.. Length(texto) loop
      ok := ok or Element(texto,i) = '@';
      if ok then
         put_line("si");
      else
         put_line("no");
      end if;

   end loop;

end test;
