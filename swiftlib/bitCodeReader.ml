module BitCodeReader = struct

open BitCodeTypes;;
open Int64;;
include BitCodeTypes;;


type bitcode_globals = {mutable curs:cursor; mutable global_abbrev_defs:global_abbr_defs array; mutable bytes:bytes};;

let globals = {curs={byte=0; bit=0}; global_abbrev_defs=[||]; bytes=(Bytes.make 0 ' ')};;

let load_file (f:string):bytes =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  s
 ;;

let add_cursor_bit() = 
	if globals.curs.bit + 1 > 7 then
		globals.curs <- {byte=(globals.curs.byte+1); bit=0}
	else
		globals.curs <- {byte=globals.curs.byte; bit=(globals.curs.bit+1)}
;;

let skip_bits size = 
	let rec skip i = 
		if i > 0 then
			begin
				add_cursor_bit();
				skip (i-1)
			end
	in
	skip (Int64.to_int size);
;;

(* reads the byte from right to left *)
let get_bit() =
	let byte = int_of_char (ExtBytes.Bytes.get globals.bytes globals.curs.byte) in
	let masks = [|1; 2; 4; 8; 16; 32; 64; 128|] in

	let b = (byte land masks.(globals.curs.bit) != 0) in
	add_cursor_bit();
	b;
;;

let align_32_bits() = 
	let new_byte =
		if globals.curs.bit > 0 then
			globals.curs.byte + 1
		else
			globals.curs.byte;
	in
	let remainder = new_byte mod 4 in
	if remainder > 0 then
		globals.curs <- {byte=(new_byte+4-remainder); bit=0}
	else
		globals.curs <- {byte=new_byte; bit=0}
;;

let more_bytes() = 
	if globals.curs.byte >= (Bytes.length globals.bytes) then
		false
	else
		true;
;;

let prepend_bit bits bit = Array.append [|bit|] bits;;

let bits_to_int bits = 
	let b2 ex = Int64.of_float (2.0**ex) in
	let masks = [|  (b2 0.0);  (b2 1.0);  (b2 2.0);  (b2 3.0); (b2 4.0); 
					(b2 5.0);  (b2 6.0);  (b2 7.0);  (b2 8.0);
					(b2 9.0);  (b2 10.0); (b2 11.0); (b2 12.0);
					(b2 13.0); (b2 14.0); (b2 15.0); (b2 16.0);
					(b2 17.0); (b2 18.0); (b2 19.0); (b2 20.0);
					(b2 21.0); (b2 22.0); (b2 23.0); (b2 24.0);
					(b2 25.0); (b2 26.0); (b2 27.0); (b2 28.0);
					(b2 29.0); (b2 30.0); (b2 31.0); (b2 32.0);
					(b2 33.0); (b2 34.0); (b2 35.0); (b2 36.0);
					(b2 37.0); (b2 38.0); (b2 39.0); (b2 40.0);
					(b2 41.0); (b2 42.0); (b2 43.0); (b2 44.0);
					(b2 45.0); (b2 46.0); (b2 47.0); (b2 48.0);
					(b2 49.0); (b2 50.0); (b2 51.0); (b2 52.0);
					(b2 53.0); (b2 54.0); (b2 55.0); (b2 56.0);
					(b2 57.0); (b2 58.0); (b2 59.0); (b2 60.0);
					(b2 61.0); (b2 62.0); (b2 63.0); (b2 64.0);|] in
	let rec bits_to_int2 bits cur_int i =
		if i < 0 then
			cur_int
		else if bits.(i) = true then
			let mask = masks.( (Array.length bits) - i - 1) in
			let num = (Int64.logor cur_int mask) in
			bits_to_int2 bits num (i-1)
		else
			bits_to_int2 bits cur_int (i-1);
	in
	bits_to_int2 bits Int64.zero ((Array.length bits)-1);
;;

let print_bin word =
	let bit_to_string bit = if bit=true then "1" else "0" in
	let rec print_bin2  word i str =
		if i < Array.length word then	
			let b = bit_to_string (word.(i)) in
			print_bin2 word (i+1) (str ^ b)
		else
			print_string (str ^ "\n");
	in
		print_bin2 word 0 "";
;;

