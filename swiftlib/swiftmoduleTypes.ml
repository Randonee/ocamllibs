module SwiftmoduleTypes = struct

open BitCodeReader;;
open Int64;;

include BitCodeReader;;


let keyedDecodingContainer_id = -1;;


(* block ids *)
let control_block_id = 9;;
let decls_and_types_block_id = 11;;
let identifier_data_block_id= 12;;


(*------ IDENTIFIER_DATA_BLOCK ------*)
(* record ids *)
let identifier_data_id = 4;;


(*------ DECLS_AND_TYPES_BLOCK ------*)
(* record ids *)
let decl_context_id = 70;;
let members_id = 90;;
let parameter_list_elt_id = 56;;
let xref_id = 91;;
let xref_type_path_piece_id_id = 75;;

(* decl record ids *)
let generic_type_param_decl_id = 35;; (* guess *)
let associated_type_decl_id = 36;;  (* guess *)
let struct_decl_id = 37;;  (* guess *)
let constructor_decl_id = 38;;
let var_decl_id = 39;;
let param_decl_id = 40;;
let func_decl_id = 41;;
let pattern_binding_decl_id = 42;;
let protocol_decl_id = 43;;  (* guess *)
let default_witness_table_decl_id = 44;;  (* guess *)
let prefix_operator_decl_id = 46;;  (* guess *)
let postfix_operator_decl_id = 47;;  (* guess *)
let infix_operator_decl_id = 48;;  (* guess *)
let class_decl_id = 49;;
let enum_decl_id = 50;; (* guess *)
let enum_element_decl_id = 51;; (* guess *)
let subscript_decl_id = 52;; (* guess *)
let extension_decl_id = 53;; (* guess *)
let destructor_decl_id = 54;;
let precedence_group_decl_id = -1;; (* not known *)

(* type record ids *)
let name_alias_type_id = 4;; 
let generic_type_param_type_id = 5;; (* guess *)
let dependent_member_type_id = 6;; (* guess *)
let nominal_type_id = 7;; 
let paren_type_id = 8;; 
let tuple_type_id = 9;; 
let function_type_id = 11;; 
let metatype_type_id = 12;; 
let inout_type_id = 15;;

let archetype_type_id = 16;; (* guess *)
let protocol_composition_type_id = 17;; (* guess *)
let bound_generic_type_id = 18;; (* guess *)
let generic_function_type_id = 19;; (* guess *)
let array_slice_type_id = 20;; (* guess *)
let dictionary_type_id = 21;; (* guess *)
let reference_storage_type_id = 22;; (* guess *)
let unbound_generic_type_id = 23;; (* guess *)
let optional_type_id = 30;;
let sil_function_type_id = 25;; (* guess *)
let unchecked_optional_type_id = 26;; (* guess *)
let dynamic_self_type_id = 27;; (* guess *)
let opened_existential_type_id = 28;; (* guess *)
let existential_metatype_type_id = 29;; (* guess *)
let sil_block_storage_type_id = 30;; (* guess *)
let sil_box_type_id = 31;; (* guess *)




type metadata_layout = {
	major_version:int64;
	minor_version:int64;
	shor_version_length:int64;
	shor_compatibility_length:int64;
	version_info:string
};;

type control_block_layout = {
	metadata:metadata_layout;
	module_name:string;
	target:string
};;


type options_block_layout = {
	sdk_path:string;
	xcc:string;
	is_sib:bool;
	id_testable:bool;
	resilience_strategy:int64;
};;



type imported_module_layout = {
	exported:bool;
	scoped:bool;
	module_name:string
};;

type link_library_layout = {
	library_kind_field:bool;
	forced:bool;
	library_name:string
};;

type imported_header_layout = {
	exported:bool;
	file_size:int64;
	file_mtime:int64;
	file_path:string
};;


type search_path_layout = {
	framework:bool;
	system:bool;
	path:string
};;

