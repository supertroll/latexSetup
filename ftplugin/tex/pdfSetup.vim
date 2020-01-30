if exists("b:plPlugin")
    finish
endif
let b:pl_plugin = 1

" compile the pdf 
function! PdfBuild() 
    update
    let b:root = expand("%:r")
    call jobstart('pdflatex -interaction=nonstopmode -file-line-error -halt-on-error ' . b:root . ".tex")
    if match(readfile(b:root . ".log"), "run Biber")
	call system("biber " . b:root . ".tex")
    endif
    if match(readfile(b:root . ".log"), "rerun")
	call system("pdflatex -interaction=nonstopmode -file-line-error -halt-on-error" . b:root . ".tex")
    endif
endfunction!

" create a pdf an opens it in zathura
function! PdfSync()
    call jobstart('zathura -x "nvr --servername ' . expand("%:t:r") . ' --remote +%{line} %{input}" ' . '--synctex-forward ' . line(".") . ":" . col(".") . ":" . shellescape(expand("%:t")) . " '" . expand("%:t:r") . ".pdf'")
endfunction!

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
inoremap \tab<Space> \begin{tabular}{<}<CR><++><CR>\end{tabular}<CR><++><Esc>3kf<xi
inoremap \it<Space> \begin{itemize}<CR><CR>\end{itemize}<CR><++><Esc>2ki
inoremap \en<Space> \begin{enumerate}<CR><CR>\end{enumerate}<CR><++><Esc>2ki
inoremap \ds<Space> \begin{description}<CR><CR>\end{description}<CR><++><Esc>2ki
inoremap \i<Space> \item<Space>

