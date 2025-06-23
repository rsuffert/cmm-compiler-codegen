	
%{
  import java.io.*;
  import java.util.ArrayList;
  import java.util.Stack;
  import java.util.Map;
  import java.util.HashMap;
%}
 

%token ID, INT, FLOAT, BOOL, NUM, LIT, VOID, MAIN, READ, WRITE, IF, ELSE
%token WHILE,TRUE, FALSE, IF, ELSE, DO, FOR, CONTINUE, BREAK
%token FUNC, RETURN

%token EQ, LEQ, GEQ, NEQ 
%token AND, OR
%token INC, DEC
%token ADDEQ

%right '=' ADDEQ
%right '?' ':'
%left OR
%left AND
%left EQ NEQ
%left  '>' '<' LEQ GEQ
%left '+' '-'
%left '*' '/' '%'
%right '!'
%left INC DEC

%type <sval> ID
%type <sval> LIT
%type <sval> NUM
%type <ival> type


%%

prog : { geraInicio(); } lVarDecl lFunc mainF { geraAreaDados(); geraAreaLiterais(); } ;

lFunc : lFunc func
	  |
	  ;

func : FUNC type ID { ts.insert(new TS_entry($3, $2, TS_entry.Class.FUNC)); currFuncDecl = $3; }
	   '(' lParamDecl ')'
	   '{'
	   		{ System.out.println("_" + $3 + ":"); } // function label
	   		lVarDecl
	   		{ generateFuncCalleePrologueSteps($3); }
			// Step 7 (CALLEE): Execute function body
	   		lcmd
			returnStmt
	   '}'
	   { currFuncDecl = null; }
	 ;

lParamDecl : /* empty */
           | lParamList
lParamList : type ID {
						TS_entry funcEntry = ts.pesquisa(currFuncDecl);
						if (funcEntry != null) {
							funcEntry.getLocalTS().insert(new TS_entry($2, $1, TS_entry.Class.PARAM));
						}
					 }
           | lParamList ',' type ID {
										TS_entry funcEntry = ts.pesquisa(currFuncDecl);
										if (funcEntry != null) {
											funcEntry.getLocalTS().insert(new TS_entry($4, $3, TS_entry.Class.PARAM));
										}
		   							}

returnStmt : RETURN exp ';' {
								System.out.println("\tPOPL %EAX"); // function return val
								generateFuncCalleeEpilogueSteps();
							}
		   | RETURN ';' { generateFuncCalleeEpilogueSteps(); }
		   ;

mainF : VOID MAIN '(' ')'   { System.out.println("_start:"); }
        '{' lcmd  { geraFinal(); } '}'
         ; 

lVarDecl : decl lVarDecl | ;

decl : type ID ';' { handleVarDecl($1, $2); }
     ;

type : INT    { $$ = INT; }
     | FLOAT  { $$ = FLOAT; }
     | BOOL   { $$ = BOOL; }
     ;

lcmd : lcmd cmd
	   |
	   ;

for_opt_exp: exp
       | //se vazio, siga em frente com o for
       ;

for_cond: exp
        | { System.out.println("\tPUSHL $1");}//se a condicao estiver vazia, siga em frente com o for como verdadeira
        ;	   

