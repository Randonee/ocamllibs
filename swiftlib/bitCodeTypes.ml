module BitCodeTypes = struct

open Int64;;

type cursor = {byte:int; bit:int};;

type bitcode_abbrev_op = {isLiteral:bool; value:int64; encoding:int64};;
type abbrev_def = {id:int64; abbrev_ops:bitcode_abbrev_op array};;

type record_name = {code:int64; name:string};;

type global_abbr_defs = {abbriv_id:int64; mutable block_name:string; defs:abbrev_def array; record_names:record_name array};;

type record = {code:int64; abbrive_id:int64; ops:bitcode_abbrev_op array; op_values:int64 array array; name:string};;

type block = {block_id:int64; abbreviation_width:int64; length:int64; abbrev_defs:abbrev_def array; records:record array; sub_blocks:block array; name:string};;

let first_applicatoin_block_id = Int64.of_int 8;;

let end_block_id = Int64.of_int 0;;
let enter_sublock_id = Int64.of_int 1;;
let unabbrev_record_id = Int64.of_int 3;;

let first_application_record_index = 4;;

let blockinfo_block_id = Int64.of_int 0;;
let blockinfo_code_setbid = Int64.of_int 1;;
let blockinfo_code_blockname = Int64.of_int 2;;
let blockinfo_code_setrecordname = Int64.of_int 3;;
let define_abbrev = Int64.of_int 2;;

let enter_subblock_width = Int64.of_int 2;;
let block_id_width = Int64.of_int 8;;
let abbreviation_width = Int64.of_int 4;;
let block_size_width = Int64.of_int 32;;
let code_length_width = Int64.of_int 32;;


let op_fixed = Int64.of_int 1;; (*A fixed width field, Val specifies number of bits.*)
let op_vbr = Int64.of_int 2;;	(*A VBR field where Val specifies the width of each chunk. *)
let op_array = Int64.of_int 3;; (*A sequence of fields, next field species elt encoding. *)
let op_char6 = Int64.of_int 4;; (*A 6-bit fixed field which maps to [a-zA-Z0-9._]. *)
let op_blob = Int64.of_int 5;; (*32-bit aligned array of 8-bit characters.*)

end