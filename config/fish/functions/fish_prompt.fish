set __fish_git_prompt_show_informative_status 'true'
set __fish_git_prompt_showcolorhints 'true'
set __fish_git_prompt_char_stateseparator " "


function fish_prompt
  # echo -n (basename $PWD)
  set_color 268bd2
  echo -n (prompt_pwd)
  # red
  set_color 657b83
  __fish_git_prompt " ♆ %s "
  # echo -n (__fish_git_prompt_show_informative_status)
  set_color d30102
  echo -n " ❯"
  # gray
  set_color 657b83
  echo -n "❯"
  # blue
  set_color 268bd2
  echo -n "❯ "
end


function __fish_git_prompt_show_upstream --description "Helper function for __fish_git_prompt"
  set -l show_upstream $__fish_git_prompt_showupstream
  set -l svn_prefix # For better SVN upstream information
  set -l informative

  set -l svn_url_pattern
  set -l count
  set -l upstream git
  set -l legacy
  set -l verbose
  set -l name

  # Default to informative if show_informative_status is set
  if test -n "$__fish_git_prompt_show_informative_status"
    set informative 1
end

set -l svn_remote
# get some config options from git-config
command git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' ^/dev/null | tr '\0\n' '\n ' | while read -l key value
switch $key
  case bash.showupstream
    set show_upstream $value
    test -n "$show_upstream"; or return
  case svn-remote.'*'.url
    set svn_remote $svn_remote $value
    # Avoid adding \| to the beginning to avoid needing #?? later
    if test -n "$svn_url_pattern"
      set svn_url_pattern $svn_url_pattern"\\|$value"
    else
      set svn_url_pattern $value
    end
    set upstream svn+git # default upstream is SVN if available, else git

    # Save the config key (without .url) for later use
    set -l remote_prefix (echo $key | sed 's/\.url$//')
    set svn_prefix $svn_prefix $remote_prefix
  end
end

# parse configuration variables
# and clear informative default when needed
for option in $show_upstream
  switch $option
  case git svn
    set upstream $option
    set -e informative
  case verbose
    set verbose 1
    set -e informative
  case informative
    set informative 1
  case legacy
    set legacy 1
    set -e informative
  case name
    set name 1
  case none
    return
  end
end

# Find our upstream
switch $upstream
case git
  set upstream '@{upstream}'
case svn\*
  # get the upstream from the 'git-svn-id: ...' in a commit message
  # (git-svn uses essentially the same procedure internally)
  set -l svn_upstream (git log --first-parent -1 --grep="^git-svn-id: \($svn_url_pattern\)" ^/dev/null)
  if test (count $svn_upstream) -ne 0
    echo $svn_upstream[-1] | read -l __ svn_upstream __
    set svn_upstream (echo $svn_upstream | sed 's/@.*//')
    set -l cur_prefix
    for i in (seq (count $svn_remote))
      set -l remote $svn_remote[$i]
      set -l mod_upstream (echo $svn_upstream | sed "s|$remote||")
      if test "$svn_upstream" != "$mod_upstream"
        # we found a valid remote
        set svn_upstream $mod_upstream
        set cur_prefix $svn_prefix[$i]
        break
      end
    end

    if test -z "$svn_upstream"
      # default branch name for checkouts with no layout:
      if test -n "$GIT_SVN_ID"
        set upstream $GIT_SVN_ID
      else
        set upstream git-svn
      end
    else
      set upstream (echo $svn_upstream | sed 's|/branches||; s|/||g')

      # Use fetch config to fix upstream
      set -l fetch_val (command git config "$cur_prefix".fetch)
      if test -n "$fetch_val"
        set -l IFS :
        echo "$fetch_val" | read -l trunk pattern
        set upstream (echo $pattern | sed -e "s|/$trunk\$||") /$upstream
      end
    end
  else if test $upstream = svn+git
    set upstream '@{upstream}'
  end
end

# Find how many commits we are ahead/behind our upstream
if test -z "$legacy"
  set count (command git rev-list --count --left-right $upstream...HEAD ^/dev/null)
else
  # produce equivalent output to --count for older versions of git
  set -l os
  set -l commits (command git rev-list --left-right $upstream...HEAD ^/dev/null; set os $status)
  if test $os -eq 0
    set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
    set -l ahead (count (for arg in $commits; echo $arg; end | grep -v '^<'))
    set count "$behind	$ahead"
  else
    set count
  end
end

