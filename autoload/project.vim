command! -nargs=+ Project
\ call project#config#project('project', <args>)

command! -nargs=+ Section
\ call project#config#project('section', <args>)

command! -nargs=+ File
\ call project#config#title(<args>)

command! -nargs=+ Callback
\ call project#config#callback(<args>)

command! -nargs=+ CallbackAllProjects
\ call project#config#callback_all_type('project', <args>)

command! -nargs=+ CallbackAllSections
\ call project#config#callback_all_type('section', <args>)

command! -complete=file -nargs=+ ProjectPath
\ call project#config#project_path(<f-args>)

command! -nargs=0 -bar Welcome
\ enew | call project#config#welcome()

command! -nargs=1 -bang -complete=custom,project#config#choices GoProject
\ call project#config#goto("<bang>", <q-args>)

command! -nargs=1 -bang -complete=custom,project#config#choices TabProject
\ tabe | call project#config#goto("<bang>", <q-args>)

command! -nargs=0 -bar TabWelcome
\ tabe | call project#config#welcome()

command! -nargs=0 -bar LockProjectDirectory
\ call project#config#set_directory_lock(1)

command! -nargs=0 -bar UnlockProjectDirectory
\ call project#config#set_directory_lock(0)

if (has("gui_running") && get(g:, 'project_enable_tab_title_gui', 1)) ||
\ (!has("gui_running") && get(g:, 'project_enable_tab_title_term'))
  function! TabTitle()
    let title = expand("%:p:t")
    let t:title = exists("b:title") ? b:title : title
  endfunction

  if has("gui_running") && get(g:, 'project_enable_tab_title_gui', 1)
    au VimEnter * set guitablabel=%-2.2N%{gettabvar(v:lnum,'title')}
  endif

  if !has("gui_running") && get(g:, 'project_enable_tab_title_term')
    " Adapted from https://github.com/mkitt/tabline.vim/blob/master/plugin/tabline.vim
    function! TabLine() abort
      let s = ''

      for t in range(tabpagenr('$'))
        let tn = t + 1

        let s .= '%' . tn . 'T' 
        let s .= (tn == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . tn . ' ' . gettabvar(tn, 'title') . ' '
      endfor

      let s .= '%#TabLineFill#'
      return s
    endfunction

    set tabline=%!TabLine()
  endif
endif

if has("gui_running") && get(g:, 'project_enable_win_title', 1)
  set title
endif

if get(g:, 'project_enable_welcome', 1)
  au VimEnter *
        \ if !argc() && (line2byte('$') == -1) && (v:progname =~? '^[gmn]\=vim\%[\.exe]$') |
        \   call project#config#welcome() |
        \ endif
endif

function! project#rc(...) abort
  let g:project_dir = len(a:000) > 0 ? expand(a:1, 1) : expand('$HOME', 1)
endfunction
