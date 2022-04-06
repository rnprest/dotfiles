(array_expression (_) @swappable)
(arguments (_) @swappable)
; want to include the attribute_item listed as a sister node above it (if present)
; right now this ONLY matches enum variants WITH attribute items above
; (
;     [
;         (attribute_item)
;     ]* @_start
;     .
;     (enum_variant) @_end
;     (#make-range! "swappable" @_start @_end)
; ) @swappable

; I really thought this would work but it doesn't
; (
;     (enum_variant_list [
;         (
;             (attribute_item) @_start
;             .
;             (enum_variant) @_end
;         )
;         (enum_variant) @_start @_end
;     ])
;     (#make-range! "swappable" @_start @_end)
; )


; ([
;     (enum_variant_list
;         (attribute_item) @_start
;         .
;         (enum_variant) @_end)
;     (enum_variant) @_start @_end
;     ]
;     (#make-range! "swappable" @_start @_end))


(field_declaration) @swappable
(field_initializer_list (_) @swappable)
(function_item) @swappable
(match_arm) @swappable
(meta_item) @swappable
(ordered_field_declaration_list (_) @swappable)
(parameters (_) @swappable)
(use_list (_) @swappable)

; (
;     ((comment) @_start @_end)
;     (#make-range! "range" @_start @_end)
; )
