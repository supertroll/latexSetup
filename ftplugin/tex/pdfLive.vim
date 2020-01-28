if exists(b:plPlugin)
    finish
endif
let b:pl_plugin = 1

" create config files

silent! system("mkdir $HOME/.config/pdfLive")

" because the synctex-forward is separate, i have to check whether zathura is open or not
if system("xdtotool search -name " . expand("%:p:r") . ".pdf")
    let b:zathuraPid = system("xdtotool search -name " . expand("%:p:r") . ".pdf getwindowpid")
endif

" compile the pdf 
function! PdfBuild() 
    update
    let b:root = expand("%:p:r")
    system("pdflatex -interaction=nonstopmode -file-line-error -halt-on-error" . b:root . ".tex")
    if match(readfile(b:root . ".log"), "run Biber")
	system("biber " . b:root . ".tex")
    endif
    if match(readfile(b:root . ".log"), "rerun")
	system("pdflatex -interaction=nonstopmode -file-line-error -halt-on-error" . b:root . ".tex")
    endif
    silent execute '!mv *.log *.bbl *.bcf *.aux *.blg *.xml many_files/'
endfunction!

" create a pdf an opens it in zathura
function! PdfSync()
    call jobstart('zathura -x "nvr --servername ' . expand("%:t:r") . ' --remote +%{line} %{input}" ' . '--synctex-forward ' . line(".") . ":" . col(".") . ":" . shellescape(expand("%:t")) . " '" . expand("%:t:r") . ".pdf'")
endfunction!


autocmd filetype *tex nnoremap <leader>p :call PdfSync()<CR>
autocmd textChanged,filetype *tex :call PdfBuild()
autocmd textChangedI,filetype *tex :call PdfBuild()
