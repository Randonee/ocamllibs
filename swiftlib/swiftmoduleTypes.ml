module SwiftmoduleTypes = struct

open Int64;;

(* block ids *)
let control_block_id = 9;;
let decls_and_types_block_id = 11;;
let identifier_data_block_id= 12;;


(* record ids *)
let class_dcls_id = 49;;
let identifier_data_id = 4;;
(*---------- control block ---------------- *)


let metadata_id = 1;;
let module_name_id = 2;;
let target_id = 3;;


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


(*---------- options block ---------------- *)
let sdk_path_id = 1;;
let xcc_id = 2;;
let is_sib_id = 3;;
let id_testable_id = 3;;
let resilience_strategy_id = 3;;

type options_block_layout = {
	sdk_path:string;
	xcc:string;
	is_sib:bool;
	id_testable:bool;
	resilience_strategy:int64;
};;



(* Input Block *)
let imported_module_id = 1;;
let link_library_id = 2;;
let imported_header_id = 3;;
let imported_header_contents_id = 4;;
let modulte_flags_module_id = 5;;
let search_path_id = 6;;


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


(*---------- decls and types block ---------------- *)



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

type parent_type_layout = {
	innter_type:int64;
	vararg:bool;
	autoclosure:bool;
	escaping:bool;
	inout:bool;
	shared:bool
};;

type tuple_type_elt_layout = {
	name:int64;
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
	name:int64;
	context_decl:int64;
	underlying_type:int64;
	interface_type:int64;
	implicit:bool;
	generic_environment:int64;
	generic_decl:int64;
	accessibility:int64
};;


type generic_type_param_dec_layout = {
	name:int64;
	context_decl:int64;
	implicit:bool;
	depth:int64;
	index:int64
};;


type associated_type_decl_layout = {
	name:int64;
	context_decl:int64;
	default_definition:int64;
	implicit:bool;
	values:int64 array
};;


type struct_layout = {
	name:int64;
	context_decl:int64;
	implicit:bool;
	generic_environment:int64;
	accessibility:int64;
	num_conformances:int64;
	values:int64 array
};;


type enum_layout = {
	name:int64;
	context_decl:int64;
	implicit:bool;
	generic_environment:int64;
	raw_type:int64;
	accessibility:int64;
	num_conformances:int64;
	num_inherited_types:int64;
	values:int64 array
};;

type class_layout = {
	name:int64;
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

type protocol_layout = {
	name:int64;
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
	name:int64;
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
	argument_name:int64;
	parameter_name:int64;
	context_decl:int64;
	specifier:int64;
	interface_type:int64
};;
(*
 template <unsigned Code>
  using UnaryOperatorLayout = BCRecordLayout<
    Code, // ID field
    IdentifierIDField, // name
    DeclContextIDField // context decl
  >;

  using PrefixOperatorLayout = UnaryOperatorLayout<PREFIX_OPERATOR_DECL>;
  using PostfixOperatorLayout = UnaryOperatorLayout<POSTFIX_OPERATOR_DECL>;
*)

type func_layout = {
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
	new_vtable_slot:bool;
	values:int64 array

};;

type infix_operator_layout = {
	name:int64;
	context_decl:int64;
	precedence_group:int64
};;


type iprecedence_group_layout = {
	name:int64;
	context_decl:int64;
	associativity:int64;
	assignment:bool;
	num_higher_than:int64;
	values:int64 array
};;


type enum_element_layout = {
	name:int64;
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

type xref_layout = {
	base_module_id:int64;
	xref_path_length:int64
};;

type sref_type_path_piece_layout = {
	name:int64;
	restrict:bool
};;

type xref_value_path_piece_layout = {
	the_type:int64;
	name:int64;
	restrict:bool;
	static:bool
};;

type xref_initializer_path_piece_layout = {
	the_type:int64;
	name:int64;
	restrict:bool;
	kind:int64
};;


type xref_extension_path_piece_layout = {
	module_id:int64;
	values:int64 array
};;


type xref_operarot_or_accessor_path_piece_layout = {
	name:int64;
	kind:int64
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
	name:int64
};;

type semantics_dec_attr_layout = {
	implicit:bool;
	semantics_value:string
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


end