---
title: Using Debug VM
layout: en
permalink: /user/using-debug-vm/
---

When the build failure is only observable on Travis CI, and if you suspect that there are
critical differences between your local development environment and Travis CI's build VM,
you can make use of debug VM to gain access to the actual VM or container (henceforth
VM for brevity).

# Starting a debug VM

This feature is available for private repositories and those public repositories for which
the feature is enabled.
For private repositories, the build build button is available on the upper right corner of
the build/job page.
For public repositories, an API call is required, in addition to the feature being enabled.

## Starting a debug VM via API

In addition to the debug button, a debug build may be started via
API (which is the only way to do it for public repositories).

Here is an example for a public repository.
Token should be set to your Travis CI token, and the job ID (`$id`) should point to the job you
want to debug.

```sh-session
$ curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Travis-API-Version: 3" \
  -H "Authorization: token ********************" \
  -d "{\"quiet\": true}" \
  https://api.travis-ci.org/job/${id}/debug
```

For private repositories, the API endpoint is `https://api.travis-ci.com/job/${id}/debug`.

The JSON payload could be empty (`-d "{}"`), in which case any command input and output
you see while connected to the debug VM will be reflected on the build log.

# Connecting to the debug VM

Once the debug VM starts, it will go through the intial steps, including setting up language
run times and installing debug utilities.

When the debug VM is ready, you will see:

```
Debug build initiated by BanzaiMan
Setting up debug tools.
Preparing debug sessions.
Use the following SSH command to access the interactive debugging environment:
ssh DwBhYvwgoBQ2dr7iQ5ZH34wGt@ny2.tmate.io
This build is running in quiet mode. No session output will be displayed.
This debug build will stay alive for 30 minutes.
```

Running the `ssh` command above will drop you in on a live VM.

## Security implications of the `ssh` command

At this time, there is no authentication beyond the `ssh` command displayed in
the logs.

You may choose to share the `ssh` command with another person who might be
able to help you out in debugging the build.

However, this also means that anyone who can see the command while the debug
VM is live can connect to the debug VM and potentially look at your secrets.
This is the reason that the feature is not available by default on public
repositories.

Do note that when another `ssh` connection commences, that new connection
will be attached to the session you are already in.
If you suspect nefarious activity, you can either close all your windows, or cancel
the debug job on the Web UI to disconnect the potential attacker.

## "Permission denied" error message

Upon entering the `ssh` command, you may see an error message such as this:

```
$ ssh DwBhYvwgoBQ2dr7iQ5ZH34wGt@ny2.tmate.io
The authenticity of host 'ny2.tmate.io (104.236.9.236)' can't be established.
ECDSA key fingerprint is c7:a1:51:36:d2:bb:35:4b:0a:1a:c0:43:97:74:ea:42.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'ny2.tmate.io,104.236.9.236' (ECDSA) to the list of known hosts.
Permission denied (publickey).
```

If you see this, run the command `ssh-keygen` (go through the prompt), and try again.

# Things to do once you are inside the debug VM

Once inside the debug VM, you are able to poke around.

You are in a [`tmate`](https://tmate.io/) session, at the point
where your `before_install` (even if it is not defined) phase is about to
start.

## Convenience `bash` functions

Various build phases are defined in a convenience `bash` functions named
`travis_run_*` (e.g., `travis_run_before_install`, `travis_run_install`).
At the most basic level, you can simply run these build phases to observe your build:

```
travis_run_before_install
travis_run_install
travis_run_before_script
travis_run_script
travis_run_after_success
travis_run_after_failure
travis_run_after_script
```

## Using basic `tmate` features

`tmate` is a fork of [`tmux`](https://tmux.github.io/).
Your debug VM session uses the default configuration; thus, the command prefix is
`ctrl-b`.

A subset of functionalities are available for you in this debug session.

### Creating a new window

- `ctrl-b c`

The first window is indexed 0, so this will give you windows 1, 2, and so on.

### Switching to a different window

- `ctrl-b 0`

This switches your session's focus to the window with the given index.

Switching between windows can be helpful if you want to run long-running process in
one window while looking at the debug VM in another.

### Scrolling up and down the terminal history

- `ctrl-[`

In this mode, you can move your cursor with your arrow keys to go through the
log history.

## Getting out of the debug VM

Once you exit from all the live `tmate` windows, the debug VM will finish
after resetting the job's status to the original status.
No more stages (`before_install`, `install`, etc.) will be executed.
