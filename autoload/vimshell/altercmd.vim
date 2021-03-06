"=============================================================================
" FILE: altercmd.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 13 Apr 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

function! vimshell#altercmd#define(original, alternative)"{{{
  execute 'inoreabbrev <buffer><expr>' a:original
        \ '(join(vimshell#get_current_args()) ==# "' . a:original  . '")?' 
        \ s:SID_PREFIX().'recursive_expand_altercmd('.string(a:original).')' ':' string(a:original)
  let b:vimshell.altercmd_table[a:original] = a:alternative
endfunction"}}}

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:recursive_expand_altercmd(string)
  " Recursive expand altercmd.
  let l:abbrev = b:vimshell.altercmd_table[a:string]
  let l:expanded = {}
  while 1
    let l:key = vimproc#parser#split_args(l:abbrev)[-1]
    if has_key(l:expanded, l:abbrev) || !has_key(b:vimshell.altercmd_table, l:abbrev)
      break
    endif
    
    let l:expanded[l:abbrev] = 1
    let l:abbrev = b:vimshell.altercmd_table[l:abbrev]
  endwhile

  return l:abbrev
endfunction

" vim: foldmethod=marker