# calculate the result
if test -n "$verbose"
  # Verbose has a space by default
  set -l prefix "$___fish_git_prompt_char_upstream_prefix"
  # Using two underscore version to check if user explicitly set to nothing
  if not set -q __fish_git_prompt_char_upstream_prefix
    set -l prefix " "
  end

  echo $count | read -l behind ahead
  switch "$count"
  case '' # no upstream
  case "0	0" # equal to upstream
    echo "$prefix$___fish_git_prompt_char_upstream_equal"
  case "0	*" # ahead of upstream
    echo "$prefix$___fish_git_prompt_char_upstream_ahead$ahead"
  case "*	0" # behind upstream
    echo "$prefix$___fish_git_prompt_char_upstream_behind$behind"
  case '*' # diverged from upstream
    echo "$prefix$___fish_git_prompt_char_upstream_diverged$ahead-$behind"
  end
  if test -n "$count" -a -n "$name"
    echo " "(command git rev-parse --abbrev-ref "$upstream" ^/dev/null)
  end
else if test -n "$informative"
  echo $count | read -l behind ahead
  switch "$count"
  case '' # no upstream
  case "0	0" # equal to upstream
  case "0	*" # ahead of upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_ahead$ahead"
  case "*	0" # behind upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_behind$behind"
  case '*' # diverged from upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_ahead$ahead$___fish_git_prompt_char_upstream_behind$behind"
  end
else
  switch "$count"
  case '' # no upstream
  case "0	0" # equal to upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_equal"
  case "0	*" # ahead of upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_ahead"
  case "*	0" # behind upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_behind"
  case '*' # diverged from upstream
    echo "$___fish_git_prompt_char_upstream_prefix$___fish_git_prompt_char_upstream_diverged"
  end
end
end

function __fish_git_prompt --description "Prompt function for Git"
  # If git isn't installed, there's nothing we can do
  # Return 1 so the calling prompt can deal with it
  if not command -s git >/dev/null
    return 1
end
set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD ^/dev/null)
test -n "$repo_info"; or return

set -l git_dir         $repo_info[1]
set -l inside_gitdir   $repo_info[2]
set -l bare_repo       $repo_info[3]
set -l inside_worktree $repo_info[4]
set -l short_sha
if test (count $repo_info) = 5
  set short_sha $repo_info[5]
end

set -l rbc (__fish_git_prompt_operation_branch_bare $repo_info)
set -l r $rbc[1] # current operation
set -l b $rbc[2] # current branch
set -l detached $rbc[3]
set -l w #dirty working directory
set -l i #staged changes
set -l s #stashes
set -l u #untracked
set -l c $rbc[4] # bare repository
set -l p #upstream
set -l informative_status

__fish_git_prompt_validate_chars
__fish_git_prompt_validate_colors

set -l space "$___fish_git_prompt_color$___fish_git_prompt_char_stateseparator$___fish_git_prompt_color_done"

if test "true" = $inside_worktree
  if test -n "$__fish_git_prompt_show_informative_status"
    set informative_status "$space"(__fish_git_prompt_informative_status)
  else
    if test -n "$__fish_git_prompt_showdirtystate"
      set -l config (command git config --bool bash.showDirtyState)
      if test "$config" != "false"
        set w (__fish_git_prompt_dirty)
        set i (__fish_git_prompt_staged $short_sha)
      end
    end

    if test -n "$__fish_git_prompt_showstashstate" -a -r $git_dir/refs/stash
      set s $___fish_git_prompt_char_stashstate
    end

    if test -n "$__fish_git_prompt_showuntrackedfiles"
      set -l config (command git config --bool bash.showUntrackedFiles)
      if test "$config" != false
        if command git ls-files --others --exclude-standard --error-unmatch -- '*' >/dev/null ^/dev/null
          set u $___fish_git_prompt_char_untrackedfiles
        end
      end
    end
  end

  if test -n "$__fish_git_prompt_showupstream" -o "$__fish_git_prompt_show_informative_status"
    set p (__fish_git_prompt_show_upstream)
  end
end

set -l branch_color $___fish_git_prompt_color_branch
set -l branch_done  $___fish_git_prompt_color_branch_done
if test -n "$__fish_git_prompt_showcolorhints"
  if test $detached = yes
    set branch_color $___fish_git_prompt_color_branch_detached
    set branch_done  $___fish_git_prompt_color_branch_detached_done
  end
end

if test -n "$w"
  set w "$___fish_git_prompt_color_dirtystate$w$___fish_git_prompt_color_dirtystate_done"
