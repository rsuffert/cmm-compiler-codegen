
/**
 * CMM - Compiler for C--
 * 
 * @authors Ricardo B. Süffert (22103137-0) Gustavo L. Molina (20103003-8)
 * @version 1.0
 */
public class TS_entry
{
   public enum Class { FUNC, PARAM, LOCAL_VAR, GLOBAL_VAR }
   
   private String id;
   private int tipo;
   private Class cls;

   // Functions
   private TabSimb localTS;

   public TS_entry(String umId, int umTipo, Class cls) {
      this.id = umId;
      this.tipo = umTipo; 
      this.cls = cls;
      
      if (cls == Class.FUNC) this.localTS = new TabSimb();
   }

   public String getId() {
       return id; 
   }

   public int getTipo() {
       return tipo; 
   }

   public TabSimb getLocalTS() {
        if (cls != Class.FUNC)
            throw new IllegalStateException("This entry is not a function");
        return localTS;
   }

    public Class getCls() {
         return cls; 
    }
   
   public String toString() {
         return String.format("TS_entry{id=%s, tipo=%d, cls=%s}", id, tipo, cls);
   }


}
