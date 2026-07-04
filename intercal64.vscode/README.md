# INTERCAL64

**IDE support for INTERCAL and INTERCAL64.**

INTERCAL64 extends the classic 1972 language to 64-bit arithmetic while remaining fully backwards compatible with programs written for INTERCAL-72. This extension brings both dialects into Visual Studio Code, including the first interactive debugger ever built for INTERCAL.

![INTERCAL64 debugger stopped on a breakpoint in Visual Studio Code](https://please-abstain.github.io/INTERCAL/intercal64-hero2.png)

> 💬 **Questions, code to share, or complaints about the syntax?** [Join the Discord.](https://discord.gg/3jQYdBvUwz)

## Syntax highlighting

Full grammar for `.i` and `.ic64` files, covering both dialects:

- **Statements** — `DO`, `PLEASE`, `NOT`, `COME FROM`, `READ OUT`, `WRITE IN`, `GIVE UP`, `ABSTAIN`, `REINSTATE`, `IGNORE`, `REMEMBER`, `STASH`, `RETRIEVE`, and the rest.
- **Operators** — `$` (mingle), `~` (select), `&` (AND), `V` (OR), `?` (XOR), `|` (rotate), `-` (flip).
- **Variables** — spots (`.1`), two-spots (`:1`), and the 64-bit four-spots (`::1`), plus arrays (`,1`, `;1`, `;;1`).
- **Constants** — the mesh prefixes `#` (16-bit), `##` (32-bit), and `####` (64-bit).
- **Labels and gerunds**, with splatted (`*`) statements flagged as errors.

Syntax highlighting works on its own — no compiler or runtime required.

## Snippets

Ready-made snippets for common INTERCAL idioms, including the double-NEXT trampoline and launch scaffolding.

## Debugging

Open any `.i` or `.ic64` file, set a breakpoint in the gutter, and press **F5**. The debugger speaks the Debug Adapter Protocol and gives you:

- **Breakpoints** on any INTERCAL statement.
- **Stepping** — Step Over, Step Into, and Continue. Step Into follows execution into a local `DO (label) NEXT`.
- **Variables panel** — your spots, two-spots, and four-spots appear as first-class locals, updated after each statement. (Array variables such as `,1` and `;1` are not shown in the Variables panel — inspect them from the Debug Console.)
- **Watch and Debug Console** — evaluate arbitrary **INTERCAL** expressions (selects, mingles, unary bit ops) against live program state. The console speaks INTERCAL, not C#.
- **ABSTAIN tracking** — see which statements are currently abstained.
- **COME FROM visualization** — the debugger marks COME FROM targets and shows where control will be pulled next.
- **Program I/O** — `WRITE IN` / `READ OUT` interaction appears in the terminal in real time.

## Requirements

- **Syntax highlighting and snippets** work on their own — just install and open a `.i` file.
- **Debugging** requires the INTERCAL64 toolchain — the `churn` compiler and the DAP adapter. Download the installer for your platform from the [latest release](https://github.com/PLEASE-ABSTAIN/INTERCAL64/releases/latest) and run it.

  On Windows, once our winget listing clears Microsoft's review (new publishers take a while to be approved), you'll also be able to install it with:

  ```
  winget install PleaseAbstain.INTERCAL64
  ```

  Either way, you'll also need the [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0), because churn compiles by transpiling to C# and invoking `csc`. Once the toolchain is installed, this extension finds the debugger automatically — no configuration needed.

  _Prefer to build from source? Clone [PLEASE-ABSTAIN/INTERCAL64](https://github.com/PLEASE-ABSTAIN/INTERCAL64) and run `dotnet build intercal64.sln`; set `intercal.projectRoot` if the extension doesn't auto-detect it._

## Getting started

1. Install this extension.
2. Open a `.i` or `.ic64` file — you get syntax highlighting immediately.
3. To debug, install the toolchain — download the installer from the [latest release](https://github.com/PLEASE-ABSTAIN/INTERCAL64/releases/latest) (or, once it's approved, `winget install PleaseAbstain.INTERCAL64`). Then open a program, set a breakpoint, and press **F5**. The 17 lessons in `samples/learn-intercal/` are built for stepping through.

## Extension settings

| Setting | Description |
|---------|-------------|
| `intercal.projectRoot` | Path to the INTERCAL64 project root (containing `churn/`, `intercal64.dap/`, etc.). Auto-detected from the workspace when empty. |

## Learn more

- **Documentation, tutorials, and papers** — [pleaseabstain.org](https://pleaseabstain.org/vscode/)
- **Source code** — [github.com/PLEASE-ABSTAIN/INTERCAL64](https://github.com/PLEASE-ABSTAIN/INTERCAL64)
- **Discord** — [join the server](https://discord.gg/3jQYdBvUwz)

## Prior art

INTERCAL was created by Don Woods and James Lyon at Princeton in 1972. This work builds on Eric Raymond's C-INTERCAL (`ick`) and Jason Whittington's 2017 compiler `cringe`, and on the wider esoteric-languages community.

## License

MIT. Published and maintained by [Please Abstain](https://pleaseabstain.org).
