let g:abolish_save_file = expand('<sfile>')

if !exists(":Abolish")
  finish
endif

" some typo abbreviatons that spell check usually doesn't fix correctly
Abolish hte the
Abolish teh the
Abolish ot to
Abolish explicite{ly,ness} explicit{}
Abolish seperat{e,es,ed,ing,ely,ion,ions,or}  separat{}
