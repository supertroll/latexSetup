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

autocmd filetype *tex nnoremap <leader>p :call PdfSync()<CR>
autocmd filetype *tex nnoremap <leader>b :call PdfBuild()<CR>
