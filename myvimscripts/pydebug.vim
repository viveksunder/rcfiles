let s:breakpoint_file = expand('~').'/.vim/myvimscripts/assets/breakpoint.png'
execute "sign define breakpoint icon=".s:breakpoint_file
let s:pudb_file = expand('~').'/.config/pudb/saved-breakpoints-3.6'

function! LoadBreakPoints()
    if !exists('b:breakpoints')
        let b:breakpoints = {}
    endif
    if !exists('b:other_breakpoints')
        let b:other_breakpoints = []
    endif

    let curfile = expand('%:p')
    for line in readfile(s:pudb_file)
        if line =~ '^b '.expand('%:p')
            let line_no = split(line, ':')[1]
            let b:breakpoints[line_no] = line_no
            call SetBreakPointInUI(line_no)
        else
            call add(b:other_breakpoints, line)
        endif
    endfor
endfunction

function! PyWriteBreakPoints()
    if !exists('b:breakpoints')
        let b:breakpoints = {}
    endif
    if !exists('b:other_breakpoints')
        let b:other_breakpoints = []
    endif
    call system('rm ~/.config/pudb/saved-breakpoints-3.6')
    let lines = []
    let curfile = expand('%:p')
    for line in keys(b:breakpoints)
        call add(lines, 'b '.curfile.':'.line)
    endfor
    for line in b:other_breakpoints
        call add(lines, line)
    endfor
    let echostr = join(lines, '\n')
    call system('echo -e "'.echostr.'" >> ~/.config/pudb/saved-breakpoints-3.6')
endfunction

function! SetBreakPointInUI(line_no)
    execute ":sign place ".a:line_no." line=".a:line_no." name=breakpoint file=".expand("%:p")
endfunction

function! UnsetBreakPointInUI(line_no)
    execute ":sign unplace ".a:line_no
endfunction

function! PyToggleBreakPoint()
    let curline = line('.')
    if !exists('b:breakpoints')
        let b:breakpoints = {} " breakpoint line_no -> sign number
    endif
    if has_key(b:breakpoints, curline)
        call UnsetBreakPointInUI(curline)
        unlet b:breakpoints[curline]
    else
        call SetBreakPointInUI(curline)
        let b:breakpoints[curline] = curline
    endif
    call PyWriteBreakPoints()
endfunction

function! PyDebug()
    " Launches an iterm2 window and invokes pudb on the file that's currently
    " open. Also sets a breakpoint on the current line and runs the program
    " upto that line.
    let source_env_if_exists = ''
    if len($PYDEBUGENVFILE) > 0
        if file_readable($PYDEBUGENVFILE)
            let source_env_if_exists = 'source '.$PYDEBUGENVFILE.' && '
        endif
    endif

    let python = source_env_if_exists.'PYTHONPATH='.$PWD.' '.trim(system('echo `which python`'))
    "call system('rm ~/.config/pudb/saved-breakpoints-3.6')
    let apple_script = 'tell application "iTerm2"\n
                \create window with default profile\n
                \tell current session of current window\n
                \write text "cd '.$PWD.'"\n
                \write text "'.python.' -m pudb '.expand('%').'"\n
                \delay 1\n
                \write text "c"\n
                \end tell\n
                \end tell'
    let cmd = "echo -e '".apple_script."' | osascript"
    call system(cmd)
endfunction

autocmd FileType python nnoremap <buffer> <space> :call PyToggleBreakPoint()<CR>
autocmd FileType python nnoremap <buffer> <C-x> :call PyDebug()<CR>
autocmd BufReadPost *.py execute ':call LoadBreakPoints()'
