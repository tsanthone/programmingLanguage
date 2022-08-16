signature MULTI_MAP =
sig
    structure Map : ORD_MAP
    
    type 'a map
    
    val empty : 'a map

    val insert : ('a map * Map.Key.ord_key * 'a) -> 'a map
    val insert' : ((Map.Key.ord_key * 'a) * 'a map) -> 'a map
    val find : ('a map * Map.Key.ord_key) -> 'a list
    val remove : ('a map * Map.Key.ord_key) -> ('a map * 'a list)

    val numItems : 'a map -> int

    val listItems : 'a map -> 'a list
    val listItemsi : 'a map -> (Map.Key.ord_key * 'a) list

    val app : ('a -> unit) -> 'a map -> unit
    val appi : ((Map.Key.ord_key * 'a) -> unit) -> 'a map -> unit
    val map : ('a -> 'b) -> 'a map -> 'b map
    val mapi : ((Map.Key.ord_key * 'a) -> 'b) -> 'a map -> 'b map

    val filter : ('a -> bool) -> 'a map -> 'a map
    val filteri : ((Map.Key.ord_key * 'a) -> bool) -> 'a map -> 'a map
end