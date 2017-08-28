module SwiftmoduleReader = struct

open Int64;;
open SwiftmoduleTypes;;
include SwiftmoduleTypes;;

type module_parts = {type_names:string array; decls: decl array; types: swift_type array; decl_contexts: decl_context_layout array; xrefs:xref_layout array};;
exception Decl_Unexpected_Type of string;;



let rec read_class_decl_records (parts:module_parts) (rcd:record):module_parts = 
	let abbrive_id = (Int64.to_int rcd.abbrive_id) in 

	(* DECL Records *)
	let dcl = match abbrive_id with
	| id when id = generic_type_param_decl_id -> 	Decl_unfinished
	| id when id = associated_type_decl_id ->		Decl_unfinished
	| id when id = struct_decl_id -> 				Decl_unfinished
	| id when id = constructor_decl_id -> 			make_constructor rcd
	| id when id = var_decl_id -> 					make_var rcd
	| id when id = param_decl_id -> 				make_param rcd
	| id when id = func_decl_id -> 					make_func rcd
	| id when id = pattern_binding_decl_id -> 		make_pattern_binding_decl_layout rcd
	| id when id = protocol_decl_id -> 				Decl_unfinished
	| id when id = default_witness_table_decl_id -> Decl_unfinished
	| id when id = prefix_operator_decl_id -> 		Decl_unfinished
	| id when id = postfix_operator_decl_id -> 		Decl_unfinished
	| id when id = postfix_operator_decl_id -> 		Decl_unfinished
	| id when id = class_decl_id -> 				make_class rcd
	| id when id = enum_decl_id -> 					Decl_unfinished
	| id when id = enum_element_decl_id -> 			Decl_unfinished
	| id when id = subscript_decl_id -> 			Decl_unfinished
	| id when id = extension_decl_id -> 			Decl_unfinished
	| id when id = destructor_decl_id -> 			Destructor
	| id when id = precedence_group_decl_id -> 		Decl_unfinished
	| id when id = xref_id -> 						make_xref rcd
	| _ -> None

	in



	let p2 = if (dcl = None) then parts else {parts with decls=(Array.append parts.decls [|dcl|])} in

	let last_decl = if (Array.length p2.decls) > 0 then ref (p2.decls.( (Array.length p2.decls) -1 )) else ref None in

	(* Other Records *)
	let p3 = match abbrive_id with
	| id when id = decl_context_id -> {p2 with decl_contexts=(Array.append p2.decl_contexts [|(make_decl_context rcd)|])}

	| id when id = members_id -> (
		match !last_decl with
		| Class c -> c.members <- rcd.op_values.(1); p2
		| _ -> p2
	)


	| id when id = parameter_list_elt_id -> (
		match !last_decl with
		| Func f -> f.parameter_list_elts <- Array.append f.parameter_list_elts [|(make_parameter_list_etc rcd)|]; p2
		| _ -> p2
	)
	| id when id = xref_type_path_piece_id_id -> 
		begin
			match !last_decl with
		| Xref xrf ->
			begin
				xrf.path_pieces <- (Array.append xrf.path_pieces [| make_xref_type_path_piece rcd |]);
				p2
			end
		| _ -> p2
		end
	| _ -> p2;
	in

	let tp = match abbrive_id with
	| id when id = name_alias_type_id -> 			make_name_alias_type rcd
	| id when id = nominal_type_id -> 				make_nominal_type rcd
	| id when id = paren_type_id -> 				make_paren_type rcd
	| id when id = tuple_type_id -> 				TupleType
	| id when id = function_type_id -> 				make_function_type rcd
	| id when id = metatype_type_id -> 				make_metatype_type rcd
	| id when id = inout_type_id -> 				make_inout_type rcd 

	| id when id = archetype_type_id -> 			make_archetype_type rcd 
	| id when id = protocol_composition_type_id -> 	make_protocol_composition_type rcd 
	| id when id = bound_generic_type_id -> 		make_bound_generic_type rcd 
	| id when id = generic_function_type_id -> 		make_generic_function_type rcd 
	| id when id = array_slice_type_id -> 			make_array_slice_type rcd 
	| id when id = dictionary_type_id -> 			make_dictionary_type rcd 
	| id when id = reference_storage_type_id -> 	make_reference_storage_type rcd 
	| id when id = unbound_generic_type_id -> 		make_unbound_generic_type rcd 
	| id when id = optional_type_id -> 				make_optional_type rcd 
	| id when id = sil_function_type_id -> 			make_sil_function_type rcd 
	| id when id = unchecked_optional_type_id -> 	make_unchecked_optional_type rcd 
	| id when id = dynamic_self_type_id -> 			make_dynamic_self_type rcd 
	| id when id = opened_existential_type_id -> 	make_opened_existential_type rcd 
	| id when id = existential_metatype_type_id -> 	make_existential_metatype_type rcd 
	| id when id = sil_block_storage_type_id -> 	make_sil_block_storage_type rcd 
	| id when id = sil_box_type_id -> 				make_sil_box_type rcd 

	| _ -> NoType

	in
	if (tp = NoType) then p3 else {p3 with types=(Array.append p3.types [|tp|])};
	