let read_bits size =
	let rec read_bits1 bits bits_left_to_read =
		if (Int64.compare bits_left_to_read Int64.zero) > 0 then
			let bit = get_bit() in
			let bits_left = (Int64.sub bits_left_to_read Int64.one) in
			read_bits1 (prepend_bit bits bit) bits_left;
		else
			bits	
	in
	read_bits1 [||] size;
;;


let read_vbr size = 
	let rec read_vbr1 bits bits_left_to_read = 
		if bits_left_to_read > 1 then
			let bit = get_bit() in
			read_vbr1 (prepend_bit bits bit) (bits_left_to_read-1);
		else
			let sig_bit = get_bit() in
			if sig_bit then
				read_vbr1 bits (Int64.to_int size)
			else
				(bits_to_int bits);
	in
		read_vbr1 [||] (Int64.to_int size);
;;


let char_of_fields (fields:int64 array) = 
	let rec char_of_fields1 str i =
		if i >= (Array.length fields) then
			str
		else
		begin
			let c = if (Int64.to_int fields.(i)) > 31 && (Int64.to_int fields.(i)) < 128 then Char.chr (Int64.to_int fields.(i)) else '.' in
			let str = str ^ (String.make 1 c) in
			char_of_fields1 str (i+1)
		end		
	in
		char_of_fields1 "" 0;
;;

let read_fixed_int size = 
	let rec read_fixed_int1 bits bits_left_to_read = 
		if (Int64.compare bits_left_to_read Int64.zero) > 0 then
			let bit = get_bit() in
			let bits_left = Int64.sub bits_left_to_read Int64.one in
				read_fixed_int1 (prepend_bit bits bit) bits_left;
		else
			(bits_to_int bits)
	in
	read_fixed_int1 [||] size;
;;

let read_subblock_id() =  
	read_vbr block_id_width;
;;

let get_abbreve_def (abbrev_defs:abbrev_def array) (id:int64):abbrev_def =
	let i = (Int64.to_int id) - first_application_record_index in
	abbrev_defs.(i);
;;

let add_abbriv_def id def =
	globals.global_abbrev_defs <- Array.map (fun item -> 
		if (Int64.compare item.abbriv_id id) = 0 then
			def
		else
			item
	) globals.global_abbrev_defs;
;;

let add_block_name id name =
	globals.global_abbrev_defs <- Array.map (fun item -> 
		if (Int64.compare item.abbriv_id id) = 0 then
			{item with block_name=name}
		else
			item
	) globals.global_abbrev_defs;
;;

let get_block_name id =
	let rec find i = 
		if i >= (Array.length globals.global_abbrev_defs) then
			""
		else if (Int64.compare globals.global_abbrev_defs.(i).abbriv_id id) = 0 then
			globals.global_abbrev_defs.(i).block_name
		else
			find (i+1)
	in
	find 0;
;;

let add_record_name id code name =
	globals.global_abbrev_defs <- Array.map (fun item -> 
		if (Int64.compare item.abbriv_id id) = 0 then
				{item with record_names=(Array.append item.record_names [|{code=code; name=name}|] )}
		else
			item
	) globals.global_abbrev_defs;

;;

let get_record_name id code = 
	let rec find i = 
		if i >= (Array.length globals.global_abbrev_defs) then
			""
		else if (Int64.compare globals.global_abbrev_defs.(i).abbriv_id id) = 0 then
			let rec find2 i2 = 
				if i2 >= (Array.length globals.global_abbrev_defs.(i).record_names) then
					""
				else if (Int64.compare globals.global_abbrev_defs.(i).record_names.(i2).code code) = 0 then
					 globals.global_abbrev_defs.(i).record_names.(i2).name					
				else
					find2 (i2+1)
			in
			find2 0
		else
			find (i+1) 
	in
	find 0;
;;

let read_abbrev_field op_def =
	if (Int64.compare op_def.encoding op_fixed) = 0 then
		let value = (read_fixed_int op_def.value) in
		value
	else if(Int64.compare op_def.encoding op_vbr) = 0 then
		let value = read_vbr op_def.value in
		value
	else if(Int64.compare op_def.encoding op_char6) = 0 then
		let value = read_fixed_int (Int64.of_int 6) in
		value
	else
		Int64.zero;
;;

