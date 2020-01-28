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

" create a pdf an opens it in zathura
	function! PdfSync()
	    call jobstart('zathura -x "nvr --servername ' . expand("%:t:r") . ' --remote +%{line} %{input}" ' . '--synctex-forward ' . line(".") . ":" . col(".") . ":" . shellescape(expand("%:t")) . " '" . expand("%:t:r") . ".pdf'")
	endfunction!

	function! PdfBuild() 
		let s:path = shellescape("%:p:h/")
		let s:fileName = shellescape("%:r")
		let s:currentfile = shellescape(expand("%:t"))
		if filereadable("references.bib")
		    silent execute ("!biber " . s:fileName)
		endif
		silent execute "!pdflatex -synctex=1 " .  s:currentfile
		silent execute '!mv *.log *.bbl *.bcf *.aux *.blg *.xml many_files/'
		unlet s:path
		unlet s:fileName
	endfunction!

autocmd filetype *tex nnoremap <leader>p :call PdfSync()<CR>
autocmd bufWrite *tex :call PdfBuild()