type input_block_layout = {
	imported_module:imported_module_layout;
	link_library:link_library_layout;
	imported_header:imported_header_layout;
	imported_header_contents:string;
	modulte_flags_module:bool;
	search_path_id:search_path_layout
};;


type name_alias_type_layout = {
	typealias_decl:int64;
	canonical_type:int64
};;

type generic_type_param_type_layout = {
	generic_type:int64;
	index:int64
};;

type dependent_member_type_layout = {
	base_type:int64;
	associated_type:int64
};;

type nominal_type_layout = {
	decl:int64;
	parent:int64
};;

type paren_type_layout = {
	innter_type:int64;
	vararg:bool;
	autoclosure:bool;
	escaping:bool;
	inout:bool;
	shared:bool
};;

type tuple_type_elt_layout = {
	name_id:int64;
	name:string;
	typle_type:int64;
	vararg:bool;
	autoclosure:bool;
	escaping:bool;
	inout:bool;
	shared:bool
};;

type function_type_layout = {
	input:int64;
	output:int64;
	representation:int64;
	autoclosure:bool;
	noescape:bool;
	throws:bool
};;

 
type metatype_type_layout = {
	instance_type:int64;
	representation:int64
};;

type existential_metatype_type_layout = {
	existential_instance_type:int64;
	representation:int64
};;

type archetype_type_layout = {
	generic_environment:int64;
	interface_type:int64
};;


type protocol_composition_type_layout = {
	has_any_object:bool;
	protocols:int64 array
};;


type bound_generic_type_layout = {
	replacement:int64;
	conformance_info:int64
};;

type bound_generic_substitution_layout = {
	replacement:int64;
	conformance_info:int64
};;


type generic_function_type_layout = {
	input:int64;
	output:int64;
	representation:int64;
	throws:bool;
	generic_parameters:int64 array;
};;


type sil_function_type_layout = {
	callee:int64;
	callee_convention:int64;
	representation:int64;
	pseudogeneric:bool;
	error:bool;
	num_parameters:int64;
	num_results:int64;
	fields:int64 array
};;

type sil_layout_layout = {
	num_fields:int64;
	fields:int64 array
};;

type dictionary_type_layout = {
	key_type:int64;
	value_type:int64
};;

type reference_stroage_type_layout = {
	ownership:int64;
	implementation_type:int64
};;

type unbound_generic_type_layout = {
	generic_decl:int64;
	parent:int64
};;


type type_alias_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	underlying_type:int64;
	interface_type:int64;
	implicit:bool;
	generic_environment:int64;
	generic_decl:int64;
	accessibility:int64
};;


type generic_type_param_dec_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	implicit:bool;
	depth:int64;
	index:int64
};;


type associated_type_decl_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	default_definition:int64;
	implicit:bool;
	values:int64 array
};;


type struct_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	implicit:bool;
	generic_environment:int64;
	accessibility:int64;
	num_conformances:int64;
	values:int64 array
};;


type enum_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	implicit:bool;
	generic_environment:int64;
	raw_type:int64;
	accessibility:int64;
	num_conformances:int64;
	num_inherited_types:int64;
	values:int64 array
};;

type protocol_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	implicit:bool;
	class_bounded:bool;
	objc:bool;
	generic_environment:int64;
	accessibility:int64;
	values:int64 array
};;

type constructor_layout = {
	context_decl:int64;
	failability:int64;
	implicit:bool;
	objc:bool;
	stub_implementation:bool;
	throws:bool;
	initializer_kind:int64;
	generic_environment:int64;
	interface_type:int64;
	overridden_decl:int64;
	accessibility:int64;
	new_vtable_slot:bool;
	required:bool;
	num_params:int64;
	values:int64 array
};;