let read_record (cur_block:block) (abbrevID:int64):record =
	if (Int64.compare abbrevID unabbrev_record_id) = 0 then
		let code = read_vbr (Int64.of_int 6) in
		let num_fields = read_vbr (Int64.of_int 6) in
		let rec readFields (fields:int64 array) (i:int) = 
			if i >= (Int64.to_int num_fields) then
				fields
			else
				let value = read_vbr (Int64.of_int 6) in
				let fields = Array.append fields [|value|] in
				readFields fields (i+1)
		in
		let fields = readFields [||] 0 in
		{code=code; abbrive_id=abbrevID; ops= [||]; op_values=[|fields|]; name=""};
	else
		let abb_def = get_abbreve_def cur_block.abbrev_defs abbrevID in
		let length = (Array.length abb_def.abbrev_ops) in
		let rec read_fields (fields_left:int) (abb_record:record):record = 
			if fields_left >= length then
				abb_record
			else
				let op_def = abb_def.abbrev_ops.(fields_left) in
				if op_def.isLiteral then
					read_fields (fields_left+1) {abb_record with op_values=(Array.append abb_record.op_values [|[|op_def.value|]|] ) }

				else if (Int64.compare op_def.encoding op_array) = 0 then
					let numItems = read_vbr (Int64.of_int 6) in
					let arrType = abb_def.abbrev_ops.(fields_left+1) in

					let rec read_array (i:int) (aFields:int64 array):record =
						if i >= Int64.to_int numItems then
							{abb_record with op_values=(Array.append abb_record.op_values [|aFields|]) }
							
						else
							let field = read_abbrev_field arrType in
							read_array (i+1) (Array.append aFields [|field|])
					in
					let abb_record = (read_array 0 [||]) in
					read_fields (fields_left+2) abb_record

				else if (Int64.compare op_def.encoding op_blob) = 0 then
					let numItems = read_vbr (Int64.of_int 6) in
					align_32_bits();
					let rec read_chars (i:int) (bFields:int64 array):record =
						if i >= Int64.to_int(numItems) then
							begin
							align_32_bits();
							{abb_record with op_values=(Array.append abb_record.op_values [|bFields|]) }
							end
						else
							let chr = read_fixed_int (Int64.of_int 8)  in
							read_chars (i+1) (Array.append bFields [|chr|])
					in
					let r = read_chars 0 [||] in
					read_fields (fields_left+1) r
				else 
					let field = read_abbrev_field op_def in
					read_fields (fields_left+1) {abb_record with op_values=(Array.append abb_record.op_values [|[|field|]|] ) };
		in
		let r = read_fields 0 {code=abbrevID; ops=abb_def.abbrev_ops; abbrive_id=abbrevID; op_values=[||]; name="" } in
		let r_code = r.op_values.(0).(0) in
		{r with code=r_code; name=(get_record_name cur_block.block_id r_code)}
;;

let read_abbreviated_def (defs:abbrev_def array):abbrev_def array = 
	let numOps = read_vbr (Int64.of_int 5) in
	let rec read_abbreviated_def1 (ops:bitcode_abbrev_op array) (i:int):abbrev_def array = 
		if i >=  (Int64.to_int numOps) then
			let id = Int64.of_int(4 + Array.length defs) in (* abbrev id start at 4 and increment by 1 *)
			let def = {id=id; abbrev_ops=ops} in
			(Array.append defs [|def|])
		else
			let isLiteral = read_bits Int64.one in
			let litVal = (Int64.to_int (bits_to_int isLiteral)) > 0 in
			if litVal then
				let value = read_vbr (Int64.of_int 8) in
				let op = {isLiteral=litVal; value=value; encoding=Int64.zero} in
				read_abbreviated_def1 (Array.append ops [|op|]) (i+1)
			else
				let encoding = read_fixed_int (Int64.of_int 3) in
				if (Int64.compare encoding op_fixed) = 0 || (Int64.compare encoding op_vbr) = 0 then
					let value = read_vbr (Int64.of_int 5) in
					let op = {isLiteral=litVal; value=value; encoding=encoding} in
					read_abbreviated_def1 (Array.append ops [|op|]) (i+1)
				else
					let op = {isLiteral=litVal; value=Int64.zero; encoding=encoding} in
					read_abbreviated_def1 (Array.append ops [|op|]) (i+1);
	in
	read_abbreviated_def1 [||] 0;
;;

