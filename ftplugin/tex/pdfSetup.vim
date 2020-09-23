if exists("b:plPlugin")
    finish
endif
let b:pl_plugin = 1

" compile the pdf 
function! PdfBuild() 
    update
    let b:root = expand("%:r")
    call execute('!pdflatex --synctex=1 ' . b:root . ".tex")
    if match(readfile(b:root . ".log"), "run Biber") > -1
	call execute("!biber " . b:root)
	call execute("!pdflatex --synctex=1 " . b:root . ".tex")
    endif
    call execute("!ln -f " . b:root . ".pdf ..")
    echo "done"
    unlet b:root
endfunction!

" create a pdf an opens it in zathura
function! PdfSync()
    call jobstart('zathura -x "nvr --servername ' . expand("%:t:r") . ' --remote +%{line} %{input}" ' . '--synctex-forward ' . line(".") . ":" . col(".") . ":" . shellescape(expand("%:t")) . " '" . expand("%:t:r") . ".pdf'")
endfunction!

" create a text object for latex environments
fun! s:environment(ia)
    normal! ^
    let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.') - &softtabstop
    let l:start = search('^\s*\%'.l:vCol.'v\\begin{[^\n]*}', 'bWn')
    let l:end = search('^\s*\%'.l:vCol.'v\\end{[^\n]*}','Wn')

    if (a:ia == 'i')
	let l:start += 1
	let l:end -= 1
    endif

    execute 'normal! '.l:start.'G0V'.l:end.'G$o'
endfun!

fun Fraction()
    if getline('.')[col('.')-1] == ')'
	exe "normal! %xi\\frac{\<Esc>lf)xa}{}<++>\<Esc>F{l"
	startinsert
    elseif getline('.')[col('.')-1] != ' '
	exe "normal! Bi\\frac{\<Esc>Ea}{}<++>\<Esc>F{l"
	startinsert
    else
	exe "normal! i \\frac{}{<++>}<++>\<Esc>?{}\<CR>l"
	startinsert
    endif
endfun 

xnoremap ie :<c-u>call <sid>environment('i')<cr>
onoremap ie :<c-u>call <sid>environment('i')<cr>

xnoremap ae :<c-u>call <sid>environment('a')<cr>
onoremap ae :<c-u>call <sid>environment('a')<cr>

nnoremap <leader>p :call PdfSync()<CR>
nnoremap <leader>b :call PdfBuild()<CR>
" latex shortcuts
inoremap \pa<Space> \part{}<CR><++><Esc>1kf{a
inoremap \ch<Space> \chapter{}<CR><++><Esc>1kf{a
inoremap \se<Space> \section{}<CR><++><Esc>1kf{a
inoremap \ss<Space> \subsection{}<CR><++><Esc>1kf{a
inoremap \sss<Space> \subsubsection{}<CR><++><Esc>1kf{a
inoremap \pr<Space> \paragraph{}<CR><++><Esc>1kf{a
inoremap \bl<Space> \textbf{}<++><Esc>F{a
inoremap \il<Space> \textit{}<++><Esc>F{a
inoremap \ul<Space> \underline{}<++><Esc>F{a
inoremap \em<Space> \emph{}<++><Esc>F{a
inoremap \tab<Space> \begin{tabular}{<}<CR><++><CR>\end{tabular}<Esc>2kf<xi
inoremap \it<Space> \begin{itemize}<CR><CR>\end{itemize}<Esc>1ki
inoremap \en<Space> \begin{enumerate}<CR><CR>\end{enumerate}<Esc>1ki
inoremap \ds<Space> \begin{description}<CR><CR>\end{description}<Esc>1ki
inoremap \ali<Space> \begin{align}<CR><CR>\end{align}<Esc>1ki
inoremap \i<Space> \item<Space>
inoremap // <Esc>:call Fraction()<CR>
inoremap \d<Space> \Delta<Space>
inoremap \sum<Space> \sum_{}^{<++>}<++><Esc>?{}<CR>a
inoremap \lim<Space> \lim_{}<++><Esc>?{}<CR>a
