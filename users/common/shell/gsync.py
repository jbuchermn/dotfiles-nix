#!/usr/bin/env python3
import sys
import os
from pathlib import Path
from subprocess import call, run, STDOUT

def is_git_repo(path):
    return call(["git", "status"], cwd=path, stderr=STDOUT, stdout=open(os.devnull, 'w')) == 0

def sync_git(path_from, path_to):
    if not path_to.parents[0].exists():
        print("Creating directory %s" % path_to.parents[0])
        path_to.parents[0].mkdir(parents=True)

    if path_to.exists() and not is_git_repo(path_to):
        backup = Path("/tmp") / "backup" 
        backup.mkdir(parents=True, exist_ok=True)
        print("Warning! %s exists, but is not a git repo!" % path_to)
        cont = input("Continue? Directory will be moved to /tmp/backup [y/N] ")
        if cont != "y":
            exit(1)
        path_to.replace(backup / path_to.name)

    if path_to.exists():
        print("Pulling git repo: %s -> %s" % (path_from, path_to))
        call(["git", "pull", "--rebase", "--", str(path_from)], cwd=path_to)
    else:
        print("Cloning git repo: %s -> %s" % (path_from, path_to))
        call(["git", "clone", str(path_from), path_to.name], cwd=path_to.parents[0])

def sync_dir(path_from, path_to):
    if not is_git_repo(path_from):
        print("%s: not a git repo..." % path_from)

        if not path_to.exists():
            print("Creating directory %s" % path_to)
            path_to.mkdir(parents=True)

        for x in path_from.iterdir():
            if x.is_dir():
                yield from sync_dir(x, path_to / x.name)
            else:
                yield x

    else:
        print("%s: git repo" % path_from)
        sync_git(path_from, path_to)



if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: gsync <source folder> <target folder>")
        exit(2)
    pf = Path(sys.argv[1]).absolute()
    pt = Path(sys.argv[2]).absolute()

    if pf.is_file():
        files = [str(pf.name)]
        pf = pf.parents[0]
        pt = pt.parents[0]
    else:
        files = [str(s.relative_to(pf)) for s in sync_dir(pf, pt)]

    files_list = "\n".join(files)

    run(["rsync", "--progress", "--modify-window=2", "--update", "--times", "--files-from=-", str(pf), str(pt)],
        input = files_list.encode("utf-8"))



































