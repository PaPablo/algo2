with text_IO, unchecked_Deallocation;
use text_IO;

package body cola is

   procedure free is new Unchecked_Deallocation (tipoNodo, tipoPunt);

   procedure crear (q:out tipoCola) is
   begin
      q.frente:=null;
      q.final:=null;
   end crear;


   procedure encolar (q: in out tipoCola; i: in tipoInfo) is
   begin
      raise operacionNoImplementada;
   exception
      when STORAGE_ERROR => raise colaLlena;
   end encolar;


   procedure desencolar (q: in out tipoCola) is

   begin
	raise operacionNoImplementada;
   end desencolar;


   procedure frente(q: in tipoCola; i: out tipoInfo) is
   begin
      raise operacionNoImplementada;
   end frente;


   procedure vaciar(q:in out tipoCola) is

   begin
      raise operacionNoImplementada;
   end vaciar;

   function esVacia(q:in tipoCola) return boolean is
   begin
      return (q.frente=null);
   end esVacia;

end cola;
