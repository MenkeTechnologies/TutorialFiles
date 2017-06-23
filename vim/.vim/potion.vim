if exists("b:current_syntax")
    finish
endif


syntax keyword potionKeyword loop times to while
syntax keyword potionKeyword if elsif else
syntax keyword potionKeyword class return

highlight link potionKeyword Keyword

syntax keyword potionFunction print join string

highlight link potionFunction Function


syntax match potionComment "\v#.*$"

highlight link potionComment Comment

syntax match potionOperator "\v\*"
syntax match potionOperator "\v/"
syntax match potionOperator "\v\+"
syntax match potionOperator "\v\-"
syntax match potionOperator "\v\?"
syntax match potionOperator "\v\*\="
syntax match potionOperator "\v/\="
syntax match potionOperator "\v\+\="
syntax match potionOperator "\v-\="
syntax region potionString start=/\v"/ skip=/\v\\./ end=/\v"/

highlight link potionString String

highlight link potionOperator Operator


let b:current_syntax = "potion"