type var_layout = {
	mutable name:string;

	name_id:int64;
	context_decl:int64;
	implicit:bool;
	objc:bool;
	static:bool;
	specifier:int64;
	has_non_pattern_binding_init:int64;
	storage_kind:int64;
	interface_type:int64;
	getter:int64;
	setter:int64;
	materialize_for_set:int64;
	addressor:int64;
	mutable_addressor:int64;
	willset:int64;
	didset:int64;
	overridden_decl:int64;
	accessibility:int64;
	setter_accessibility:int64;
	dependencies:int64 array
};;

type param_layout = {
	mutable argument_name:string;
	mutable parameter_name:string;


	argument_name_id:int64;
	parameter_name_id:int64;
	context_decl:int64;
	specifier:int64;
	interface_type:int64
};;

type infix_operator_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	precedence_group:int64
};;


type iprecedence_group_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	associativity:int64;
	assignment:bool;
	num_higher_than:int64;
	values:int64 array
};;


type enum_element_layout = {
	name_id:int64;
	name:string;
	context_decl:int64;
	interface_type:int64;
	has_arg_type:bool;
	implicit:bool;
	raw_value_kind:int64;
	negative_raw_value:bool;
	raw_value:string
};;


type subscript_layout = {
	context_decl:int64;
	implicit:bool;
	objc:bool;
	storage_kind:int64;
	generic_environment:bool;
	interface_type:int64;
	getter:int64;
	setter:int64;
	materialize_for_set:int64;
	addressor:int64;
	mutable_addressor:int64;
	willSet:int64;
	didset:int64;
	overridden_decl:int64;
	accessibility:int64;
	setter_accessibility:int64;
	num_names:int64;
	values:int64 array
};;

type extension_layout = {
	base_type:int64;
	decl_context_id_field:int64;
	implicit:bool;
	generic_environment:bool;
	protocol_conformances:int64;
	num_inherited_types:bool;
	values:int64 array
};;

type destructor_layout = {
	context_decl:int64;
	implicit:bool;
	objc:bool;
	generic_environment:bool;
	interface_type:int64;
};;

type parameter_list_elt_layout = {
	param_decl:int64;
	is_variadic:bool;
	default_argument:int64
};;

type tuple_pattern_layout = {
	the_type:int64;
	arity:int64;
	implicit:bool
};;

type named_pattern_layout = {
	associated_var_decl:int64;
	the_type:int64;
	implicit:bool
};;

type any_pattern_layout = {
	the_type:int64;
	implicit:bool
};;

type typed_pattern_layout = {
	associated_type:int64;
	implicit:bool
};;

type var_pattern_layout = {
	is_let:bool;
	implicit:bool
};;

type generic_requirement_layout = {
	requirement_kind:int64;
	types:int64;
	same_type:int64
};;


type layout_requirement_layout = {
	requirement_kind:int64;
	constrained_type:int64;
	size:int64;
	alignment:int64
};;

type normal_protocol_conformance_layout = {
	protocol:int64;
	conformance_decl:int64;
	value_count:int64;
	type_count:int64;
	conformance_count:int64;
	values:int64 array
};;

type specialized_protocol_conformance_layout = {
	conforming_type:int64;
	types:int64;
	values:int64
};;

type protocol_conformance_xref_layout = {
	conformance_protocol:int64;
	nominal_type:int64;
	conformance_module:int64
};;

type xref_type_path_piece_layout = {
	mutable name:string;
	name_id:int64;
	restrict:bool
};;

type xref_value_path_piece_layout = {
	mutable name:string;
	the_type:int64;
	name_id:int64;
	restrict:bool;
	static:bool
};;

type xref_initializer_path_piece_layout = {
	mutable name:string;
	the_type:int64;
	name_id:int64;
	restrict:bool;
	kind:int64
};;

type xref_extension_path_piece_layout = {
	module_id:int64;
	values:int64 array
};;


type xref_operarot_or_accessor_path_piece_layout = {
	mutable name:string;
	name_id:int64;
	kind:int64;
};;