end
if test -n "$i"
  set i "$___fish_git_prompt_color_stagedstate$i$___fish_git_prompt_color_stagedstate_done"
end
if test -n "$s"
  set s "$___fish_git_prompt_color_stashstate$s$___fish_git_prompt_color_stashstate_done"
end
if test -n "$u"
  set u "$___fish_git_prompt_color_untrackedfiles$u$___fish_git_prompt_color_untrackedfiles_done"
end
set b (echo $b | sed 's|refs/heads/||')
if test -n "$b"
  set b "$branch_color$b$branch_done"
end
if test -n "$c"
  set c "$___fish_git_prompt_color_bare$c$___fish_git_prompt_color_bare_done"
end
if test -n "$r"
  set r "$___fish_git_prompt_color_merging$r$___fish_git_prompt_color_merging_done"
end
if test -n "$p"
  set p "$___fish_git_prompt_color_upstream$p$___fish_git_prompt_color_upstream_done"
end

# Formatting
set -l f "$w$i$s$u"
if test -n "$f"
  set f "$space$f"
end
set -l format $argv[1]
if test -z "$format"
  set format " (%s)"
end

printf "%s$format%s" "$___fish_git_prompt_color_prefix" "$___fish_git_prompt_color_prefix_done$c$b$f$r$p$informative_status$___fish_git_prompt_color_suffix" "$___git_ps_color_suffix_done"
end

### helper functions

function __fish_git_prompt_staged --description "__fish_git_prompt helper, tells whether or not the current branch has staged files"
  set -l short_sha $argv[1]

  set -l staged

  if test -n "$short_sha"
    command git diff-index --cached --quiet HEAD --; or set staged $___fish_git_prompt_char_stagedstate
else
  set staged $___fish_git_prompt_char_invalidstate
end
echo $staged
end

function __fish_git_prompt_dirty --description "__fish_git_prompt helper, tells whether or not the current branch has tracked, modified files"
  set -l dirty

  set -l os
  command git diff --no-ext-diff --quiet --exit-code
  set os $status
  if test $os -ne 0
    set dirty $___fish_git_prompt_char_dirtystate
end
echo $dirty
end

set -g ___fish_git_prompt_status_order stagedstate invalidstate dirtystate untrackedfiles

function  __fish_git_prompt_informative_status

  set -l changedFiles (command git diff --name-status | cut -c 1-2)
  set -l stagedFiles (command git diff --staged --name-status | cut -c 1-2)

  set -l dirtystate (math (count $changedFiles) - (count (echo $changedFiles | grep "U")))
  set -l invalidstate (count (echo $stagedFiles | grep "U"))
  set -l stagedstate (math (count $stagedFiles) - $invalidstate)
  set -l untrackedfiles (count (command git ls-files --others --exclude-standard))

  set -l info

  if [ (math $dirtystate + $invalidstate + $stagedstate + $untrackedfiles) = 0 ]
    set info $___fish_git_prompt_color_cleanstate$___fish_git_prompt_char_cleanstate$___fish_git_prompt_color_cleanstate_done
else
  for i in $___fish_git_prompt_status_order
    if [ $$i != "0" ]
      set -l color_var ___fish_git_prompt_color_$i
      set -l color_done_var ___fish_git_prompt_color_{$i}_done
      set -l symbol_var ___fish_git_prompt_char_$i

      set -l color $$color_var
      set -l color_done $$color_done_var
      set -l symbol $$symbol_var

      set -l count

      if not set -q __fish_git_prompt_hide_$i
        set count $$i
      end

      set info "$info$color$symbol$count$color_done"
    end
  end
end

echo $info

end

# Keeping these together avoids many duplicated checks
function __fish_git_prompt_operation_branch_bare --description "__fish_git_prompt helper, returns the current Git operation and branch"
  # This function is passed the full repo_info array
  set -l git_dir         $argv[1]
  set -l inside_gitdir   $argv[2]
  set -l bare_repo       $argv[3]
  set -l short_sha
  if test (count $argv) = 5
    set short_sha $argv[5]
end

set -l branch
set -l operation
set -l detached no
set -l bare
set -l step
set -l total
set -l os

if test -d $git_dir/rebase-merge
  set branch (cat $git_dir/rebase-merge/head-name ^/dev/null)
  set step (cat $git_dir/rebase-merge/msgnum ^/dev/null)
  set total (cat $git_dir/rebase-merge/end ^/dev/null)
  if test -f $git_dir/rebase-merge/interactive
    set operation "|REBASE-i"
  else
    set operation "|REBASE-m"
  end
