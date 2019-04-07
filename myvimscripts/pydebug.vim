function! PyDebug()
    " Launches an iterm2 window and invokes pudb on the file that's currently
    " open. Also sets a breakpoint on the current line and runs the program
    " upto that line.
    let python = trim(system('echo `which python`'))
    call system('rm ~/.config/pudb/saved-breakpoints-3.6')
    let curline = line('.')

    if curline != '1'
        " add curline as a breakpoint to the file pudb looks at when it starts
        echo system('echo "b '.expand('%:p').':'.curline.'" > ~/.config/pudb/saved-breakpoints-3.6')
        let apple_script = 'tell application "iTerm2"\n
                    \create window with default profile\n
                    \tell current session of current window\n
                    \write text "'.python.' -m pudb '.expand('%:p').'"\n
                    \delay 1\n
                    \write text "c"\n
                    \end tell\n
                    \end tell'
    else
        " don't add curline as a breakpoint essentially letting pudb start in
        " vanilla mode
        let apple_script = 'tell application "iTerm2"\n
                    \create window with default profile\n
                    \tell current session of current window\n
                    \write text "'.python.' -m pudb '.expand('%:p').'"\n
                    \end tell\n
                    \end tell'
    endif
    let cmd = "echo -e '".apple_script."' | osascript"
    call system(cmd)
endfunction