type xref_path_piece =
| XrefType of xref_type_path_piece_layout
| XrefValue of xref_value_path_piece_layout
| XrefInitializer of xref_initializer_path_piece_layout
| XrefExtension of xref_extension_path_piece_layout
| XrefOpperator of xref_operarot_or_accessor_path_piece_layout;;


type xref_layout = {
	mutable path_pieces: xref_path_piece array;
	mutable full_path_name:string;
	base_module_id:int64;
	xref_path_length:int64
};;




type sref_type_path_piece_layout = {
	name_id:int64;
	name:string;
	restrict:bool
};;

type sil_gen_name_dec_attr_layout = {
	implicit:bool;
	silgen_name:string
};;

type cdecl_decl_attr_layout = {
	implicit:bool;
	silgen_name:string
};;

type alignment_dec_attr_layout = {
	implicit:bool;
	alignment:int64
};;

type swift_native_objc_runtime_base_decl_attr_layout = {
	implicit:bool;
	name_id:int64;
	name:string
};;

type semantics_dec_attr_layout = {
	implicit:bool;
	semantics_value:string
}

type decl_context_layout = {
	index:int64;
	is_decl:bool
}

type foreign_error_convention_layout = {
	kind:int64;
	owned:bool;
	replaced:bool;
	error_index:int64;
	error_type:int64;
	result_type:int64
}

type abstract_closure_expr_layout = {
	the_type:int64;
	implicit:bool;
	discriminator:int64;
	parent_context_decl:int64
}

type pattern_binding_initializer_layout = {
	binding_decl:int64;
	binding_index:int64
}

type default_argument_initializer_layout = {
	parent_context_decl:int64;
	param_index:int64
}

type available_decl_attr_layout = {
	implicit:bool;
	is_unavailable:bool;
	is_deprecated:bool;
	introduced:int64;
	deprecated:int64;
	obsoleted:int64;
	platform:int64;
	message_length:int64;
	rename_length:int64;
	values:string;
}

type obj_decl_attr_layout = {
	implicit:bool;
	inferred:bool;
	implicit_name:bool;
	num_args:int64;
	values:int64 array
}

type specialize_decl_attr_layout = {
	exported:bool;
	specialization:bool
}


type pattern_binding_decl_layout = {
	context_decl:int64;
	implicit:bool;
	static:bool;
	spelling:int64;
	numpatterns:int64;
	values:int64 array;
}