cmd :  exp { System.out.println("\tPOPL %EAX"); } ';' // permitir qualquer expressao (inclusive sem efeito colateral, como "42;") como cmd

      | WRITE '(' LIT ')' ';' { strTab.add($3);
                                System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX"); 
				System.out.println("\tMOVL $_str_"+strCount+", %ECX"); 
                                System.out.println("\tCALL _writeLit"); 
				System.out.println("\tCALL _writeln"); 
                                strCount++;
				}
      
	  | WRITE '(' LIT 
                              { strTab.add($3);
                                System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX"); 
				System.out.println("\tMOVL $_str_"+strCount+", %ECX"); 
                                System.out.println("\tCALL _writeLit"); 
				strCount++;
				}

                    ',' exp ')' ';' 
			{ 
			 System.out.println("\tPOPL %EAX"); 
			 System.out.println("\tCALL _write");	
			 System.out.println("\tCALL _writeln"); 
                        }
         
     | READ '(' ID ')' ';'								
								{
									System.out.println("\tPUSHL $_"+$3);
									System.out.println("\tCALL _read");
									System.out.println("\tPOPL %EDX");
									System.out.println("\tMOVL %EAX, (%EDX)");
									
								}
    | WHILE {
					lpRot.push(proxRot);// estrutura de controle de loop
					proxRot += 2;
					System.out.printf("rot_%02d:\n",lpRot.peek());
				  } 
			 '(' exp ')' {
			 							System.out.println("\tPOPL %EAX   # desvia se falso...");
											System.out.println("\tCMPL $0, %EAX");
											System.out.printf("\tJE rot_%02d\n", (int)lpRot.peek()+1);
										} 
				'{' lcmd '}'		{
				  		System.out.printf("\tJMP rot_%02d   # terminou cmd na linha de cima\n", lpRot.peek());
							System.out.printf("rot_%02d:\n",(int)lpRot.peek()+1);
							//limpa a pilha para o break e continue
							lpRot.pop();
							
							}

	| DO { //topo
			lpRot.push(proxRot);//estrutura de controle de loop
			proxRot+=2;//para o continue e break(label topo DO e label de fim)
			System.out.printf("rot_%02d:\n", lpRot.peek());//
		 }
	 '{' lcmd '}'
	 WHILE '(' exp ')' {
							System.out.println("\tPOPL %EAX");
							System.out.println("\tCMPL $0, %EAX");//mais robusto e alinhado com C, 0 sendo falso e qualquer outro valor seria verdadeiro
							System.out.printf("\tJNE rot_%02d\n",lpRot.peek());//jump not equal, se for verdadeiro, vai para o topo do loop
	 				   }
	 ';'{
		System.out.printf("rot_%02d:\n", (int)lpRot.peek() + 1);//termino do loop, label de fim
		//limpa a pilha para o break e continue 
		lpRot.pop();
	 }
							
			| IF '(' exp {	
											pRot.push(proxRot);  proxRot += 2;
															
											System.out.println("\tPOPL %EAX");
											System.out.println("\tCMPL $0, %EAX");
											System.out.printf("\tJE rot_%02d\n", pRot.peek());
										}
								')' '{' lcmd '}'

             restoIf {
											System.out.printf("rot_%02d:\n",pRot.peek()+1);
											pRot.pop();
										}
	| FOR '('
    for_opt_exp ';' //inicializador do for(sem label)
    {
		lpRot.push(proxRot);//estrutura de controle de loop 
		proxRot += 4;//salva 4 labels na pilha (for_opt_exp(exp;;exp), for_cond(;exp;), cmd({}))
        
		System.out.printf("rot_%02d:\n", (int)lpRot.peek() + 2);//mover para a posicao do for_cond
    }
    for_cond ';' //condicao do for
    {
        System.out.println("\tPOPL %EAX");//pop condicao 
        
		System.out.println("\tCMPL $0, %EAX");//compara com 0 a condicao do for

        System.out.printf("\tJE rot_%02d\n", (int)lpRot.peek() + 1);//jump equals,se falso, pula para o final do for

        System.out.printf("\tJMP rot_%02d\n", (int)lpRot.peek() + 3);//se verdadeiro, pula para o corpo do for

        System.out.printf("rot_%02d:\n", lpRot.peek());//pega o label do for_opt_exp(incrementador)
    }
    for_opt_exp ')' //incrementador do for
    {
        System.out.printf("\tJMP rot_%02d\n", (int)lpRot.peek() + 2);//vai para o label do for_cond

        System.out.printf("rot_%02d:\n", (int)lpRot.peek() + 3);//pega o label do corpo do for
    }
    '{' lcmd '}' //corpo do for
    {
        System.out.printf("\tJMP rot_%02d\n", lpRot.peek());//vai para o label do for_opt_exp(incrementador)
        
        System.out.printf("rot_%02d:\n", (int)lpRot.peek() + 1);//pega o label do final do for
        //limpa a pilha para o break e continue
		lpRot.pop();
    }
	| BREAK ';' {
        System.out.printf("\tJMP rot_%02d\n", (int)lpRot.peek()+1);//vai para o label final do loop, usa a pilha lpRot
    }
	| CONTINUE ';' {
        System.out.printf("\tJMP rot_%02d\n", (int)lpRot.peek());//ignora resto do loop, usa a pilha lpRot
    }
    ;
     
     
