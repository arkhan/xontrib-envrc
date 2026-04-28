"""xontrib-envrc: direnv (.envrc) support for xonsh shell.

Loads/unloads environment variables from direnv on directory changes.
Compatible with xonsh 0.19+.
"""
import json
import subprocess

from xonsh.built_ins import XSH


def _direnv_export() -> dict | None:
    """Run `direnv export json` and return parsed dict, or None on failure.

    direnv exits with non-zero when the .envrc is blocked (needs `direnv allow`)
    or when there is no .envrc in scope. We capture stderr so the user still
    sees direnv's own diagnostic messages (e.g. the "blocked" warning) but we
    never let a non-zero exit bubble up as an unhandled exception.
    """
    try:
        result = subprocess.run(
            ["direnv", "export", "json"],
            capture_output=True,
            text=True,
        )
        # direnv prints its status messages (blocked, loaded, …) to stderr.
        if result.stderr:
            print(result.stderr, end="", flush=True)
        if result.returncode != 0 or not result.stdout.strip():
            return None
        return json.loads(result.stdout)
    except FileNotFoundError:
        # direnv is not installed / not on PATH – fail silently.
        return None
    except json.JSONDecodeError:
        return None


def _apply_direnv() -> None:
    """Apply the environment changes exported by direnv."""
    changes = _direnv_export()
    if not changes:
        return
    env = XSH.env
    with env.swap(UPDATE_OS_ENVIRON=True):
        for key, value in changes.items():
            if value is None:
                # direnv signals "unset this variable" with a JSON null
                env.pop(key, None)
            else:
                env[key] = value


@events.on_post_init
def _envrc_post_init(**kwargs) -> None:
    _apply_direnv()


@events.on_chdir
def _envrc_chdir(olddir: str, newdir: str, **kwargs) -> None:
    """Re-evaluate direnv on every directory change.

    When we are already inside a direnv-managed tree we only call direnv when
    we actually leave that tree (or enter a different one), which matches the
    behaviour of the bash/zsh direnv hooks.
    """
    direnv_dir = XSH.env.get("DIRENV_DIR")
    if direnv_dir is not None:
        # DIRENV_DIR is "-/path/to/project" – strip the leading dash.
        managed_root = direnv_dir.lstrip("-")
        import pathlib
        new_path = pathlib.Path(newdir).resolve()
        managed_path = pathlib.Path(managed_root).resolve()
        # Only re-run if we moved outside the currently managed subtree.
        if not str(new_path).startswith(str(managed_path)):
            _apply_direnv()
    else:
        _apply_direnv()


@events.on_postcommand
def _envrc_postcommand(cmd: str, rtn: int, out: str | None, ts: list, **kwargs) -> None:
    """Re-apply direnv after every command so that `direnv allow` takes effect
    immediately without needing a manual `cd .`."""
    _apply_direnv()