else
  if test -d $git_dir/rebase-apply
    set step (cat $git_dir/rebase-apply/next ^/dev/null)
    set total (cat $git_dir/rebase-apply/last ^/dev/null)
    if test -f $git_dir/rebase-apply/rebasing
      set branch (cat $git_dir/rebase-apply/head-name ^/dev/null)
      set operation "|REBASE"
    else if test -f $git_dir/rebase-apply/applying
      set operation "|AM"
    else
      set operation "|AM/REBASE"
    end
  else if test -f $git_dir/MERGE_HEAD
    set operation "|MERGING"
  else if test -f $git_dir/CHERRY_PICK_HEAD
    set operation "|CHERRY-PICKING"
  else if test -f $git_dir/REVERT_HEAD
    set operation "|REVERTING"
  else if test -f $git_dir/BISECT_LOG
    set operation "|BISECTING"
  end
end

if test -n "$step" -a -n "$total"
  set operation "$operation $step/$total"
end

if test -z "$branch"
  set branch (command git symbolic-ref HEAD ^/dev/null; set os $status)
  if test $os -ne 0
    set detached yes
    set branch (switch "$__fish_git_prompt_describe_style"
          case contains
            command git describe --contains HEAD
          case branch
            command git describe --contains --all HEAD
          case describe
            command git describe HEAD
          case default '*'
            command git describe --tags --exact-match HEAD
          end ^/dev/null; set os $status)
          if test $os -ne 0
            if test -n "$short_sha"
              set branch $short_sha...
      else
        set branch unknown
      end
    end
    set branch "($branch)"
  end
end

if test "true" = $inside_gitdir
  if test "true" = $bare_repo
    set bare "BARE:"
  else
    # Let user know they're inside the git dir of a non-bare repo
    set branch "GIT_DIR!"
  end
end

echo $operation
echo $branch
echo $detached
echo $bare
end

function __fish_git_prompt_set_char
  set -l user_variable_name "$argv[1]"
  set -l char $argv[2]
  set -l user_variable $$user_variable_name

  if test (count $argv) -ge 3
    if test -n "$__fish_git_prompt_show_informative_status"
      set char $argv[3]
  end
end

set -l variable _$user_variable_name
set -l variable_done "$variable"_done

if not set -q $variable
  set -g $variable (set -q $user_variable_name; and echo $user_variable; or echo $char)
end
end

function __fish_git_prompt_validate_chars --description "__fish_git_prompt helper, checks char variables"

  __fish_git_prompt_set_char __fish_git_prompt_char_cleanstate        '✔'
  __fish_git_prompt_set_char __fish_git_prompt_char_dirtystate        '*' '✚'
  __fish_git_prompt_set_char __fish_git_prompt_char_invalidstate      '#' '✖'
  __fish_git_prompt_set_char __fish_git_prompt_char_stagedstate       '+' '●'
  __fish_git_prompt_set_char __fish_git_prompt_char_stashstate        '$'
  __fish_git_prompt_set_char __fish_git_prompt_char_stateseparator    ' ' '|'
  __fish_git_prompt_set_char __fish_git_prompt_char_untrackedfiles    '%' '…'
  __fish_git_prompt_set_char __fish_git_prompt_char_upstream_ahead    '>' '↑'
  __fish_git_prompt_set_char __fish_git_prompt_char_upstream_behind   '<' '↓'
  __fish_git_prompt_set_char __fish_git_prompt_char_upstream_diverged '<>'
  __fish_git_prompt_set_char __fish_git_prompt_char_upstream_equal    '='
  __fish_git_prompt_set_char __fish_git_prompt_char_upstream_prefix   ''

end

function __fish_git_prompt_set_color
  set -l user_variable_name "$argv[1]"
  set -l user_variable $$user_variable_name
  set -l user_variable_bright

  set -l default default_done
  switch (count $argv)
case 1 # No defaults given, use prompt color
  set default $___fish_git_prompt_color
  set default_done $___fish_git_prompt_color_done
case 2 # One default given, use normal for done
  set default "$argv[2]"
  set default_done (set_color normal)
case 3 # Both defaults given
  set default "$argv[2]"
  set default_done "$argv[3]"
end

set -l variable _$user_variable_name
set -l variable_done "$variable"_done

if not set -q $variable
  if test -n "$user_variable"
    set -g $variable (set_color $user_variable)
    set -g $variable_done (set_color normal)
  else
    set -g $variable $default
    set -g $variable_done $default_done
  end
