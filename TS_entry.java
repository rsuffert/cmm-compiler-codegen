
/**
 * CMM - Compiler for C--
 * 
 * @authors Ricardo B. Süffert (22103137-0) Gustavo L. Molina (20103003-8)
 * @version 1.0
 */
public class TS_entry
{
   private String id;
   private int tipo;
   private int nElem;
   private int tipoBase;


   public TS_entry(String umId, int umTipo, int ne, int umTBase) {
      id = umId;
      tipo = umTipo;
      nElem = ne;
      tipoBase = umTBase;
   }

   public TS_entry(String umId, int umTipo) {
      this(umId, umTipo, -1, -1);
   }


   public String getId() {
       return id; 
   }

   public int getTipo() {
       return tipo; 
   }
   
   public int getNumElem() {
       return nElem; 
   }

   public int getTipoBase() {
       return tipoBase; 
   }

   
   public String toString() {
       String aux = (nElem != -1) ? "\t array(" + nElem + "): "+tipoBase : "";
       return "Id: " + id + "\t tipo: " + tipo + aux;
   }


}