restoIf : ELSE  {
											System.out.printf("\tJMP rot_%02d\n", pRot.peek()+1);
											System.out.printf("rot_%02d:\n",pRot.peek());
								
										} 							
							'{' lcmd '}'  
							
							
		| {
		    System.out.printf("\tJMP rot_%02d\n", pRot.peek()+1);
				System.out.printf("rot_%02d:\n",pRot.peek());
				} 
		;										


exp :  NUM  { System.out.println("\tPUSHL $"+$1); } 
    |  TRUE  { System.out.println("\tPUSHL $1"); } 
    |  FALSE  { System.out.println("\tPUSHL $0"); }      
 		| ID   { System.out.println("\tPUSHL " + getVarAddr($1)); }
    | '(' exp	')' 
    | '!' exp       { gcExpNot(); }
	| ID '=' exp {
					System.out.println("\tPOPL %EDX");
					System.out.println("\tMOVL %EDX, " + getVarAddr($1));
					System.out.println("\tPUSHL %EDX");
				 }
	
	| ID ADDEQ exp {
						String varAddr = getVarAddr($1);
						System.out.println("\tPOPL %EDX");
						System.out.println("\tMOVL " + varAddr + ", %EAX");
						System.out.println("\tADDL %EDX, %EAX");
						System.out.println("\tMOVL %EAX, " + varAddr);
						System.out.println("\tPUSHL %EAX");
				   }
     
		| exp '+' exp		{ gcExpArit('+'); }
		| exp '-' exp		{ gcExpArit('-'); }
		| exp '*' exp		{ gcExpArit('*'); }
		| exp '/' exp		{ gcExpArit('/'); }
		| exp '%' exp		{ gcExpArit('%'); }
																			
		| exp '>' exp		{ gcExpRel('>'); }
		| exp '<' exp		{ gcExpRel('<'); }											
		| exp EQ exp		{ gcExpRel(EQ); }											
		| exp LEQ exp		{ gcExpRel(LEQ); }											
		| exp GEQ exp		{ gcExpRel(GEQ); }											
		| exp NEQ exp		{ gcExpRel(NEQ); }											
												
		| exp OR exp		{ gcExpLog(OR); }											
		| exp AND exp		{ gcExpLog(AND); }	

	| ID INC {
				String varAddr = getVarAddr($1);
				System.out.println("\tPUSHL " + varAddr);
				System.out.println("\tINCL " + varAddr);
			 }
	| ID DEC {
				String varAddr = getVarAddr($1);
				System.out.println("\tPUSHL " + varAddr);
				System.out.println("\tDECL " + varAddr);
			 }
	| INC ID {
				String varAddr = getVarAddr($2);
				System.out.println("\tINCL " + varAddr);
				System.out.println("\tPUSHL " + varAddr);
			 }
	| DEC ID {
				String varAddr = getVarAddr($2);
				System.out.println("\tDECL " + varAddr);
				System.out.println("\tPUSHL " + varAddr);
			 }	
	| exp '?' {
					pRot.push(proxRot); proxRot += 2;
					System.out.println("\tPOPL %EAX");
					System.out.println("\tCMPL $0, %EAX");
					System.out.printf("\tJE rot_%02d\n", pRot.peek());
			  }
	exp 	  {
					System.out.printf("JMP rot_%02d\n", (int)pRot.peek()+1);
					System.out.printf("rot_%02d:\n", pRot.peek());
			  } 
	':' exp   {
					System.out.printf("rot_%02d:\n", (int)pRot.peek()+1);
					pRot.pop();
			  }
	| ID '(' lParamExp ')' { generateFuncCallerSteps($1); }
	| ID '(' ')'           { generateFuncCallerSteps($1); }
	;							