type func_layout = {
	mutable params : param_layout ref array;
	mutable name:string;
	mutable parameter_list_elts : parameter_list_elt_layout array;

	context_decl:int64;
	implicit:bool;
	is_static:bool;
	spelling:int64;
	objc:bool;
	mutating:bool;
	has_dynamic_self:bool;
	throws:bool;
	num_patterns:int64;
	generic_environment:int64;
	interface_type:int64;
	operator_decl:int64;
	overridden_function:int64;
	accessor_storage_decl:int64;
	num_param_names:int64;
	accessor_kind:int64;
	accessibility:int64;
	new_vtable_slot:bool; (* This is in the header but doesn't seem to be in the data *)
	values:int64 array

};;

type class_layout = {
	mutable name:string;
	mutable vars: var_layout ref array;
	mutable funcs: func_layout ref array;
	mutable members: int64 array;

	name_id:int64;
	context_decl:int64;
	implicit:bool;
	objc:bool;
	req_stored_prop:bool;
	generic_environment:int64;
	superclass:int64;
	accessibility:int64;
	num_conformances:int64;
	values:int64 array
};;

type decl =
| Class of class_layout
| Var of var_layout
| Func of func_layout
| Param of param_layout
| PatternBinding of pattern_binding_decl_layout
| Constructor of constructor_layout
| Destructor
| Decl_unfinished
| Xref of xref_layout
| None;;


type swift_type = 
| NameAliasType of name_alias_type_layout
| GenericTypeParamType of generic_type_param_type_layout
| NominalType of nominal_type_layout 
| ParenType of paren_type_layout
| TupleType
| FunctionType of function_type_layout
| MetaTypeType of metatype_type_layout
| InoutType of int64
| ArcheTypeType of archetype_type_layout
| ProtocolCompositionType of protocol_composition_type_layout
| BoundGenericType of bound_generic_type_layout
| GenericFunctionType of generic_function_type_layout
| ArraySliceType of int64
| DictionaryType of dictionary_type_layout
| ReferenceStorageType of reference_stroage_type_layout
| UnboundGenereicType of unbound_generic_type_layout
| OptionalType of int64
| SilFunctionType of sil_function_type_layout
| UncheckedOptionalType of int64
| DynamicSelfType of int64
| OpenedExistentialType of int64
| ExistentialMetaTypeType of existential_metatype_type_layout
| SilBlockStorageType of int64
| SilBoxType of int64
| NoType;;


let to_bool (n:int64) = (Int64.compare n Int64.zero) > 0;;

let make_class (rcd:record):decl = 
	Class({
		name="";
		vars=[||];
		funcs=[||];
		members = [||];
		name_id=rcd.op_values.(1).(0);
		context_decl=rcd.op_values.(2).(0);
		implicit=(to_bool rcd.op_values.(3).(0)); 
		objc=(to_bool rcd.op_values.(4).(0)); 
		req_stored_prop=(to_bool rcd.op_values.(5).(0));
		generic_environment=rcd.op_values.(6).(0);
		superclass=rcd.op_values.(7).(0);
		accessibility=rcd.op_values.(8).(0);
		num_conformances=rcd.op_values.(9).(0);
		values=rcd.op_values.(10);
	});
;;

let make_func (rcd:record):decl = 
	Func({
		params = [||];
		parameter_list_elts = [||];
		name="";
		context_decl=rcd.op_values.(1).(0);
		implicit=(to_bool rcd.op_values.(2).(0)); 
		is_static=(to_bool rcd.op_values.(3).(0)); 
		spelling=rcd.op_values.(4).(0);
		objc=(to_bool rcd.op_values.(5).(0)); 
		mutating=(to_bool rcd.op_values.(6).(0));
		has_dynamic_self=(to_bool rcd.op_values.(7).(0));
		throws=(to_bool rcd.op_values.(7).(0));
		num_patterns=rcd.op_values.(9).(0);
		generic_environment=rcd.op_values.(10).(0);
		interface_type=rcd.op_values.(11).(0);
		operator_decl=rcd.op_values.(12).(0);
		overridden_function=rcd.op_values.(13).(0);
		accessor_storage_decl=rcd.op_values.(14).(0);
		num_param_names=rcd.op_values.(15).(0);
		accessor_kind=rcd.op_values.(16).(0);
		accessibility=rcd.op_values.(17).(0);
		new_vtable_slot=false; (* This is in the header but doesn't seem to be in the data *)
		values=rcd.op_values.(18);
	})
;;

let make_var (rcd:record):decl = 
	Var({
		name="";
		name_id=rcd.op_values.(1).(0);
		context_decl=rcd.op_values.(2).(0);
		implicit=(to_bool rcd.op_values.(3).(0)); 
		objc=(to_bool rcd.op_values.(4).(0)); 
		static=(to_bool rcd.op_values.(5).(0));
		specifier=rcd.op_values.(12).(0);
		has_non_pattern_binding_init=rcd.op_values.(7).(0);
		storage_kind=rcd.op_values.(8).(0);
		interface_type=rcd.op_values.(9).(0);
		getter=rcd.op_values.(10).(0);
		setter=rcd.op_values.(11).(0);
		materialize_for_set=rcd.op_values.(12).(0);
		addressor=rcd.op_values.(13).(0);
		mutable_addressor=rcd.op_values.(13).(0);
		willset=rcd.op_values.(14).(0);
		didset=rcd.op_values.(15).(0);
		overridden_decl=rcd.op_values.(16).(0);
		accessibility=rcd.op_values.(17).(0);
		setter_accessibility=rcd.op_values.(18).(0);
		dependencies=rcd.op_values.(19);
	})
;;

let make_param (rcd:record):decl = 
	Param({
		parameter_name="";
		argument_name="";
		argument_name_id=rcd.op_values.(1).(0);
		parameter_name_id=rcd.op_values.(2).(0);
		context_decl=rcd.op_values.(3).(0);
		specifier=rcd.op_values.(4).(0);
		interface_type=rcd.op_values.(5).(0)
	});
;;

let make_pattern_binding_decl_layout (rcd:record):decl = 
	PatternBinding({
		context_decl=rcd.op_values.(1).(0);
		implicit=(to_bool rcd.op_values.(2).(0));
		static=(to_bool rcd.op_values.(3).(0));
		spelling=rcd.op_values.(4).(0);
		numpatterns=rcd.op_values.(5).(0);
		values=rcd.op_values.(6)
	});
;;

let make_constructor (rcd:record):decl = 
	Constructor({
		context_decl=rcd.op_values.(1).(0);
		failability=rcd.op_values.(2).(0);
		implicit=(to_bool rcd.op_values.(3).(0));
		objc=(to_bool rcd.op_values.(4).(0));
		stub_implementation=(to_bool rcd.op_values.(5).(0));
		throws=(to_bool rcd.op_values.(6).(0));
		initializer_kind=rcd.op_values.(7).(0);
		generic_environment=rcd.op_values.(8).(0);
		interface_type=rcd.op_values.(9).(0);
		overridden_decl=rcd.op_values.(10).(0);
		accessibility=rcd.op_values.(11).(0);
		new_vtable_slot=false; (* This is in the header but doesn't seem to be in the data *)
		required=(to_bool rcd.op_values.(9).(0));
		num_params=rcd.op_values.(11).(0);
		values=rcd.op_values.(12)
	});
;;

let make_name_alias_type (rcd:record):swift_type = 
	NameAliasType({
		typealias_decl=rcd.op_values.(1).(0);
		canonical_type=Int64.zero (* This is in the header but doesn't seem to be in the data *)
	});
;;

let make_generic_type_param (rcd:record):swift_type = 
	GenericTypeParamType({
		generic_type=rcd.op_values.(1).(0);
		index=Int64.zero (* This is in the header but doesn't seem to be in the data *)
	});
;;


let make_nominal_type (rcd:record):swift_type = 
	NominalType({
		decl=rcd.op_values.(1).(0);
		parent=rcd.op_values.(2).(0);
	});
;;

let make_paren_type (rcd:record):swift_type = 
	ParenType({
		innter_type=rcd.op_values.(1).(0);
		vararg=(to_bool rcd.op_values.(2).(0));
		autoclosure=(to_bool rcd.op_values.(3).(0));
		escaping=(to_bool rcd.op_values.(4).(0));
		inout=false;
		shared=false;
	});
;;

let make_function_type (rcd:record):swift_type = 
	FunctionType({
		input=rcd.op_values.(1).(0);
		output=rcd.op_values.(2).(0);
		representation=rcd.op_values.(3).(0);
		autoclosure=(to_bool rcd.op_values.(4).(0));
		noescape=(to_bool rcd.op_values.(5).(0));
		throws=(to_bool rcd.op_values.(6).(0));
	});
;;


let make_metatype_type (rcd:record):swift_type = 
	MetaTypeType({
		instance_type=rcd.op_values.(1).(0);
		representation=rcd.op_values.(2).(0);
	});
;;

let make_inout_type (rcd:record):swift_type = 
	InoutType(rcd.op_values.(1).(0));
;;

let make_archetype_type (rcd:record):swift_type = 
	ArcheTypeType({
		generic_environment=rcd.op_values.(1).(0);
		interface_type=rcd.op_values.(2).(0);
	});
;;




let make_protocol_composition_type (rcd:record):swift_type = 
	ProtocolCompositionType({
		has_any_object=(to_bool rcd.op_values.(1).(0));
		protocols=rcd.op_values.(2);
	});
;;

let make_bound_generic_type (rcd:record):swift_type = 
	BoundGenericType({
		replacement=rcd.op_values.(1).(0);
		conformance_info=rcd.op_values.(2).(0);
	});
;;

let make_generic_function_type (rcd:record):swift_type = 
	GenericFunctionType({
		input=rcd.op_values.(1).(0);
		output=rcd.op_values.(2).(0);
		representation=rcd.op_values.(3).(0);
		throws=(to_bool rcd.op_values.(4).(0));
		generic_parameters=rcd.op_values.(5);
	});
;;


let make_array_slice_type (rcd:record):swift_type = 
	ArraySliceType(rcd.op_values.(1).(0));
;;

let make_dictionary_type (rcd:record):swift_type = 
	DictionaryType({
		key_type=rcd.op_values.(1).(0);
		value_type=rcd.op_values.(2).(0);
	});
;;

let make_reference_storage_type (rcd:record):swift_type = 
	ReferenceStorageType({
		ownership=rcd.op_values.(1).(0);
		implementation_type=rcd.op_values.(2).(0);
	});
;;

let make_unbound_generic_type (rcd:record):swift_type = 
	UnboundGenereicType({
		generic_decl=rcd.op_values.(1).(0);
		parent=rcd.op_values.(2).(0);
	});
;;

let make_optional_type (rcd:record):swift_type = 
	OptionalType(rcd.op_values.(1).(0));
;;


let make_sil_function_type (rcd:record):swift_type = 
	SilFunctionType({
		callee=rcd.op_values.(1).(0);
		callee_convention=rcd.op_values.(2).(0);
		representation=rcd.op_values.(3).(0);
		pseudogeneric=(to_bool rcd.op_values.(4).(0));
		error=(to_bool rcd.op_values.(5).(0));
		num_parameters=rcd.op_values.(6).(0);
		num_results=rcd.op_values.(7).(0);
		fields=rcd.op_values.(8);
	});
;;


let make_unchecked_optional_type (rcd:record):swift_type = 
	UncheckedOptionalType(rcd.op_values.(1).(0));
;;

let make_dynamic_self_type (rcd:record):swift_type = 
	DynamicSelfType(rcd.op_values.(1).(0));
;;

let make_opened_existential_type (rcd:record):swift_type = 
	OpenedExistentialType(rcd.op_values.(1).(0));
;;

let make_existential_metatype_type (rcd:record):swift_type = 
	ExistentialMetaTypeType({
		existential_instance_type=rcd.op_values.(1).(0);
		representation=rcd.op_values.(2).(0);
	});
;;

let make_sil_block_storage_type (rcd:record):swift_type = 
	SilBlockStorageType(rcd.op_values.(1).(0));
;;

let make_sil_box_type (rcd:record):swift_type = 
	SilBoxType(rcd.op_values.(1).(0));
;;


let make_parameter_list_etc (rcd:record):parameter_list_elt_layout = 
	{
		param_decl=rcd.op_values.(1).(0);
		is_variadic=(to_bool rcd.op_values.(2).(0));
		default_argument=rcd.op_values.(3).(0)
	}
;;

let make_decl_context (rcd:record):decl_context_layout = 
	{
		index=rcd.op_values.(1).(0);
		is_decl=(to_bool rcd.op_values.(2).(0))
	}
;;

let make_xref (rcd:record):decl = 
	Xref({
		path_pieces=[||];
		full_path_name = "";
		base_module_id=rcd.op_values.(1).(0);
		xref_path_length=rcd.op_values.(2).(0)
	})
;;


let make_xref_type_path_piece (rcd:record):xref_path_piece = 
	XrefType({
		name="";
		name_id=rcd.op_values.(1).(0);
		restrict=(to_bool rcd.op_values.(2).(0));
	});
;;


end