let read_records (codesize:int64) (cur_block:block) (read_subblock):block = 
	let rec read_records1 (cur_block:block) (records:record array) (bid:int64):block =
		let abbriv_id = read_fixed_int codesize in
		if (Int64.compare abbriv_id end_block_id) = 0 then (* END_BLOCK *)
			begin
			align_32_bits();
			{cur_block with records=records}
			end
		else if (Int64.compare abbriv_id enter_sublock_id) = 0 then (* ENTER_SUBLOCK *)
			begin
			let (sub_block:block) = read_subblock() in
			let b = {cur_block with records=records; sub_blocks=(Array.append cur_block.sub_blocks [|sub_block|])} in
			read_records1 b records bid
			end
		else if (Int64.compare abbriv_id define_abbrev) = 0 then (* DEFINE_ABBREV *)
			begin
				let defs = read_abbreviated_def cur_block.abbrev_defs in
				if (Int64.compare cur_block.block_id blockinfo_block_id) = 0 then
					begin
						add_abbriv_def bid {abbriv_id=bid; defs=defs; block_name=""; record_names=[||]};
						read_records1 cur_block records bid
					end
				else
					read_records1 {cur_block with abbrev_defs=defs} records bid
			end
		else
			let record = read_record cur_block abbriv_id in
			(*Printf.printf "RECORD name=%s BID=%d abbriv_id=%d code=%d\n" record.name (Int64.to_int cur_block.block_id) (Int64.to_int record.abbrive_id) (Int64.to_int record.code);*)
			if (Int64.compare cur_block.block_id blockinfo_block_id) = 0 && (Int64.compare record.code (Int64.of_int 3) ) <= 0 then
				if (Int64.compare record.code blockinfo_code_setbid) <= 0 then
					let bid = record.op_values.(0).(0) in
					globals.global_abbrev_defs <- (Array.append globals.global_abbrev_defs [|{abbriv_id=bid; defs=[||]; block_name=""; record_names=[||]}|]);
					read_records1 cur_block (Array.append records [|record|]) bid
				else if(Int64.compare record.code blockinfo_code_blockname ) <= 0 then
					begin
						add_block_name bid (char_of_fields record.op_values.(0));
						read_records1 cur_block (Array.append records [|record|]) bid
					end
				else (* blockinfo_code_setrecordname *)
					begin
						let char_fields = Array.sub record.op_values.(0) 1 ((Array.length record.op_values.(0))-1) in
						add_record_name bid record.op_values.(0).(0) (char_of_fields char_fields);
						read_records1 cur_block (Array.append records [|record|]) bid
					end
					
			else
				read_records1 cur_block (Array.append records [|record|]) bid;
	in
	read_records1 cur_block [||] Int64.zero; 
;;

let get_global_abbrevs (abbriv_id:int64):abbrev_def array = 
	let rec find i =
		if i >= (Array.length globals.global_abbrev_defs) then
			[||]
		else if (Int64.compare globals.global_abbrev_defs.(i).abbriv_id abbriv_id) = 0 then
			globals.global_abbrev_defs.(i).defs
		else
			find (i+1)
	in
	find 0;
;;

let rec read_subblock():block =
	let block_id = read_subblock_id() in
	let abbr_len = read_vbr abbreviation_width in
	align_32_bits();
	let block_length = read_fixed_int block_size_width in
	let defs = get_global_abbrevs block_id in
	let cur_block = {block_id=block_id; abbreviation_width=abbr_len; length=block_length; abbrev_defs=defs; records=[||]; sub_blocks=[||]; name=(get_block_name block_id)} in
	(*Printf.printf "BLOCK: %s ID=%d  abbriv size: %d Length: %d\n" cur_block.name (Int64.to_int block_id) (Int64.to_int abbr_len) (Int64.to_int block_length);*)
	read_records abbr_len cur_block read_subblock
;;

let read_top_block() =
	(* skip the magic stuff at the start and go right to the top level ENTER_SUBBLOCK *)
	skip_bits code_length_width;

	let rec read_blocks blocks = 
		if more_bytes() then
			let code = read_fixed_int enter_subblock_width in
			if (Int64.compare code enter_sublock_id) = 0 then
				let nblock = read_subblock() in
				read_blocks (Array.append blocks [|nblock|])
			else
				blocks
		else
			blocks
	in
	read_blocks [||];
;;


let read_bitcode (src:string) =
	globals.bytes <- (load_file src);
	globals.curs <- {byte=0; bit=0};
	globals.global_abbrev_defs <- [||];
	read_top_block();
;;

end


