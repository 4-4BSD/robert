<p align="center">
  <a href="https://llmrb.github.io/robert">
    <img src="https://img.shields.io/badge/docs-llmrb.github.io/robert-blue.svg" alt="Website">
  </a>
  <a href="https://opensource.org/license/0bsd">
    <img src="https://img.shields.io/badge/License-0BSD-orange.svg" alt="License">
  </a>
  <a href="https://github.com/llmrb/robert/releases/tag/latest">
    <img src="https://img.shields.io/badge/version-0.5.2-green.svg" alt="Version">
  </a>
  <a href="https://www.freebsd.org/">
    <img src="https://img.shields.io/badge/FreeBSD-supported-brightgreen.svg" alt="FreeBSD">
  </a>
</p>

## About

Robert is designed to help you learn about FreeBSD through its official
documentation and man pages. It is distributed as a standalone, 3MB
binary. The [website](https://llmrb.github.io/robert) provides a
rich introduction with screenshots and a screencast.

Robert requires DeepSeek, and it is almost free to use but
robert _could_ also work with other providers.

## Appearance

**Boot**

The boot screen runs `fortune freebsd-tips` <br>
Similar to the default FreeBSD default `${HOME}/.profile`.

![robert1.png](robert1.png)

**First turn**

Simple greeting.

![robert2.png](robert2.png)

**Second turn**

Question answered from the FreeBSD man pages.

![robert3.png](robert3.png)

**Tool confirmation**

No confirmation required to read, or search man pages. <br>
Confirmation required to read files.

![robert4.png](robert4.png)

## Tools

| Tool | Description | Confirmation |
|------|-------------|--------------|
| `man-page` | Returns the contents of a man page (optionally by section) | No |
| `man-search` | Searches manual pages for keywords via `apropos` | No |
| `read-file` | Reads a file from the filesystem | Yes |
| `version` | Reports Robert's version number | No |

## Build from source

Robert is an mruby gem built with the mruby-llm runtime. To build
from source, check out the repository and use the included Makefile:

```sh
git clone https://github.com/llmrb/robert.git
cd robert
make
```

The Makefile expects an mruby checkout at `../mruby`. Override with
`MRUBY_DIR=/path/to/mruby` if needed.

## Download

There are two ways to build Robert: as a statically linked binary,
or as a dynamically linked binary. The static binary weighs a little
under 3MB, and the dynamic binary weighs a little under 2MB.

The static binary can be [downloaded via GitHub actions](https://github.com/llmrb/robert/releases/tag/latest),
and it has been tested on both FreeBSD 15-STABLE and FreeBSD 16-CURRENT.

## Association

This project belongs to the [llm.rb](https://github.com/llmrb/llm.rb#readme) family of
projects. The [mruby-llm](https://github.com/llmrb/mruby-llm#readme) runtime is a
port of [llm.rb](https://github.com/llmrb/llm.rb) to mruby, and it was used
to build this project.

## License

0BSD. See [LICENSE](LICENSE).