;;

let rec read_identifier_data_records (names:string array) (rcd:record):string array = 
	let rec read_names_blob fields s arr i =
		if i >= (Array.length fields) then
			arr
		else
			if Int64.to_int fields.(i) = 0 then
				read_names_blob fields "" (Array.append arr [|s|]) (i+1)
			else
				let c = if (Int64.to_int fields.(i)) > 31 && (Int64.to_int fields.(i)) < 128 then Char.chr (Int64.to_int fields.(i)) else ' ' in
				let str = s ^ (String.make 1 c) in
				read_names_blob fields str arr (i+1)
	in
		
	match (Int64.to_int rcd.abbrive_id) with
	| id when id = identifier_data_id -> 
		Array.append names (read_names_blob rcd.op_values.(1) "" [||] 0)
	| _ -> names;
;;


let get_type_name (index:int64) (names:string array):string = 
	(*  The index seems to be the context_decl - 2. This was found by looking at data so could be wrong *)
	let i = (Int64.to_int index)-2 in
	if i >= 0 && i < (Array.length names) then
		names.(i)
	else
		"";
;;



let combine_types (parts:module_parts):decl array = 
	
	let get_context index = parts.decl_contexts.((Int64.to_int index)-1) in

	let get_class (class_ctx_index:int64):class_layout = 
		match parts.decls.( (Int64.to_int class_ctx_index)-1 ) with
		| Class c -> c
		| _ -> raise(Decl_Unexpected_Type "Class expected at index")
	in

	let g_param dcl = 
		match dcl with | Param p -> p | _ -> raise(Decl_Unexpected_Type "Param expected at index")
	in


	for i = 0 to ((Array.length parts.xrefs)-1) do
		let xrf = parts.xrefs.(i) in
		for j = 0 to ((Array.length xrf.path_pieces)-1) do
			match xrf.path_pieces.(j) with
			| XrefType p-> p.name <- 
				get_type_name p.name_id parts.type_names;
				xrf.full_path_name <- (xrf.full_path_name ^ p.name ^ " ")
			| _ -> ()
		done;
		Printf.printf "Xref path=%s\n" xrf.full_path_name
	done;

	print_string "\n";

	for i = 0 to ((Array.length parts.types)-1) do
		Printf.printf "TYPE i=%d " (i+1);
		match parts.types.(i) with
		| NameAliasType t -> Printf.printf "NameAliasType declID=%d\n" (Int64.to_int t.typealias_decl)
		| GenericTypeParamType t -> Printf.printf "ArcheTypeType\n"
		| NominalType t -> Printf.printf "NominalType dID=%d parent=%d\n" (Int64.to_int t.decl) (Int64.to_int t.parent)
		| ParenType t -> Printf.printf "ParenType type=%d\n" (Int64.to_int t.innter_type)
		| TupleType -> Printf.printf "TupleType\n"
		| FunctionType t -> Printf.printf "FunctionType\n"
		| MetaTypeType t -> Printf.printf "MetaTypeType\n"
		| InoutType t -> Printf.printf "InoutType type=%d\n" (Int64.to_int t)
		| ArcheTypeType t -> Printf.printf "ArcheTypeType\n"
		| ProtocolCompositionType t -> Printf.printf "ProtocolCompositionType\n"
		| BoundGenericType t -> Printf.printf "BoundGenericType\n"
		| GenericFunctionType t -> Printf.printf "GenericFunctionType\n"
		| ArraySliceType t -> Printf.printf "ArraySliceType\n"
		| DictionaryType t -> Printf.printf "DictionaryType\n"
		| ReferenceStorageType t -> Printf.printf "ReferenceStorageType\n"
		| UnboundGenereicType t -> Printf.printf "UnboundGenereicType\n"
		| OptionalType t -> Printf.printf "OptionalType\n"
		| SilFunctionType t -> Printf.printf "SilFunctionType\n"
		| UncheckedOptionalType t -> Printf.printf "UncheckedOptionalType\n"
		| DynamicSelfType t -> Printf.printf "DynamicSelfType\n"
		| OpenedExistentialType t -> Printf.printf "OpenedExistentialType\n"
		| ExistentialMetaTypeType t -> Printf.printf "ExistentialMetaTypeType\n"
		| SilBlockStorageType t -> Printf.printf "SilBlockStorageType\n"
		| SilBoxType t -> Printf.printf "SilBoxType\n"
		| NoType -> Printf.printf "NoType\n"
	done;

	print_string "\n";
	for i = 0 to ((Array.length parts.decl_contexts)-1) do
		Printf.printf "DECL_CTX i=%d id=%b decl=%d\n" (i+1)  parts.decl_contexts.(i).is_decl (Int64.to_int parts.decl_contexts.(i).index);
	done;
	print_string "\n";

	for i = 0 to ((Array.length parts.decls)-1) do
	Printf.printf "DECL i=%d " (i+1);
		let dcl = parts.decls.(i) in (
  		match dcl with
  		| Class c -> 
  			c.name <- (get_type_name c.name_id parts.type_names);
  			Printf.printf "Class %s " c.name
		| Var v ->  
			v.name <- (get_type_name v.name_id parts.type_names);
			Printf.printf "VAR : %s ctx=%d TypeId=%d get=%d set=%d" v.name (Int64.to_int v.context_decl) (Int64.to_int v.interface_type) (Int64.to_int v.getter) (Int64.to_int v.setter);
			let ctx_i = (get_context v.context_decl).index in
			let c = (get_class ctx_i ) in
			c.vars <- (Array.append c.vars [|ref v|])
		| Func f -> 
			Printf.printf "FUNC ctx=%d type=%d " (Int64.to_int f.context_decl) (Int64.to_int f.interface_type);
			if f.implicit = false then (* Only adding non implicit functions. are imlicit needed? *)
				let name = 
					if (Int64.compare f.num_param_names Int64.zero) > 0 then
						get_type_name f.values.(0) parts.type_names 
					else
						" " (* How to get name? *)
				in
				Printf.printf " %s ctx=%d" name (Int64.to_int f.context_decl);
				f.name <- name;
				for i = 0 to ((Array.length f.parameter_list_elts)-1) do
					let dcl_i = (Int64.to_int f.parameter_list_elts.(i).param_decl ) - 1 in
					
					let p = g_param( parts.decls.(dcl_i) ) in
					Printf.printf " name_i=%d" (Int64.to_int p.parameter_name_id);
					f.params <- Array.append f.params [| (ref p) |]
				done;

				let ctx_i = (get_context f.context_decl).index in
				let c = (get_class ctx_i) in
				c.funcs <- (Array.append c.funcs [|ref f|])
			
		| Param p -> 
			p.parameter_name <- (get_type_name p.parameter_name_id parts.type_names);
			p.argument_name <- (get_type_name p.argument_name_id parts.type_names);
			
			Printf.printf "Param %s ctx=%d type=%d" p.parameter_name (Int64.to_int p.context_decl) (Int64.to_int p.interface_type);
			
		| PatternBinding pb -> Printf.printf "PatternBinding ctx=%d " (Int64.to_int pb.context_decl)
		| Constructor c ->
			Printf.printf "Constructor ctx=%d " (Int64.to_int c.context_decl);
			if (Array.length c.values) > 1 then
			let name = get_type_name c.values.(1) parts.type_names in
			Printf.printf "n=%s" name

		| Xref xrf -> 
		begin
			Printf.printf "XREF ";
			for i = 0 to ((Array.length xrf.path_pieces)-1) do
				match xrf.path_pieces.(i) with
				| XrefType tp ->
					tp.name <- get_type_name tp.name_id parts.type_names;
					xrf.full_path_name <- xrf.full_path_name ^ tp.name
				| _ -> ()
			done;
			Printf.printf "%s" xrf.full_path_name;
		end
		| Destructor -> Printf.printf "Destructor "
		| _ -> Printf.printf "OTHER "
		);
		print_string "\n";
	done;
	parts.decls