end

end


function __fish_git_prompt_validate_colors --description "__fish_git_prompt helper, checks color variables"

  # Base color defaults to nothing (must be done first)
  __fish_git_prompt_set_color __fish_git_prompt_color '' ''

  # Normal colors
  __fish_git_prompt_set_color __fish_git_prompt_color_prefix
  __fish_git_prompt_set_color __fish_git_prompt_color_suffix
  __fish_git_prompt_set_color __fish_git_prompt_color_bare
  __fish_git_prompt_set_color __fish_git_prompt_color_merging
  __fish_git_prompt_set_color __fish_git_prompt_color_cleanstate
  __fish_git_prompt_set_color __fish_git_prompt_color_invalidstate
  __fish_git_prompt_set_color __fish_git_prompt_color_upstream

  # Colors with defaults with showcolorhints
  if test -n "$__fish_git_prompt_showcolorhints"
    __fish_git_prompt_set_color __fish_git_prompt_color_flags       (set_color --bold blue)
    __fish_git_prompt_set_color __fish_git_prompt_color_branch      (set_color green)
    __fish_git_prompt_set_color __fish_git_prompt_color_dirtystate  (set_color red)
    __fish_git_prompt_set_color __fish_git_prompt_color_stagedstate (set_color green)
else
  __fish_git_prompt_set_color __fish_git_prompt_color_flags
  __fish_git_prompt_set_color __fish_git_prompt_color_branch
  __fish_git_prompt_set_color __fish_git_prompt_color_dirtystate  $___fish_git_prompt_color_flags $___fish_git_prompt_color_flags_done
  __fish_git_prompt_set_color __fish_git_prompt_color_stagedstate $___fish_git_prompt_color_flags $___fish_git_prompt_color_flags_done
end

# Branch_detached has a default, but is only used with showcolorhints
__fish_git_prompt_set_color __fish_git_prompt_color_branch_detached (set_color red)

# Colors that depend on flags color
__fish_git_prompt_set_color __fish_git_prompt_color_stashstate      $___fish_git_prompt_color_flags $___fish_git_prompt_color_flags_done
__fish_git_prompt_set_color __fish_git_prompt_color_untrackedfiles  $___fish_git_prompt_color_flags $___fish_git_prompt_color_flags_done

end

set -l varargs
for var in repaint describe_style show_informative_status showdirtystate showstashstate showuntrackedfiles showupstream
  set varargs $varargs --on-variable __fish_git_prompt_$var
end
function __fish_git_prompt_repaint $varargs --description "Event handler, repaints prompt when functionality changes"
  if status --is-interactive
    if test $argv[3] = __fish_git_prompt_show_informative_status
      # Clear characters that have different defaults with/without informative status
      for name in cleanstate dirtystate invalidstate stagedstate stateseparator untrackedfiles upstream_ahead upstream_behind
        set -e ___fish_git_prompt_char_$name
    end
  end

  commandline -f repaint ^/dev/null
end
end

set -l varargs
for var in '' _prefix _suffix _bare _merging _cleanstate _invalidstate _upstream _flags _branch _dirtystate _stagedstate _branch_detached _stashstate _untrackedfiles
  set varargs $varargs --on-variable __fish_git_prompt_color$var
end
set varargs $varargs --on-variable __fish_git_prompt_showcolorhints
function __fish_git_prompt_repaint_color $varargs --description "Event handler, repaints prompt when any color changes"
  if status --is-interactive
    set -l var $argv[3]
    set -e _$var
    set -e _{$var}_done
    if test $var = __fish_git_prompt_color -o $var = __fish_git_prompt_color_flags -o $var = __fish_git_prompt_showcolorhints
      # reset all the other colors too
      for name in prefix suffix bare merging branch dirtystate stagedstate invalidstate stashstate untrackedfiles upstream flags
        set -e ___fish_git_prompt_color_$name
        set -e ___fish_git_prompt_color_{$name}_done
    end
  end
  commandline -f repaint ^/dev/null
end
end

set -l varargs
for var in cleanstate dirtystate invalidstate stagedstate stashstate stateseparator untrackedfiles upstream_ahead upstream_behind upstream_diverged upstream_equal upstream_prefix
  set varargs $varargs --on-variable __fish_git_prompt_char_$var
end
function __fish_git_prompt_repaint_char $varargs --description "Event handler, repaints prompt when any char changes"
  if status --is-interactive
    set -e _$argv[3]
    commandline -f repaint ^/dev/null
end
end
