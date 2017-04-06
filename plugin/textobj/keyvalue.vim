if exists('g:loaded_textobj_keyvalue')
  finish
endif

let g:loaded_textobj_keyvalue = 1

call textobj#user#plugin('key', {
\   '-': {
\     '*sfile*': expand('<sfile>:p'),
\     'select-i': 'ik',
\     'select-a': 'ak',
\     '*select-i-function*': 's:select_key_i',
\     '*select-a-function*': 's:select_key_a',
\   }
\})

function! s:select_key_i()  "{{{2
    normal! 0
    let splitter = s:get_splitter()
    call search('["' . "'][^'" .'"'."]\\+" . '["' . "']" . "\\s*" . splitter)
    normal! l
    let c = getpos('.')
    let [b, e] = [c, c]
    call search('["' . "']" . "\\s*" . splitter)
    normal! h
    let e = getpos('.')
  return ['v', b, e]
endfunction

function! s:select_key_a()  "{{{2
    normal! 0
    let splitter = s:get_splitter()
    call search('\S\+\s*' . splitter)
    let c = getpos('.')
    let [b, e] = [c, c]
    call search('\S\s*' . splitter, '', line('.'))
    let e = getpos('.')
  return ['v', b, e]
endfunction



call textobj#user#plugin('value', {
\   '-': {
\     '*sfile*': expand('<sfile>:p'),
\     'select-i': 'iv',
\     'select-a': 'av',
\     '*select-i-function*': 's:select_value_i',
\     '*select-a-function*': 's:select_value_a',
\   }
\})


function! s:select_value_i()  "{{{2
    normal! 0
    let splitter = s:get_splitter()
    call search(splitter . "\\s*" . '["' . "'][^'" .'"'."]\\+" . '["' . "']", 'c')
    call search('["' . "']")
    normal! l
    let c = getpos('.')
    let [b, e] = [c, c]
    normal! $
    call search('["' . "']", 'bc', line('.'))
    normal! h
    let e = getpos('.')
  return ['v', b, e]
endfunction

function! s:select_value_a()  "{{{2
    normal! 0
    let splitter = s:get_splitter()
    call search(splitter . "\s*", 'c')
    execute('normal! ' . len(splitter) . 'l')
    call search("\\S", '')
    let c = getpos('.')
    let [b, e] = [c, c]
    normal! $
    call search("\S", 'bc', line('.'))
    let cursorchar = getline('.')[col('.') - 1]
    if (cursorchar =~ ',')
        normal! h
    endif

    let e = getpos('.')
  return ['v', b, e]
endfunction

let s:splitter_map = {
\    'vim'        : ':',
\    'javascript' : ':',
\    'json'       : ':',
\    'coffee'     : ':',
\    'python'     : ':',
\    'perl'       : '=>',
\    'default'    : '='
\}

function! s:get_splitter()
    let ft = &filetype
    if has_key(s:splitter_map, ft)
        return s:splitter_map[ft]
    endif
    return s:splitter_map['default']
endfunction

