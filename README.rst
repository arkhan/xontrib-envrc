xontrib-envrc
=============

`direnv <https://direnv.net>`_ support for the `xonsh shell <https://xon.sh>`_.

Automatically loads and unloads environment variables defined in ``.envrc``
files as you change directories, matching the behaviour of the official
bash/zsh direnv hooks.

Tested with Python 3.11, xonsh 0.23 and direnv 2.34+.

Install
-------

.. code-block:: xonsh

    xpip install xontrib-envrc
    xontrib load envrc

Or add to your ``~/.xonshrc``::

    xontrib load envrc

Usage
-----

Works exactly like the upstream direnv shell hook.  When you ``cd`` into a
directory that contains an ``.envrc``, direnv exports the environment changes
and this xontrib applies them to the running xonsh session.

Running ``direnv allow`` in a shell takes effect on the **next command**
without requiring a manual ``cd .``.

Migration from xonsh-direnv
----------------------------

The xontrib name changed from ``direnv`` to ``envrc``.  Update your
``~/.xonshrc``::

    # old
    xontrib load direnv
    # new
    xontrib load envrc

Change Log
----------

2.0.0
~~~~~
* Renamed package to ``xontrib-envrc`` and xontrib to ``envrc``
* Fixed crash when direnv exits non-zero (e.g. blocked ``.envrc``)
* Replaced ``$(...)`` xonsh capture with ``subprocess.run`` to avoid
  ``CalledProcessError`` bubbling up through the event system
* Uses ``XSH`` (new canonical API, xonsh >= 0.19) instead of ``__xonsh__``
* Switched to ``pathlib`` for directory comparison
* Added ``python_requires >= 3.10`` (union type hints ``X | Y``)

1.6.5
~~~~~
* PR https://github.com/74th/xonsh-direnv/pull/24

1.6.4
~~~~~
* PR https://github.com/74th/xonsh-direnv/pull/21

1.6.3
~~~~~
* PR https://github.com/74th/xonsh-direnv/pull/19

1.6.2
~~~~~
* PR https://github.com/74th/xonsh-direnv/pull/18

1.6.1
~~~~~
* Temporary revert 1.6.0

1.6.0
~~~~~
* PR https://github.com/74th/xonsh-direnv/pull/12

1.5
~~~
* Fix https://github.com/74th/xonsh-direnv/issues/2

1.4
~~~
* Fix xonsh has a history of breaking its built-ins
  https://github.com/74th/xonsh-direnv/pull/3

1.3
~~~
* ``$HOME/.envrc`` support
* ``direnv allow`` takes effect immediately

Contributors
------------

* Atsushi Morimoto (@74th, original author)
* con-f-use (@con-f-use, co-maintainer)
* Gil Forsyth (@gforsyth, contributor)
* Greg Hellings (@greg-hellings, contributor)
* Andy Kipp (@anki-code, contributor)
* Alexander Sosedkin (@t184256, contributor)
* Mark Bestley (@bestlem, contributor)
* mingmingrr (@mingmingrr, contributor)
