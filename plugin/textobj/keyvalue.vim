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
    let splitter = ':'
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
    let splitter = ':'
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
    normal! $
    let splitter = ':'
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
    normal! $
    let splitter = ':'
    call search(splitter, "bc")
    call search(splitter . "\\s*" . '["' . "'][^'" .'"'."]\\+" . '["' . "']", 'c')
    call search('["' . "']")
    let c = getpos('.')
    let [b, e] = [c, c]
    normal! $
    call search('["' . "']", 'bc', line('.'))
    let e = getpos('.')
  return ['v', b, e]
endfunction