// Step 1 (CALLER): Push function arguments (right to left)
lParamExp : exp ',' lParamExp
		  | exp
		  ;

%%

  private Yylex lexer;

  private TabSimb ts = new TabSimb();

  private int strCount = 0;
  private ArrayList<String> strTab = new ArrayList<String>();

  private Stack<Integer> pRot = new Stack<Integer>();
  private Stack<Integer> lpRot = new Stack<Integer>();
  private int proxRot = 1;
  private final int VAR_SIZE_BYTES = 4;

  private String currFuncDecl;

  public static int ARRAY = 100;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error + "  linha: " + lexer.getLine());
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }  

  public void setDebug(boolean debug) {
    yydebug = debug;
  }

  public void listarTS() { ts.listar();}

  public static void main(String args[]) throws IOException {

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
      // yyparser.listarTS();

    }
    else {
      // interactive mode
      System.out.println("\n\tFormato: java Parser entrada.cmm >entrada.s\n");
    }

  }

	private String getVarAddr(String varName) {
		if (currFuncDecl != null) {
			// we're inside a function, so we should access the variable from
			// its local symbol table instead of as a global
			TS_entry funcEntry = ts.pesquisa(currFuncDecl);
			TS_entry memberEntry = funcEntry.getLocalTS().pesquisa(varName);
			if (memberEntry != null) {
				if (memberEntry.getCls() == TS_entry.Class.PARAM) {
					int idx = funcEntry.getLocalTS().getParamIdx(memberEntry);
					int totalParams = funcEntry.getLocalTS().getParamsCount();
					int reversedIdx = totalParams - idx - 1;
					int offset = 8 + VAR_SIZE_BYTES * reversedIdx;
					return offset + "(%EBP)";
				} else if (memberEntry.getCls() == TS_entry.Class.LOCAL_VAR) {
					int idx = funcEntry.getLocalTS().getLocalVarIdx(memberEntry);
					int offset = -VAR_SIZE_BYTES * (idx + 1);
					return offset + "(%EBP)";
				}
			}
		}

		// accessing as a global
		return "_" + varName;
	}

	private void generateFuncCallerSteps(String funcName) {
		// Steps 2 and 3 (CALLER): Push return address to the stack and jump to the function label
		System.out.println("\tCALL _" + funcName);
		// Step 11 (CALLER): Deallocate function arguments from the stack
		int localVarsCount = ts.pesquisa(funcName).getLocalTS().getLocalVarsCount();
		System.out.println("\tADDL $" + (localVarsCount * VAR_SIZE_BYTES) + ", %ESP");
	}

	private void generateFuncCalleePrologueSteps(String funcName) {
		// Step 4 (CALLEE - PROLOGUE): Save caller's frame (base) pointer in the stack
		System.out.println("\tPUSHL %EBP");
		// Step 5 (CALLEE - PROLOGUE): Set callee's frame (base) pointer to the top of the stack ($SP)
		System.out.println("\tMOVL %ESP, %EBP");
		// Step 6 (CALLEE - PROLOGUE): Allocate space for local vars
		int localVarsCount = ts.pesquisa(funcName).getLocalTS().getLocalVarsCount();
		System.out.println("\tSUBL $" + (localVarsCount * VAR_SIZE_BYTES) + ", %ESP");
	}

	private void generateFuncCalleeEpilogueSteps() {
		// Step 8 (CALLEE - EPILOGUE): Deallocate local vars from the stack
		System.out.println("\tMOVL %EBP, %ESP");
		// Step 9 (CALLEE - EPILOGUE): Restore caller's frame (base) pointer
		System.out.println("\tPOPL %EBP");
		// Step 10 (CALLEE - EPILOGUE): Pop the return address from the stack and jump to it
		System.out.println("\tRET");
	}

	private void handleVarDecl(int varType, String varName) {
		if (currFuncDecl != null) {
			// the declaration is happening inside a func, so we try to add
			// the variable to the function's local symbol table
			TS_entry funcEntry = ts.pesquisa(currFuncDecl);
			if (funcEntry.getLocalTS().pesquisa(varName) == null)
				funcEntry.getLocalTS().insert(
					new TS_entry(varName, varType, TS_entry.Class.LOCAL_VAR)
				);
			else
				yyerror("(sem) variavel >" + varName + "< jah declarada");
		}
		else if (ts.pesquisa(varName) != null)
			yyerror("(sem) variavel >" + varName + "< jah declarada");
		else
			ts.insert(new TS_entry(varName, varType, TS_entry.Class.GLOBAL_VAR));
	}
							
		void gcExpArit(int oparit) {
 				System.out.println("\tPOPL %EBX");
   			System.out.println("\tPOPL %EAX");

   		switch (oparit) {
     		case '+' : System.out.println("\tADDL %EBX, %EAX" ); break;
     		case '-' : System.out.println("\tSUBL %EBX, %EAX" ); break;
     		case '*' : System.out.println("\tIMULL %EBX, %EAX" ); break;

    		case '/': 
           		     System.out.println("\tMOVL $0, %EDX");
           		     System.out.println("\tIDIVL %EBX");
           		     break;
     		case '%': 
           		     System.out.println("\tMOVL $0, %EDX");
           		     System.out.println("\tIDIVL %EBX");
           		     System.out.println("\tMOVL %EDX, %EAX");
           		     break;
    		}
   		System.out.println("\tPUSHL %EAX");
		}

	public void gcExpRel(int oprel) {

    System.out.println("\tPOPL %EAX");
    System.out.println("\tPOPL %EDX");
    System.out.println("\tCMPL %EAX, %EDX");
    System.out.println("\tMOVL $0, %EAX");
    
    switch (oprel) {
       case '<':  			System.out.println("\tSETL  %AL"); break;
       case '>':  			System.out.println("\tSETG  %AL"); break;
       case Parser.EQ:  System.out.println("\tSETE  %AL"); break;
       case Parser.GEQ: System.out.println("\tSETGE %AL"); break;
       case Parser.LEQ: System.out.println("\tSETLE %AL"); break;
       case Parser.NEQ: System.out.println("\tSETNE %AL"); break;
       }
    
    System.out.println("\tPUSHL %EAX");

	}


	public void gcExpLog(int oplog) {

	   	System.out.println("\tPOPL %EDX");
 		 	System.out.println("\tPOPL %EAX");

  	 	System.out.println("\tCMPL $0, %EAX");
 		  System.out.println("\tMOVL $0, %EAX");
   		System.out.println("\tSETNE %AL");
   		System.out.println("\tCMPL $0, %EDX");
   		System.out.println("\tMOVL $0, %EDX");
   		System.out.println("\tSETNE %DL");

   		switch (oplog) {
    			case Parser.OR:  System.out.println("\tORL  %EDX, %EAX");  break;
    			case Parser.AND: System.out.println("\tANDL  %EDX, %EAX"); break;
       }

    	System.out.println("\tPUSHL %EAX");
	}

	public void gcExpNot(){

  	 System.out.println("\tPOPL %EAX" );
 	   System.out.println("	\tNEGL %EAX" );
  	 System.out.println("	\tPUSHL %EAX");
	}

   private void geraInicio() {
			System.out.println(".text\n\n#\t Ricardo B. Süffert (22103137-0) Gustavo L. Molina (20103003-8)\n#\n"); 
			System.out.println(".GLOBL _start\n\n");  
   }

   private void geraFinal(){
	
			System.out.println("\n\n");
			System.out.println("#");
			System.out.println("# devolve o controle para o SO (final da main)");
			System.out.println("#");
			System.out.println("\tmov $0, %ebx");
			System.out.println("\tmov $1, %eax");
			System.out.println("\tint $0x80");
	
			System.out.println("\n");
			System.out.println("#");
			System.out.println("# Funcoes da biblioteca (IO)");
			System.out.println("#");
			System.out.println("\n");
			System.out.println("_writeln:");
			System.out.println("\tMOVL $__fim_msg, %ECX");
			System.out.println("\tDECL %ECX");
			System.out.println("\tMOVB $10, (%ECX)");
			System.out.println("\tMOVL $1, %EDX");
			System.out.println("\tJMP _writeLit");
			System.out.println("_write:");
			System.out.println("\tMOVL $__fim_msg, %ECX");
			System.out.println("\tMOVL $0, %EBX");
			System.out.println("\tCMPL $0, %EAX");
			System.out.println("\tJGE _write3");
			System.out.println("\tNEGL %EAX");
			System.out.println("\tMOVL $1, %EBX");
			System.out.println("_write3:");
			System.out.println("\tPUSHL %EBX");
			System.out.println("\tMOVL $10, %EBX");
			System.out.println("_divide:");
			System.out.println("\tMOVL $0, %EDX");
			System.out.println("\tIDIVL %EBX");
			System.out.println("\tDECL %ECX");
			System.out.println("\tADD $48, %DL");
			System.out.println("\tMOVB %DL, (%ECX)");
			System.out.println("\tCMPL $0, %EAX");
			System.out.println("\tJNE _divide");
			System.out.println("\tPOPL %EBX");
			System.out.println("\tCMPL $0, %EBX");
			System.out.println("\tJE _print");
			System.out.println("\tDECL %ECX");
			System.out.println("\tMOVB $'-', (%ECX)");
			System.out.println("_print:");
			System.out.println("\tMOVL $__fim_msg, %EDX");
			System.out.println("\tSUBL %ECX, %EDX");
			System.out.println("_writeLit:");
			System.out.println("\tMOVL $1, %EBX");
			System.out.println("\tMOVL $4, %EAX");
			System.out.println("\tint $0x80");
			System.out.println("\tRET");
			System.out.println("_read:");
			System.out.println("\tMOVL $15, %EDX");
			System.out.println("\tMOVL $__msg, %ECX");
			System.out.println("\tMOVL $0, %EBX");
			System.out.println("\tMOVL $3, %EAX");
			System.out.println("\tint $0x80");
			System.out.println("\tMOVL $0, %EAX");
			System.out.println("\tMOVL $0, %EBX");
			System.out.println("\tMOVL $0, %EDX");
			System.out.println("\tMOVL $__msg, %ECX");
			System.out.println("\tCMPB $'-', (%ECX)");
			System.out.println("\tJNE _reading");
			System.out.println("\tINCL %ECX");
			System.out.println("\tINC %BL");
			System.out.println("_reading:");
			System.out.println("\tMOVB (%ECX), %DL");
			System.out.println("\tCMP $10, %DL");
			System.out.println("\tJE _fimread");
			System.out.println("\tSUB $48, %DL");
			System.out.println("\tIMULL $10, %EAX");
			System.out.println("\tADDL %EDX, %EAX");
			System.out.println("\tINCL %ECX");
			System.out.println("\tJMP _reading");
			System.out.println("_fimread:");
			System.out.println("\tCMPB $1, %BL");
			System.out.println("\tJNE _fimread2");
			System.out.println("\tNEGL %EAX");
			System.out.println("_fimread2:");
			System.out.println("\tRET");
			System.out.println("\n");
     }

     private void geraAreaDados(){
			System.out.println("");		
			System.out.println("#");
			System.out.println("# area de dados");
			System.out.println("#");
			System.out.println(".data");
			System.out.println("#");
			System.out.println("# variaveis globais");
			System.out.println("#");
			ts.geraGlobais();	
			System.out.println("");
	
    }

     private void geraAreaLiterais() { 

         System.out.println("#\n# area de literais\n#");
         System.out.println("__msg:");
	       System.out.println("\t.zero 30");
	       System.out.println("__fim_msg:");
	       System.out.println("\t.byte 0");
	       System.out.println("\n");

         for (int i = 0; i<strTab.size(); i++ ) {
             System.out.println("_str_"+i+":");
             System.out.println("\t .ascii \""+strTab.get(i)+"\""); 
	           System.out.println("_str_"+i+"Len = . - _str_"+i);  
	      }		
   }
   
