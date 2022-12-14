exception runtime_error;

(* =========================================================================================================== *)
structure Model =

struct 

(* =========================================================================================================== *)
(* This function may be useful to get the leaf node of a tree -- which is always a string (even for integers).
   It is up to the interpreter to translate values accordingly (e.g., string to integer and string to boolean).
   
   Consult (i.e., open Int and open Bool) the SML structures Int and Bool for functions that can help with 
   this translation. 
*)
fun getLeaf( term ) = CONCRETE.leavesToStringRaw term

fun error msg = ( print msg; raise runtime_error );



(* For your typeChecker you may want to have a datatype that defines the types 
  (i.e., integer, boolean and error) in your language. *)
datatype types = INT | BOOL | ERROR;


(* It is recommended that your model store integers and Booleans in an internal form (i.e., as terms belonging to
   a userdefined datatype (e.g., denotable_value). If this is done, the store can be modeled as a list of such values.
*)
datatype denotable_value =  Boolean of bool 
                          | Integer of int;


type loc   = int
type env   = (string * types * loc) list
type store = (loc * denotable_value) list

fun accessEnv ( id1, (env,_,s) ) = 
       let
          val msg = "Error: accessEnv " ^ id1 ^ " not found.";

          fun aux [] = error msg
            | aux ((id,t,loc)::env) = 
                     if id1 = id then (t,loc)
                     else aux env;
       in
          aux env
       end;
 
fun accessStore ( loc1, (env,_,s) ) = 
       let
          val msg = "Error: accessStore " ^ Int.toString(loc1) ^ " not found.";

          fun aux [] = error msg
            | aux ((loc,v)::s) = 
                     if loc1 = loc then v
                     else aux s;
       in
          aux s
       end;

fun updateEnv ( id1, t1, loc1, (env1,n1,s) ) =
        let
          fun aux [] = ( [(id1, t1, loc1)], n1+1,s )
            | aux ((id,t,loc)::env2) =
                if id1 = id then ( (id1, t1, loc1)::env2, n1, s)
                else
                    let
                      val (env3,n2,_) = aux env2
                    in
                      ( (id,t,loc)::env3, n2, s )
                    end
        in
          aux env1
        end;
 
fun updateStore ( loc1, v1, (env,n,s1) ) =
        let
          fun aux [] = [(loc1, v1)]
            | aux ((loc,v)::s2) =
                if loc1 = loc then (loc1, v1)::s2
                else (loc,v)::aux s2
        in
          ( env, n, aux s1 )
        end;
                
fun getLoc ( t, loc ) = loc;

fun getType ( t, loc) = t;

fun typeToString BOOL  = "bool"
  | typeToString INT   = "integer"
  | typeToString ERROR = "error";

fun envEntryToString (id,t,loc) = 
       "(" ^ id ^ "," ^ typeToString t ^ "," ^ Int.toString loc ^ ")"; 

fun showEnv [] = print "\n"
  | showEnv (entry::env) = ( 
                             print("\n" ^ envEntryToString entry);
                             showEnv env
                           );
fun varToString (Boolean(x)) = Bool.toString x
  | varToString (Integer(x)) = Int.toString x;

fun storeEntryToString (loc, v) = 
       "(" ^ Int.toString loc ^ "," ^ varToString v ^ ")"; 

fun showStore [] = print "\n"
  | showStore (entry::store) = ( 
                             print("\n" ^ storeEntryToString entry);
                             showStore store
                           );

fun showProgState (env,n,s) =   
    (
    print("ENVIRONMENT");
    showEnv env;
    
    print("\n");
    print("COUNTER\n");
    print(Int.toString n ^ "\n");
    
    print("\n");
    print("STORE");
    showStore s
 );

fun toInt(Boolean(x)) = error "invalid type for int"
  | toInt(Integer(x)) = x;

fun toBool(Integer(x)) = error "invalid type for boolean"
  | toBool(Boolean(x)) = x;

(* The model defined here is a triple consisting of an environment, an address counter, and a store. The environment
   and the store are lists similar to what we have used in class. The address counter serves as an implementation of
   new(). Note that, depending on your implementation, this counter either contains the address of (1) the
   next available memory location, or (2) the last used memory location -- it all depends on when the counter is 
   incremented. *)
val initialModel = ( []:env, 0:loc, []:store )

(* =========================================================================================================== *)
end; (* struct *) 
(* =========================================================================================================== *)





