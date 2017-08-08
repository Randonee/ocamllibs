module SwiftmoduleReader = struct

open Int64;;
open BitCodeReader;;
open SwiftmoduleTypes;;
include BitCodeReader;;
include SwiftmoduleTypes;;

let to_bool (n:int64) = (Int64.compare n Int64.zero) > 0;;

type swift_module_globals = {mutable type_names:string array};;
let swift_globals = {type_names=[||]};;

let rec read_class_dcls_records (types:class_layout array) (rcd:record):class_layout array = 

	match (Int64.to_int rcd.abbrive_id) with
	| id when id = class_dcls_id -> 
		let cls = {
			name=rcd.op_values.(1).(0);
			context_decl=rcd.op_values.(2).(0);
			implicit=(to_bool rcd.op_values.(3).(0)); 
			objc=(to_bool rcd.op_values.(4).(0)); 
			req_stored_prop=(to_bool rcd.op_values.(5).(0));
			generic_environment=rcd.op_values.(6).(0);
			superclass=rcd.op_values.(7).(0);
			accessibility=rcd.op_values.(8).(0);
			num_conformances=rcd.op_values.(9).(0);
			values=rcd.op_values.(10);
		} 
		in
		(Array.append types [|cls|])
	| _ -> types;
;;


let rec read_identifier_data_records (types:class_layout array) (rcd:record):class_layout array = 


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
		swift_globals.type_names <- (Array.append swift_globals.type_names (read_names_blob rcd.op_values.(1) "" [||] 0));
		types
	| _ -> types;
;;


let rec read_swiftblock (types:class_layout array) (block:block):class_layout array =

	let local_types = match Int64.to_int block.block_id with
	| id when id = decls_and_types_block_id -> (Array.fold_left read_class_dcls_records types block.records)
	| id when id = identifier_data_block_id -> (Array.fold_left read_identifier_data_records types block.records)
	| _ -> types
	in
	Array.fold_left read_swiftblock local_types block.sub_blocks;

;;

let read_swiftmodule (blocks:block array):class_layout array = 
	
	Array.fold_left read_swiftblock [||] blocks
;;

let blocks = read_bitcode "tool.swiftmodule" in
print_string "READ SWIFT\n";
let types = read_swiftmodule blocks in
Printf.printf "num typs=%d\n" (Array.length types);


end