;;


let get_decl_name (declID:int64) (parts:module_parts):string = 
	match parts.decls.( (Int64.to_int declID)-1) with 
	| Class c -> c.name
	| Xref xrf -> xrf.full_path_name
	| _ -> "NOT_FOUND"
;;

let get_name_by_typeID (typeID:int64) (parts:module_parts):string = 
	match parts.types.( (Int64.to_int typeID)-1) with 
	| NominalType tp -> get_decl_name tp.decl parts
	| _ -> "NOT_FOUND"

;;

let rec read_swiftblock (parts:module_parts) (block:block):module_parts =

	if (Int64.to_int block.block_id) = identifier_data_block_id then
		let names = (Array.fold_left read_identifier_data_records parts.type_names block.records) in
		Array.fold_left read_swiftblock {parts with type_names=names} block.sub_blocks;
	else
		let parts = match Int64.to_int block.block_id with
		| id when id = decls_and_types_block_id -> (Array.fold_left read_class_decl_records parts block.records)
		| _ -> parts
		in
		Array.fold_left read_swiftblock parts block.sub_blocks;
;;


let read_swiftmodule (blocks:block array):module_parts = 
	Array.fold_left read_swiftblock {type_names=[||]; decls=[||]; types=[||]; decl_contexts=[||]; xrefs=[||]} blocks
;;

let blocks = read_bitcode "tool.swiftmodule" in
print_string "READ SWIFT\n";
let parts = read_swiftmodule blocks in
let decls = combine_types parts in

for i = 0 to ((Array.length decls)-1) do
	match decls.(i) with
	| Class c -> Printf.printf "Class: %s\n" c.name;

		for j = 0 to ((Array.length c.vars)-1) do
			let v_ref = c.vars.(j) in
			Printf.printf "  var: %s:%s\n" !v_ref.name (get_name_by_typeID !v_ref.interface_type parts);
		done;

		for j = 0 to ((Array.length c.funcs)-1) do
			let f_ref = c.funcs.(j) in
			Printf.printf "  func: %s(" !f_ref.name;

			for k = 1 to ((Array.length !f_ref.params)-1) do
				let p_ref = !f_ref.params.(k) in
				Printf.printf " %s:%s" !p_ref.parameter_name (get_name_by_typeID !p_ref.interface_type parts);
			done;

			print_string " )\n";
		done
	| _ ->()
done


end