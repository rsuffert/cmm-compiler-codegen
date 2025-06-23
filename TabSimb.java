import java.util.ArrayList;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Map;

public class TabSimb
{
    private ArrayList<TS_entry> lista;

    // Used if this is a function's local symbol table
    private int localVarsCount;
    private Map<String, Integer> localVarsOffsets;
    private int paramsCount;
    private Map<String, Integer> paramsOffsets;
    
    public TabSimb( )
    {
        lista = new ArrayList<TS_entry>();
        localVarsCount = paramsCount = 0;
        localVarsOffsets = new HashMap<>();
        paramsOffsets = new HashMap<>();
    }
    
    public void insert( TS_entry nodo ) {
      lista.add(nodo);
      if (nodo.getCls() == TS_entry.Class.LOCAL_VAR)
        localVarsOffsets.put(nodo.getId(), localVarsCount++);
      else if (nodo.getCls() == TS_entry.Class.PARAM)
        paramsOffsets.put(nodo.getId(), paramsCount++);
    }

    public int getLocalVarOffset(TS_entry node) {
        if (node.getCls() != TS_entry.Class.LOCAL_VAR)
            throw new IllegalArgumentException("Node is not a local variable");
        return localVarsOffsets.getOrDefault(node.getId(), -1);
    }

    public int getParamOffset(TS_entry node) {
        if (node.getCls() != TS_entry.Class.PARAM)
            throw new IllegalArgumentException("Node is not a parameter");
        return paramsOffsets.getOrDefault(node.getId(), -1);
    }

    public int getLocalVarsCount() {
        return localVarsCount;
    }

    public int getParamsCount() {
        return paramsCount;
    }
    
    public void listar() {
      int cont = 0;  
      System.out.println("\n\n# Listagem da tabela de simbolos:\n");
      for (TS_entry nodo : lista) {
          System.out.println("# " + nodo);
      }
    }
      
    public TS_entry pesquisa(String umId) {
      for (TS_entry nodo : lista) {
          if (nodo.getId().equals(umId)) {
	      return nodo;
            }
      }
      return null;
    }

	public void geraGlobais() {
          // assume que todas variáveis são globais e inteiras.
	      for (TS_entry nodo : lista) {
                if (nodo.getCls() != TS_entry.Class.GLOBAL_VAR)
                  continue;
	            	System.out.println("_"+nodo.getId()+":"+"	.zero 4");
	            }
	      }

}



